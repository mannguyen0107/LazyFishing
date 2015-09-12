; Main GUI.
Gui, Main:Default
Gui, Main:Add, Picture, x5 y15 w550 h95 , %A_ScriptDir%/data/img/launcher/banner.png
Gui, Main:Font, S10 Q4, Verdana
Gui, Main:Add, Tab2, x5 y110 w540 h460 -Wrap -Background, Log Screen||Login Bot|Fishing Bot|Boot/Decons Bot|Misc
Gui, Main:Add, Tab2, x5 y570 w540 h70 -Wrap -Background

; Log Screen Tab
Gui, Main:Tab, 1, 1
Gui, Main:Add, Edit, x15 y140 w520 h420 vConsole

; Login Tab
Gui, Main:Tab, 2, 1
Gui, Main:Add, ListView, x15 y140 w320 h420 NoSortHdr Grid -Multi AltSubmit vAccountList gAccountList, Login Account|Fishing Mode
Gui, Main:Add, Button, x345 y140 w190 h40 gSaveLogin, Save Current Login
Gui, Main:Add, Button, x345 y190 w190 h40 gRemoveAcc, Remove Selected Account
Gui, Main:Add, Button, x345 y280 w190 h40 gLaunchGlyph, Launch Glyph
Gui, Main:Add, Button, x345 y330 w190 h40 gLaunchSelected, Launch Selected Account
Gui, Main:Add, Button, x345 y380 w190 h40 gLaunchAll, Launch All Account
Gui, Main:Add, Button, x345 y520 w190 h40 gLoginSetting, Config Glyph Path/Version

; Fishing Tab
Gui, Main:Tab, 3, 1
Gui, Main:Add, ListView, x15 y140 w520 h300 NoSortHdr Grid vFishingList, Account Name|Reel In|Fish In|Status

Gui, Main:Add, GroupBox, x335 y450 w200 h100 +Center, Setting
Gui, Main:Add, Text, x345 y480 w60 h20 +Left, Address:
Gui, Main:Add, Edit, x415 y480 w110 h20 +Center vAddress
Gui, Main:Add, Button, x405 y515 w60 h20 gFishingSettingSave, Save

Gui, Main:Add, Button, x15 y457 w120 h40 gFishingStartAll, Start All
Gui, Main:Add, Button, x15 y507 w120 h40 gFishingStopAll, Stop All
Gui, Main:Add, Button, x145 y457 w180 h40 gFishingStartSelected, Start Selected Account
Gui, Main:Add, Button, x145 y507 w180 h40 gFishingStopSelected, Stop Selected Account

; Boot/Decons Tab
Gui, Tab, 4, 1
Gui, Main:Add, ListView, x15 y140 w520 h260 NoSortHdr Grid AltSubmit vBDList gBDList, Account Name|Boot Drop Mode|Decons Mode

hotkeylist := "Ctrl + Numpad0|Ctrl + Numpad1|Ctrl + Numpad2|Ctrl + Numpad3|Ctrl + Numpad4|Ctrl + Numpad5|Ctrl + Numpad6|Ctrl + Numpad7|Ctrl + Numpad8|Ctrl + Numpad9|Ctrl + F1|Ctrl + F2|Ctrl + F3|Ctrl + F4|Ctrl + F5|Ctrl + F6|Ctrl + F7|Ctrl + F8|Ctrl + F9|Ctrl + F10|Ctrl + F11|Ctrl + F12"

Gui, Main:Add, GroupBox, x285 y410 w250 h150 +Center, Setting
Gui, Main:Add, Text, x300 y435 w100 h20 +Left, Session Delay:
Gui, Main:Add, Edit, x410 y435 w110 h20 +Center vBDDelay
Gui, Main:Add, Text, x300 y467 w100 h20 +Left, Drop Method:
Gui, Main:Add, ComboBox, x410 y465 w110 vBootDropMethod hwndHBootDropMethod, Image Search|Manual
Gui, Main:Add, Text, x300 y502 w100 h20 +Left, Stop Hotkey:
Gui, Main:Add, ComboBox, x410 y500 w110 vHK_BDStop hwndHHK_BDStop, %hotkeylist%
Gui, Main:Add, Button, x385 y533 w60 h20 gBDSettingSave, Save

Gui, Main:Add, Button, x15 y417 w120 h40 gBDStart, Start
Gui, Main:Add, Button, x145 y417 w120 h40 gBDStop, Stop

Gui, Main:Add, GroupBox, x15 y470 w250 h90 +Center, Next Session Start In
Gui, Main:Font, S35 Q4, Verdana
Gui, Main:Add, Text, x30 y490 h20 vBDCDTime, 00:00:00

Gui, Main:Font, S10 Q4, Verdana
Gui, Main:Add, StatusBar
SB_SetParts(20, 450, 80)
SB_SetIcon(A_ScriptDir . "/data/img/main.ico", 1, 1) 
SB_SetText("By: TaeJim", 3)

; Misc Tab
Gui, Tab, 5, 1
Gui, Main:Add, Picture, x15 y140 w235 h420 , %A_ScriptDir%/data/img/inv/inventory.png
LoadGUIImgSetSlots()

Gui, Main:Add, GroupBox, x280 y150 w250 h70 +Center, Set Slots
Gui, Main:Add, Button, x295 y175 w100 h30 gSetSlotsSave, Save
Gui, Main:Add, Button, x415 y175 w100 h30 gSetDefaultSlots, Reset Default

Gui, Main:Add, GroupBox, x280 y235 w250 h70 +Center, Resize Game Window To Default
Gui, Main:Add, Button, x345 y260 w120 h30 gResizeAll, Resize All

Gui, Main:Add, GroupBox, x280 y320 w250 h230 +Center, Auto Shutdown Trove/Computer
Gui, Main:Add, Text, x295 y350 h20, Shutdown:
Gui, Main:Add, ComboBox, x390 y347 w120 vShutdownType hwndHShutdownType, Computer|Trove
Gui, Main:Add, Text, x295 y380 h20, Time:
Gui, Main:Add, Edit, x390 y380 w30 h20 +Center vSDHour
Gui, Main:Add, Text, x425 y380 h20 , :
Gui, Main:Add, Edit, x435 y380 w30 h20 +Center vSDMin
Gui, Main:Add, Text, x470 y380 h20 , :
Gui, Main:Add, Edit, x480 y380 w30 h20 +Center vSDSec
Gui, Main:Add, GroupBox, x295 y420 w220 h80 +Center, Time Left
Gui, Main:Add, Button, x310 y510 w80 h30 gSDStart, Start
Gui, Main:Add, Button, x420 y510 w80 h30 gSDStop, Stop

Gui, Main:Font, S30 Q4, Verdana
Gui, Main:Add, Text, x315 y440 h20 vSDCDTime, 00:00:00

Gui, Main:Font, S10 Q4, Verdana
Gui, Tab
Gui, Main:Add, Button, x50 y585 w120 h40 gCleanLogFolder, Clean Log Folder
Gui, Main:Add, Button, x215 y585 w120 h40, Read Me
Gui, Main:Add, Button, x380 y585 w120 h40 gDonate, Donate

; Login Setting GUI.
Gui, LoginSetting:Font, S10 Q4, Verdana
Gui, LoginSetting:Add, Text, x10 y23 w140 h20, Glyph Version:
Gui, LoginSetting:Add, ComboBox, x140 y20 w140 vGlyphVer hwndHGlyphVer, Steam|Standalone
Gui, LoginSetting:Add, Text, x10 y60 w140 h20, Glyph Folder Path:
Gui, LoginSetting:Add, Edit, x140 y60 w260 h20 vGlyphPathDisplay
Gui, LoginSetting:Add, Button, x410 y60 w60 h20 gLoginSettingBrowsePath, Browse

Gui, LoginSetting:Add, Button, x100 y100 w120 h30 gLoginSettingSave, Save
Gui, LoginSetting:Add, Button, x270 y100 w120 h30 gLoginSettingCancel, Close