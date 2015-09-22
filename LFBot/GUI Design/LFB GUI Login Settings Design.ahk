Gui, LoginSetting:Font, S10 Q4, Verdana
Gui, LoginSetting:Add, Text, x10 y23 w140 h20, Glyph Version:
Gui, LoginSetting:Add, ComboBox, x140 y20 w140 vGlyphVer hwndHGlyphVer, Steam|Standalone
Gui, LoginSetting:Add, Text, x10 y60 w140 h20, Glyph Folder Path:
Gui, LoginSetting:Add, Edit, x140 y60 w260 h20 vGlyphPathDisplay
Gui, LoginSetting:Add, Button, x410 y60 w60 h20 gLoginSettingBrowsePath, Browse

Gui, LoginSetting:Add, Button, x100 y100 w120 h30 gLoginSettingSave, Save
Gui, LoginSetting:Add, Button, x270 y100 w120 h30 gLoginSettingCancel, Close