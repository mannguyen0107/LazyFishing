Gui, Main:Default
Gui, Main:Font, S9 Q4, Verdana
Gui, Main:Add, GroupBox, x10 y10 w710 r3
Gui, Main:Add, Picture, x155 y22 w438 h63 BackgroundTrans, %A_ScriptDir%/data/img/launcher/banner.png
Gui, Main:Add, Text, x20 y20, CPU:
Gui, Main:Add, Text, x60 y20 w100 vCPU


Gui, Main:Add, Tab2, x10 y100 w710 h300 -Wrap -Background +Theme 0x400 , General||Login|Fishing|Boot/Decons|Misc|Notification
Gui, Main:Add, StatusBar

; General Tab
Gui, Main:Tab, 1
Gui, Main:Add, Edit, x30 y140 w480 h240 vConsole
Gui, Main:Add, GroupBox, x530 y160 w170 h175 E0x00000020
Gui, Main:Add, Button, x540 y180 w150 h40 gCleanLogFolder, Clean Log Folder
Gui, Main:Add, Button, x540 y230 w150 h40 gReadMe, Read Me
Gui, Main:Add, Button, x540 y280 w150 h40 gDonate, Donate

; Login Tab
Gui, Main:Tab, 2
Gui, Main:Add, ListView, x30 y140 w670 h140 NoSortHdr Grid -Multi vAccountList gAccountList, Login Account|Fishing Mode
Gui, Main:Add, Button, x30 y290 w190 h40 gSaveLogin, Save Current Login
Gui, Main:Add, Button, x30 y340 w190 h40 gRemoveAcc, Remove Selected Account
Gui, Main:Add, Button, x270 y290 w190 h40 gLaunchGlyph, Launch Glyph
Gui, Main:Add, Button, x270 y340 w190 h40 gLaunchSelected, Launch Selected Account
Gui, Main:Add, Button, x510 y290 w190 h40 gLaunchAll, Launch All Account
Gui, Main:Add, Button, x510 y340 w190 h40 gLoginSetting, Config Glyph Path/Version

; Fishing Tab
Gui, Main:Tab, 3
Gui, Main:Add, ListView, x30 y140 w670 h140 NoSortHdr Grid -Multi vFishingList, Account Name|Start Time|Reel In|Fish In|Status|AFK Start Time
Gui, Main:Add, Button, x30 y290 w190 h40 gFishingStartAll, Fishing Start All
Gui, Main:Add, Button, x30 y340 w190 h40 gFishingStopAll, Fishing Stop All
Gui, Main:Add, Button, x270 y290 w190 h40 gFishingStartSelected, Fishing Start Selected
Gui, Main:Add, Button, x270 y340 w190 h40 gFishingStopSelected, Fishing Stop Selected
Gui, Main:Add, Button, x510 y290 w190 h40 gFishingSetting, Settings

; Boot/Decons Tab
Gui, Main:Tab, 4
Gui, Main:Add, ListView, x30 y140 w490 h240 NoSortHdr Grid -Multi AltSubmit vBDList gBDList, Account Name|Boot Drop Mode|Decons Mode
Gui, Main:Add, Button, x540 y180 w160 h40 gBDStart vBDStart, Start
Gui, Main:Add, Button, x540 y230 w160 h40 gBDStop, Stop
Gui, Main:Add, Button, x540 y280 w160 h40 gBDSetting, Settings

; Misc Tab
Gui, Main:Tab, 5
Gui, Main:Font, S9 Q4, Verdana
Gui, Main:Add, Text, x30 y150 BackgroundTrans E0x00000020, Auto Shutdown
Gui, Main:Add, GroupBox, x30 y160 w300 h220 E0x00000020
Gui, Main:Add, Text, x50 y180 BackgroundTrans E0x00000020, Shutdown:
Gui, Main:Add, ComboBox, x140 y178 w120 vShutdownType hwndHShutdownType, Computer|Trove
Gui, Main:Add, Text, x50 y210 BackgroundTrans E0x00000020, Time:
Gui, Main:Add, Edit, x140 y209 w40 h20 +Center vSDHour
Gui, Main:Add, Text, x190 y210 BackgroundTrans E0x00000020, :
Gui, Main:Add, Edit, x205 y209 w40 h20 +Center vSDMin
Gui, Main:Add, Text, x255 y210 BackgroundTrans E0x00000020, :
Gui, Main:Add, Edit, x270 y209 w40 h20 +Center vSDSec
Gui, Main:Add, GroupBox, x70 y240 w220 h70 E0x00000020
Gui, Main:Font, S30 Q4, Verdana
Gui, Main:Add, Text, x87 y252 BackgroundTrans E0x00000020 vSDCDTime, 00:00:00
Gui, Main:Font, S9 Q4, Verdana
Gui, Main:Add, Button, x60 y330 w100 h30 gSDStart, Start
Gui, Main:Add, Button, x200 y330 w100 h30 gSDStop, Stop
Gui, Main:Add, Text, x360 y150 BackgroundTrans E0x00000020, Ultilities Buttons
Gui, Main:Add, GroupBox, x360 y160 w300 h220 E0x00000020
Gui, Main:Add, Button, x380 y180 w140 h30 gResize, Resize All Windows


; Notification Tab
Gui, Main:Tab, 6
Gui, Main:Font, S15 Q4 Underline, Verdana
Gui, Main:Add, Text, x210 y140 BackgroundTrans E0x00000020, PushBullet Notification System
Gui, Main:Font, S9 Q4 norm, Verdana
Gui, Main:Add, GroupBox, x80 y175 w560 h210 E0x00000020
Gui, Main:Add, Text, x120 y200 BackgroundTrans E0x00000020, Access Token:
Gui, Main:Add, Edit, x280 y199 w310 h20 +Center vToken
Gui, Main:Add, Text, x120 y230 BackgroundTrans E0x00000020, Push Notify Every:
Gui, Main:Add, Edit, x280 y229 w40 h20 +Center vPBHour
Gui, Main:Add, Text, x330 y230 BackgroundTrans E0x00000020, :
Gui, Main:Add, Edit, x345 y229 w40 h20 +Center vPBMin
Gui, Main:Add, Text, x395 y230 BackgroundTrans E0x00000020, :
Gui, Main:Add, Edit, x410 y229 w40 h20 +Center vPBSec
Gui, Main:Add, Text, x120 y263 BackgroundTrans E0x00000020, Delete All Msg On Start:
Gui, Main:Add, ComboBox, x280 y260 w126 vDelMsgOnStart hwndHDelMsgOnStart, Yes|No
Gui, Main:Add, Button, x170 y300 w160 h30 gNotifySaveSetting, Save Settings
Gui, Main:Add, Button, x400 y300 w160 h30 gTestToken, Test Token
Gui, Main:Add, Button, x170 y340 w160 h30 gEnableNotify vEnableNotify, Enable
Gui, Main:Add, Button, x400 y340 w160 h30 gDisableNotify vDisableNotify, Disable