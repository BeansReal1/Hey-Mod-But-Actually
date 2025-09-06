function onCreatePost()
    precacheImage('bg')
    precacheImage('mikuc')
    precacheImage('mikublind')
end

function onCreate()
    makeLuaSprite('bg', 'cherry_pop_bg', -749, -356)
    setScrollFactor('bg', 1, 1)
    scaleObject('bg', 2.9, 2.9)
    
    makeAnimatedLuaSprite('mikuc', 'mikuc', -260, -752)
    addAnimationByPrefix('mikuc', 'mikuc', 'mikuc idle0', 7, true)
    setScrollFactor('mikuc', 1, 1)
    scaleObject('mikuc', 1, 1)

    makeAnimatedLuaSprite('mikublind', 'mikuc-noe', -260, -752)
    addAnimationByPrefix('mikublind', 'mikuc-noe', 'mikuc-noe idle0', 7, true)
    setScrollFactor('mikucblind', 1, 1)
    scaleObject('mikublind', 1, 1)
    setProperty('mikublind.alpha', 0) -- Start invisible

    addLuaSprite('bg', false)
    addLuaSprite('mikublind', false)
    addLuaSprite('mikuc', false)
end

function onStepHit()
    if curStep == 1322 then
        setProperty('mikublind.alpha', 1) -- Make mikublind visible
        setProperty('mikuc.alpha', 0) -- Make mikuc invisible
    end
    if curStep == 1330 then
        setProperty('mikublind.alpha', 0) -- Make mikublind invisible
        setProperty('mikuc.alpha', 1) -- Make mikuc visible
    end
end
