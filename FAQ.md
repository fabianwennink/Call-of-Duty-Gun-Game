# Call of Duty - Gun Game | FAQ
<b>Q: Can I use any weapon/playermodel (addon) I want?</b><br />
A: Yes, you can use any weapon or playermodel you want as long as the server has installed the required addons and you're using a dedicated server. You can edit the weapons list located in the settings.lua file, see <a href="https://github.com/fabianwennink/Call-of-Duty-Gun-Game/blob/92629918ed0a10b392cfa581d78e3556944275f0/SETTINGS.md">SETTINGS.md (GG_WEAPONS_LIST)</a> for a preview. It's best to keep the secondary weapon a melee-type weapon.

<b>Q: Do I need to install the additional addons?</b><br/>
A: No, you are not required to install any of the additional addons. I used these addons during the development of the gamemode to make the gamemode feel more Call of Duty-like. The gamemode will function in the same way as it would with the additional addons being installed.

<b>Q: Can I use this gamemode if I don't have a dedicated server?</b><br />
A: Yes, you can use this gamemode in a 'singleplayer' server but remember that it's not really made for this kind of server.

<b>Q: How do I install the gamemode on my dedicated server?</b><br />
A: To install the gamemode on your dedicate server, you can either download the decompiled gamemode source files from <a href="https://github.com/fabianwennink/Call-of-Duty-Gun-Game/releases">here</a> or decompile the addon yourself by using the GMAD Extractor: <a href="https://www.youtube.com/watch?v=waLchC8_qRk">https://www.youtube.com/watch?v=waLchC8_qRk</a>.

Once you have downloaded/decompiled the source files, simply drag the `/cod_gungame/` folder into the `/gamemodes/` folder of your server.


<b>Q: I can't press the 'Start Game' button!</b><br />
A: Only admins and players defined in the `GG_ALLOWED_PLAYERS` table are allowed to start the match. If you can't edit the `settings.lua` file, please install a rank/permissions manager.

<b>Q: I don't see a countdown screen after starting the match!</b><br />
A: When this happens it's likely that your addon version doesn't match the server one. Please make sure that both are up-to-date. It's not really a huge problem if the screen doesn't appear as the gamemode still runs in the background.

<b>Q: The MySQL database doesn't work!</b><br />
A: Make sure that you configured the database settings correctly. Also make sure that you've installed the required modules.
