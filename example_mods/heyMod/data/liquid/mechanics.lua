function onCreate()
	isParrying = false
	isParryingActive = false
	canParry = true

	activeParryTime = 0.2
	cooldownParryTime = 0.2
	currentParryTime = 0 -- do not touch this one

	redBusterExists = false
	redBusterDuration = 0.5
	redBusterParryDuration = 0.4
	redBusterParried = false
	redBusterDamage = 0.4

	parryOffsetX = -160
	parryOffsetY = -170

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
	--DEBUG OPTIONS





	if keyboardJustPressed('SPACE') and canParry then
		startParry()
	    playSound('snd_parry_miss', 0.9)
	end

	if getProperty('parryEffect.animation.curAnim.finished') and getProperty('parryEffect.animation.curAnim.name') == 'parry' then
		setProperty("parryEffect.alpha", 0);
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

	if redBusterExists then 
		local cameraShakeIntensity = 0.02
		local cameraShakeDuration = 0.07

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

function spawnRedBuster()
	local redBusterScale = 1.75
	local redBusterOffsetY = -230
	local redBusterOffsetX = -50

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
	local hitboxOffset = 170 -- this is to make it so the hitbox is slightly behind the character that way the timing feels better to parry, not applying it until we actually get the sprites tho
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




