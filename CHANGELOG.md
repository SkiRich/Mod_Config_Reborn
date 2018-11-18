# Mod Config Reborn Changelog
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
