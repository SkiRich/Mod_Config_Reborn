local function LegacyDailyPopup()
    CreateRealTimeThread(function()
        local params = {
              title = "Legacy Mod Config Loaded",
               text = "Please disable this version of Mod Config and download and enable the new version, Mod Config Reborn.",
            choice1 = "Download Mod Config Reborn [Opens in new window]",
            choice2 = "I'll do it later",
              image = "UI/Messages/death.tga",
              start_minimized = false,
        } -- params
        local choice = WaitPopupNotification(false, params)
        if choice == 1 then
        	OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1542863522", true)
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function OnMsg.NewDay()
  if table.find(ModsLoaded, "steam_id", "1340775972") then
    LegacyDailyPopup()
  end -- if table
end -- NewDay