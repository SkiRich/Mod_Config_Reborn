
--[[
    Handling messages sent by this mod:

    function OnMsg.ModConfigReady()
        Sent once ModConfig has finished loading and its safe to start using.

    function OnMsg.ModConfigChanged(mod_id, option_id, value, old_value, token)
        Sent whenever any mod option is changed.
        The 'token' parameter matches the token given to ModConfig:Set(). The intention here is to
        make it easier for you to filter messages you shouldnt be responding to; if you set an
        option yourself you might want to pass in a token so that your handler can check for it and
        ignore the message.
--]]


--[[  Use this code to detect modconfig on startup

local mod_name = "@MOD" -- Replace @MOD with your mods name.  It will show up in the logs.
local lf_print = false -- Used for debugging
local ModConfig_id = "1542863522"
local ModConfigWaitThread = false
g_ModConfigLoaded = nil

-- wait for mod config to load or fail out and use defaults
local function WaitForModConfig()
	if (not ModConfigWaitThread) or (not IsValidThread(ModConfigWaitThread)) then
		ModConfigWaitThread = CreateRealTimeThread(function()
	    if lf_print then print(string.format("%s WaitForModConfig Thread Started", mod_name)) end
      local Sleep = Sleep
      local TableFind  = table.find
      local ModsLoaded = ModsLoaded
      local threadlimit = 120  -- loops to wait before fail and exit thread loop
 		  while threadlimit > 0 do
 		  	--check to make sure another mod didn't already set g_ModConfigLoaded
 			  if not g_ModConfigLoaded then
 			  	g_ModConfigLoaded = TableFind(ModsLoaded, "steam_id", ModConfig_id) or false
 			  end -- if not g_ModConfigLoaded
 			  if g_ModConfigLoaded and ModConfig:IsReady() then
 			  	-- if ModConfig loaded and is in ready state then set as true
 			  	g_ModConfigLoaded = true
 			  	break
 			  else
 			    Sleep(500) -- Sleep 1/2 second
 			  end -- if g_ModConfigLoaded
 			  threadlimit = threadlimit - 1
 		  end -- while
      if lf_print then print(string.format("%s WaitForModConfig Thread Continuing", mod_name)) end

      -- See if ModConfig is installed and any defaults changed
      if g_ModConfigLoaded and ModConfig:IsReady() then

      	-- PUT YOUR MODs ModConfig CODE HERE --

        ModLog(string.format("%s detected ModConfig running - Setup Complete", mod_name))
      else
      	-- PUT MOD DEFAULTS HERE OR SET THEM UP BEFORE RUNNING THIS FUNCTION ---

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
