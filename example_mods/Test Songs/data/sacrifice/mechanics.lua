function onCreate()

end

function onUpdate()

	if mouseClicked('left') then
		characterPlayAnim('BF', 'shoot1', false)
	end

	if mouseClicked('right') then
		characterPlayAnim('BF', 'shoot2', false)
	end

	if keyboardJustPressed('SPACE') then
		characterPlayAnim('BF', 'dodge', false) 
	end

	if keyboardJustPressed('SLASH') then
		characterPlayAnim('BF', 'shoot2', false) 
		setHealth(getHealth()+ 0.1)
	end

	if keyboardJustPressed('Z') then
		characterPlayAnim('BF', 'shoot1', false)
		triggerEvent('Play Animation', 'hit', 'dad') 
		setHealth(getHealth()+ 0.1)
	end
end

function opponentNoteHit(b, t, s)
	if getHealth()>0.1 then
		setHealth(getHealth()- 0.05)
	end
end