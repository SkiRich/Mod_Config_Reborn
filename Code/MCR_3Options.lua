function OnMsg.ModConfigReady()
    local StringIdBase = ModConfig.StringIdBase

    -- Register this mod's name and description
    ModConfig:RegisterMod("_ModConfigReborn_", -- ID
        T{StringIdBase, "_Mod Config Reborn_"}, -- Optional display name, defaults to ID
        T{StringIdBase + 1, "Options for Mod Config Reborn"} -- Optional description
    )

    ModConfig:RegisterOption("_ModConfigReborn_", "ResetModConfigData", {
        name = T{StringIdBase + 2, "Reset Mod Config Data"},
        desc = T{StringIdBase + 3, "Reset and default all Mod Config Data"},
        type = "boolean",
        default = false
    })

end -- OnMsg.ModConfigReady()