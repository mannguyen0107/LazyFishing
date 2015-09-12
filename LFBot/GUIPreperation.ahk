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
LV_ModifyCol(1, 215)
LV_ModifyCol(1, "Center")
LV_ModifyCol(2, "AutoHdr")
LV_ModifyCol(2, "Center")

; Fishing List
IniRead, LoadAddress, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
GuiControl, Main:, Address, %LoadAddress%
FishingListReload()
Gui, Main:ListView, FishingList
LV_ModifyCol(1, 250)
LV_ModifyCol(2, 70)
LV_ModifyCol(3, 80)
LV_ModifyCol(1, "Center")
LV_ModifyCol(2, "Center")
LV_ModifyCol(3, "Center")
LV_ModifyCol(4, "Center")
LV_ModifyCol(4, "AutoHdr")

; Boot/Decons List
IniRead, GetBDDelay, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
GuiControl, Main:, BDDelay, %GetBDDelay%
IniRead, GetDropMethod, %A_ScriptDir%/data/configs/bdsystem.ini, DropMethod, Method
GuiControl, Disable, BootDropMethod
ControlSetText, , %GetDropMethod%, ahk_id %HBootDropMethod%
IniRead, BDStopHK,  %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
GetHotKey := StrSplit(BDStopHK, " + ")
@BDStopHK := GetHotKey[2]
ControlSetText, , %BDStopHK%, ahk_id %HHK_BDStop%
HotKey, ^%@BDStopHK%, HKBDStop, On
BDListReload()
Gui, Main:ListView, BDList
LV_ModifyCol(1, 290)
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

IniRead, ClientWidth, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Width
IniRead, ClientHeight, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Height