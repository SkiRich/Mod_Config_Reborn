-- Code developed for Mod Config Reborn
-- Code originally developed by Waywocket as Mod Config
-- Modified to work with Gagarin Patch
-- Re-written to optimize code
-- Author @SkiRich
-- All rights reserved.
-- Created Oct 14th, 2018
-- Updated Oct 20th, 2018

local lf_debug   = false  -- used only for certain ex() instance
local lf_print   = false  -- Setup debug printing in local file
                          -- Use if lf_print then print("something") end

----------------------------------------------------------------------------------------------------------
DefineClass.XModConfigToggleButton = {
    __parents = {
        "XToggleButton"
    },
    properties = {
        { category = "Image", id = "DisabledImage", editor = "text", default = "UI/Icons/traits_approve_disable.tga" },
        { category = "Image", id = "EnabledImage",  editor = "text", default = "UI/Icons/traits_approve.tga" },
        { category = "Params", id = "ModId",        editor = "text", default = "" },
        { category = "Params", id = "OptionId",     editor = "text", default = "" },
    },
    Dock = "right",
    HAlign = "right",
    VAlign = "center",
    TextFont = "InfoText",
    TextStyle = "InfoText",
    Background = RGBA(0, 0, 0, 0),
    RolloverBackground = RGBA(0, 0, 0, 0),
    PressedBackground = RGBA(0, 0, 0, 0),
    MouseCursor = "UI/Cursors/Rollover.tga",
}
function XModConfigToggleButton:Init()
    self.idIcon.ImageFit = "height"
    self:SetToggled(ModConfig:Get(self.ModId, self.OptionId), false)
end

function XModConfigToggleButton:SetToggled(toggled, update)
    self:Set(toggled, update)
end

function XModConfigToggleButton:Set(value, update)
    if update == nil then update = true end
    self.Toggled = value
    self.idIcon:SetImage(value and self.EnabledImage or self.DisabledImage)
    if update then
        ModConfig:Set(self.ModId, self.OptionId, value, ModConfig.internal_token)
    end
end

----------------------------------------------------------------------------------------------------------
DefineClass.XModConfigEnum = {
    __parents = {
        "XPageScroll",
    },
    properties = {
        { category = "Params", id = "ModId",        editor = "text",  default = "" },
        { category = "Params", id = "OptionId",     editor = "text",  default = "" },
        { category = "Params", id = "OptionValues", editor = "table", default = {} },
    },
    visible = true,
}

function XModConfigEnum:Init()
    self.parent.idLabel:SetMargins(box(0, 0, self.MinWidth, 0))
    local current_value = ModConfig:Get(self.ModId, self.OptionId)
    local value_index = 1
    for i, option in ipairs(self.OptionValues) do
        if option.value == current_value then
            value_index = i
            break
        end
    end
    self:Set(value_index, false)
end

function XModConfigEnum:Set(page, update)
    if update == nil then update = true end
    self.current_page = page
    self.idPage:SetText(self.OptionValues[page].label)
    if update then
        ModConfig:Set(self.ModId, self.OptionId,
            self.OptionValues[page].value, ModConfig.internal_token)
    end
end

function XModConfigEnum:NextPage()
    local next_page = self.current_page + 1
    if next_page > #self.OptionValues then
        next_page = 1
    end
    self:Set(next_page)
end

function XModConfigEnum:PreviousPage()
    local next_page = self.current_page - 1
    if next_page < 1 then
        next_page = #self.OptionValues
    end
    self:Set(next_page)
end

----------------------------------------------------------------------------------------------------------
DefineClass.XModConfigNumberInput = {
    __parents = {
        "XWindow",
    },
    properties = {
        { category = "Params", id = "ModId",      editor = "text",   default = "" },
        { category = "Params", id = "OptionId",   editor = "text",   default = "" },
        { category = "Params", id = "OptionName", editor = "text",   default = "" },
        { category = "Params", id = "Min",        editor = "number", default = nil },
        { category = "Params", id = "Max",        editor = "number", default = nil },
        { category = "Params", id = "Step",       editor = "number", default = 1 },
    },
    HAlign = "right",
    LayoutMethod = "HList",
    TextFont = "InfoText",
    TextStyle = "InfoText",
}

function XModConfigNumberInput:Init()
    self.idRemove = XTextButton:new({
        Id = "idRemove",
        HAlign = "left",
        VAlign = "center",
        TextFont = "InfoText",
        TextStyle = "InfoText",
        MouseCursor = "UI/Cursors/Rollover.tga",
        FXMouseIn = "RocketRemoveCargoHover",
        RepeatStart = 300,
        RepeatInterval = 150,
        OnPress =  function(self) self.parent:Remove() end,
        Image = "UI/Infopanel/arrow_remove.tga",
        ColumnsUse = "abcc",
        RolloverTemplate = "Rollover",
    }, self)
    self.idAmount = XText:new({
        Id = "idAmount",
        Padding = box(2, 2, 5, 2),
        HAlign = "right",
        VAlign = "center",
        MinWidth = 60,
        MaxWidth = 70,
        TextFont = "UIPage",
        TextStyle = "UIPage",
        WordWrap = false,
        TextHAlign = "center",
        TextVAlign = "center",
    }, self)
    self.idAdd = XTextButton:new({
        Id = "idAdd",
        HAlign = "right",
        VAlign = "center",
        TextFont = "InfoText",
        TextStyle = "InfoText",
        MouseCursor = "UI/Cursors/Rollover.tga",
        FXMouseIn = "RocketRemoveCargoHover",
        RepeatStart = 300,
        RepeatInterval = 300,
        OnPress =  function(self) self.parent:Add() end,
        Image = "UI/Infopanel/arrow_add.tga",
        ColumnsUse = "abcc",
        RolloverTemplate = "Rollover",
    }, self)
    local AddRemoveRolloverHint = T{
        ModConfig.StringIdBase + 4,
        "<em><click></em> x<step><newline>"..
        "<em><shift> + <click></em> x<step10><newline>"..
        "<em><control> + <click></em> x<step100>",
        click = "<image "..MouseButtonImagesInText.MouseL..">",
        shift = ShortcutKeysToText({VKStrNames[const.vkShift]}),
        control = ShortcutKeysToText({VKStrNames[const.vkControl]}),
        step = self.Step,
        step10 = self.Step * 10,
        step100 = self.Step * 100,
    }
    self.idAmount:SetRolloverTextColor(RGB(255, 215, 0)) -- -- RolloverTextColor is Gold
    self.idRemove:SetRolloverTitle(self.OptionName)
    self.idAdd:SetRolloverTitle(self.OptionName)
    self.idRemove:SetRolloverText(self.OptionDesc or T{
        ModConfig.StringIdBase + 5,
        "<center>Decrease"
    })
    self.idAdd:SetRolloverText(self.OptionDesc or T{
        ModConfig.StringIdBase + 6,
        "<center>Increase"
    })
    self.idRemove:SetRolloverHint(AddRemoveRolloverHint)
    self.idAdd:SetRolloverHint(AddRemoveRolloverHint)
    self:Set(ModConfig:Get(self.ModId, self.OptionId))
    self.idAdd.MinWidth    = 20 -- Fix for Gagarin triangle issue
    self.idAdd.Columns     = 2  -- Fix for Gagarin triangle issue
    self.idRemove.MinWidth = 20 -- Fix for Gagarin triangle issue
    self.idRemove.Columns  = 2  -- Fix for Gagarin triangle issue
end

function XModConfigNumberInput:Set(value, update)
    if update == nil then update = true end
    if type(value) ~= "number" then value = 0 end
    if self.Min ~= nil and value < self.Min then
        value = self.Min
    elseif self.Max ~= nil and value > self.Max then
        value = self.Max
    end
    self.current_value = value
    if value == self.Min then
        self.idRemove:SetVisible(false)
    else
        self.idRemove:SetVisible(true)
    end
    if value == self.Max then
        self.idAdd:SetVisible(false)
    else
        self.idAdd:SetVisible(true)
    end
    self.idAmount:SetText(LocaleInt(self.current_value))
    if update then
        ModConfig:Set(self.ModId, self.OptionId, value, ModConfig.internal_token)
    end
end

function XModConfigNumberInput:Remove()
    local step = self.Step
    if terminal.IsKeyPressed(const.vkShift) then
        step = step * 10
    elseif terminal.IsKeyPressed(const.vkControl) then
        step = step * 100
    end
    self:Set(self.current_value - step)
end

function XModConfigNumberInput:Add()
    local step = self.Step
    if terminal.IsKeyPressed(const.vkShift) then
        step = step * 10
    elseif terminal.IsKeyPressed(const.vkControl) then
        step = step * 100
    end
    self:Set(self.current_value + step)
end


----------------------------------------------------------------------------------------------------------
--  A bit of a shim class to emulate the behaviour of XScrollThumb from before the Curiosity update.
DefineClass.XModConfigScrollThumb = {
    __parents = {
        "XScrollThumb",
        "XEmbedIcon",
    },
}

function XModConfigScrollThumb:Init()
    -- The post-Curiosity XScrollThumb seems to be intended to be used only via its XSleekScroll
    -- subclass, which has an idThumb property that's functionally equivalent (for our purposes at
    -- least) to XEmbedIcon's idIcon property, so we just add an alias.
    self.idThumb = self.idIcon
end

DefineClass.XModConfigSlider = {
    __parents = {
        "XPropControl",
    },
    properties = {
        { category = "Params", id = "ModId",      editor = "text",   default = "" },
        { category = "Params", id = "OptionId",   editor = "text",   default = "" },
        { category = "Params", id = "OptionName", editor = "text",   default = "" },
        { category = "Params", id = "Min",        editor = "number", default = nil },
        { category = "Params", id = "Max",        editor = "number", default = nil },
        { category = "Params", id = "Step",       editor = "number", default = 1 },
    },
    RolloverOnFocus = true,
    FXMouseIn = "MenuItemHover",
}

function XModConfigSlider:Init()
    XWindow:new({
        Id = "idSliderTarget",
        OnScrollTo = function(self, scroll) self.parent:Set(scroll) end,
    }, self)
    self.slider = XModConfigScrollThumb:new({
        Dock = "right",
        VAlign = "center",
        Icon = "UI/Infopanel/progress_bar_slider.tga",
        Max = self.Max,
        Min = self.Min,
        StepSize = self.Step,
        Target = "idSliderTarget",
        MinWidth = 200,
        Horizontal = true,
    }, self)
    XFrame:new({
        ZOrder = 0,
        Image = "UI/Infopanel/progress_bar.tga",
        FrameBox = box(5, 0, 5, 0),
        SqueezeY = false,
    }, self.slider)
    self.idLabel = XText:new({
    	  TextFont = "InfoText",
        TextStyle = "InfoText",
        Translate = true,
        Margins = box(10, 0, 10, 0),
        Dock = "right",
    }, self)
    self:Set(ModConfig:Get(self.ModId, self.OptionId))
end

function XModConfigSlider:Set(value, update)
    if update == nil then update = true end
    if type(value) ~= "number" then value = 0 end
    if value < self.Min then
        value = self.Min
    elseif value > self.Max then
        value = self.Max
    end
    self.slider:SetScroll(value)
    if self.Label then
        self.idLabel:SetText(T{self.Label, value=value})
    end
    if update then
        ModConfig:Set(self.ModId, self.OptionId, value, ModConfig.internal_token)
    end
end
