```
-- Code developed for Mod Config Reborn
-- Code originally developed by Waywocket as Mod Config
-- Modified to work with Gagarin Patch
-- Re-written to optimize code
-- Author @SkiRich
-- This mod is subject to the terms and conditions outlined in the LICENSE file included in this mod.
-- Created Oct 14th, 2018
-- Updated April 4th, 2021

--[[  Use this code to detect modconfig on startup obviously dont copy this line

-- these variables go at the top of your lua script file
-- only at the top, do not set these too far down.
-- be carefull to use locals where stated
local mod_name = "@MOD" -- Replace @MOD with your mods name.  It will show up in the logs.
local lf_print = false -- Used for debugging
local TableFind  = table.find
local ModConfig_id = "1542863522"
local ModConfigWaitThread = false
local ModConfigLoaded     = TableFind(ModsLoaded, "steam_id", ModConfig_id) or false


-- This code is called from some other function or OnMsg
-- typically OnMsg.CityStart() OnMsg.NewMapLoaded() or OnMsg.LoadGame()
-- but can be called from just about any other function
-- wait for mod config to load or fail out and use defaults
-- always use a local here or name the function something unique to your mod for global use.
local function WaitForModConfig()
	if (not ModConfigWaitThread) or (not IsValidThread(ModConfigWaitThread)) then
		ModConfigWaitThread = CreateRealTimeThread(function()
	    if lf_print then print(string.format("%s WaitForModConfig Thread Started", mod_name)) end
      local threadlimit = 120  -- (60 seconds) loops to wait before fail and exit thread loop
 		  while threadlimit > 0 do
 			  if ModConfigLoaded and ModConfig:IsReady() then
 			  	-- if ModConfig loaded and is in ready state then break out of loop
 			  	threadlimit = 0
 			  	break
 			  else
 			    threadlimit = threadlimit - 1
 			    Sleep(500) -- Sleep 1/2 second
 			    ModConfigLoaded = TableFind(ModsLoaded, "steam_id", ModConfig_id) or false
 			  end -- if ModConfigLoaded
 		  end -- while
      if lf_print then print(string.format("%s WaitForModConfig Thread Continuing", mod_name)) end

      -- See if ModConfig is installed and any defaults changed
      if ModConfigLoaded and ModConfig:IsReady() then

      	-- PUT YOUR MODs ModConfig CODE HERE --

        ModLog(string.format("%s detected ModConfig running - Setup Complete", mod_name))
      else
      	-- PUT MOD DEFAULTS HERE OR SET THEM UP BEFORE RUNNING THIS FUNCTION ---

    	  if lf_print then print(string.format("**** %s - Mod Config Never Detected On Load - Using Defaults ****", mod_name)) end
    	  ModLog(string.format("**** %s - Mod Config Never Detected On Load - Using Defaults ****", mod_name))
      end -- end if ModConfigLoaded
      if lf_print then print(string.format("%s WaitForModConfig Thread Ended", mod_name)) end
		end) -- thread
	else
		if lf_print then print(string.format("%s Error - WaitForModConfig Thread Never Ran", mod_name)) end
		ModLog(string.format("%s Error - WaitForModConfig Thread Never Ran", mod_name))
	end -- check to make sure thread not running
end -- WaitForModConfig

--]]
```
