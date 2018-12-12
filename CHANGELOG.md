# Mod Config Reborn Changelog
## v2.4.2 12/11/2018 5:05:37 PM
#### Changed
- ModConfig:Save()
- ModConfig:RegisterMod()
- ModConfig:ResetAllToDefaults() now emulates the Set() command but forces the set
- ModConfig:Save() - added reset parm for passthrought to SaveSettingsFile()
- ModConfig:SaveSettingsFile(0 - added reset param for special handling of defaults

#### Added
- parameter restrictions for sav_loc in RegisterMod()
- token ModConfigReset send in Msg ModConfigChanged in ResetAllToDefaults()
- check for persistent storage limit reached in ModConfig:CalcDataSpace()
- ModConfigWarnOverLimit() - a check for persistent storage space prior to save.

#### Fixed Issues
- fixed check for nil in Save()

--------------------------------------------------------
## v2.4.1 12/03/2018 11:23:09 PM
#### Changed
- fixed syntax and documentation of comments

--------------------------------------------------------
## v2.4.0 12/03/2018 8:08:45 PM
#### Changed
- function ModConfig:RegisterMod
  - included option for sav_loc
- ModConfig:CalcDataSpace(mod_data)
  - sending save_data from Save() function to caculate only the central storage
- ModConfig:Save()
  - now splits save to central or local storage
- ModConfig:Load()
  - now calls ReadSettingsFile() and consolidates the data in ModConfig.data
- ModConfig:CalcDataSpace()
  - takes into account local vs central storage and returns only space used by central storage.

#### Added
- Added functions to read and save to LocalStorage.lua
- function ModConfig:ReadSettingsFile()
- function ModConfig:SaveSettingsFile()

--------------------------------------------------------
## v2.3.1 12/02/2018 5:44:28 PM
#### Added
- Interface checks to safe space functions to prevent log spam on nil interface.
  - function OnMsg.SafeAreaMarginsChanged()
- Added Ignore_Files to metadata
  - moved preview image to root
  - ignoring git and image dirs
  - modified .gitignore to ignore root image files.

#### Fixed Issues
- Changing display res causes nil errors to interface var in SafeAreaMarginsChanged()
--------------------------------------------------------
## v2.3.0 11/17/2018 11:03:28 PM
#### Added
- added legacyCode.md file for sample code for original Mod Config
- added border to id_scroll_window
- code from choggi fork for allowing dialog to move.
- dlg.idSizeControl = XSizeControl:new({ }, dlg)
- dlg.idMoveControl = XMoveControl:new({
--------------------------------------------------------
## v2.2.3 11/17/2018 5:56:23 PM
#### Changed
- mcr classes trianglle fix
  - self.idAdd.MinWidth    = 20 -- Fix for Gagarin triangle issue
  - self.idAdd.Columns     = 1  -- Fix for Gagarin triangle issue
  - self.idAdd.ColumnsUse  = "aaaaa"  -- Fix for Gagarin triangle issue
  - self.idRemove.MinWidth    = 20 -- Fix for Gagarin triangle issue
  - self.idRemove.Columns     = 1  -- Fix for Gagarin triangle issue
  - self.idRemove.ColumnsUse  = "aaaaa"  -- Fix for Gagarin triangle issue
--------------------------------------------------------
## v2.2.2 11/11/2018 10:26:03 PM
#### Changed
- g_ModConfigLoaded = false instead of nil
--------------------------------------------------------
## v2.2.1 Oct 28th, 2018
- First static release of Mod Config Reborn

#### Added
- Signed code certificate

#### Issues
- Due to base code changed this version can only be used with Gagarin Patch.  It will show as disabled in the mod manager until then, however users with the beta can use it right away.
- Cannot be run simultaniously with original Mod Config after Gagarin patch

#### Deprecated
- rawget _G

#### Todo
- Localizations
