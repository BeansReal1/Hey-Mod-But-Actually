function onCreate()
	-- background shit
	makeLuaSprite('bg','',-3000,-1500)
	makeGraphic('bg',8500,4000,'ffffff')
	addLuaSprite('bg',false)
	
	makeLuaSprite('speakerLeft', 'roa/speakerSketch', -200, -20);
	setScrollFactor('speakerLeft', 1.02, 1);
	addLuaSprite('speakerLeft', false);

	makeLuaSprite('speakeRight', 'roa/speakerSketch', 1650, -20);
	setScrollFactor('speakeRight', 1.02, 1);
	addLuaSprite('speakeRight', false);
	setProperty('speakeRight.scale.x', -1)

	makeLuaSprite('stage', 'roa/stageSketch', -410, 835);
	addLuaSprite('stage', false);

end