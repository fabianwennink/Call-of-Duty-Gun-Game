util.AddNetworkString("Open_Lobby")
util.AddNetworkString("Close_Lobby")

-- Player enters lobby
function enterLobby(ply)

	local status = GetGlobalInt( "GG_GAME_STATUS" )

	if(status == 1) then -- if playing
		GiveLoadout(ply, GetKills(ply) + 1)
	else 
		if(status == 0) then -- if not started yet
			net.Start("Open_Lobby")
			net.Send(ply)
		elseif(status == 2 || status == 3) then
			ply:SetHealth(100)
			ply:Lock()
			ply:RemoveAllItems()

			GiveLoadout(ply, GetKills(ply) + 1)
		end
	end

end

-- Close lobby
function closeLobby()

	net.Start("Close_Lobby")
	net.Broadcast()

end

hook.Add("PlayerInitialSpawn", "OpenPlayerLobby", enterLobby)