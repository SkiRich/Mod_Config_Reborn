-- Code developed for Mod Config Reborn
-- Code originally developed by Waywocket as Mod Config
-- Modified to work with Gagarin Patch
-- Re-written to optimize code
-- Author @SkiRich
-- All rights reserved.
-- Created Oct 14th, 2018
local lf_debug   = false  -- used only for certain ex() instance
local lf_print   = false  -- Setup debug printing in local file
                          -- Use if lf_print then print("something") end


ModConfig = {}    -- base class for modconfig
ModConfig.StringIdBase = 76827146


--------------------- ModConfig:RegisterMod ----------------------------------------------------------
-- @param mod_id - The internal name of this mod
-- @param mod_name - The name of this mod as presented to the user. This may be a translatable tuple
--                   like T{12345, "Mod Name"}. If unset, defaults to mod_id.
-- @param mod_desc - The description for this mod as presented to the user.This may be a
--                   translatable tuple like T{12345, "Mod Description"}. If unset, defaults to an
--                   empty string.
function ModConfig:RegisterMod(mod_id, mod_name, mod_desc)
    mod_name = mod_name or mod_id
    mod_desc = mod_desc or ""
    if not self.registry then self.registry = {} end
    self.registry[mod_id] = {name = mod_name, desc = mod_desc}
end -- ModConfig:RegisterMod


--------------------- ModConfig:RegisterOption -------------------------------------------------------
-- Register a name and a description for a mod option. An option does not need to be registered in
-- order to use Get() and Set(), however only registered options will be included in the settings
-- dialog.
--
-- @param mod_id - The internal name of this mod
-- @param option_id - The internal name of this option. This does not need to be globally unique, so
--                    different mods can have options with the same name.
-- @param option_params - A table describing the parameter of this option. Keys are:
--                        name - The name of this option as presented to the user. This may be a
--                               translatable tuple like T{12345, "Option Name"}. If unset, defaults
--                               to option_id.
--                        desc - The description for this option as presented to the user.This may
--                               be a translatable tuple like T{12345, "Option Description"}. If
--                               unset, defaults to an empty string.
--                        order - The order in which the option will be shown. If unset, defaults to
--                                1. Options with the same order will be ordered alphabetically by
--                                name.
--                        type - The type of variable this option controls. Currently 'boolean',
--                               'enum', 'number', 'slider', and 'note' are supported. In the future
--                               this may be extended to other options. If unset, defaults to
--                               'boolean'.
--                        values - When type is 'enum', this defines the possible values for the
--                                 option, and the label shown to the user.
--                                 Example: values = {
--                                                      {value = 1, label = "Option 1"},
--                                                      {value = "foo", label = T{12345, "Foo"}},
--                                                      {value = true, label = "Always"}
--                                                   }
--                        min, max - When type is 'number' or 'slider', these are used to set the
--                                   minimum and maximum allowed values. If unset, no limits are
--                                   enforced for 'number', and slider defaults to 0 and 100
--                                   respectively.
--                        step - When type is 'number', this is used to set how much the value will
--                               change when clicking the +/- buttons. If unset, defaults to 1.
--                               When type is 'slider', this sets the steps that the slider will
--                               snap to, and defaults to (max - min) / 10.
--                        label - When type is 'slider', this can optionally be used to display the
--                                current value as the user moves the slider, by passing a T{}
--                                object which uses a <value> element.
--                                Example: label = T{12345, "Set to <value>"} or
--                                         label = T{12345, "<percent(value)>"}
--                                If unset, defaults to blank.
--                        default - The value to use if the user hasn't set the option.
function ModConfig:RegisterOption(mod_id, option_id, option_params)
    option_params = option_params or {}
    option_params.name = option_params.name or option_id
    option_params.desc = option_params.desc or ""
    option_params.order = option_params.order or 1
    if not option_params.default then
        -- It makes sense to have a built-in fallback default for booleans and numbers.
        if option_params.type == "boolean" then
            option_params.default = false
        elseif option_params.type == "number"  or option_params.type == "slider" then
            option_params.default = 0
        end
    end
    if not (self.registry and self.registry[mod_id]) then
        self:RegisterMod(mod_id)
    end
    local options = self.registry[mod_id].options or {}
    options[option_id] = option_params
    self.registry[mod_id].options = options
end -- ModConfig:RegisterOption


------------------------------- ModConfig:Set -----------------------------------------------------------
-- Set an option's value, then save. Sends the "ModConfigChanged" message when complete.
--
-- @param mod_id
-- @param option_id
-- @param value
-- @param token - An optional arbitrary variable you might want to pass in. The intention here is to
--                make it easier for you to filter messages you shouldn't be responding to; if you
--                set an option yourself you might want to pass in a token so that your
--                ModConfigChanged() handler can check for it and ignore the message.
--
-- @return The new value of the option
function ModConfig:Set(mod_id, option_id, value, token)
    local old_value = self:Get(mod_id, option_id)
    if value ~= old_value then
        if not self.data then self.data = {} end
        if not self.data[mod_id] then self.data[mod_id] = {} end
        self.data[mod_id][option_id] = value
        self:Save()
        Msg("ModConfigChanged", mod_id, option_id, value, old_value, token)
    end
    return value
end -- ModConfig:Set


----------------------------------- ModConfig:Toggle ---------------------------------------------------
-- Toggle a boolean value
--
-- @param mod_id
-- @param option_id
-- @param token - As per Set()
--
-- @return The new value if the option is a boolean, else nil
function ModConfig:Toggle(mod_id, option_id, token)
    local mod_options = self.registry and self.registry[mod_id] and self.registry[mod_id].options
    local option_params = mod_options and mod_options[option_id]
    if option_params and option_params.type and option_params.type == 'boolean' then
        return self:Set(mod_id, option_id, not self:Get(mod_id, option_id), token)
    else
        return nil
    end
end -- ModConfig:Toggle


----------------------------------- ModConfig:Revert ---------------------------------------------------
-- Revert an option to its default value.
--
-- @param mod_id
-- @param option_id
-- @param token - As per Set()
--
-- @return The default setting of the option if defined, else nil
function ModConfig:Revert(mod_id, option_id, token)
    local default = self:GetDefault(mod_id, option_id)
    if default ~= nil then
        self:Set(mod_id, option_id, default, token)
    end
    return default
end -- ModConfig:Revert

----------------------------------- ModConfig:GetDefault -----------------------------------------------
-- Get the default value of an option.
--
-- @param mod_id
-- @param option_id
--
-- @return The default setting of the option if defined, else nil
function ModConfig:GetDefault(mod_id, option_id)
    local mod_options = self.registry and self.registry[mod_id] and self.registry[mod_id].options
    return mod_options and mod_options[option_id] and mod_options[option_id].default
end -- ModConfig:GetDefault


----------------------------------- ModConfig:Get ------------------------------------------------------
-- Get the current or default value of an option.
--
-- @param mod_id
-- @param option_id
--
-- @return The current setting of the option if set, else the default if defined, else nil
function ModConfig:Get(mod_id, option_id)
    local mod_data = self.data and self.data[mod_id]
    local value = mod_data and mod_data[option_id]
    if value == nil then
        value = self:GetDefault(mod_id, option_id)
    end
    return value
end -- ModConfig:Get


----------------------------------- ModConfig:GetRegisteredMod -----------------------------------------
-- Get a table of all the currently registered mods.
--
-- Using this is preferred over accessing the registry directly, as the internal format of the
-- registry might change in the future.
--
-- @return Table whose keys are registered mod IDs, and values are a table with keys
--         'name, desc, options', where 'options' is a table as returned by GetRegisteredOptions()
function ModConfig:GetRegisteredMods()
    -- Currently this just returns the registry as-is
    return self.registry or {}
end -- ModConfig:GetRegisteredMod



----------------------------------- ModConfig:GetRegisteredOptions -------------------------------------
-- Get a table of all the options registered for the given mod.
--
-- Using this is preferred over accessing the registry directly, as the internal format of the
-- registry might change in the future.
--
-- @return Table whose keys are option IDs, and values are a table with keys 'name, desc, order',
--         and any or all optional keys 'default, type, values, min, max, step, label'.
function ModConfig:GetRegisteredOptions(mod_id)
    if not (self.registry and self.registry[mod_id]) then
        return {}
    end
    return self.registry[mod_id].options or {}
end -- ModConfig:GetRegisteredOptions


----------------------------------- ModConfig:Load -----------------------------------------------------
-- Load previously saved settings from disk.
-- ModConfig.data (self.data) is where all 'changed' or 'set' values reside
function ModConfig:Load()
    local err, file_content = ReadModPersistentData()
    local data
    if err then
        self.data = {}
    else
        err, data = LuaCodeToTuple(Decompress(file_content))
        if not err then self.data = data end
    end
    if not self.registry then self.registry = {} end
end -- ModConfig:Load

----------------------------------- ModConfig:Save -----------------------------------------------------
-- Save all of the current settings to disk.
-- ModConfig.data (self.data) is where all 'changed' or 'set' values reside
function ModConfig:Save()
    local mod_data = self.data or {}
    local save_data = Compress(ValueToLuaCode(mod_data))
    local interface = GetInGameInterface()
    if interface and interface.idModConfigDlg  and interface.idModConfigDlg:IsVisible() then
        ModConfig.space_label:SetText(T{ModConfig.StringIdBase + 7,
            "(Storage space in use: <used>%)",
            used = 100* string.len(save_data) / const.MaxModDataSize,
        })
    end
    WriteModPersistentData(save_data)
end -- ModConfig:Save


----------------------------------- ModConfig:IsReady --------------------------------------------------
-- Sometimes you want to do something very early on, when ModConfig might not have loaded yet
-- because there's no way to set mod load order in Surviving Mars. If you have a hard dependency on
-- ModConfig, you can just put it in your OnMsg.ModConfigChanged handler and it will run as soon as
--~ *************** Needs Update **********************
-- ModConfig is ready, but otherwise you can check if ModConfig is enabled and ready by doing
-- "if rawget(_G, "ModConfig") and ModConfig:IsReady() then ..."
function ModConfig:IsReady()
    -- The internal token is set immediately before firing ModConfigReady, so we can check for it to
    -- determine whether we've finished loading.
    return self.internal_token ~= nil
end -- ModConfig:IsReady

----------------------------------- ModConfig.CloseDialog ----------------------------------------------
function ModConfig.CloseDialog()
    GetInGameInterface().idModConfigDlg:delete()
    ModConfig.elements = {}
end -- ModConfig.CloseDialog

----------------------------------- ModConfig.OpenDialog -----------------------------------------------
function ModConfig.OpenDialog()
    local interface = GetInGameInterface()
    if not interface.idModConfigDlg then
        ModConfig:CreateModConfigDialog()
    end
    interface.idModConfigDlg:SetVisible(true)
    -- In order for the scroll bar to know whether it needs to be shown, it needs to be able to
    -- compare its content size with its actual size, and those values aren't calculated until
    -- render time.
    CreateRealTimeThread(function()
        WaitMsg("OnRender")
        interface.idModConfigDlg.idScroll:ShowHide()
    end)
end -- ModConfig.OpenDialog

---------------------------------- ModConfig:CreateModConfigDialog ------------------------------
-- There are some parts of this mod that I think are good enough to be worth copying. This is not
-- one of those parts. This is an ugly mess that happens to work. Do not use this as an example of
-- the right way to create a dialogue box.
function ModConfig:CreateModConfigDialog()
    local interface = GetInGameInterface()
    if interface.idModConfigDlg then
        interface.idModConfigDlg:delete()
    end

    -- Create the base dialog
    local dlg = XDialog:new({
        Id = "idModConfigDlg",
        HAlign = "center",
        VAlign = "center",
        MinWidth = 400,
        MaxWidth = 800,
        MaxHeight = 800,
        Margins = box(0, 30, 0, 100),
        BorderColor = RGB(83, 129, 187),
        BorderWidth = 1,
        Padding = box(-2, 0, 0, 0),
        LayoutMethod = "VList",
        HandleMouse = true,
    }, interface)
    dlg:SetFocus(true)
    dlg:SetVisible(false)

    -- internal window container for dlg for background
    local win = XWindow:new({
        Dock = "box",
    }, dlg)
    XImage:new({
        Image = "UI/Infopanel/pad_2.tga",
        ImageFit = "stretch",
    }, win)
    XFrame:new({
        Image = CurrentModPath.."UI/watermark_tilable.tga",
        TileFrame = true,
    }, win)

    -- Add the title
    local title = XFrame:new({
    	  Id = "idMCRTitleFrame",
        Image = "UI/Infopanel/title.tga",
        Margins = box(2, 0, 2, 2),
    }, dlg)
    XText:new({
    	  Id = "idMCRTitle",
        Margins = box(0, 0, 0, 0),
        Padding = box(2, 8, 2, 8),
        HAlign = "stretch",
        VAlign = "center",
        TextHAlign = "center",
        TextFont = "HUDStat",
        TextStyle = "HUDStat",
        --TextColor = RGB(244, 228, 117),
        RolloverTextColor = RGB(244, 228, 117),
        Translate = true
    }, title):SetText(T{ModConfig.StringIdBase, "Mod Config Reborn Mod Options"})

    -- Create a container to house a scrollable area (in case the options don't all fit on one
    -- screen) and its associated scrollbar. These two elements need to be siblings to work
    -- correctly, and the scrollbar will fill the height of its container, which is why they need
    -- this wrapper.
    local scroll_container = XWindow:new({
    	Id = "id_scroll_container",
    }, dlg)

    local content = XContentTemplateScrollArea:new({
        Id = "idModContentsList",
        LayoutMethod = "VList",
        Background = RGBA(0, 0, 0, 0),
        FocusedBackground = RGBA(0, 0, 0, 0),
        RolloverBackground = RGBA(0, 0, 0, 0),
        Padding = box(0, 0, 0, 0),
        Margins = box(0, -2, 0, 45),
        VScroll = "idScroll",
    }, scroll_container)

    -- Intro text
    if self.registry and next(self.registry) ~= nil then
        XText:new({
        	  Id = "idMCRintroText1",
            Padding = box(5, 2, 5, 2),
            VAlign = "center",
            TextAlign = "center",
            TextFont = "InfoText",
            TextStyle = "InfoText",
            --TextColor = RGB(233, 242, 255),
            RolloverTextColor = RGB(233, 242, 255),
            Translate = true
        }, content):SetText(T{ModConfig.StringIdBase + 1,
                "Mouse over options to see a description of what they mean."})
        ModConfig.space_label = XText:new({
        	  Id = "id_space_label",
            Padding = box(5, 2, 5, 2),
            VAlign = "center",
            TextAlign = "center",
            TextFont = "InfoText",
            TextStyle = "InfoText",
            --TextColor = RGB(233, 242, 255),
            RolloverTextColor = RGB(233, 242, 255),
            Translate = true
        }, content)
    end

    -- Add all the options to the idModContentsList container
    self:AddAllModSettingsToDialog(content)

    -- add the actual scroll bar to the container after the container is populated
    XScrollBar:new({
        Id = "idScroll",
        Dock = "right",
        BorderWidth = 0,
        Background = RGBA(0, 20, 40, 100),
        ScrollColor = RGBA(83, 129, 187, 127),
        BorderColor = RGB(83, 129, 187),
        Margins = box(0, -2, 0, 45),
        MinWidth = 20,
        MaxWidth = 20,
        Horizontal = false,
        Target = "idModContentsList",
        ShowHide = function(self) self:SetVisible(self.Max > self.PageSize) end
    }, scroll_container)

    -- All the rest is creating the close button
    local close_button = XTextButton:new({
        Id = "idCloseButton",
        Dock = "bottom",
        Margins = box(-25, 0, 0, -1),
        Padding = box(25, 0, 0, 0),
        MaxHeight = 45,
        Background = RGBA(0, 0, 0, 0),
        FocusedBackground = RGBA(0, 0, 0, 0),
        RolloverBackground = RGBA(0, 0, 0, 0),
        PressedBackground = RGBA(0, 0, 0, 0),
        MouseCursor = "UI/Cursors/Rollover.tga",
        RelativeFocusOrder = "new-line",
        HandleMouse = true,
        FXMouseIn = "PopupChoiceHover",
        FXPress = "PopupChoiceClick",
        OnSetRollover = function(self, rollover)
            CreateRealTimeThread(function()
                if self.window_state ~= "destroying" then
                    self.rollover = rollover
                    self.idCloseButtonIcon:SetRollover(rollover)
                    self.idRollover2:SetVisible(rollover)
                    local b = self.idRollover2.box
                    self.idRollover2:AddInterpolation({
                        type = const.intRect,
                        duration = self.idRollover2:GetFadeInTime(),
                        startRect = b,
                        endRect = sizebox(b:minx(), b:miny(), 40, b:sizey()),
                        flags = const.intfInverse,
                        autoremove = true
                    })
                end
            end)
        end,
    }, dlg)
    close_button.OnPress = ModConfig.CloseDialog
    XImage:new({
        Id = "idRollover2",
        ZOrder = 0,
        Margins = box(0, 0, 0, -6),
        Dock = "box",
        FadeInTime = 150,
        Image = "UI/Common/message_choice_shine.tga",
        ImageFit = "stretch",
    }, close_button):SetVisible(false)
    local button_icon = XImage:new({
        Id = "idCloseButtonIcon",
        ZOrder = 2,
        Margins = box(-25, 0, 0, 0),
        Shape = "InHHex",
        Dock = "left",
        MinWidth = 50,
        MinHeight = 43,
        MaxWidth = 50,
        MaxHeight = 43,
        Image = "UI/Icons/message_ok.tga",
        ImageFit = "smallest",
    }, close_button)
    XImage:new({
        Id = "idRollover",
        Margins = box(-3, -3, -3, -3),
        Dock = "box",
        Image = "UI/Common/Hex_small_shine_2.tga",
        ImageFit = "smallest",
    }, button_icon):SetVisible(false)
    XText:new({
    	  id = "idClose",
        Padding = box(10, 0, 2, 0),
        HAlign = "left",
        VAlign = "center",
        TextFont = "HUDStat",
        TextStyle = "HUDStat",
        --TextColor = RGB(254, 237, 122),
        RolloverTextColor = RGB(255, 255, 255),
        Translate = true,
        --CalcTextColor = function(self)
        --    return self.parent.rollover and self.RolloverTextColor or self.TextColor
        --end,
    }, close_button):SetText(T{1011, "Close"})
    XAction:new({
        OnActionEffect = "close",
        ActionShortcut = "Escape",
    }, dlg)
end -- ModConfig:CreateModConfigDialog


------------------------------- ModConfig:AddAllModSettingsToDialog --------------------------------
-- Adds each mod_id's info to the parent dialog
function ModConfig:AddAllModSettingsToDialog(parent)
    if not self.registry or next(self.registry) == nil then
        XText:new({
            Margins = box(0, 0, 0, 0),
            Padding = box(8, 2, 2, 8),
            HAlign = "center",
            TextFont = "InfoText",
            TextStyle = "InfoText",
            RolloverTextColor = RGB(255, 255, 255),
            Background = RGBA(0, 0, 0, 0),
            Translate = true
        }, parent):SetText(T{ModConfig.StringIdBase + 2,
            "There are no mods currently active which use this settings dialogue."})
    else
        local sortable = {}
        for mod_id, mod_registry in pairs(self.registry) do
            sortable[#sortable + 1] = {id = mod_id, name = mod_registry.name}
        end
        TSort(sortable, "name")
        for _, id_and_name in ipairs(sortable) do
            ModConfig:AddModSettingsToDialog(parent, id_and_name.id, self.registry[id_and_name.id])
        end
    end
end -- ModConfig:AddAllModSettingsToDialog


---------------------------- ModConfig:AddModSettingsToDialog -------------------------------------------
function ModConfig:AddModSettingsToDialog(parent, mod_id, mod_registry)
    local mod_name = mod_registry.name
    local mod_desc = mod_registry.desc
    local section_header = XFrame:new({
    	  Id = "idMod_Frame",
        Image = "UI/Infopanel/section.tga",
        Margins = box(2, 0, 2, 2),
        RolloverTemplate = "Rollover",
        RolloverAnchor = "bottom",
        RolloverTextColor = RGB(244, 228, 117),
    }, parent)
    XText:new({
    	  Id = "idMCR_ModTitle",
        Margins = box(0, 0, 0, 0),
        Padding = box(2, 8, 2, 8),
        VAlign = "center",
        TextHAlign = "center",
        TextFont = "HUDStat",
        TextStyle = "HUDStat",
        --TextFont = "InfopanelTitle",
        --TextColor = RGB(244, 228, 117),
        RolloverTextColor = RGB(244, 228, 117),
        Translate = true
    }, section_header):SetText(mod_name)
    if mod_desc and mod_desc ~= "" then
        section_header:SetRolloverTitle(mod_name)
        section_header:SetRolloverText(mod_desc)
    end
    local sortable = {}
    for option_id, option_params in pairs(mod_registry.options) do
        sortable[#sortable + 1] = {
            id = option_id,
            name = option_params.name,
            order = option_params.order
        }
    end
    -- To sort by "order, name" we can sort by name and then resort the result by order.
    TSort(sortable, "name")
    -- TSort converts all its fields to text, so we can't use it if we want 9 to sort before 10
    --table.stable_sort(sortable, function(a, b) return a.order < b.order end)
    table.sortby_field(sortable, "order")

    for _, sorted_option_params in ipairs(sortable) do
        local option_id = sorted_option_params.id
        local option_params = mod_registry.options[option_id]
        local option_section = XFrame:new({
        	  Id = string.format("id_%s", option_id),
            LayoutMethod = "Grid",
            Margins = box(2, 2, 2, 2),
            Background = RGBA(0, 0, 0, 0),
            TextFont = "InfoText",
            TextStyle = "InfoText",
            TextHAlign = "left",
            RolloverTemplate = "Rollover",
            RolloverAnchor = "bottom",
            --RolloverTextColor = RGB(244, 228, 117),
        }, parent)
        if option_params.desc and option_params.desc ~= "" then
            option_section:SetRolloverTitle(T{option_params.name, UICity})
            option_section:SetRolloverText(T{option_params.desc, UICity})
        end

        XText:new({
            Id = "idLabel",
            Margins = box(0, 0, 0, 0),
            Padding = box(8, 2, 2, 2),
            --VAlign = "center",
            TextFont = "InfoText",
            TextStyle = "InfoText",
            TextHAlign = "left",
            --TextColor = RGB(255, 255, 255),
            --RolloverTextColor = RGB(255, 215, 0),
            Background = RGBA(0, 0, 0, 0),
            Translate = true
        }, option_section):SetText(option_params.name)

        ModConfig:AddOptionControl(option_section, mod_id, option_id)
    end
end -- ModConfig:AddModSettingsToDialog


--------------------------- ModConfig:AddOptionControl ----------------------------------
function ModConfig:AddOptionControl(parent, mod_id, option_id)
    local option_params = self.registry[mod_id].options[option_id]
    local element

    if not option_params.type then
        option_params.type = 'boolean'
    end

    if option_params.type == 'boolean' then
        element = XModConfigToggleButton:new({
            Id = option_id,
            Dock = "right",
            ModId = mod_id,
            OptionId = option_id,
            MaxHeight = 35,
        }, parent)
    elseif option_params.type == 'enum' then
        element = XModConfigEnum:new({
            Id = option_id,
            ModId = mod_id,
            OptionId = option_id,
            OptionValues = option_params.values,
            MaxHeight = 35,
        }, parent)
    elseif option_params.type == 'number' then
        element = XModConfigNumberInput:new({
            Id = option_id,
            Dock = "right",
            ModId = mod_id,
            OptionId = option_id,
            OptionName = option_params.name,
            OptionDesc = option_params.desc,
            Max = option_params.max,
            Min = option_params.min,
            Step = option_params.step or 1,
            MaxHeight = 35,
        }, parent)
    elseif option_params.type == 'slider' then
        local max = option_params.max or 100
        local min = option_params.min or 0
        element = XModConfigSlider:new({
            Id = option_id,
            ModId = mod_id,
            OptionId = option_id,
            OptionName = option_params.name,
            OptionDesc = option_params.desc,
            Max = max or 100,
            Min = min or 0,
            Step = option_params.step or floatfloor((max - min) / 10),
            Label = option_params.label,
            MaxHeight = 35,
        }, parent)
    elseif option_params.type == 'note' then
    end

    -- set ModConfig.elements here
    if element then
        if not self.elements then self.elements = {} end
        if not self.elements[mod_id] then self.elements[mod_id] = {} end
        self.elements[mod_id][option_id] = element
    end
end --ModConfig:AddOptionControl


--------------------------------------------------------------------------------------------------------
----------------------------------- OnMsgs -------------------------------------------------------------
function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates
  local ObjModified = ObjModified
  local PlaceObj = PlaceObj
  local MCRMenuID01 = "MCRMenu-01"
  local MCRObjVer  = "v1.0"
  local XT = XTemplates.XIGMenu
  local idMenuList = XT[1][3][1] or empty_table
  local idx = 1 -- default to 1 just in case we cant find the index


  -- function re-write to hook into menu button
  local Old_HUD_idMenuOnPress = HUD.idMenuOnPress
  function HUD.idMenuOnPress()
    OpenIngameMainMenu()
  end -- HUD.idMenuOnPress

  -- find idOptions in the XIGMenu template
  -- Gagarin uses ActionId now for some things
  for i	= 1, #idMenuList do
    if idMenuList[i].ActionId == "idOptions" then
      idx = i
      break
    end -- if idMenuList
  end -- for i

  --retrofix versioning and remove legacyXtemplate if found
  if XT.MCR then
  	if lf_print then print("Retro fitting MCR in XIGMenu") end
  	for i, obj in pairs(idMenuList) do
  		if (type(obj) == "table" and (obj.UniqueID == MCRMenuID01) and (obj.Version ~= MCRObjVer)) or
  		   (type(obj) == "table" and (obj.Id == "idActionOpenModConfig") and (not obj.UniqueID)) then
  			table.remove(idMenuList, i)
  			if lf_print then print("Removed old MCR Class") end
  			XT.MCR = nil
  		end -- if obj
  	end -- for each obj
  end -- retrofix versioning

  -- build the classes just once per game
  if not XT.MCR then
  	XT.MCR = true      -- MCR id for template
  	XT.idMenuList = idMenuList -- add idMenuList to root of template for easy debug purposes

    table.insert(XT.idMenuList, idx,
      PlaceObj("XTemplateAction", {
      	"Id", "idActionOpenModConfig",
      	"UniqueID", MCRMenuID01,
      	"Version", MCRObjVer,
        "ActionId", "idActionOpenModConfig",
        "ActionName", T{ModConfig.StringIdBase + 3, "Mod Options"},
        "ActionToolbar", "mainmenu",
        --"OnActionEffect", "mode",
        "OnAction", function(self, host)
           ModConfig.OpenDialog()
           host:Close()
        end
      }) -- PlaceObject
    ) -- table.insert

    XT.idActionOpenModConfig = idMenuList[idx] -- add Mod Config to root of template for easy debug purposes

  end -- if not XT.MCR

end -- OnMsg.ClassesBuilt

-- Setup ModConfig earlier so that it can be used in other onmsg classes as well as CityStart and LoadGame
function OnMsg.ClassesGenerate()
--function OnMsg.Autorun()
    ModConfig:Load()
    ModConfig.internal_token = 70492318 -- en entirely arbitrary token, randomly generated
    Msg("ModConfigReady")
end -- OnMsg.Autorun


function OnMsg.ModConfigChanged(mod_id, option_id, value, old_value, token)
    if token ~= ModConfig.internal_token then
        -- A value was changed externally
        local interface = GetInGameInterface()
        if interface and interface.idModConfigDlg  and interface.idModConfigDlg:IsVisible() then
            -- The dialog is open, so we need to reflect external changes.
            ModConfig.elements[mod_id][option_id]:Set(value, false)
        end
    end
end -- OnMsg.ModConfigChanged

-- Determine whether we need to show/hide the scroll bar when the UI scale changes
function OnMsg.SafeAreaMarginsChanged()
    local interface = GetInGameInterface()
    if interface.idModConfigDlg then
        interface.idModConfigDlg.idScroll:ShowHide()
    end
end -- OnMsg.SafeAreaMarginsChanged
