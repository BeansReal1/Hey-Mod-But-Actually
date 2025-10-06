function onCreate()
	-- background shit

	makeLuaSprite('kitchen', 'gamingRoom/kitchen', 384.85, 150)
	setLuaSpriteScrollFactor('kitchen', 0.86, 0.88);
	addLuaSprite('kitchen', false);

	makeLuaSprite('wall', 'gamingRoom/wall', -59.95, -16.20);
	addLuaSprite('wall', false);

	makeLuaSprite('couchBack', 'gamingRoom/couchBack', 1261, 498.75);
	addLuaSprite('couchBack', false);

	makeAnimatedLuaSprite('tvFull', 'gamingRoom/tvFull', 90, 157.2);
	addAnimationByPrefix('tvFull', 'idle', 'tvFull', 24, true);
	addLuaSprite('tvFull', false);

	makeLuaSprite('couchFront', 'gamingRoom/couchFront', 1492.8, 617.25);
	addLuaSprite('couchFront', true);

	makeLuaSprite('blue', 'gamingRoom/blue', 60., -15.95);
	setBlendMode('blue', 'multiply');
	addLuaSprite('blue', true);

	makeAnimatedLuaSprite('tvGlow', 'gamingRoom/tvGlow', 581.4, 156.15);
	addAnimationByPrefix('tvGlow', 'idle', 'tvGlow', 24, true);
	setBlendMode('tvGlow', 'add');
	addLuaSprite('tvGlow', false);

end