# Call of Duty - Gun Game | MySQL

For server owners who like to display game stats on their website / join screen, I added MySQL support. Certain game and 
player stats like wins, kills and deaths will be stored when this setting is enabled and configured properly.

## Installation of the MySQL modules
Because Gmod doesn't have a MySQL driver installed by default, you have to install it yourself.
The required modules you need to install are `tmysql4` and `libmysql/libmysqlclient`.

### tmysql4
* Windows: https://github.com/bkacjios/gm_tmysql4/releases/download/R1/gmsv_tmysql4_win32.dll
* Linux: https://github.com/bkacjios/gm_tmysql4/releases/download/R1.01/gmsv_tmysql4_linux.dll

Copy the file to "path/to/server/garrysmod/lua/bin/". If the bin folder doesn't exist, go ahead and create one.

### libmysql/libmysqlclient
* Windows: https://github.com/syl0r/MySQLOO/raw/master/MySQL/lib/windows/libmysql.dll
* Linux: https://github.com/syl0r/MySQLOO/raw/master/MySQL/lib/linux/libmysqlclient.so.18

Copy the file to "path/to/server/". This is the folder that contains `srcds.exe` or `srcds_run`.

## Database table
When you run the gamemode for the first time, it will automatically create the table `gmod_gungame` in your database. 
The table will have the following columns:

```id, username, steam_id, rounds_played, rounds_won, rounds_lost, rounds_tied, total_kills, total_deaths, last_played```

`id` is the primary key, `username` is the unique key.

	
## MySQL section of the settings file
```lua
--[[-------------------------------------------------------------------------
MySQL Support. If enabled, certain game stats will be stored which can be
used later on by for example, a dashboard on a website.

Requirements to get this feature working:

- Have gmsv_tmysql4 installed on the dedicated server
	Windows: https://github.com/bkacjios/gm_tmysql4/releases/download/R1/gmsv_tmysql4_win32.dll
	Linux: https://github.com/bkacjios/gm_tmysql4/releases/download/R1.01/gmsv_tmysql4_linux.dll

	Install in "path/to/server/garrysmod/lua/bin/".
	(create the bin folder if it does not exist)

- Have libmysql/libmysqlclient installed on the dedicated server
	Windows: https://github.com/syl0r/MySQLOO/raw/master/MySQL/lib/windows/libmysql.dll
	Linux: https://github.com/syl0r/MySQLOO/raw/master/MySQL/lib/linux/libmysqlclient.so.18

	Install in "path/to/server/".
	(in the folder that contains srcds.exe or srcds_run)

Note: no pre-made website dashboard will be provided. You need to have 
programming knowledge to develop your own.
---------------------------------------------------------------------------]]
GG_USE_MYSQL = false
GG_MYSQL_HOST = "localhost"
GG_MYSQL_USERNAME = "username"
GG_MYSQL_PASSWORD = "password"
GG_MYSQL_DATABASE = "database"
GG_MYSQL_POST = 3306
```
