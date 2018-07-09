local frame
local round_time = GG_ROUND_TIME_IN_MINUTES; match_rounds = GG_AMOUNT_OF_ROUNDS_PER_MATCH
local invert_guns = false

-- Get admin function
function playerIsAllowed(username)

	if(countValues(GG_ALLOWED_PLAYERS) == 0) then
		return true
	end

	for _, ply in ipairs(GG_ALLOWED_PLAYERS) do
		if(ply == username) then 
			return true 
		end
	end

	return false

end

-- Open the lobby
function openLobby()

	local width = ScrW() / 2
	local height = ScrH() / 2
	local playercount = 0

	if !IsValid( frame ) then
		frame = vgui.Create("DFrame")
		frame:SetSize(ScrW(), ScrH())
		frame:Center()
		frame:SetVisible(true)
		frame:ShowCloseButton(false)
		frame:SetDraggable(false)
		frame:SetTitle("")
		frame.Paint = function(s, w, h)
			playercount = countValues(getPlayerData())
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
			draw.RoundedBox(1, width - 304, height - 250, 608, 500, Color(73,72,80))
			draw.RoundedBox(1, width - 300, height - 246, 600, 492, Color(52,51,56))
			draw.RoundedBox(1, width - 300, height - 55, 600, 4, Color(64,63,68))
			draw.RoundedBox(1, width - 300, height + 70, 600, 4, Color(64,63,68))
			draw.RoundedBox(1, width - 300, height + 205, 600, 4, Color(64,63,68))

			draw.DrawText(string.upper("(Only admins can start the game)"), "COD_FONT_3", width, height + 38, Color(255,255,255), TEXT_ALIGN_CENTER)
			
			if(playercount < 2) then
				draw.DrawText("Waiting for 1 more player", "COD_FONT_1", width, height + 214, Color(244,252,142), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("Ready to start the game (" .. playercount .. ")", "COD_FONT_1", width, height + 214, Color(244,252,142), TEXT_ALIGN_CENTER)
			end

			draw.DrawText(string.upper("Time per round"), "COD_FONT_3", width - 130, height + 83, Color(255,255,255), TEXT_ALIGN_CENTER)
			draw.DrawText(round_time, "COD_FONT_1", width - 135, height + 110, Color(255,255,255), TEXT_ALIGN_CENTER)
			
			draw.DrawText(string.upper("Rounds per match"), "COD_FONT_3", width + 135, height + 83, Color(255,255,255), TEXT_ALIGN_CENTER)
			draw.DrawText(match_rounds, "COD_FONT_1", width + 135, height + 110, Color(255,255,255), TEXT_ALIGN_CENTER)

			if(invert_guns) then
				draw.DrawText("enabled", "COD_FONT_1", width + 100, height + 160, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("disabled", "COD_FONT_1", width + 100, height + 160, Color(255,255,255), TEXT_ALIGN_CENTER)
			end

			if(GetConVar("sv_cheats"):GetInt() == 1) then
				draw.DrawText("Warning: sv_cheats is enabled!", "COD_FONT_1", width, height - 290, Color(255,129,129), TEXT_ALIGN_CENTER)
			end
		end
		frame:MakePopup()

		-- Logo
		local logoImg = vgui.Create( "DImage", frame )
		logoImg:SetPos( width - 168, height - 200 )
		logoImg:SetSize( 336, 105 )
		logoImg:SetImage( "gamemodes/cod_gungame/logo.png" )
		
		local startBut = vgui.Create("DButton", frame)
		startBut:SetSize(250, 55)
		startBut:SetTextColor(Color(255, 255, 255))
		startBut:SetText("Start game")
		startBut:SetFont("COD_FONT_1")
		startBut:SetPos(width - 125, height - (55/2))
		startBut.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(73,72,80))
		end
		startBut.DoClick = function()
			if(LocalPlayer():IsAdmin() and playercount > 1 || playerIsAllowed(LocalPlayer():GetName()) == true and playercount > 1 || GG_DEBUG == true) then

				net.Start("Start_Game")
					net.WriteTable({round_time, match_rounds, invert_guns, LocalPlayer():GetName()})
				net.SendToServer()

			end
		end

	    -- Plus button - minutes
		local timePlus = vgui.Create("DButton", frame)
		timePlus:SetSize(45, 35)
		timePlus:SetTextColor(Color(255, 255, 255))
		timePlus:SetText("+")
		timePlus:SetFont("COD_FONT_1")
		timePlus:SetPos(width - 80, height + 105)
		timePlus.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(73,72,80))
		end
		timePlus.DoClick = function()
			if(LocalPlayer():IsAdmin() || playerIsAllowed(LocalPlayer():GetName()) == true || GG_DEBUG == true) then
				if(round_time >= 0 && round_time < 60) then
					round_time = round_time + 1
				end
			end
		end
		
		-- Minus button - minutes
		local timeMin = vgui.Create("DButton", frame)
		timeMin:SetSize(45, 35)
		timeMin:SetTextColor(Color(255, 255, 255))
		timeMin:SetText("-")
		timeMin:SetFont("COD_FONT_1")
		timeMin:SetPos(width - 225, height + 105)
		timeMin.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(73,72,80))
		end
		timeMin.DoClick = function()
			if(LocalPlayer():IsAdmin() || playerIsAllowed(LocalPlayer():GetName()) == true || GG_DEBUG == true) then
				if(round_time > 1 && round_time < 60) then
					round_time = round_time - 1
				end
			end
		end
		
		-- Plus button - rounds
		local roundsPlus = vgui.Create("DButton", frame)
		roundsPlus:SetSize(45, 35)
		roundsPlus:SetTextColor(Color(255, 255, 255))
		roundsPlus:SetText("+")
		roundsPlus:SetFont("COD_FONT_1")
		roundsPlus:SetPos(width + 175, height + 105)
		roundsPlus.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(73,72,80))
		end
		roundsPlus.DoClick = function()
			if(LocalPlayer():IsAdmin() || playerIsAllowed(LocalPlayer():GetName()) == true || GG_DEBUG == true) then
				if(match_rounds >= 0 && match_rounds < 25) then
					match_rounds = match_rounds + 1
				end
			end
		end
		
		-- Minus button - rounds
		local roundsMin = vgui.Create("DButton", frame)
		roundsMin:SetSize(45, 35)
		roundsMin:SetTextColor(Color(255, 255, 255))
		roundsMin:SetText("-")
		roundsMin:SetFont("COD_FONT_1")
		roundsMin:SetPos(width + 50, height + 105)
		roundsMin.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(73,72,80))
		end
		roundsMin.DoClick = function()
			if(LocalPlayer():IsAdmin() || playerIsAllowed(LocalPlayer():GetName()) == true || GG_DEBUG == true) then
				if(match_rounds > 1 && match_rounds < 25) then
					match_rounds = match_rounds - 1
				end
			end
		end

		-- Invert button - guns
		local gunsInvert = vgui.Create("DButton", frame)
		gunsInvert:SetSize(250, 35)
		gunsInvert:SetTextColor(Color(255, 255, 255))
		gunsInvert:SetText("Invert Weapons")
		gunsInvert:SetFont("COD_FONT_1")
		gunsInvert:SetPos(width - 225, height + 155)
		gunsInvert.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(73,72,80))
		end
		gunsInvert.DoClick = function()
			if(LocalPlayer():IsAdmin() || playerIsAllowed(LocalPlayer():GetName()) == true || GG_DEBUG == true) then
				if(invert_guns == false) then
					invert_guns = true
				else 
					invert_guns = false
				end
			end
		end

		-- Disconnect button
		local disconBut = vgui.Create("DButton", frame)
		disconBut:SetSize(200, 35)
		disconBut:SetTextColor(Color(255, 255, 255))
		disconBut:SetText("Click here to disconnect")
		disconBut:SetFont("COD_FONT_3")
		disconBut:SetPos(width - 100, height + 250)
		disconBut.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,0))
		end
		disconBut.DoClick = function()
			LocalPlayer():ConCommand( "disconnect" )
		end
	end
end

-- Close lobby
function closeLobby() 

	frame:Close()

end

-- Open & Close lobby
net.Receive("Open_Lobby", openLobby)
net.Receive("Close_Lobby", closeLobby)