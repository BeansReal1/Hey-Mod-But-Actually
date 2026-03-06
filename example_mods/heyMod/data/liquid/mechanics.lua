function onCreate()
	isParrying = false
	isParryingActive = false
	canParry = true

	activeParryTime = 0.14
	cooldownParryTime = 0.2
	currentParryTime = 0 -- do not touch this one

	redBusterExists = false
	redBusterDuration = 0.5
	redBusterParryDuration = 0.4
	redBusterParried = false
	redBusterDamage = 0.4




	redBusterScale = 1.75
	redBusterOffsetY = -230
	redBusterOffsetX = -50

	trailDelay = 0.04
	trailTimer = 0 
	trailMaxAmount = 2
	trailCounter = 0
	trailAlpha = 0.7

	trailScaleTarget = 1

	trailActive = false
	trailParried = false
	parryXLocation = 0

	disableDuration = 0.71 -- change this for susies disabled anims

	ralseiExists = false
	ralseiDuration = 0.6
	ralseiParryDuration = 0.5
	ralseiParried = false
	ralseiHeight = 630
	ralseiStunDuration = 1.2
	ralseiStunCurrent = 0 -- do NOT touch this one either bitch, or Im touching YOU

	ralseiOffsetY = -230
	ralseiOffsetX = -50

	isStunned = false
	
	hitboxOffset = 170
	hitboxOffsetSusie = 300

	parryOffsetX = -160
	parryOffsetY = -170

	cameraShakeIntensity = 0.02
	cameraShakeDuration = 0.07

	-- this is for consistency in the rude buster trajectory
	initialDadMidX = getGraphicMidpointX('dad')
	initialDadMidY = getGraphicMidpointY('dad')
	initialBfMidX = getGraphicMidpointX('boyfriend')
	initialBfdMidY = getGraphicMidpointY('boyfriend')



	makeAnimatedLuaSprite('parryEffect', 'roa/parryEffect', getProperty('boyfriend.x') + parryOffsetX, getProperty('boyfriend.y') + parryOffsetY);
	addAnimationByPrefix('parryEffect', 'parry', 'parry effect', 24, false);
	addLuaSprite('parryEffect', false);
	setProperty("parryEffect.alpha", 0);
	addHaxeLibrary('ColorSwap', 'shaders')
end


function onUpdate(dt)
	setProperty('parryEffect.x', getProperty('boyfriend.x') + parryOffsetX)
	setProperty('parryEffect.y', getProperty('boyfriend.y') + parryOffsetY)

	--DEBUG OPTIONS
	if keyboardJustPressed('BACKSPACE') then
		playAnim("dad", "pre-attack", true)
		setProperty("dad.specialAnim", true) 
	end

	if keyboardJustPressed('P') then
		destroyRedBuster()
	end

	if keyboardJustPressed('Q') then 
		playAnim("dad", "pre-throw", true)
		setProperty("dad.specialAnim", true) 
	end
	--DEBUG OPTIONS



	if keyboardJustPressed('SPACE') and canParry and not isStunned then
		startParry()
	    playSound('snd_parry_miss', 0.9)
		playAnim('boyfriend', 'block', true)
		disableCharaAnims(true, 0.5)
	end

	if getProperty('parryEffect.animation.curAnim.finished') and getProperty('parryEffect.animation.curAnim.name') == 'parry' then
		setProperty("parryEffect.alpha", 0);
	end

	if getProperty('dad.animation.curAnim.finished') and getProperty('dad.animation.curAnim.name') == 'pre-attack' then
		spawnRedBuster()
	end

	if getProperty('dad.animation.curAnim.name') == 'pre-attack' and getProperty('dad.animation.curAnim.curFrame') == 0 then 
		disableCharaAnims(false, disableDuration)
	end

	if getProperty('dad.animation.curAnim.finished') and getProperty('dad.animation.curAnim.name') == 'pre-throw' then
		spawnRalsei()
	end

	if getProperty('dad.animation.curAnim.name') == 'pre-throw' and getProperty('dad.animation.curAnim.curFrame') == 0 then 
		disableCharaAnims(false, disableDuration)
	end


	if isParrying then 
		currentParryTime = currentParryTime + dt
		
		if currentParryTime <= activeParryTime then 
			isParryingActive = true
			canParry = false
		elseif currentParryTime <= activeParryTime + cooldownParryTime then
			isParryingActive = false 
			canParry = false 
		else 
			endParry()
		end

	end

	--RED BUSTER LOGIC
	if redBusterExists then 
		

		if checkCollision('redBuster', 'boyfriend', redBusterParried) and isParryingActive and not redBusterParried then 
			parryXLocation = getProperty('redBuster.x')
			parryRedBuster()
			disableCharaAnims(true, disableDuration)
	    	playSound('snd_parry_success', 0.9)
			destroyTrail()
			trailParried = true
			trailActive = true
		elseif checkCollision('redBuster', 'boyfriend', redBusterParried) and not isParryingActive and not redBusterParried then 
			-- take damage
			setHealth(getHealth() - redBusterDamage)
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
			destroyRedBuster()
			disableCharaAnims(true, disableDuration)
	    	playSound('snd_rudebuster_hit', 0.9)
		    playAnim('boyfriend', 'hurt', true)
			setProperty('boyfriend.stunned', true)
			setProperty("boyfriend.specialAnim", true) 

			destroyTrail()
		end 

		if checkCollision('redBuster', 'dad', redBusterParried) and redBusterParried then 
			-- susie takes damage
			setHealth(getHealth() + redBusterDamage)
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
			destroyRedBuster()
			disableCharaAnims(false, disableDuration)
	    	playSound('snd_rudebuster_hit', 0.9)
		    playAnim('dad', 'hurt', true)
			setProperty('dad.stunned', true)
			setProperty("dad.specialAnim", true) 

			destroyParryTrail()
			destroyTrail()
		end

	end 

	-- TRAIL LOGIC (BAD)

	if trailCounter > trailMaxAmount then
		trailActive = false 
	end

	if trailActive and not trailParried then 
		trailTimer = trailTimer + dt
		if trailTimer >= trailDelay and trailCounter <= trailMaxAmount then 
			trailCounter = trailCounter + 1
			spawnTrail(trailCounter, trailAlpha - (trailCounter*0.15), 1.65, 1.65 - (trailCounter *0.2), trailParried)

			trailTimer = 0
		end 

		if trailCounter > trailMaxAmount then
			trailActive = false 
		end

	elseif  trailActive and trailParried then 
		trailTimer = trailTimer + dt
		if trailTimer >= trailDelay and trailCounter <= trailMaxAmount then 
			trailCounter = trailCounter + 1
			spawnParryTrail(trailCounter, trailAlpha - (trailCounter*0.15), 1.65, 1.65 - (trailCounter *0.2), trailParried)

			trailTimer = 0
		end 

		if trailCounter > trailMaxAmount then
			trailActive = false 
		end

	end

	if not trailActive then 
		trailTimer = 0
		treilCounter = 0
	end

	if not redBusterExists then 
		for i = 0, 20 do
			local spritename = 'trail' .. i
			local spritenameParry = 'trailParry' .. i

			removeLuaSprite(spritename)
			removeLuaSprite(spritenameParry)
		end
	end

	--RALSEI LOGIC
	if ralseiExists then  


		if checkCollision('ralsei', 'boyfriend', ralseiParried, true) and isParryingActive and not ralseiParried then 
			parryRalsei()
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
	    	playSound('snd_parry_success', 0.9)
		elseif checkCollision('ralsei', 'boyfriend', ralseiParried, true) and not isParryingActive and not ralseiParried then 
			-- stun bf
			isStunned = true
			ralseiStunCurrent = 0
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
			destroyRalsei()
			playAnim('boyfriend', 'stun', true)
	    	playSound('snd_hypnosis', 0.9)
			setProperty("boyfriend.specialAnim", true) 
			disableCharaAnims(true, ralseiStunDuration)
		end 

		if checkCollision('ralsei', 'dad', ralseiParried, true) and ralseiParried then 
			--bro hit susie
			destroyRalsei()
		end
	end

	--STUN LOGIC
	if isStunned then
		ralseiStunCurrent = ralseiStunCurrent + dt
		setProperty('boyfriend.stunned', true)
		if ralseiStunCurrent >= ralseiStunDuration then 
			isStunned = false 
			ralseiStunCurrent = 0
		end
	else 
		setProperty('boyfriend.stunned', false)
	end


end

function disableCharaAnims(musthit, duration)
	local disableDuration = duration
	for notesLength = 0,getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', notesLength, 'noteType') == '' then
			if not both and getPropertyFromGroup('notes', notesLength, 'mustPress') == musthit then
				setPropertyFromGroup('notes', notesLength, 'noAnimation', true)
				runTimer('reenableAnims', disableDuration)
			end
            end
        end
end

function onTimerCompleted(tag)
	if tag == 'reenableAnims' then
		for notesLength = 0,getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', notesLength, 'noteType') == '' then
				setPropertyFromGroup('notes', notesLength, 'noAnimation', false)
			end
		end
	end
end



function opponentNoteHit(id, direction, noteType, isSustainNote)

	if getHealth()>0.1 then
		setHealth(getHealth()- 0.01)
	end
end

function startParry()
	isParrying = true
	setProperty("parryEffect.alpha", 1) 
	playAnim("parryEffect", "parry", true)
	setProperty("boyfriend.specialAnim", true) 

		
	runHaxeCode([[
        var colorSwap = new ColorSwap();
        game.boyfriend.shader = colorSwap.shader;
        colorSwap.hue = 0/360;
        colorSwap.saturation = 0/100;
        colorSwap.brightness = 80/100;
	]])
end 

function endParry()
	isParryingActive = false 
	canParry = true
	isParrying = false
	currentParryTime = 0

	runHaxeCode([[
        var colorSwap = new ColorSwap();
        game.boyfriend.shader = colorSwap.shader;
        colorSwap.hue = 0/360;
        colorSwap.saturation = 0/100;
        colorSwap.brightness = 0/100;
	]])
end

function spawnRalsei()
	local ralseiScale = 1

	playAnim('dad', 'throw', true)
	makeLuaSprite('ralsei', 'roa/ralseiProjectile', initialDadMidX + ralseiOffsetX, initialDadMidY + ralseiOffsetY)
	addLuaSprite('ralsei', true)
	setProperty('ralsei.scale.x', ralseiScale)
	setProperty('ralsei.scale.y', ralseiScale)
	updateHitbox('ralsei')
	doTweenX('ralseiTweenX', 'ralsei', initialBfMidX - hitboxOffset, ralseiDuration, 'linear')
	doTweenY('ralseiTweenRise', 'ralsei', initialDadMidY + ralseiOffsetY - ralseiHeight, ralseiDuration/2, 'quadOut')
	ralseiExists = true 
	ralseiParried = false 
end

function parryRalsei()
	cancelTween('ralseiTweenX')
	cancelTween('ralseiTweenRise')
	cancelTween('ralseiTweenFall')
	setProperty('ralsei.scale.x', -getProperty('ralsei.scale.x'))
	updateHitbox('ralsei')
	doTweenX('ralseiParryTweenX', 'ralsei', initialDadMidX + hitboxOffset, ralseiParryDuration, 'linear')
	doTweenY('ralseiParryTweenRise', 'ralsei',  initialDadMidY + ralseiOffsetY - ralseiHeight, ralseiParryDuration/2, 'quadOut')
	ralseiParried = true
end

function destroyRalsei()
	removeLuaSprite('ralsei')
	ralseiExists = false
	ralseiParried = false
end

function onTweenCompleted(tag)
	if tag == 'ralseiTweenRise' then 
		doTweenY('ralseiTweenFall', 'ralsei', initialDadMidY, ralseiDuration/2, 'quadIn')
	end

	if tag == 'ralseiParryTweenRise' then 
		doTweenY('ralseiParryTweenFall', 'ralsei', initialDadMidY, ralseiParryDuration/2, 'quadIn')
	end

	for i = 0, 20 do
		if tag == 'trailTween' .. i then
			removeLuaSprite('trail' .. i)
		end

		if tag == "trailTweenParry" .. i then 
		removeLuaSprite("trailParry" .. i)
		end


	end


end

function spawnRedBuster()


	playAnim('dad', 'attack', true)
    playSound('snd_rudebuster_swing', 0.9)
	makeLuaSprite('redBuster', 'roa/redBusterPlaceholder', initialDadMidX + redBusterOffsetX, initialDadMidY + redBusterOffsetY)
	addLuaSprite('redBuster', true)
	setProperty('redBuster.scale.x', -redBusterScale)
	setProperty('redBuster.scale.y', -redBusterScale)
	updateHitbox('redBuster')
	doTweenX('redBusterTween', 'redBuster', initialBfMidX - 100 , redBusterDuration, 'linear')
	redBusterExists = true
	redBusterParried = false
	trailActive = true
end

function spawnTrail(trailAmount, alpha, scale, scaleY, parried)
	if not parried then
		makeLuaSprite('trail' .. trailAmount, 'roa/redBusterPlaceholder', initialDadMidX + redBusterOffsetX, initialDadMidY + redBusterOffsetY)
		addLuaSprite('trail' .. trailAmount, false)
		setProperty('trail' .. trailAmount .. '.scale.x', -scale)
		setProperty('trail' .. trailAmount .. '.scale.y', scale)
		setProperty('trail' .. trailAmount .. '.alpha', alpha)
		updateHitbox('trail' .. trailAmount)
		doTweenX('trailTween' .. trailAmount, 'trail' .. trailAmount, initialBfMidX, redBusterDuration, 'linear')
		--doTweenY('trailTweenScale' .. trailAmount, 'trail' .. trailAmount .. '.scale', trailScaleTarget, redBusterDuration, 'quadIn')
	end

end

function spawnParryTrail(trailAmount, alpha, scale, scaleY, parried)
	if parried then
		makeLuaSprite('trailParry' .. trailAmount, 'roa/redBusterPlaceholder', parryXLocation, initialDadMidY + redBusterOffsetY)
		addLuaSprite('trailParry' .. trailAmount, false)
		setProperty('trailParry' .. trailAmount .. '.scale.x', scale)
		setProperty('trailParry' .. trailAmount .. '.scale.y', scale)
		setProperty('trailParry' .. trailAmount .. '.alpha', alpha)
		updateHitbox('trailParry' .. trailAmount)
		doTweenX('trailTweenParry' .. trailAmount, 'trailParry' .. trailAmount, initialDadMidX + hitboxOffsetSusie, redBusterParryDuration, 'linear')
		--doTweenY('trailTweenParryScale' .. trailAmount, 'trailParry' .. trailAmount .. '.scale', trailScaleTarget, redBusterDuration, 'quadIn')
	end

end

function destroyTrail() 
	trailActive = false
	trailParried = false
	trailCounter = 0
	trailTimer = 0


	
	for i = 0, 20 do
		cancelTween('trailTween' .. i)
		cancelTween('trailTweenScale' .. i)
		removeLuaSprite('trail' .. i)
	end



end

function destroyParryTrail()
	trailActive = false
	trailParried = false
	trailCounter = 0
	trailTimer = 0



	for i = 0, 20 do
		cancelTween('trailTweenParry' .. i)
		cancelTween('trailTweenParryScale' .. i)
		removeLuaSprite('trailParry' .. i)
	end

end

function parryRedBuster()
	cancelTween('redBusterTween')
	setProperty('redBuster.scale.x', -getProperty('redBuster.scale.x'))
	updateHitbox('redBuster')
	doTweenX('redBusterParryTween', 'redBuster', initialDadMidX + hitboxOffsetSusie, redBusterParryDuration, 'linear')
	
	redBusterParried = true
end

function destroyRedBuster()
	removeLuaSprite('redBuster')
	redBusterExists = false
	redBusterParried = false

	destroyTrail()
	destroyParryTrail()


end





function checkCollision(spriteA, spriteB, parried, ralsei)
	 -- this is to make it so the hitbox is slightly behind the character that way the timing feels better to parry, not applying it until we actually get the sprites tho
	local hboxOffset
	local ralseiOffset = 70
	if parried then 
		hboxOffset = -hitboxOffsetSusie
	else 
		hboxOffset = hitboxOffset
	end

	if not ralsei then 
		ralseiOffset = 0
	end


	-- sprite A is usually red buster
    local a_left = getProperty(spriteA .. '.x') + ralseiOffset
    local a_right = getProperty(spriteA .. '.x') + getProperty(spriteA .. '.width') + ralseiOffset


    local b_left = getProperty(spriteB .. '.x') - hboxOffset
    local b_right = getProperty(spriteB .. '.x') + getProperty(spriteB .. '.width') - hboxOffset



    if a_right > b_left and a_left < b_right then -- I dont even bother checking for y, might have to for ralsei but thats for later
        return true 
    else
        return false 
    end
end
