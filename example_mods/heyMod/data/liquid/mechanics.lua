function onCreate()
	isParrying = false
	isParryingActive = false
	canParry = true

	activeParryTime = 0.5
	cooldownParryTime = 0.2
	currentParryTime = 0 

	makeAnimatedLuaSprite('parryEffect', 'roa/parryEffect', 'boyfriend.x', 'boyfriend.y');
	addAnimationByPrefix('parryEffect', 'parry', 'parry effect', 24, false);
	addLuaSprite('parryEffect', false);
	setProperty("parryEffect.alpha", 0);
	addHaxeLibrary('ColorSwap', 'shaders')
end

function onUpdate(dt)

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