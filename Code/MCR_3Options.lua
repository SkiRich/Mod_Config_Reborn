-- Code developed for Mod Config Reborn
-- Code originally developed by Waywocket as Mod Config
-- Modified to work with Gagarin Patch
-- Re-written to optimize code
-- Author @SkiRich
-- This mod is subject to the terms and conditions outlined in the LICENSE file included in this mod.
-- Created Oct 14th, 2018
-- Updated March 16th, 2021

-- StringIdBase this file 31-50

function OnMsg.ModConfigReady()
    local StringIdBase = ModConfig.StringIdBase

    -- Register this mod's name and description
    ModConfig:RegisterMod("_ModConfigReborn_", -- ID
        T{StringIdBase, "_Mod Config Reborn_"}, -- Optional display name, defaults to ID
        T{StringIdBase + 1, "Options for Mod Config Reborn"} -- Optional description
    )

    ModConfig:RegisterOption("_ModConfigReborn_", "ResetModConfigData", {
        name = T{StringIdBase + 2, "Reset All Mod Config Data:"},
        desc = T{StringIdBase + 3, "Reset and default all Mod Config Data. All mods will be defaulted if defaults defined. Do this only if you suspect registry corruption in mod config or for a fresh start."},
        type = "boolean",
        default = false
    })

end -- OnMsg.ModConfigReady()

local function MCRConfirmChangePopup(changetype)
	local changetypetext = {
		["blank"] = {text = "None Specified", explain = "will do nothing.", choice1 = "Close", choice2 = "Close"},
		["reset"] = {text = "Reset All Data", explain = "is not reversable.  All data will be defaulted for all mods.", choice1 = "Do It", choice2 = "Cancel"},
	}
	if not changetype then changetype = "blank" end
    CreateRealTimeThread(function()
        local params = {
            title = "Mod Config Reborn",
             text = string.format("The change <em>%s</em> %s", changetypetext[changetype].text, changetypetext[changetype].explain),
            choice1 = changetypetext[changetype].choice1,
            choice2 = changetypetext[changetype].choice2,
            image = "UI/Messages/death.tga",
            start_minimized = false,
        } -- params

        local choice = WaitPopupNotification(false, params)
        if changetype == "blank" then
        elseif changetype == "reset" then
        end


        if choice == 1 then
        	if changetype == "blank" then end
        	if changetype == "reset" then
        		ModConfig.CloseDialog()
        		ModConfig:ResetAllToDefaults() -- reset all data
        	end -- reset
        elseif choice == 2 then
        	if changetype == "blank" then end
        	if changetype == "reset" then end
        end -- if statement
    end ) -- CreateRealTimeThread
end -- MCRConfirmChangePopup()

function OnMsg.ModConfigChanged(mod_id, option_id, value, old_value, token)
    if g_ModConfigLoaded and mod_id == "_ModConfigReborn_" then
        -- reset mod config data
        if option_id == "ResetModConfigData" then
        	if value == true and token ~= "Reset" then
        		CreateRealTimeThread(function()
        			Sleep(100) -- Short delay to show the toggle
        			ModConfig:Toggle("_ModConfigReborn_", "ResetModConfigData", "Reset")
        			Sleep(100) -- Short Delay to allow process to happen
        			MCRConfirmChangePopup("reset") -- show confirm dialog
        		end) -- end RealTimeThread
        	end
        end
    end -- if g_ModConfigLoaded
end -- OnMsg.ModConfigChanged