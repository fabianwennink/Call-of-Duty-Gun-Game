-- Return match timer
function getGameTimer()

	return GetGlobalInt( "GG_MATCH_START_TIMER" )

end

-- Return round timer
function getRoundTimer()

	return GetGlobalInt( "GG_ROUND_END_TIMER" )

end

-- Start round
function startGame()

	SetGlobalInt( "GG_GAME_STATUS" , 1 ) 
	starttime = CurTime()

end

-- Receive restart game
net.Receive("Restart_Game", function() 

	SetGlobalInt( "GG_MATCH_END_TIMER", 10 )

end)