--[[-------------------------------------------------------------------------

	Copyright © Fabian Wennink - All rights reserved
	CALL OF DUTY is a trademark of Activision Publishing, Inc. 

	Please do not copy and/or re-distribute any code without my 
	written permission.

---------------------------------------------------------------------------]]

GM.Name = "Call of Duty - Gun Game"
GM.Author = "Fabian Wennink"
GM.Website = "https://www.fabianwennink.nl"

function GM:Initialize()

	-- COD HUD Font
	resource.AddSingleFile("resource/fonts/bankgthd.ttf")
	resource.AddSingleFile( "materials/hud/knife.png" )
	resource.AddSingleFile( "materials/hud/m9.png" )
	resource.AddSingleFile( "materials/hud/skull.png" )

	if( SERVER ) then

		if(GG_USE_M9K) then
			resource.AddWorkshop("128089118") -- Assault rifles
			resource.AddWorkshop("128091208") -- Heavy weapons
			resource.AddWorkshop("128093075") -- Small arms pack
			resource.AddWorkshop("144982052") -- Specialties

			RunConsoleCommand("M9KWeaponStrip","0")
		else
			print("[Call of Duty - Gun Game] M9K weapons packs not enabled.")
		end

		if(GG_USE_MW2_SKINS) then
			resource.AddWorkshop("500247187")
		else
			print("[Call of Duty - Gun Game] MW2 skins not enabled.")
		end

	    -- 0 = not started, 
	    -- 1 = playing, 
	    -- 2 = match beginning, 
	    -- 3 = round changing
		SetGlobalInt( "GG_GAME_STATUS" , 0 ) 
		SetGlobalInt( "GG_CURRENT_ROUND" , 1 ) 
		SetGlobalInt( "GG_MATCH_START_TIMER" , 10 )
		SetGlobalInt( "GG_ROUND_END_TIMER", 20 )
		SetGlobalBool( "GG_INVERT_WEAPON_LIST", false )
	end

	if( CLIENT ) then

		surface.CreateFont( "COD_FONT_1", { font = "BankGothic Md BT", size = 25, antialias = true })
		surface.CreateFont( "COD_FONT_2", { font = "BankGothic Md BT", size = 18, antialias = true })
		surface.CreateFont( "COD_FONT_3", { font = "BankGothic Md BT", size = 14, antialias = true })
		surface.CreateFont( "COD_FONT_COUNT_1", { font = "BankGothic Md BT", size = 50, antialias = true })
		surface.CreateFont( "COD_FONT_COUNT_2", { font = "BankGothic Md BT", size = 100, antialias = true })
		surface.CreateFont( "COD_FONT_SCORE_1", { font = "BankGothic Md BT", size = 30, antialias = true })

	end

	self.BaseClass.Initialize(self)

end

-- Count values in table
function countValues(tbl)

	local total = 0
	for k, v in ipairs( tbl ) do
		total = total + 1
	end
	
	return total

end