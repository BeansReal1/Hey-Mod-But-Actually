function onCreate()
	isParrying = false
	isParryingActive = false
	canParry = true

	activeParryTime = 0.5
	cooldownParryTime = 0.2
	currentParryTime = 0 

	redBusterExists = false
	redBusterDuration = 0.5
	redBusterParryDuration = 0.4
	redBusterParried = false


	makeAnimatedLuaSprite('parryEffect', 'roa/parryEffect', getGraphicMidpointX('boyfriend'), getGraphicMidpointY('boyfriend'));
	addAnimationByPrefix('parryEffect', 'parry', 'parry effect', 24, false);
	addLuaSprite('parryEffect', false);
	setProperty("parryEffect.alpha", 0);
	addHaxeLibrary('ColorSwap', 'shaders')
end

function onUpdate(dt)
	setProperty('parryEffect.x', getGraphicMidpointX('boyfriend'))
	setProperty('parryEffect.y', getGraphicMidpointY('boyfriend'))

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
		if checkCollision('redBuster', 'boyfriend') and isParryingActive and not redBusterParried then 
			parryRedBuster()
		elseif checkCollision('redBuster', 'boyfriend') and not isParryingActive and not redBusterParried then 
			-- take damage here
			destroyRedBuster()
		end 

		if checkCollision('redBuster', 'dad') and redBusterParried then 
			-- susie takes damage
			destroyRedBuster()
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

	makeLuaSprite('redBuster', 'roa/redBusterPlaceholder', getGraphicMidpointX('dad'), getGraphicMidpointY('dad'))
	addLuaSprite('redBuster', true)
	doTweenX('redBusterTween', 'redBuster', getGraphicMidpointX('boyfriend'), redBusterDuration, 'linear')
	redBusterExists = true
	redBusterParried = false
end

function parryRedBuster()
	cancelTween('redBusterTween')
	setProperty('redBuster.scale.x', -1)
	--setProperty('redBuster.x', getGraphicMidpointX('boyfriend'))
	doTweenX('redBusterParryTween', 'redBuster', getGraphicMidpointX('dad'), redBusterParryDuration, 'linear')
	redBusterParried = true
end

function destroyRedBuster()
	removeLuaSprite('redBuster')
	redBusterExists = false
	redBusterParried = false
end

function checkCollision(spriteA, spriteB)
	local hitboxOffset = 5 -- this is to make it so the hitbox is slightly behind the character that way the timing feels better to parry, not applying it until we actually get the sprites tho

	-- sprite A is usually red buster
    local a_left = getProperty(spriteA .. '.x')
    local a_right = getProperty(spriteA .. '.x') + getProperty(spriteA .. '.width')


    local b_left = getProperty(spriteB .. '.x') -- hitboxOffset would go here but I'd have to change it depending on if its kibble or susie, I can do it but I wanna have the sprites first
    local b_right = getProperty(spriteB .. '.x') + getProperty(spriteB .. '.width') 



    if a_right > b_left and a_left < b_right then -- I dont even bother checking for y, might have to for ralsei but thats for later
        return true 
    else
        return false 
    end
end


