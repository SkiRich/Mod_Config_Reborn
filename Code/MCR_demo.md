```
-- Code developed for Mod Config Reborn
-- Code originally developed by Waywocket as Mod Config
-- Modified to work with Gagarin Patch
-- Re-written to optimize code
-- Author @SkiRich
-- All rights reserved.
-- Created Oct 14th, 2018
-- Updated Oct 20th, 2018

-- This is sample code straight from Mod Config Demo
-- You can copy it as is minus the carets to see what it looks like.

function OnMsg.ModConfigReady()
    -- Randomly generated number to start counting from, to generate IDs for translatable strings
    local StringIdBase = 76837246

    -- Register this mod's name and description
    ModConfig:RegisterMod("ModConfigDemo", -- ID
        T{StringIdBase, "Mod Config Demo"}, -- Optional display name, defaults to ID
        T{StringIdBase + 1, "A demonstration of how to use Mod Config"} -- Optional description
    )

    ModConfig:RegisterOption("ModConfigDemo", "BooleanOption", {
        name = T{StringIdBase + 2, "A Boolean Option"},
        desc = T{StringIdBase + 3, "This is what a boolean option looks like."},
        type = "boolean",
        default = false
    })

    ModConfig:RegisterOption("ModConfigDemo", "BooleanOption2", {
        name = T{StringIdBase + 4, "The First Option"},
        desc = T{StringIdBase + 5, "This option should be first in the list."},
        type = "boolean",
        default = true,
        order = 0, -- The default is one, so this will go before anything that doesn't specify
    })

    ModConfig:RegisterOption("ModConfigDemo", "EnumOption", {
        -- Texts can include images or other formatting
        name = T{
            StringIdBase + 4, "<image UI/Icons/res_theoretical_research.tga> Enumerable Option"},
        desc = T{
            StringIdBase + 5,
            "This option lets the user pick from a selection of possible values."
        },
        type = "enum",
        values = {
            {value = "string", label = "A String"}, -- All of these texts may be raw strings
            {value = 37, label = "A Number"},
            {value = false, label = T{StringIdBase + 4, "Off"}}
        },
        default = "string"
    })

    ModConfig:RegisterOption("ModConfigDemo", "NumericalOption1", {
        name = T{StringIdBase + 7, "Pick a Number"},
        desc = T{StringIdBase + 8, "Goes up in ones, no limit."},
        type = "number",
    })

    ModConfig:RegisterOption("ModConfigDemo", "Note", {
        name = T{StringIdBase + 11, "This is a note, which can be used - for example - to introduce"
            .. " a new section or describe a group of options. This is a long text to demonstrate"
            .. " how the dialog handles expanding and wrapping."},
        type = "note",
        order = 0
    })

    ModConfig:RegisterOption("ModConfigDemo", "NumericalOption2", {
        name = T{StringIdBase + 9, "Pick Another Number"},
        desc = T{StringIdBase + 10, "Goes up in tens, 0 to 200."},
        type = "number",
        default = 10,
        min = 0,
        max = 200,
        step = 10,
    })

    ModConfig:RegisterOption("ModConfigDemo", "SliderOption", {
        name = T{StringIdBase + 12, "Set percentage"},
        desc = T{StringIdBase + 13, "Percentage is an example; you can choose how to format this."},
        label = T{StringIdBase + 14, "<percent(value)>"}, -- The selected value will be passed in
        type = "slider",
        default = 100,
        min = 50,
        max = 500,
        step = 10,
    })

    -- Options don't need to be registered for you to save and load them, only for them to be
    -- visible in the config dialogue.
    local load_count = ModConfig:Get("ModConfigDemo", "LoadCount") or 1
    load_count = load_count + 1
    ModConfig:Set("ModConfigDemo", "LoadCount", load_count)

end

function OnMsg.ModConfigChanged(mod_id, option_id, value, old_value)
    if rawget(_G, "lcPrint")  and mod_id == "ModConfigDemo" then
        lcPrint(string.format("Option '%s' changed from %s to %s", option_id, old_value, value))
    end
end

function OnMsg:Autorun()
    if rawget(_G, "lcPrint") then
        lcPrint(string.format("ModConfig Available: %s", not not rawget(_G, "ModConfig")))
        lcPrint(string.format("ModConfig Ready: %s", rawget(_G, "ModConfig") and ModConfig:IsReady()))
    end
end
```