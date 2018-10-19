
--[[
    Handling messages sent by this mod:

    function OnMsg.UIReady()
        Sent once the game's UI has loaded and is ready to query or modify.

    function OnMsg.ModConfigReady()
        Sent once ModConfig has finished loading and it's safe to start using.

    function OnMsg.ModConfigChanged(mod_id, option_id, value, old_value, token)
        Sent whenever any mod option is changed.
        The 'token' parameter matches the token given to ModConfig:Set(). The intention here is to
        make it easier for you to filter messages you shouldn't be responding to; if you set an
        option yourself you might want to pass in a token so that your handler can check for it and
        ignore the message.
--]]

