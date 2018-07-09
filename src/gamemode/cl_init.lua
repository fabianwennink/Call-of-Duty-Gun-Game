-- Include the default scripts
include("settings.lua")
include("shared.lua")

-- Include the other scripts
include("data_handler/cl_data_handler.lua")
include("game_handler/cl_game_handler.lua")
include("pregame_screen/cl_pregame.lua")

local m9_icon = Material( "hud/m9.png", "noclamp smooth" ) 
local knife_icon = Material( "hud/knife.png", "noclamp smooth" ) 
local skull_icon = Material( "hud/skull.png", "noclamp smooth" ) 

-- Hide the default HUD elements
local hide = { CHudHealth = true, CHudBattery = true, CHudAmmo = true, CHudWeapon = true, CHudSecondaryAmmo = false }
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if (hide[name]) then return false end
end)

-- Draw the custom HUD
hook.Add( "HUDPaint", "COD_HUD", function()
	
	local gameStatus = GetGlobalInt( "GG_GAME_STATUS" )
	local width = ScrW(); height = ScrH()

	local roundTime = (GetGlobalInt( "GG_ROUND_COUNTDOWN" ) + (GetGlobalInt( "GG_ROUND_TIME" ) * 60)) - CurTime()

	if(gameStatus == 1) then
		local winning = false; losing = false; tie = false
		local per_win = 0; per_lose = 0
		local player = LocalPlayer()

		local kills_1 = getDataKills(1); kills_2 = getDataKills(2); own_kills = player:GetNWInt("killcounter")
		local player_1 = getDataName(1); player_2 = getDataName(2);
		--[[-------------------------------------------------------------------------
		Deside the player's game status
		---------------------------------------------------------------------------]]
		if(player_1 == player:GetName() and kills_1 > kills_2) then
			winning = true
			per_win = player:GetNWInt("killcounter")

			if(kills_2 != nil) then
				per_lose = kills_2
			else
				per_lose = 0
			end
		else
			if(kills_1 == own_kills and player_1 != player:GetName() || kills_1 == kills_2 and 
				(player_1 == player:GetName() || player_2 == player:GetName())) then
					tie = true
					per_win = player:GetNWInt("killcounter")

					if(kills_2 != nil) then
						per_lose = kills_2
					else
						per_lose = 0
					end
			else 
				losing = true
				per_win = player:GetNWInt("killcounter")
				per_lose = kills_1
			end
		end

		--[[-------------------------------------------------------------------------
		Draw the RenderView for the 'minimap'
		---------------------------------------------------------------------------]]
	    local CamData = {}
	    CamData.angles = Angle(90,90,-player:GetAimVector():Angle().y + 90)
	    CamData.origin = Vector(player:GetPos().x,player:GetPos().y,500)
	    CamData.x = 20
	    CamData.y = 20
	    CamData.w = 175
	    CamData.h = 175   
	    CamData.drawviewmodel = false
	    render.RenderView( CamData )

	    surface.SetDrawColor( Color( 255, 255, 255, 120 ) )
		surface.DrawOutlinedRect( 19, 19, 177, 177 )
		surface.SetDrawColor( Color( 245,226,167, 240 ) )

		local triangle = {
			{ x = 100, y = 110 },
			{ x = 105, y = 100 },
			{ x = 110, y = 110 }
		}

		surface.DrawPoly( triangle )

		--[[-------------------------------------------------------------------------
		Draw the winning box
		---------------------------------------------------------------------------]]
		draw.RoundedBox( 2, 30, height - 97, 360 ,20, Color(40,40,40, 75))
		draw.RoundedBox( 2, 75, height - 93, (per_win * 5) * 3 ,12, Color(157,215,154))
		draw.RoundedBox( 2, 75 + (per_win * 5) * 3, height - 93, 3 ,12, Color(255,255,255))

		--[[-------------------------------------------------------------------------
		Draw a white line between the boxes
		---------------------------------------------------------------------------]]
		draw.RoundedBox( 0, 30, height - 76, 360 ,1, Color(255,255,255, 75))
		
		--[[-------------------------------------------------------------------------
		Draw the losing boxes
		---------------------------------------------------------------------------]]
		draw.RoundedBox( 2, 30, height - 75, 360 ,20, Color(40,40,40, 75))
		draw.RoundedBox( 2, 75, height - 71, (per_lose * 5) * 3 ,12, Color(194,73,62))
		draw.RoundedBox( 2, 75 + (per_lose * 5) * 3, height - 71, 3 ,12, Color(255,255,255))
		
		--[[-------------------------------------------------------------------------
		Draw the winning and losing points amount
		---------------------------------------------------------------------------]]
		draw.SimpleText(per_win, "COD_FONT_1", 50, height - 102 + 14, Color(255,255,255),1,1)
		draw.SimpleText(per_lose, "COD_FONT_1", 50, height - 75 + 9, Color(255,255,255),1,1)
		
		--[[-------------------------------------------------------------------------
		Draw the player's game status
		---------------------------------------------------------------------------]]
		if(losing) then
			draw.SimpleText("LOSING", "COD_FONT_1", 80, height - 115, Color(216,116,121),1,1)
		elseif(winning) then
			draw.SimpleText("WINNING", "COD_FONT_1", 90, height - 115, Color(134,255,142),1,1)
		else
			draw.SimpleText("TIE", "COD_FONT_1", 50, height - 115, Color(255,255,108),1,1)
		end

		--[[-------------------------------------------------------------------------
		Draw the round timer
		---------------------------------------------------------------------------]]
		draw.SimpleText(string.FormattedTime(roundTime, "%02i:%02i"), "COD_FONT_1", 450, height - 64, Color(255,255,255),1,1)
		
		--[[-------------------------------------------------------------------------
		Calculate the amount of bullets left
		---------------------------------------------------------------------------]]
		local weapon = player:GetActiveWeapon()

		if ( !IsValid( weapon )) then return -1 end
		
		local bulletNum = weapon:Clip1()
		local max = weapon:GetMaxClip1()
		local ammo_gun = player:GetAmmoCount( weapon:GetPrimaryAmmoType() )
		
		--[[-------------------------------------------------------------------------
		Draw the bullet lines based on the amount of bullets left in the gun
		---------------------------------------------------------------------------]]
		if(bulletNum <= 50) then
			for i = 1,bulletNum do 
				surface.DrawLine( width -197-i*5, height - 80, width-197-i*5, height - 65 )      
				surface.DrawLine( width -198-i*5, height - 80, width-198-i*5, height - 65 )  
				surface.DrawLine( width -199-i*5, height - 80, width-199-i*5, height - 65 )         
			end
		else
			local BarLength = (bulletNum * 240) / max
			
			surface.SetDrawColor( Color(160, 160, 160) )
	        surface.DrawRect(width-210-BarLength, height - 80, BarLength - 13, 15 )  
	    end 

		surface.SetDrawColor( Color(160, 160, 160) )
		
		--[[-------------------------------------------------------------------------
		Display the current bullet count
		---------------------------------------------------------------------------]]
		draw.SimpleText(ammo_gun + bulletNum, "COD_FONT_1", width - 165, height - 74, Color(255,255,255),1,1)
		draw.SimpleText(weapon:GetPrintName(), "COD_FONT_1", width - 290, height - 45, Color(255,255,255),1,1)
		
		-- Create the lines in the right bottom side
	    surface.DrawRect(width - 450, height - 61, 315, 3 )  
		surface.DrawLine(width - 135, height - 60, width - 114, height - 85 )      
	  	surface.DrawLine(width - 136, height - 60, width - 115, height - 85 )      
		surface.DrawLine(width - 137, height - 60, width - 116, height - 85 )      
		surface.DrawRect(width - 116, height - 84, 50, 3 ) 

		--[[-------------------------------------------------------------------------
		Display the health of the player
		---------------------------------------------------------------------------]]
		local health = player:Health()
		local health_string = health

		if ( health > 100 ) then health = 100 end

		if(health >= 75) then
			surface.SetDrawColor(63,195,89, 225) -- green
		elseif(health < 75 and health >= 50) then
			surface.SetDrawColor(243,219,65, 225) -- yellow
		else
			surface.SetDrawColor(194,73,62, 225) -- red
		end

		surface.DrawRect( width - 50, height - health * 3 - 80, 30, health * 3 )
		draw.SimpleText(health_string .. "%", "COD_FONT_2", width - 35, height - health * 3 - 100 + 9, Color(255,255,255),1,1)

		--[[-------------------------------------------------------------------------
		Draw a crosshair on the screen
		---------------------------------------------------------------------------]]
		surface.SetDrawColor(255,255,255)
		surface.DrawRect(width / 2 - 1, height / 2 - 1, 2, 2)

		-- Killfeed
		if(showKillFeed()) then
			drawKillFeed(height)
		end
	else
		if(gameStatus == 2) then

			draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
			draw.DrawText(string.upper("Match Begins in"), "COD_FONT_COUNT_1", width / 2, height / 2 - 200, Color(255,255,255), TEXT_ALIGN_CENTER)
			draw.DrawText(getGameTimer(), "COD_FONT_COUNT_2", width / 2, height / 2 - 125, Color(255,247,1), TEXT_ALIGN_CENTER)

		elseif(gameStatus == 3) then
			local playercount = countValues(getPlayerData())

			local player = LocalPlayer()
			local kills_1 = getDataKills(1); kills_2 = getDataKills(2); own_kills = player:GetNWInt("killcounter")
			local player_1 = getDataName(1); player_2 = getDataName(2);

			draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
			
			-- Top text
			draw.RoundedBox(3, width / 2 - 300, height / 2 - 230, 600, 75, Color(0,0,0, 100))

			if(roundTime <= 0) then
				draw.DrawText("Time limit reached - round " .. GetGlobalInt("GG_CURRENT_ROUND") .. "/" .. GetGlobalInt("GG_MATCH_ROUNDS"), "COD_FONT_SCORE_1", width / 2, height / 2 - 265, Color(234, 234, 234), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("Score limit reached - round " .. GetGlobalInt("GG_CURRENT_ROUND") .. "/" .. GetGlobalInt("GG_MATCH_ROUNDS"), "COD_FONT_SCORE_1", width / 2, height / 2 - 265, Color(234, 234, 234), TEXT_ALIGN_CENTER)
			end

			if(player_1 == player:GetName() and kills_1 > kills_2) then
				draw.DrawText("VICTORY!", "COD_FONT_COUNT_1", width / 2, height / 2 - 218, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				if(kills_1 == own_kills and player_1 != player:GetName() || kills_1 == kills_2 and 
					(player_1 == player:GetName() || player_2 == player:GetName())) then

					draw.DrawText("TIE!", "COD_FONT_COUNT_1", width / 2, height / 2 - 218, Color(255,255,255), TEXT_ALIGN_CENTER)
				else 
					draw.DrawText("DEFEAT!", "COD_FONT_COUNT_1", width / 2, height / 2 - 218, Color(255,255,255), TEXT_ALIGN_CENTER)
				end
			end

			if(roundTime <= 0) then
				draw.DrawText("Match ending in: " .. getRoundTimer(), "COD_FONT_1", width / 2, height / 2 - 148, Color(244,252,142), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("Next round starting in: " .. getRoundTimer(), "COD_FONT_1", width / 2, height / 2 - 148, Color(244,252,142), TEXT_ALIGN_CENTER)
			end

			-- #1
			draw.DrawText("1st", "COD_FONT_COUNT_1", width / 2, height / 2 - 83, Color(250,250,250), TEXT_ALIGN_CENTER)
			draw.DrawText(getDataName(1), "COD_FONT_COUNT_1", width / 2, height / 2 - 35, Color(250,250,250), TEXT_ALIGN_CENTER)

			-- #2
			if(playercount > 1) then
				draw.DrawText("2nd", "COD_FONT_1", width / 2, height / 2 + 45, Color(165, 165, 165), TEXT_ALIGN_CENTER)
				draw.DrawText(getDataName(2), "COD_FONT_SCORE_1", width / 2, height / 2 + 75, Color(165, 165, 165), TEXT_ALIGN_CENTER)
			end

			-- #3
			if(playercount > 2) then
				draw.DrawText("3rd", "COD_FONT_1", width / 2, height / 2 + 135, Color(165, 165, 165), TEXT_ALIGN_CENTER)
				draw.DrawText(getDataName(3), "COD_FONT_SCORE_1", width / 2, height / 2 + 165, Color(180, 180, 180), TEXT_ALIGN_CENTER)
			end
		end
	end
end)

function drawKillFeed(height)
	local feed = getKillFeed()
	local total = countValues(feed)

	if(total > 0) then
		for i = 1, #feed do
			if(feed[i] != nil) then

				surface.SetFont( "COD_FONT_2" )
				surface.SetDrawColor( 255, 255, 255, 255 )
				
				if(feed[i].attacker == nil) then -- suicide					
					surface.SetMaterial( skull_icon	)
					surface.DrawTexturedRect( 38, height - (165  + (30 * (total - i))), 15, 17 )

					draw.SimpleText(feed[i].victim, "COD_FONT_2", 38 + 25, height - (158  + (30 * (total - i))), Color(255,255,255),0,1)

					draw.WordBox( 4, 30, height - (170  + (30 * (total - i))), "____" .. feed[i].victim, "COD_FONT_2", Color(0,0,0, 90), Color(0,0,0,0) )
				elseif(feed[i].status == 1) then -- knife kill
				 	local tWidth, tHeight = surface.GetTextSize( feed[i].attacker )

					draw.SimpleText(feed[i].attacker, "COD_FONT_2", 38, height - (158  + (30 * (total - i))), Color(255,255,255),0,1)

					surface.SetMaterial( knife_icon	)
					surface.DrawTexturedRect( 48 + tWidth, height - (165  + (30 * (total - i))), 15, 17 )

					draw.SimpleText(feed[i].victim, "COD_FONT_2", 38 + tWidth + 35, height - (158  + (30 * (total - i))), Color(255,255,255),0,1)

					draw.WordBox( 4, 30, height - (170  + (30 * (total - i))), feed[i].attacker .. "_____" .. feed[i].victim, "COD_FONT_2", Color(0,0,0, 90), Color(0,0,0,0) )
				else -- kill
				 	local tWidth, tHeight = surface.GetTextSize( feed[i].attacker )

					draw.SimpleText(feed[i].attacker, "COD_FONT_2", 38, height - (158  + (30 * (total - i))), Color(255,255,255),0,1)

					surface.SetMaterial( m9_icon	)
					surface.DrawTexturedRect( 48 + tWidth, height - (165  + (30 * (total - i))), 25, 17 )

					draw.SimpleText(feed[i].victim, "COD_FONT_2", 38 + tWidth + 45, height - (158  + (30 * (total - i))), Color(255,255,255),0,1)

					draw.WordBox( 4, 30, height - (170  + (30 * (total - i))), feed[i].attacker .. "______" .. feed[i].victim, "COD_FONT_2", Color(0,0,0, 90), Color(0,0,0,0) )
				end

				if(feed[i].die < CurTime()) then table.remove(feed, 1 ) end
			end
		end
	else
		if(show_feed) then show_feed = false end
	end
end

function GM:PostDrawViewModel( vm, ply, weapon )

  if ( weapon.UseHands || !weapon:IsScripted() ) then
    local hands = LocalPlayer():GetHands()
    if ( IsValid( hands ) ) then hands:DrawModel() end

  end

end