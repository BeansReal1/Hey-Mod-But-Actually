function onCreate()

	makeAnimatedLuaSprite('parryEffect', 'roa/parryEffect', 'boyfriend.x', 'boyfriend.y');
	addAnimationByPrefix('parryEffect', 'parry', 'parry effect', 24, false);
	addLuaSprite('parryEffect', false);
	setProperty("parryEffect.alpha", 0);
end

function onUpdate()

	if keyboardJustPressed('SPACE') then
		setProperty("parryEffect.alpha", 1) 
		playAnim("parryEffect", "parry", true)
		setProperty("boyfriend.specialAnim", true) 
		runHaxeCode([[
        	var colorSwap = new ColorSwap();
        	game.modchartSprites.get(boyfriend).shader = colorSwap.shader;
        	colorSwap.hue = 0/360;
        	colorSwap.saturation = 0/100;
        	colorSwap.brightness = 80/100;
		]])
	end

	if getProperty('parryEffect.animation.curAnim.finished') and getProperty('parryEffect.animation.curAnim.name') == 'parry' then
		setProperty("parryEffect.alpha", 0);
	end

end

function opponentNoteHit(b, t, s)
	if getHealth()>0.1 then
		setHealth(getHealth()- 0.01)
	end
end