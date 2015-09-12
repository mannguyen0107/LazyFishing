IfNotExist, %A_ScriptDir%/data/savedlogins
{
	FileCreateDir, %A_ScriptDir%/data/savedlogins
}

IfNotExist, %A_ScriptDir%/data/configs
{
	FileCreateDir, %A_ScriptDir%/data/configs
}

IfNotExist, %A_ScriptDir%/data/log
{
	FileCreateDir, %A_ScriptDir%/data/log
}

IfNotExist, %A_ScriptDir%/data/configs/loginsystem.ini
{
	;Default Settings for Login System.
	IniWrite, C:\Program Files (x86)\Steam\SteamApps\common\Trove, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	IniWrite, Steam, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniWrite, 480, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Width
	IniWrite, 360, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Height
}

IfNotExist, %A_ScriptDir%/data/configs/fishingsystem.ini
{
	;Default Settings for Fishing.
	IniWrite, 0x00A43F04, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
}

IfNotExist, %A_ScriptDir%/data/configs/bdsystem.ini
{
	;Default Settings for Login System.
	IniWrite, 600000, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
	IniWrite, Ctrl + F1, %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
	IniWrite, Image Search, %A_ScriptDir%/data/configs/bdsystem.ini, DropMethod, Method
	IniWrite, 360, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseX ; Relative 360, Client 352
	IniWrite, 98, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseY ; Relative 158, Client 127
	IniWrite, 80, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptX
	IniWrite, 310, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptY
	IniWrite, 210, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesX
	IniWrite, 200, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesY
	IniWrite, 0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|0|0|0|0|0|0|0|0|0|0, %A_ScriptDir%/data/configs/bdsystem.ini, InventorySlots, SelectedSlots
}

IfNotExist, %A_ScriptDir%/data/configs/miscsettings.ini
{
	;Default Settings for Login System.
	IniWrite, Trove, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Type
	IniWrite, 120000, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Time
}