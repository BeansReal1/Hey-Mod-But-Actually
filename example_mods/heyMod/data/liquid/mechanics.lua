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
		spawnRedBuster()
	end

	if keyboardJustPressed('P') then
		destroyRedBuster()
	end

	if keyboardJustPressed('Q') then 
		spawnRalsei()
	end
	--DEBUG OPTIONS





	if keyboardJustPressed('SPACE') and canParry and not isStunned then
		startParry()
	    playSound('snd_parry_miss', 0.9)
	end

	if getProperty('parryEffect.animation.curAnim.finished') and getProperty('parryEffect.animation.curAnim.name') == 'parry' then
		setProperty("parryEffect.alpha", 0);
	end

	if getProperty('dad.animation.curAnim.finished') and getProperty('dad.animation.curAnim.name') == 'pre-attack' then
		spawnRedBuster()
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
			parryRedBuster()
	    	playSound('snd_parry_success', 0.9)
		elseif checkCollision('redBuster', 'boyfriend', redBusterParried) and not isParryingActive and not redBusterParried then 
			-- take damage
			setHealth(getHealth() - redBusterDamage)
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
			destroyRedBuster()
	    	playSound('snd_rudebuster_hit', 0.9)
		end 

		if checkCollision('redBuster', 'dad', redBusterParried) and redBusterParried then 
			-- susie takes damage
			setHealth(getHealth() + redBusterDamage)
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
			destroyRedBuster()
	    	playSound('snd_rudebuster_hit', 0.9)
		    playAnim('dad', 'hurt', true)
			setProperty("dad.specialAnim", true) 
		end
	end 

	--RALSEI LOGIC
	if ralseiExists then  


		if checkCollision('ralsei', 'boyfriend', ralseiParried) and isParryingActive and not ralseiParried then 
			parryRalsei()
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
	    	playSound('snd_parry_success', 0.9)
		elseif checkCollision('ralsei', 'boyfriend', ralseiParried) and not isParryingActive and not ralseiParried then 
			-- stun bf
			isStunned = true
			ralseiStunCurrent = 0
			cameraShake('game', cameraShakeIntensity, cameraShakeDuration)
			destroyRalsei()
	    	playSound('snd_hypnosis', 0.9)
		end 

		if checkCollision('ralsei', 'dad', ralseiParried) and ralseiParried then 
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

function opponentNoteHit(b, t, s)
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
	local ralseiScale = 2.5

	makeLuaSprite('ralsei', 'roa/ralseiPlaceholder', initialDadMidX + ralseiOffsetX, initialDadMidY + ralseiOffsetY)
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
end

function spawnRedBuster()
	local redBusterScale = 1.75
	local redBusterOffsetY = -230
	local redBusterOffsetX = -50

	playAnim('dad', 'attack', true)
    playSound('snd_rudebuster_swing', 0.9)
	makeLuaSprite('redBuster', 'roa/redBusterPlaceholder', initialDadMidX + redBusterOffsetX, initialDadMidY + redBusterOffsetY)
	addLuaSprite('redBuster', true)
	setProperty('redBuster.scale.x', -redBusterScale)
	setProperty('redBuster.scale.y', -redBusterScale)
	updateHitbox('redBuster')
	doTweenX('redBusterTween', 'redBuster', initialBfMidX, redBusterDuration, 'linear')
	redBusterExists = true
	redBusterParried = false
end

function parryRedBuster()
	cancelTween('redBusterTween')
	setProperty('redBuster.scale.x', -getProperty('redBuster.scale.x'))
	updateHitbox('redBuster')
	doTweenX('redBusterParryTween', 'redBuster', initialDadMidX, redBusterParryDuration, 'linear')
	redBusterParried = true
end

function destroyRedBuster()
	removeLuaSprite('redBuster')
	redBusterExists = false
	redBusterParried = false
end

function checkCollision(spriteA, spriteB, parried)
	 -- this is to make it so the hitbox is slightly behind the character that way the timing feels better to parry, not applying it until we actually get the sprites tho
	if parried then 
		hitboxOffset = -hitboxOffset
	end


	-- sprite A is usually red buster
    local a_left = getProperty(spriteA .. '.x')
    local a_right = getProperty(spriteA .. '.x') + getProperty(spriteA .. '.width')


    local b_left = getProperty(spriteB .. '.x') - hitboxOffset
    local b_right = getProperty(spriteB .. '.x') + getProperty(spriteB .. '.width') - hitboxOffset



    if a_right > b_left and a_left < b_right then -- I dont even bother checking for y, might have to for ralsei but thats for later
        return true 
    else
        return false 
    end
end




-- THIS IS WHERE THE MAGIC HAPPENS

function onBeatHit()

    if curBeat == 260 then
		playAnim("dad", "pre-attack", true)
    end

end