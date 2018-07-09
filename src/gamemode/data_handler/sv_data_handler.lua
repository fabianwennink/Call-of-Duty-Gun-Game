local server_players = {} -- data between server and client (contains match details)
local player_stats = {} -- only server side (contains total kills and deaths)
local kill_feed = {}

util.AddNetworkString("SendPlayerData")
util.AddNetworkString("SendKillFeed")

-- Table functions
function containsValue(username, tbl)

	for k, v in ipairs( tbl ) do
		if(v.name == val) then
			return true
		end
	end
	
	return false

end

function getTableKey(username, tbl)

	local count = 1

	for k, v in ipairs( tbl ) do
		if(v.name == username) then
			return count
		end

		count = count + 1
	end

end

function updateValue(username, score, tbl)

	for k, v in ipairs( tbl ) do
		if(v.name == username) then
			v.kills = score
		end
	end
	
	return false

end

function updateStatsKills(username)

	for k, v in ipairs( player_stats ) do
		if(v.name == username) then
			v.kills = v.kills + 1
		end
	end

end

function getStatsKills(username)

	for k, v in ipairs( player_stats ) do
		if(v.name == username) then
			return v.kills
		end
	end
	
	return 0

end

function updateStatsDeaths(username)

	for k, v in ipairs( player_stats ) do
		if(v.name == username) then
			v.deaths = v.deaths + 1
		end
	end
	
end

function getStatsDeaths(username)

	for k, v in ipairs( player_stats ) do
		if(v.name == username) then
			return v.deaths
		end
	end
	
	return 0

end

-- Update score
function updateScore(username, score)

	if(score >= 0 && score < 21) then
		updateValue(username, score, server_players)

		-- Send data to clients
		SendPlayerData()

		if(score >= 20) then

			SetGlobalInt( "GG_GAME_STATUS" , 3 ) 

			timer.Create("CountDownTimerScore", 1, 0, updateScoreTimer)

			for _, ply in ipairs( player.GetAll() ) do
				ply:Lock()
			end
		end
	end

end

-- Update server score
function updateServerScore(attacker, victim) 

	if(attacker != nil) then
		updateStatsKills(attacker:GetName())
	end

	updateStatsDeaths(victim:GetName())

end

-- Update kill feed
function updateKillFeed( attacker, victim, status )

	if(status == -1) then -- kill
		table.Add(kill_feed, {{ attacker = attacker:GetName(), victim = victim:GetName(), status = 0, die = CurTime() + 10 }})
	elseif(status == 0) then -- suicide
		table.Add(kill_feed, {{ attacker = nil, victim = victim:GetName(), status = 0, die = CurTime() + 10 }})
	else -- knife kill
		table.Add(kill_feed, {{ attacker = attacker:GetName(), victim = victim:GetName(), status = 1, die = CurTime() + 10 }})
	end

	for i = 1, #kill_feed do
		if(kill_feed[i] != nil) then
			if(kill_feed[i].die < CurTime()) then table.remove(kill_feed, 1 ) end
		end
	end
end

-- Check first time spawning
function checkScore( ply ) 
	if(!containsValue(ply:GetName(), server_players)) then
		server_players[countValues(server_players) + 1] = {
			name = ply:GetName(), 
			steam_id = ply:SteamID(), 
			kills = 0
		}

		player_stats[countValues(player_stats) + 1] = {
		 	name = ply:GetName(), 
		 	kills = 0,
		 	deaths = 0
		}

		SendPlayerData()
	end
end


-- Update client game
function SendPlayerData()

	table.SortByMember(server_players, "kills")

	net.Start("SendPlayerData")
		net.WriteTable(server_players)
	net.Broadcast()

	net.Start("SendKillFeed")
		net.WriteTable(kill_feed)
	net.Broadcast()

end

-- Reset player data
function ResetData(ply)

	table.remove(server_players, getTableKey(ply:GetName(), server_players))
	table.SortByMember(server_players, "kills")
	ply:SetNWInt("killcounter", 0)

	if(GetGlobalInt("GG_GAME_STATUS") == 1 and GG_USE_MYSQL) then
		updateScoreDatabase(ply:GetName(), ply:SteamID(), getStatsKills(ply:GetName()), getStatsDeaths(ply:GetName()), 1) -- lost
	end
	
	table.remove(player_stats, getTableKey(ply:GetName(), player_stats))

	SendPlayerData()

end

-- Reset all data
function ResetAllData()
	if(GG_USE_MYSQL) then
		-- Sort the table once more, just to be sure
		table.SortByMember(server_players, "kills")
		
		local kills_1 = server_players[1].kills; kills_2 = 0
		local player_1 = server_players[1].name; player_2 = "_"

		if(server_players[2] != nil) then 
			kills_2 = server_players[2].kills
			player_2 = server_players[2].name
		end

		for k, v in ipairs( server_players ) do
			if(player_1 == v.name and kills_1 > kills_2) then
				updateScoreDatabase(v.name, v.steam_id, getStatsKills(v.name), getStatsDeaths(v.name), 0) -- won
			else
				if(kills_1 == v.kills and player_1 != v.name || kills_1 == kills_2 and (player_1 == v.name || player_2 == v.name)) then
					updateScoreDatabase(v.name, v.steam_id, getStatsKills(v.name), getStatsDeaths(v.name), 2) -- tied
				else
					updateScoreDatabase(v.name, v.steam_id, getStatsKills(v.name), getStatsDeaths(v.name), 1) -- lost
				end
			end

			v.kills = 0
		end
	else
		for k, v in ipairs( server_players ) do
			v.kills = 0
		end

		for k, v in ipairs( player_stats ) do
			v.kills = 0
			v.deaths = 0
		end
	end

	for _, ply in ipairs( player.GetAll() ) do
		ply:SetNWInt("killcounter", 0)
	end

	SendPlayerData()
	
end

