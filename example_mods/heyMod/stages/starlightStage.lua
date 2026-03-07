function onCreate()
	-- background shit
	makeLuaSprite('sky1','roa/bg1/sky1',-2247.75,-1719.5)
	addLuaSprite('sky1',false)
	
	makeAnimatedLuaSprite('speakerBigLeft', 'roa/speakerBigL', -617.3, -170.25);
	addAnimationByPrefix('speakerBigLeft', 'idle', 'speakerBigL', 24, true);
	setScrollFactor('speakerBigLeft', 1.02, 1);
	addLuaSprite('speakerBigLeft', false);

	makeLuaSprite('speakerRight', 'roa/speakerSketch', 1650, -20);
	setScrollFactor('speakerRight', 1.02, 1);
	addLuaSprite('speakerRight', false);
	setProperty('speakerRight.scale.x', -1);
	updateHitbox('speakerRight');

	makeLuaSprite('stage', 'roa/stageSketch', -410, 835);
	addLuaSprite('stage', false);

end