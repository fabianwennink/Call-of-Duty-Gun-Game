-- Send the default scripts to the client
AddCSLuaFile("settings.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Include the default scripts
include("settings.lua")
include("shared.lua")
include("mysql.lua")

-- Send the other scripts to the client
AddCSLuaFile("data_handler/cl_data_handler.lua")
AddCSLuaFile("game_handler/cl_game_handler.lua")
AddCSLuaFile("pregame_screen/cl_pregame.lua")

-- Include the other scripts
include("data_handler/sv_data_handler.lua")
include("game_handler/sv_game_handler.lua")
include("pregame_screen/sv_pregame.lua")

-- Initial spawn
function GM:PlayerInitialSpawn( player ) 

	-- Set a model for the player
	if(util.IsValidModel(table.Random( GG_SKINS_LIST ))) then
		player:SetModel( table.Random( GG_SKINS_LIST ) )
	else
		player:SetModel( table.Random( GG_BACKUP_SKINS_LIST ) )
	end

	-- Check if the player is in the score list
	checkScore( player )

end

-- Player Spawn event
function GM:PlayerSpawn( player )

	-- Check if the game started and the player has less than 20 kills
	if(GetKills(player) < 20 && GetGlobalInt( "GG_GAME_STATUS" ) == 1) then
		player:RemoveAllItems()
		GiveLoadout(player, GetKills(player) + 1)
	end

	-- Set a model for the player
	if(util.IsValidModel(table.Random( GG_SKINS_LIST ))) then
		player:SetModel( table.Random( GG_SKINS_LIST ) )
	else
		player:SetModel( table.Random( GG_BACKUP_SKINS_LIST ) )
	end

	-- Set correct player hands
	local oldhands = player:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
	    player:SetHands( hands )
	    hands:SetOwner( player )

	    -- Which hands should we use?
	    local cl_playermodel = player:GetInfo( "cl_playermodel" )
	    local info = player_manager.TranslatePlayerHands( cl_playermodel )

	    if ( info ) then
	      hands:SetModel( info.model )
	      hands:SetSkin( info.skin )
	      hands:SetBodyGroups( info.body )
	    end

	    -- Attach them to the viewmodel
	    local vm = player:GetViewModel( 0 )
	    hands:AttachToViewmodel( vm )

	    vm:DeleteOnRemove( hands )
	    player:DeleteOnRemove( hands )

	    hands:Spawn()
	end

end

-- On player death event
function GM:PlayerDeath( victim, weapon, attacker )

	-- If the player commited suicide, remove a kill
	if (victim == attacker || !attacker:IsPlayer()) then
		RemoveKill(nil, victim, 0)
	else
		-- If the weapon used is a knife
		local used_weapon = ""

		-- if weapon doesn't equal player
		if(weapon:GetClass() != "player") then
			used_weapon = weapon:GetClass()
		else -- if attacker's weapon is not nil
			if(attacker:GetActiveWeapon():GetClass() != nil) then 

				-- if the current weapon doesn't equal the one from the weapons list
				if(getCurrentWeapon(GetKills(attacker) + 1) != nil and attacker:GetActiveWeapon():GetClass() != getCurrentWeapon(GetKills(attacker) + 1)) then
					used_weapon = attacker:GetActiveWeapon():GetClass()
				end

			end
		end

		-- if melee attack
		if(used_weapon == GG_KNIFE || used_weapon == GG_KNIFE_THROW || used_weapon == GG_BACKUP_KNIFE || used_weapon == GG_BACKUP_KNIFE_THROW) then
		   	RemoveKill(attacker, victim, 1)
		else 
			AddKill(attacker, victim, -1)
		end
	end
	
	-- If the player has less than 20 kills
	if (IsValid(attacker)) then
		if(attacker:IsPlayer() and GetKills(attacker) < 20) then
			if(victim != attacker and attacker:Alive()) then 
				attacker:RemoveAllItems() 
			end

			GiveLoadout(attacker, GetKills(attacker) + 1)
		end
	end

end

-- Player disconnects
function GM:PlayerDisconnected( ply )
	
	local gameStatus = GetGlobalInt( "GG_GAME_STATUS" )

	-- If the game started or is counting down, delete data
	ResetData(ply)

	-- If only 1 player is left, end game
	if(countValues(player.GetAll()) <= 1 && (gameStatus == 1 || gameStatus == 2)) then
		checkReset()
	end

end

-- Give player first weapon
function GiveLoadout(player, count) 

	local wp

	if(GetGlobalBool( "GG_INVERT_WEAPON_LIST" )) then
		wp = GG_WEAPONS_LIST[20 - (count - 1)].weapon

		if(weapons.GetStored( wp ) == nil) then
			print("[Call of Duty - Gun Game] Weapon '" .. wp .. "' missing, using backup weapon!")
			wp = GG_BACKUP_WEAPONS_LIST[20 - (count - 1)].weapon
		end
	else
		wp = GG_WEAPONS_LIST[count].weapon

		if(weapons.GetStored( wp ) == nil and GG_USE_M9K) then
			print("[Call of Duty - Gun Game] Weapon '" .. wp .. "' missing, using backup weapon!")
			wp = GG_BACKUP_WEAPONS_LIST[count].weapon
		end
	end

	-- Give the gun and stip from all the ammo
	player:Give(wp)
	player:StripAmmo()

	local weapon = player:GetActiveWeapon()

	if(IsValid(weapon)) then
		local ammo_type = weapon:GetPrimaryAmmoType()
		local remaining_ammo

		if(GetGlobalBool( "GG_INVERT_WEAPON_LIST" )) then
			if(weapons.GetStored( wp ) == nil and GG_USE_M9K) then
				remaining_ammo = GG_BACKUP_WEAPONS_LIST[20 - (count - 1)].ammo - weapon:Clip1()
			else
				remaining_ammo = GG_WEAPONS_LIST[20 - (count - 1)].ammo - weapon:Clip1()
			end
		else
			if(weapons.GetStored( wp ) == nil and GG_USE_M9K) then
				remaining_ammo = GG_BACKUP_WEAPONS_LIST[count].ammo - weapon:Clip1()
			else 
				remaining_ammo = GG_WEAPONS_LIST[count].ammo - weapon:Clip1()
			end
		end

	    -- Give ammo
		player:GiveAmmo(remaining_ammo, ammo_type, true)
	end

	-- Give the knife
	if(weapons.GetStored( GG_KNIFE ) == nil and GG_USE_M9K) then
		player:Give(GG_BACKUP_KNIFE)
		print("[Call of Duty - Gun Game] Weapon '" .. GG_KNIFE .. "' missing!")
	else
		player:Give(GG_KNIFE)
	end

	-- Select gun
	player:SelectWeapon(wp)

end

-- Get current weapon from list
function getCurrentWeapon(count)

	local wp

	if(GetGlobalBool( "GG_INVERT_WEAPON_LIST" )) then
		wp = GG_WEAPONS_LIST[20 - (count - 1)].weapon

		if(weapons.GetStored( wp ) == nil) then
			print("[Call of Duty - Gun Game] Weapon '" .. wp .. "' missing, using backup weapon!")
			wp = GG_BACKUP_WEAPONS_LIST[20 - (count - 1)].weapon
		end
	else
		wp = GG_WEAPONS_LIST[count].weapon

		if(weapons.GetStored( wp ) == nil and GG_USE_M9K) then
			print("[Call of Duty - Gun Game] Weapon '" .. wp .. "' missing, using backup weapon!")
			wp = GG_BACKUP_WEAPONS_LIST[count].weapon
		end
	end

	return wp
end

-- Kill counter - add kill
function AddKill(attacker, victim, status)

	attacker:SetNWInt("killcounter", GetKills(attacker) + 1)

	updateKillFeed(attacker, victim, -1)
	updateServerScore(attacker, victim)

	-- Update serverside score
	updateScore(attacker:GetName(), GetKills(attacker))

end

-- Kill counter - set kills
function RemoveKill(attacker, victim, status)

	if(GetKills(victim) > 0) then
		victim:SetNWInt("killcounter", GetKills(victim) - 1)
	end

	-- Update kill feed
	if(status == 0) then
		updateKillFeed(nil, victim, status)
		updateServerScore(nil, victim)
	elseif(status == 1) then
		updateKillFeed(attacker, victim, status)
		updateServerScore(attacker, victim)
	end

	-- Update serverside score
	updateScore(victim:GetName(), GetKills(victim))

end

-- Kill counter - get kills
function GetKills(player)

	return player:GetNWInt("killcounter")

end