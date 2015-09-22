Gui, BDSetting:Font, S10 Q4, Verdana
Gui, BDSetting:Add, Picture, x15 y10 w235 h420 , %A_ScriptDir%/data/img/inv/inventory.png
LoadGUIImgSetSlots()

Gui, BDSetting:Add, GroupBox, x10 y440 w245 h140
Gui, BDSetting:Add, Text, x20 y460, Time:
Gui, BDSetting:Add, Edit, x120 y460 w30 h20 +Center vBDHour
Gui, BDSetting:Add, Text, x155 y460 h20, :
Gui, BDSetting:Add, Edit, x165 y460 w30 h20 +Center vBDMin
Gui, BDSetting:Add, Text, x200 y460 h20, :
Gui, BDSetting:Add, Edit, x210 y460 w30 h20 +Center vBDSec

hotkeylist := "Ctrl + Numpad0|Ctrl + Numpad1|Ctrl + Numpad2|Ctrl + Numpad3|Ctrl + Numpad4|Ctrl + Numpad5|Ctrl + Numpad6|Ctrl + Numpad7|Ctrl + Numpad8|Ctrl + Numpad9|Ctrl + F1|Ctrl + F2|Ctrl + F3|Ctrl + F4|Ctrl + F5|Ctrl + F6|Ctrl + F7|Ctrl + F8|Ctrl + F9|Ctrl + F10|Ctrl + F11|Ctrl + F12"
Gui, BDSetting:Add, Text, x20 y490, Stop Hotkey:
Gui, BDSetting:Add, ComboBox, x120 y487 w120 vHK_BDStop hwndHHK_BDStop, %hotkeylist%
Gui, BDSetting:Add, Button, x55 y530 w160 h30 gBDSettingSave, Save and Exit