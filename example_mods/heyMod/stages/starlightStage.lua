
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


	-- OK SO HERES HOW THIS SHIT WORKS
	-- the last to numbers in the variable declaration are xSpacing and ySpacing, you can mess with those
	-- and the values in velocity.set are the xVelocity and yVelocity you can mess with those as well
	-- aside from that you can treat it as a normal lua sprite with the tag heartsBoard
	runHaxeCode([[
		import flixel.addons.display.FlxBackdrop;

        var hearts:FlxBackdrop = new FlxBackdrop(Paths.image('roa/bg2/heartSingle'), 0x11, 100, 100);
             
        hearts.velocity.set(-150, 150);
        
        setVar('heartsBoard', hearts);
	]])

	addLuaSprite('heartsBoard', false)

	

	-- loop the next 2

-- you can change the bar speed here
	runHaxeCode([[
		import flixel.addons.display.FlxBackdrop;

        var barTop:FlxBackdrop = new FlxBackdrop(Paths.image('roa/bg2/barTopSingle'), 0x01, 0, 0);
             
        barTop.velocity.set(300, 0);
        
        setVar('barTop', barTop);

		var barBottom:FlxBackdrop = new FlxBackdrop(Paths.image('roa/bg2/barBottomSingle'), 0x01, 0, 0);
             
        barBottom.velocity.set(300, 0);
        
        setVar('barBottom', barBottom);
	]])

	addLuaSprite('barTop', false)
	addLuaSprite('barBottom', false)
	setProperty('barTop.x', -2323.75)
	setProperty('barTop.y', -1833.75 + 400) -- change the +400 if you wanna change the top bar offset you know how ts works
	setProperty('barBottom.x', -2323.75)
	setProperty('barBottom.y', 1573.5)

	-- shit gets tweened in later in the song, or we can make an event for it? regardless we'll handle it
	setProperty('sky2.alpha', 0)
	setProperty('barTop.alpha', 0)
	setProperty('barBottom.alpha', 0)
	setProperty('heartsBoard.alpha', 0)




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


	



end

function onTweenCompleted(tag)
	if tag == 'noteLoopTween' then 
		setProperty('noteLoop.x',  -2358.95)
		setProperty('noteLoop2.x',  -2358.95 - width)
		doTweenX('noteLoopTween', 'noteLoop', getProperty('noteLoop.x') + width, noteTweenTime, 'linear')
		doTweenX('noteLoopTween2', 'noteLoop2', getProperty('noteLoop2.x') + width, noteTweenTime, 'linear')
	end



	

	if tag == "sky1AlphaTween" then
		removeLuaSprite('sky1', true)
		removeLuaSprite('arch', true)
		removeLuaSprite('noteLoop', true)
		removeLuaSprite('noteLoop2', true)


	end

	if tag == 'sky2AlphaTween2' then
		removeLuaSprite('sky2', true)
		removeLuaSprite('barTop', true)
		removeLuaSprite('barTop2', true)
		removeLuaSprite('barBottom', true)
		removeLuaSprite('barBottom2', true)
		removeLuaSprite('heartsBoard', true)


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
		doTweenAlpha('heartsBoardAlphaTween', 'heartsBoard', 1, transitionTime, 'linear')
		doTweenAlpha('barTopAlphaTween', 'barTop', 1, transitionTime, 'linear')
		doTweenAlpha('barBottomAlphaTween', 'barBottom', 1, transitionTime, 'linear')





	end

	if stage == 'stars' then
		--old shit out
		doTweenAlpha('sky2AlphaTween2', 'sky2', 0, transitionTime, 'linear')
		doTweenAlpha('heartsBoardAlphaTween2', 'heartsBoard', 0, transitionTime, 'linear')
		doTweenAlpha('barTopAlphaTween2', 'barTop', 0, transitionTime, 'linear')
		doTweenAlpha('barBottomAlphaTween2', 'barBottom', 0, transitionTime, 'linear')



		-- new shit in
		doTweenAlpha('sky3AlphaTween', 'sky3', 1, transitionTime, linear)
	end

end

function onUpdate(dt)
	--note swap medias
	if curBeat == 0 then
		setPropertyFromGroup('playerStrums', 0, 'x', defaultOpponentStrumX0)

		setPropertyFromGroup('playerStrums', 1, 'x', defaultOpponentStrumX1)

		setPropertyFromGroup('playerStrums', 2, 'x', defaultOpponentStrumX2)

		setPropertyFromGroup('playerStrums', 3, 'x', defaultOpponentStrumX3)


        setPropertyFromGroup('opponentStrums', 0, 'x', defaultPlayerStrumX0 + 0)

        setPropertyFromGroup('opponentStrums', 1, 'x', defaultPlayerStrumX1 + 0)

        setPropertyFromGroup('opponentStrums', 2, 'x', defaultPlayerStrumX2 + 0)

        setPropertyFromGroup('opponentStrums', 3, 'x', defaultPlayerStrumX3 + 0)

	end


	if keyboardJustPressed('N') then
		stageTransition('hearts')
	end

	if keyboardJustPressed('M') then
		stageTransition('stars')
	end
end
