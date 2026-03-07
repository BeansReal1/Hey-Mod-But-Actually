function onCreate()
	-- background shit
	makeLuaSprite('sky1','roa/bg1/sky1', -2247.75,-1719.5)
	addLuaSprite('sky1',false)

	makeLuaSprite('arch','roa/bg1/bgArch', -1979.15,-1463.75)
	setScrollFactor('arch', 1.08, 1);
	addLuaSprite('arch',false)

	-- make this shit loop \/
	makeLuaSprite('noteLoop','roa/bg1/bgNoteLoop', -2358.95,-1307.5)
	addLuaSprite('noteLoop',false)
	
	-- bg2
	makeLuaSprite('sky2','roa/bg2/sky2', -2247.75,-1719.5)
	addLuaSprite('sky2',false)

	-- ok loop these scrolling to the left and diagonally lol
	makeLuaSprite('hearts','roa/bg2/heartSingle', -2323,-893.5)
	addLuaSprite('hearts',false)

	-- loop the next 2
	makeLuaSprite('barTop','roa/bg2/barTop', -2323.75,-1833.75)
	addLuaSprite('barTop',false)
	
	makeLuaSprite('barBottom','roa/bg2/barBottom', -2323.75, 1573.5)
	addLuaSprite('barBottom',false)

	-- shit gets tweened in later in the song, or we can make an event for it? regardless we'll handle it
	setProperty('sky2.alpha', 0)
	setProperty('hearts.alpha', 0)
	setProperty('barTop.alpha', 0)
	setProperty('barBottom.alpha', 0)

	-- bg3

	-- more main shit
	makeAnimatedLuaSprite('speakerSmallLeft', 'roa/speakerSmallL', 28.6, 89.75);
	addAnimationByPrefix('speakerSmallLeft', 'idle', 'speakerSmallL', 24, true);
	setScrollFactor('speakerSmallLeft', 0.98, 1);
	addLuaSprite('speakerSmallLeft', false);

	makeAnimatedLuaSprite('speakerBigLeft', 'roa/speakerBigL', -617.3, -170.25);
	addAnimationByPrefix('speakerBigLeft', 'idle', 'speakerBigL', 24, true);
	addLuaSprite('speakerBigLeft', false);

	makeAnimatedLuaSprite('speakerSmallRight', 'roa/speakerSmallR', 1366.05, 89.75);
	addAnimationByPrefix('speakerSmallRight', 'idle', 'speakerSmallR', 24, true);
	setScrollFactor('speakerSmallRight', 0.98, 1);
	addLuaSprite('speakerSmallRight', false);

	makeAnimatedLuaSprite('speakerBigRight', 'roa/speakerBigR', 1798.15, -170.25);
	addAnimationByPrefix('speakerBigRight', 'idle', 'speakerBigR', 24, true);
	addLuaSprite('speakerBigRight', false);

	makeLuaSprite('stage', 'roa/starlightStage', -727.7, 688.75);  
	addLuaSprite('stage', false);

end