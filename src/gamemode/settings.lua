--[[-------------------------------------------------------------------------
Enable or disable the usage of the M9K weapon packs.

To use this, make sure that the server has installed all of the required addons.
Players also need to download the addons, but as a dedicated server owner I 
expect you to know how this works.

Required addon IDs:
- 144982052
- 128089118
- 128091208
- 128093075

NOTE: If you disable this, the weapons in the pre-made weapon list won't work!
---------------------------------------------------------------------------]]
GG_USE_M9K = true

--[[-------------------------------------------------------------------------
Enable or disable the usage of MW2 playermodels.

To use this, make sure that the server has installed the required addon.
Players also need to download the addon, but as a dedicated server owner I 
expect you to know how this works.

Required addon ID:
- 500247187

NOTE: If you disable this, the skins in the pre-made skins list won't work!
---------------------------------------------------------------------------]]
GG_USE_MW2_SKINS = true

--[[-------------------------------------------------------------------------
This is the list with weapons used during the game. You can edit the list if
you want to use different weapons. Keep in mind that the all slots have to
be filled and that you can't have more than 20 weapons in the list.

Note: If somehow the weapons in the list below don't work, the back-up
weapons list will be used instead.
---------------------------------------------------------------------------]]
GG_WEAPONS_LIST = {
	{ weapon = "m9k_coltpython", ammo = 30 }, -- Colt Python
	{ weapon = "m9k_sig_p229r", ammo = 30 }, -- SIG P229R
	{ weapon = "m9k_glock", ammo = 64 }, -- Glock 18
	{ weapon = "m9k_mp9", ammo = 60 }, -- MP9
	{ weapon = "m9k_mp5", ammo = 60 }, -- MP5
	{ weapon = "m9k_smgp90", ammo = 100 }, -- P90
	{ weapon = "m9k_mp7", ammo = 60 }, -- MP7
	{ weapon = "m9k_ak47", ammo = 60 }, -- AK47
	{ weapon = "m9k_scar", ammo = 60 }, -- SCAR
	{ weapon = "m9k_auga3", ammo = 60 }, -- AUG A3
	{ weapon = "m9k_pkm", ammo = 150 }, -- PKM
	{ weapon = "m9k_m249lmg", ammo = 150 }, -- M249
	{ weapon = "m9k_ithacam37", ammo = 30 }, -- Ithacam 37
	{ weapon = "m9k_m3", ammo = 30 }, -- M3
	{ weapon = "m9k_1887winchester", ammo = 12 }, -- 1887 Winchester
	{ weapon = "m9k_m14sp", ammo = 40 }, -- M14
	{ weapon = "m9k_m98b", ammo = 60 }, -- M98B
	{ weapon = "m9k_aw50", ammo = 60 }, -- AW50
	{ weapon = "m9k_m79gl", ammo = 2 }, -- M79GL
	{ weapon = "m9k_rpg7", ammo = 1 }, -- RPG7
}

--[[-------------------------------------------------------------------------
This is the back-up weapons list that will be used during the game if somehow 
the above weapons list doesn't work.
---------------------------------------------------------------------------]]
GG_BACKUP_WEAPONS_LIST = {
	{ weapon = "weapon_357", ammo = 36 },
	{ weapon = "weapon_pistol", ammo = 36 },
	{ weapon = "weapon_smg1", ammo = 64 },
	{ weapon = "weapon_shotgun", ammo = 40 },
	{ weapon = "weapon_ar2", ammo = 100 },
	{ weapon = "weapon_crossbow", ammo = 10 },
	{ weapon = "weapon_rpg", ammo = 2 },
	{ weapon = "weapon_357", ammo = 36 },
	{ weapon = "weapon_pistol", ammo = 36 },
	{ weapon = "weapon_smg1", ammo = 64 },
	{ weapon = "weapon_shotgun", ammo = 40 },
	{ weapon = "weapon_ar2", ammo = 100 },
	{ weapon = "weapon_crossbow", ammo = 10 },
	{ weapon = "weapon_rpg", ammo = 2 },
	{ weapon = "weapon_357", ammo = 36 },
	{ weapon = "weapon_pistol", ammo = 36 },
	{ weapon = "weapon_smg1", ammo = 64 },
	{ weapon = "weapon_shotgun", ammo = 40 },
	{ weapon = "weapon_ar2", ammo = 100 },
	{ weapon = "weapon_crossbow", ammo = 10 },
}

--[[-------------------------------------------------------------------------
This is the secondary weapon which should be a melee weapon of some sort.

Note: If somehow the melee weapon down below doesn't work, the back-up melee
weapon will be used instead.
---------------------------------------------------------------------------]]
GG_KNIFE = "m9k_knife"
GG_KNIFE_THROW = "m9k_thrown_spec_knife"

--[[-------------------------------------------------------------------------
This is the back-up melee weapon that will be used during the game if somehow 
the above melee weapon doesn't work.
---------------------------------------------------------------------------]]
GG_BACKUP_KNIFE = "weapon_crowbar"
GG_BACKUP_KNIFE_THROW = "weapon_crowbar"

--[[-------------------------------------------------------------------------
This is a list of skins that will be used during the game. You can add
whatever skin you want here but make sure that every client has the skins
installed, otherwise they'll only see errors.

Note: If somehow the skins in the list below don't work, the backup list will
be used instead. Leave this list untouched!
---------------------------------------------------------------------------]]
GG_SKINS_LIST = {
	"models/codmw2/codmw2.mdl",
	"models/codmw2/codmw2h.mdl",
	"models/codmw2/codmw2he.mdl",
	"models/codmw2/codmw2hexe.mdl",
	"models/codmw2/codmw2m.mdl",
	"models/codmw2/t_codm.mdl",
	"models/codmw2/t_codmw2.mdl",
	"models/codmw2/t_codmw2h.mdl",
	"models/mw2guy/rus/gassoldier.mdl",
	"models/mw2guy/rus/soldier_a.mdl",
	"models/mw2guy/rus/soldier_c.mdl",
	"models/mw2guy/rus/soldier_d.mdl",
	"models/mw2guy/rus/soldier_e.mdl",
	"models/mw2guy/rus/soldier_f.mdl",
}

--[[-------------------------------------------------------------------------
This is a list of skins that will be used during the game if somehow the
skins in the list above don't work. Leave this list untouched!
---------------------------------------------------------------------------]]
GG_BACKUP_SKINS_LIST = {
	"models/player/urban.mdl",
	"models/player/gasmask.mdl",
	"models/player/riot.mdl",
	"models/player/swat.mdl",
	"models/player/leet.mdl",
	"models/player/guerilla.mdl",
	"models/player/arctic.mdl",
	"models/player/phoenix.mdl"
}

--[[-------------------------------------------------------------------------
The default number of minutes a round will take. You can also edit this in-game.
---------------------------------------------------------------------------]]
GG_ROUND_TIME_IN_MINUTES = 15

--[[-------------------------------------------------------------------------
The default amount of rounds a match has. You can also edit this in-game.
---------------------------------------------------------------------------]]
GG_AMOUNT_OF_ROUNDS_PER_MATCH = 5

--[[-------------------------------------------------------------------------
This is a list of usernames who can edit the game settings and start the 
match. If you leave the list empty, every player can start the match.

Note: If a player has admin rights but is not present in this list, he/she
can still start and control the game.

Example: GG_ALLOWED_PLAYERS = {
	"poepjejan1",
	"bluedragon102"
}
---------------------------------------------------------------------------]]
GG_ALLOWED_PLAYERS = {}

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

--[[-------------------------------------------------------------------------
KEEP THIS DISABLED ON REAL SERVERS - FOR DEBUGGING ONLY!
---------------------------------------------------------------------------]]
GG_DEBUG = false