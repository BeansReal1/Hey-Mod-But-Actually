function onCreate()

	makeLuaSprite('wall', 'docRoom/wall', -410, -230);
	addLuaSprite('wall', false);

	makeLuaSprite('desk', 'docRoom/desk', -140, 245);
	setLuaSpriteScrollFactor('desk', 0.94, 0.96);
	addLuaSprite('desk', false);

end