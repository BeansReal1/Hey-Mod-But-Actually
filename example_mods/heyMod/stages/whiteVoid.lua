function onCreate()
	-- background shit
	makeLuaSprite('bg','',-900,-900)
	makeGraphic('bg',4000,4000,'ffffff')
	addLuaSprite('bg',false)
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end