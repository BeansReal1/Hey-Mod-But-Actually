function onEvent(name, value1, value2, strumTime)
	local targetAlpha = tonumber(value1)
	if targetAlpha == nil then
		targetAlpha = 0.25 --default value for target alpha
	end

	local duration = tonumber(value2)
	if duration == nil then
		duration = 1 --default value for duration
	end

	doTweenAlpha('opponent fade tween', 'dad', targetAlpha, duration, 'sineInOut')
end