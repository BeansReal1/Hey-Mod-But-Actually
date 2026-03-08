
-- just defining shit dont mind this you change it later in the code
width = 0
widthTop = 0
widthBottom = 0
widthHeart = 0
HeightHeart = 0
noteTweenTime = 0
barTweenTime = 0
heartTweenTime = 0
heartX = 0
heartY = 0
heartYOffset = 0
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
	width = getProperty('noteLoop.width')

	makeLuaSprite('noteLoop2','roa/bg1/bgNoteLoop', -2358.95 - width,-1307.5)
	addLuaSprite('noteLoop2',false)
	
	-- bg2
	makeLuaSprite('sky2','roa/bg2/sky2', -2247.75,-1719.5)
	addLuaSprite('sky2',false)

	-- ok loop these scrolling to the left and diagonally lol
	makeLuaSprite('hearts','roa/bg2/heartBoard', -2381.5,-893.5)
	addLuaSprite('hearts',false)
	widthHeart = getProperty('hearts.width')
	heightHeart = getProperty('hearts.height')
	heartX = getProperty('hearts.x')
	heartY = getProperty('hearts.y')
	heartYOffset = 0 -- change offset here but maybe dont cause it looks weird

	makeLuaSprite('heartsTop','roa/bg2/heartBoard', -2381.5,-893.5 - heightHeart - heartYOffset)
	addLuaSprite('heartsTop',false)

	makeLuaSprite('heartsTopRight','roa/bg2/heartBoard', -2381.5 + widthHeart,-893.5 - heightHeart - heartYOffset)
	addLuaSprite('heartsTopRight', false)

	makeLuaSprite('heartsRight','roa/bg2/heartBoard', -2381.5 + widthHeart,-893.5)
	addLuaSprite('heartsRight', false)

	-- loop the next 2
	makeLuaSprite('barTop','roa/bg2/barTop', -2323.75,-1833.75)
	addLuaSprite('barTop',false)
	widthTop = getProperty('barTop.width')
	barTopX = getProperty('barTop.x')

	makeLuaSprite('barTop2','roa/bg2/barTop', -2323.75 - widthTop,-1833.75)
	addLuaSprite('barTop2',false)
	
	makeLuaSprite('barBottom','roa/bg2/barBottom', -2323.75, 1573.5)
	addLuaSprite('barBottom',false)
	widthBottom = getProperty('barBottom.width')
	barBottomX = getProperty('barBottom.x')

	makeLuaSprite('barBottom2','roa/bg2/barBottom', -2323.75 - widthBottom, 1573.5)
	addLuaSprite('barBottom2',false)

	-- shit gets tweened in later in the song, or we can make an event for it? regardless we'll handle it
	setProperty('sky2.alpha', 0)
	setProperty('hearts.alpha', 0)
	setProperty('heartsTop.alpha', 0)
	setProperty('heartsRight.alpha', 0)
	setProperty('heartsTopRight.alpha', 0)
	setProperty('barTop.alpha', 0)
	setProperty('barBottom.alpha', 0)
	setProperty('barTop2.alpha', 0)
	setProperty('barBottom2.alpha', 0)

	-- bg3

	makeLuaSprite('sky3','roa/bg3/sky3', -2247.75,-1719.5)
	addLuaSprite('sky3',false)

	setProperty('sky3.alpha', 0)

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

	
	--Tweens
	noteTweenTime = 6 -- change this for the note tween time, duh
	doTweenX('noteLoopTween', 'noteLoop', getProperty('noteLoop.x') + width, noteTweenTime, 'linear')
	doTweenX('noteLoopTween2', 'noteLoop2', getProperty('noteLoop2.x') + width, noteTweenTime, 'linear')

	barTweenTime = 6 --  yeah you get it by now
	doTweenX('barTopTween', 'barTop', getProperty('barTop.x') + widthTop, barTweenTime, 'linear')
	doTweenX('barTopTween2', 'barTop2', getProperty('barTop2.x') + widthTop, barTweenTime, 'linear')

	doTweenX('barBottomTween', 'barBottom', getProperty('barBottom.x') + widthBottom, barTweenTime, 'linear')
	doTweenX('barBottomTween2', 'barBottom2', getProperty('barBottom2.x') + widthBottom, barTweenTime, 'linear')

	heartTweenTime = 6 -- licks you a little
	doTweenX('heartsTweenX', 'hearts',heartX - widthHeart, heartTweenTime, 'linear')
	doTweenY('heartsTweenY', 'hearts',heartY + heightHeart, heartTweenTime, 'linear')

	doTweenX('heartsTweenTopX', 'heartsTop', heartX - widthHeart, heartTweenTime, 'linear')
	doTweenY('heartsTweenTopY', 'heartsTop', heartY - heartYOffset , heartTweenTime, 'linear')


	doTweenX('heartsTweenRightX', 'heartsRight', heartX, heartTweenTime, 'linear')
	doTweenY('heartsTweenRightY', 'heartsRight',heartY + heightHeart, heartTweenTime, 'linear')


	doTweenX('heartsTweenTopRightX', 'heartsTopRight', heartX, heartTweenTime, 'linear')
	doTweenY('heartsTweenTopRightY', 'heartsTopRight', heartY - heartYOffset, heartTweenTime, 'linear')


end

function onTweenCompleted(tag)
	if tag == 'noteLoopTween' then 
		setProperty('noteLoop.x',  -2358.95)
		setProperty('noteLoop2.x',  -2358.95 - width)
		doTweenX('noteLoopTween', 'noteLoop', getProperty('noteLoop.x') + width, noteTweenTime, 'linear')
		doTweenX('noteLoopTween2', 'noteLoop2', getProperty('noteLoop2.x') + width, noteTweenTime, 'linear')
	end

	if tag == 'barTopTween' then
		setProperty('barTop.x', barTopX)
		setProperty('barTop2.x', barTopX - widthTop)
		setProperty('barBottom.x', barBottomX)
		setProperty('barBottom2.x', barBottomX - widthBottom)

		doTweenX('barTopTween', 'barTop', getProperty('barTop.x') + widthTop, barTweenTime, 'linear')
		doTweenX('barTopTween2', 'barTop2', getProperty('barTop2.x') + widthTop, barTweenTime, 'linear')

		doTweenX('barBottomTween', 'barBottom', getProperty('barBottom.x') + widthBottom, barTweenTime, 'linear')
		doTweenX('barBottomTween2', 'barBottom2', getProperty('barBottom2.x') + widthBottom, barTweenTime, 'linear')
	end

	if tag == 'heartsTweenX' then
		
		setProperty('hearts.x', heartX)
		setProperty('hearts.y', heartY)

		setProperty('heartsTop.x', heartX)
		setProperty('heartsTop.y', heartY - heightHeart - heartYOffset)

		setProperty('heartsRight.x', heartX + widthHeart)
		setProperty('heartsRight.y', heartY)

		setProperty('heartsTopRight.x', heartX + widthHeart)
		setProperty('heartsTopRight.y', heartY - heightHeart - heartYOffset)

		doTweenX('heartsTweenX', 'hearts',heartX - widthHeart, heartTweenTime, 'linear')
		doTweenY('heartsTweenY', 'hearts',heartY + heightHeart, heartTweenTime, 'linear')

		doTweenX('heartsTweenTopX', 'heartsTop', heartX - widthHeart, heartTweenTime, 'linear')
		doTweenY('heartsTweenTopY', 'heartsTop', heartY - heartYOffset , heartTweenTime, 'linear')


		doTweenX('heartsTweenRightX', 'heartsRight', heartX, heartTweenTime, 'linear')
		doTweenY('heartsTweenRightY', 'heartsRight',heartY + heightHeart, heartTweenTime, 'linear')


		doTweenX('heartsTweenTopRightX', 'heartsTopRight', heartX, heartTweenTime, 'linear')
		doTweenY('heartsTweenTopRightY', 'heartsTopRight', heartY - heartYOffset, heartTweenTime, 'linear')
	


	end

	if tag == "sky1AlphaTween" then
		removeLuaSprite('sky1', true)
		removeLuaSprite('arch', true)
		removeLuaSprite('noteLoop', true)
		removeLuaSprite('noteLoop2', true)


	end

	if tag == 'sky2AlphaTween2' then
		removeLuaSprite('sky2', true)
		removeLuaSprite('hearts', true)
		removeLuaSprite('heartsTop', true)
		removeLuaSprite('heartsTopRight', true)
		removeLuaSprite('heartsRight', true)
		removeLuaSprite('barTop', true)
		removeLuaSprite('barTop2', true)
		removeLuaSprite('barBottom', true)
		removeLuaSprite('barBottom2', true)


	end


end

function stageTransition(stage) 
	local transitionTime = 3
	if stage == 'hearts' then
		-- old shit out
		doTweenAlpha('sky1AlphaTween', 'sky1', 0, transitionTime, 'linear')
		doTweenAlpha('archAlphaTween', 'arch', 0, transitionTime, 'linear')
		doTweenAlpha('noteLoopAlphaTween', 'noteLoop', 0, transitionTime, 'linear')
		doTweenAlpha('noteLoopAlphaTween2', 'noteLoop2', 0, transitionTime, 'linear')

		-- new shit in
		doTweenAlpha('sky2AlphaTween', 'sky2', 1, transitionTime, 'linear')
		doTweenAlpha('heartAlphaTween', 'hearts', 1, transitionTime, 'linear')
		doTweenAlpha('heartTopAlphaTween', 'heartsTop', 1, transitionTime, 'linear')
		doTweenAlpha('heartRightAlphaTween', 'heartsRight', 1, transitionTime, 'linear')
		doTweenAlpha('heartTopRightAlphaTween', 'heartsTopRight', 1, transitionTime, 'linear')
		doTweenAlpha('barTopAlphaTween', 'barTop', 1, transitionTime, 'linear')
		doTweenAlpha('barBottomAlphaTween', 'barBottom', 1, transitionTime, 'linear')
		doTweenAlpha('barTopAlphaTween2', 'barTop2', 1, transitionTime, 'linear')
		doTweenAlpha('barBottomAlphaTween2', 'barBottom2', 1, transitionTime, 'linear')

	end

	if stage == 'stars' then
		--old shit out
		doTweenAlpha('sky2AlphaTween2', 'sky2', 0, transitionTime, 'linear')
		doTweenAlpha('heartAlphaTween2', 'hearts', 0, transitionTime, 'linear')
		doTweenAlpha('heartTopAlphaTween2', 'heartsTop', 0, transitionTime, 'linear')
		doTweenAlpha('heartRightAlphaTween2', 'heartsRight', 0, transitionTime, 'linear')
		doTweenAlpha('heartTopRightAlphaTween2', 'heartsTopRight', 0, transitionTime, 'linear')
		doTweenAlpha('barTopAlphaTween2', 'barTop', 0, transitionTime, 'linear')
		doTweenAlpha('barBottomAlphaTween2', 'barBottom', 0, transitionTime, 'linear')
		doTweenAlpha('barTopAlphaTween22', 'barTop2', 0, transitionTime, 'linear')
		doTweenAlpha('barBottomAlphaTween22', 'barBottom2', 0, transitionTime, 'linear')

		-- new shit in
		doTweenAlpha('sky3AlphaTween', 'sky3', 1, transitionTime, linear)
	end

end

function onUpdate(dt)
	if keyboardJustPressed('N') then
		stageTransition('hearts')
	end

	if keyboardJustPressed('M') then
		stageTransition('stars')
	end
end