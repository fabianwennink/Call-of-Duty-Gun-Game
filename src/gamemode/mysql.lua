if(GG_USE_MYSQL) then
    require("tmysql4")

    ---------------------------------------------------
    -- Create database instance
    local db, err = tmysql.Create(GG_MYSQL_HOST, GG_MYSQL_USERNAME, GG_MYSQL_PASSWORD, GG_MYSQL_DATABASE, GG_MYSQL_POST)

    -- Called on connect
    local function createTable()
        print( "[Call of Duty - Gun Game] Established a connection with the MySQL database at '" .. GG_MYSQL_HOST .. "'!" )
    end

    local status, err = db:Connect()

    if err then
        print( "[Call of Duty - Gun Game] MySQL Connection error: " .. err )
        GG_USE_MYSQL = false
    else
        db:Query("CREATE TABLE IF NOT EXISTS `gmod_gungame` ( `id` int(11) NOT NULL AUTO_INCREMENT, `username` varchar(64) NOT NULL DEFAULT '0', `steam_id` varchar(64) NOT NULL DEFAULT '0', `rounds_played` int(11) NOT NULL DEFAULT '0', `rounds_won` int(11) NOT NULL DEFAULT '0', `rounds_lost` int(11) NOT NULL DEFAULT '0', `rounds_tied` int(11) NOT NULL DEFAULT '0', `total_kills` int(11) NOT NULL DEFAULT '0', `total_deaths` int(11) NOT NULL DEFAULT '0', `last_played` varchar(64) NOT NULL DEFAULT '0', PRIMARY KEY (`id`), UNIQUE KEY `username` (`username`) ) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;", createTable)
    end
    ---------------------------------------------------

    -- Update score function
    function updateScoreDatabase( player, steam_id, kills, deaths, status )
        
        local game_status

        if(status == 0) then 
            game_status = "rounds_won"
        elseif(status == 1) then
            game_status = "rounds_lost"
        else
            game_status = "rounds_tied"
        end

        db:Query("INSERT INTO `gmod_gungame` (username, steam_id, rounds_played, " .. game_status .. ", total_kills, total_deaths, last_played) VALUES ('" .. player .. "', '" .. steam_id .. "', '1', '1', '" .. kills .. "', '" .. deaths .. "', '" .. os.time() .. "') ON DUPLICATE KEY UPDATE rounds_played = rounds_played+1, total_kills = " .. kills .. ", total_deaths = " .. deaths .. ", last_played = " .. os.time() .. ", " .. game_status .. " = " .. game_status .. "+1")

    end

end