IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
if (GetGlyphVer = "Steam")
{
	IniRead, AfterLaunch, %GetGlyphPath%/GlyphClient.cfg, Glyph, AfterLaunch
	if (AfterLaunch != "Exit")
	{
		IniWrite, Exit, %GetGlyphPath%/GlyphClient.cfg, Glyph, AfterLaunch
	}
}
else
{
	IniRead, AfterLaunch, %StandaloneDataPath%/GlyphClient.cfg, Glyph, AfterLaunch
	if (AfterLaunch != "Exit")
	{
		IniWrite, Exit, %StandaloneDataPath%/GlyphClient.cfg, Glyph, AfterLaunch
	}
}

LoadSelectedSlot()

; Account List
AccountListReload()
Gui, Main:ListView, AccountList
LV_ModifyCol(1, 350)
LV_ModifyCol(1, "Center")
LV_ModifyCol(2, "AutoHdr")
LV_ModifyCol(2, "Center")

; Fishing List
IniRead, LoadAddress, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
IniRead, LoadScanTime, %A_ScriptDir%/data/configs/fishingsystem.ini, TimeBeforeScan, Time
GuiControl, Main:, Address, %LoadAddress%
GuiControl, Main:, ScanTime, %LoadScanTime%
FishingListReload()
Gui, Main:ListView, FishingList
LV_ModifyCol(1, "Center")
LV_ModifyCol(1, 160)
LV_ModifyCol(2, "Center")
LV_ModifyCol(2, 150)
LV_ModifyCol(3, "Center")
LV_ModifyCol(3, 60)
LV_ModifyCol(4, "Center")
LV_ModifyCol(4, 80)
LV_ModifyCol(5, "Center")
LV_ModifyCol(5, 65)
LV_ModifyCol(6, "Center")
LV_ModifyCol(6, 150)

; Boot/Decons List
IniRead, GetBDTime, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
IniRead, BDStopHK,  %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
GetHotKey := StrSplit(BDStopHK, " + ")
@BDStopHK := GetHotKey[2]
HotKey, ^%@BDStopHK%, HKBDStop, On
BDListReload()
Gui, Main:ListView, BDList
LV_ModifyCol(1, 270)
LV_ModifyCol(1, "Center")
LV_ModifyCol(2, "AutoHdr")
LV_ModifyCol(2, "Center")
LV_ModifyCol(3, "Center")
LV_ModifyCol(3, "AutoHdr")

IniRead, GetSDType, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Type
ControlSetText, , %GetSDType%, ahk_id %HShutdownType%
IniRead, GetSDTime, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Time
StringMid, SDTimeH, GetSDTime, 1, 2
StringMid, SDTimeM, GetSDTime, 3, 2
StringMid, SDTimeS, GetSDTime, 5, 2
GuiControl, Main:, SDHour, %SDTimeH%
GuiControl, Main:, SDMin, %SDTimeM%
GuiControl, Main:, SDSec, %SDTimeS%

IniRead, GetToken, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, Token
GuiControl, Main:, Token, %GetToken%
IniRead, GetPBime, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, NotifyTime
StringMid, NTimeH, GetPBime, 1, 2
StringMid, NTimeM, GetPBime, 3, 2
StringMid, NTimeS, GetPBime, 5, 2
GuiControl, Main:, PBHour, %NTimeH%
GuiControl, Main:, PBMin, %NTimeM%
GuiControl, Main:, PBSec, %NTimeS%
IniRead, GetDelMsgOnStart, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, DelMsgOnStart
ControlSetText, , %GetDelMsgOnStart%, ahk_id %HDelMsgOnStart%

SB_SetParts(20, 610, 100)
SB_SetIcon(A_ScriptDir . "/data/img/main.ico", 1, 1) 
SB_SetText("By: TaeJim", 3)

IniRead, ClientWidth, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Width
IniRead, ClientHeight, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Height