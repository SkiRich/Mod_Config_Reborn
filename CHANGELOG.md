# Mod Config Reborn Changelog
## v2.5.5 04/04/2021 2:27:18 PM
#### Changed
- MCR_docs.md file WaitForModConfig

--------------------------------------------------------
## 2.5.4 03/16/2021 8:11:58 PM
#### Changed
- Text in main menu to not confuse with in game mod manager

--------------------------------------------------------
## 2.5.3 06/16/2019 2:19:10 AM
#### Changed
- All font styles updated to use current text styles
- changed StringIDBase to my range
- moved starting global vars to MCR_1Classes file

#### Fixed Issues
- font used did not paint russian cirillic characters

--------------------------------------------------------
## v2.5.2 06/05/2019 7:58:40 PM
#### Changed
- ModConfig:Load()
  - now added err to ModLog
  - Does an immediate write to blank out the persistent data in account.dat
- ModConfig.CloseDialog(dlg)
  - using Close() instead of delete()
- changed various ModConfig.something to self.something
- minor changes to retrofit routine and using table.find

#### Removed
- OnSetRollover = function from local close_button
- close_button.OnPress = ModConfig.CloseDialog

#### Fixed Issues
- Interpolation issues generated when closing the modconfig dialog

--------------------------------------------------------
## v2.5.1 06/04/2019 9:29:07 PM
#### Changed
- ModConfig:CalcDataSpace()

#### Fixed Issues
- CalcDataSpace() was calculating incorrect srting length size

--------------------------------------------------------
## v2.5.0 06/04/2019 1:01:53 AM
#### Changed
- function ModConfig:ReadSettingsFile(restore)
  - changed the way it reads the file data, allows for two types of reads, restore and localstorage
  - no longer walking registry
  - removed convertion techniques, not needed here
- function ModConfig:CalcDataSpace(compressData)
  - no longer calculating compression by default
  - no longer walking registry
- function ModConfig:SaveSettingsFile(backup)
  - changed the way it saves the file data, allows for two types of save, backup and localstorage
  - no longer walking registry
  - removed convertion techniques, not needed here
- ModConfig:Save()
  - no longer walking registry
  - no longer compressing
- ModConfig:Load()
  - no longer walking registry
  - no longer decompressing

#### Added
- Additional ModLog messages

#### Removed
- Removed initialize LocalStorage, moved to read and save file functions.
- no longer compressing data
- removed OnMsg.CityStart() , LoadGame(), and CityStart() - didnt need them.

#### Fixed Issues
- registry walking in the load and save functions was flawed after the game converted to
using double load of mods (ReloadLua()), once during game load on the start screen and again on game load/new.
The result was an incomplete registry since not all mods loaded yet but some mods would do a ModConfig:Set().
Walking the registry early caused some mod data to be wiped clean on every game load or new game.

#### Todo
- Add a compress technique and modconfig optoin to use if data size creep gets too large.

--------------------------------------------------------
## v2.4.5 06/01/2019 3:58:11 AM

#### Added
- OnMsg.CityStart

#### Fixed Issues
- ReadPersistentStorage was wiping the storage on citystart and exit.

--------------------------------------------------------
## v2.4.4 05/25/2019 4:40:29 AM

#### Added
- added OnMsg.SaveGame()
- added OnMsg.LoadGame()

#### Removed

#### Fixed Issues
- ReadModPersistentData() was clearing persistent data upon being issued causing write data not to be current, so if a user loaded a game and quit the data was reset on next load.

--------------------------------------------------------
## v2.4.3 05/09/2019 10:44:35 PM

#### Added
- Added g_ModConfigLoadedInitData
  - a variable that contains a copy of the registry at the moment MCR loads and before any other mod makes changes
  - used for debugging
- Added additional prints and ModLog's to code when MCR fails during load - for debugging

--------------------------------------------------------
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
