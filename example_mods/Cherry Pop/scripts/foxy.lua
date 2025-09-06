local range = 1000000
local foxyChance = getRandomInt(1,range)

function onCreate()
	precacheImage('foxy/foxy')
	precacheSound('Xscream3')
	makeAnimatedLuaSprite('foxy','foxy/foxy')
	setObjectCamera('foxy','other')
	addAnimationByPrefix('foxy','jumpscare','jumpscare',30,false)
	scaleObject('foxy', 1.25, 1)
	screenCenter('foxy', 'XY')
	runTimer('foxyTry',1)
end

function onTimerCompleted(t)
	if t == 'foxyTry' then
		foxyChance = getRandomInt(1,range)
		runTimer('foxyTry',1)
		if foxyChance == 1 then
			addLuaSprite('foxy',true)
			playSound('Xscream3', 5, 'scream')
		end
	end
end

function onUpdate()
	if getProperty('foxy.animation.finished') then
		setProperty('health', 0)
		stopSound('scream')
	end
end