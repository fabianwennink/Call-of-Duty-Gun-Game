local client_players = {}
local kill_feed = {}
local show_feed = false

-- Receive the score data
net.Receive("SendPlayerData", function(len)

	client_players = net.ReadTable()
	
end)

-- Receive the kill feed
net.Receive("SendKillFeed", function(len)

	kill_feed = net.ReadTable()

	if(countValues(kill_feed) > 0) then
		show_feed = true
	end

end)


-- Return player data table
function getPlayerData()

	return client_players

end

-- Returns table name data of the given value
function getDataName(val)

	if(client_players[val] != nil) then
		return client_players[val].name
	end

end

-- Returns the table kills data of the given value
function getDataKills(val)

	if(client_players[val] != nil) then 
		return client_players[val].kills 
	end

	return 0
end

-- Returns the kill feed
function getKillFeed() 

	return kill_feed

end

-- Return show kill feed
function showKillFeed() 

	return show_feed

end