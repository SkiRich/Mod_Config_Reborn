
--[[
    Handling messages sent by this mod:

    function OnMsg.UIReady()
        Sent once the game's UI has loaded and is ready to query or modify.

    function OnMsg.ModConfigReady()
        Sent once ModConfig has finished loading and it's safe to start using.

    function OnMsg.ModConfigChanged(mod_id, option_id, value, old_value, token)
        Sent whenever any mod option is changed.
        The 'token' parameter matches the token given to ModConfig:Set(). The intention here is to
        make it easier for you to filter messages you shouldnt be responding to; if you set an
        option yourself you might want to pass in a token so that your handler can check for it and
        ignore the message.
--]]


--[[  Use this code to detect modconfig on startup

local mod_name = "@MOD" -- Replace @MOD with your mods name.  It will show up in the logs.
local ModConfig_id = "1340775972"
local ModConfigWaitThread = false
g_ModConfigLoaded = table.find_value(ModsLoaded, "steam_id", ModConfig_id) or false


-- wait for mod config to load or fail out and use defaults
local function WaitForModConfig()
	if (not ModConfigWaitThread) or (not IsValidThread(ModConfigWaitThread)) then
		ModConfigWaitThread = CreateRealTimeThread(function()
	    if lf_print then print(string.format("%s WaitForModConfig Thread Started", mod_name)) end
      local threadlimit = 120  -- loops to wait before fail and exit thread loop
      local runloop     = true -- var to exit early
 		  while runloop and threadlimit > 0 do
 			  g_ModConfigLoaded = table.find_value(ModsLoaded, "steam_id", ModConfig_id) or false
 			  if g_ModConfigLoaded and ModConfig:IsReady() then
 			  	runloop = false
 			  else
 			    Sleep(500) -- Sleep 1/2 second
 			  end -- if g_ModConfigLoaded
 			  threadlimit = threadlimit - 1
 		  end -- while
      if lf_print then print(string.format("%s WaitForModConfig Thread Continuing", mod_name)) end

      -- See if ModConfig is installed and any defaults changed
      if g_ModConfigLoaded and ModConfig:IsReady() then

      	-- PUT CODE HERE --

      else
      	-- PUT DEFAULTS HERE OR SET THEM UP BEFORE RUNNING THIS FUNCTION ---

    	  if lf_print then print(string.format("**** %s - Mod Config Never Detected On Load - Using Defaults ****", mod_name)) end
    	  ModLog(string.format("**** %s - Mod Config Never Detected On Load - Using Defaults ****", mod_name))
      end -- end if g_ModConfigLoaded
      if lf_print then print(string.format("%s WaitForModConfig Thread Ended", mod_name)) end
		end) -- thread
	else
		if lf_print then print(string.format("%s Error - WaitForModConfig Thread Never Ran", mod_name)) end
		ModLog(string.format("%s Error - WaitForModConfig Thread Never Ran", mod_name))
	end -- check to make sure thread not running
end -- WaitForModConFig

--]]
