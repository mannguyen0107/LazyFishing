Gui, FishingSetting:Font, S9 Q4, Verdana
Gui, FishingSetting:Add, GroupBox, x15 y10 w350 h80, Main
Gui, FishingSetting:Add, Text, x30 y30 w100 h20, Base Address:
Gui, FishingSetting:Add, Edit, x130 y28 w200 h20 +Center vAddress
Gui, FishingSetting:Add, Text, x30 y60 w100 h20, Scan Start At:
Gui, FishingSetting:Add, Edit, x130 y58 w40 h20 +Center vScanTime
Gui, FishingSetting:Add, Text, x175 y60 w60 h20, seconds

Gui, FishingSetting:Add, GroupBox, x15 y100 w350 h110, Fish Bite Offsets
Gui, FishingSetting:Add, Text, x30 y120 w100 h20, Water:
Gui, FishingSetting:Add, Edit, x130 y118 w200 h20 +Center vFishBiteWaterOffsets
Gui, FishingSetting:Add, Text, x30 y150 w100 h20, Lava:
Gui, FishingSetting:Add, Edit, x130 y148 w200 h20 +Center vFishBiteLavaOffsets
Gui, FishingSetting:Add, Text, x30 y180 w100 h20, Choco:
Gui, FishingSetting:Add, Edit, x130 y178 w200 h20 +Center vFishBiteChocoOffsets

Gui, FishingSetting:Add, GroupBox, x15 y220 w350 h110, Liquid Type Offsets
Gui, FishingSetting:Add, Text, x30 y240 w100 h20, Water:
Gui, FishingSetting:Add, Edit, x130 y238 w200 h20 +Center vLiquidTypeWaterOffsets
Gui, FishingSetting:Add, Text, x30 y270 w100 h20, Lava:
Gui, FishingSetting:Add, Edit, x130 y268 w200 h20 +Center vLiquidTypeLavaOffsets
Gui, FishingSetting:Add, Text, x30 y300 w100 h20, Choco:
Gui, FishingSetting:Add, Edit, x130 y298 w200 h20 +Center vLiquidTypeChocoOffsets

Gui, FishingSetting:Add, Picture, x340 y30 w14 h14 vFishingSettingHelp1 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y60 w14 h14 vFishingSettingHelp2 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y120 w14 h14 vFishingSettingHelp3 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y150 w14 h14 vFishingSettingHelp4 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y180 w14 h14 vFishingSettingHelp5 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y240 w14 h14 vFishingSettingHelp6 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y270 w14 h14 vFishingSettingHelp7 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, FishingSetting:Add, Picture, x340 y300 w14 h14 vFishingSettingHelp8 gHelp, %A_ScriptDir%/data/img/launcher/help.png

Gui, FishingSetting:Add, Button, x50 y340 w120 h30 gFishingSettingSave, Save
Gui, FishingSetting:Add, Button, x220 y340 w120 h30 gFishingSettingCancel, Cancel