local match_timer = 9; round_timer = 19

util.AddNetworkString("UpdateMatchTimer")
util.AddNetworkString("UpdateScoreTimer")
util.AddNetworkString("Start_Game")
util.AddNetworkString("Restart_Game")

net.Receive("Start_Game", function()

	local data = net.ReadTable()
	local verified = false

	for _, ply in ipairs(player.GetAll()) do
		if(ply:GetName() == data[4]) then 
			verified = true 
		end
	end

	if(verified) then
		SetGlobalInt( "GG_ROUND_TIME", data[1])
		SetGlobalInt( "GG_MATCH_ROUNDS", data[2])
		SetGlobalBool( "GG_INVERT_WEAPON_LIST", data[3])

		SetGlobalInt( "GG_GAME_STATUS" , 2 )
		SetGlobalInt( "GG_CURRENT_ROUND" , 1 ) 
		closeLobby()

		startGame()
	else
		print("[CoD - Gun Game] Security risk! Player '" .. data[4] .. "' tried to bypass the admin check and start the game!")
	end

end)

-- Set game status
function setGameStatus(status)

	SetGlobalInt( "GG_GAME_STATUS" , status )
	updateClientGameStatus()

end

-- Start game
function startGame()

	-- Freeze all players
	for _, ply in ipairs( player.GetAll() ) do
		ply:Spawn()
		ply:SetHealth(100)
		ply:RemoveAllItems()

		GiveLoadout(ply, GetKills(ply) + 1)
		game.CleanUpMap()

		ply:Lock()
		ply:Freeze(true)
	end

	-- Start counting down
	timer.Create("CountDownTimer", 1, 0, updateTimer)

end

-- Restart the round
function restartRound()

	if(countValues(player.GetAll()) == 1 || GetGlobalInt( "GG_CURRENT_ROUND" ) == GetGlobalInt( "GG_MATCH_ROUNDS" )) then
		checkReset()
		match_timer = 9
		round_timer = 19

		SetGlobalInt( "GG_MATCH_START_TIMER" , match_timer )
		SetGlobalInt( "GG_ROUND_END_TIMER", round_timer )

		SetGlobalInt( "GG_GAME_STATUS" , 0 )
		SetGlobalInt( "GG_CURRENT_ROUND", 1 )

		for _, ply in ipairs( player.GetAll() ) do
			enterLobby(ply)
		end
	else
		ResetAllData()
		match_timer = 10
		round_timer = 20

		SetGlobalInt( "GG_MATCH_START_TIMER" , match_timer )
		SetGlobalInt( "GG_ROUND_END_TIMER", round_timer )

		net.Start("Restart_Game")
		net.Broadcast()

		SetGlobalInt( "GG_GAME_STATUS" , 2 )
		SetGlobalInt( "GG_CURRENT_ROUND", GetGlobalInt( "GG_CURRENT_ROUND" ) + 1 )
		startGame()
	end

end

-- Update match timer
function updateTimer()

	SetGlobalInt( "GG_MATCH_START_TIMER" , match_timer )
	
	if(match_timer == 0) then
		timer.Destroy("CountDownTimer")

		SetGlobalInt( "GG_GAME_STATUS" , 1 )

		-- Set starting time
		SetGlobalInt( "GG_ROUND_COUNTDOWN" , CurTime())

		local time = (GetGlobalInt( "GG_ROUND_COUNTDOWN" ) + (GetGlobalInt( "GG_ROUND_TIME" ) * 60)) - CurTime()
		timer.Create("RoundTimer", time, 1, endRoundTimer)

		-- Unfreeze all players
		for _, ply in ipairs( player.GetAll() ) do
			ply.UnLock(ply)
		end
	else
		match_timer = match_timer - 1
	end

end

-- Update round score timer
function updateScoreTimer()

	SetGlobalInt( "GG_ROUND_END_TIMER", round_timer )
	
	if(round_timer == 0) then
		timer.Destroy("CountDownTimerScore")

		SetGlobalInt( "GG_GAME_STATUS" , 2 )

		restartRound()
	else
		round_timer = round_timer - 1
	end

end

-- Update round timer
function endRoundTimer()

	SetGlobalInt( "GG_GAME_STATUS" , 3 ) 

	timer.Create("CountDownTimerScore", 1, 0, updateScoreTimer)

	for _, ply in ipairs( player.GetAll() ) do
		ply:Lock()
	end

end

-- Restart round check
function checkReset()

	ResetAllData()
	match_timer = 9
	round_timer = 19

	SetGlobalInt( "GG_GAME_STATUS" , 0 )

	for _, ply in ipairs( player.GetAll() ) do
		enterLobby(ply)
	end

end