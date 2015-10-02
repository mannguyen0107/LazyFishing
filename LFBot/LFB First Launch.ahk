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
	IniWrite, 320, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Width
	IniWrite, 240, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Height
}

IfNotExist, %A_ScriptDir%/data/configs/fishingsystem.ini
{
	;Default Settings for Fishing Sytem.
	IniWrite, 0x00AAB440, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
	IniWrite, 0x144+0xe4+0x70, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Water
	IniWrite, 0x144+0xe4+0x514, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Lava
	IniWrite, 0x144+0xe4+0x2c0, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Choco
	IniWrite, 0x604+0x7d4+0x28+0x524, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Water
	IniWrite, 0x604+0x7d4+0x48c+0x3e0, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Lava
	IniWrite, 0x604+0x7d4+0x3c8+0xfc, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Choco
	IniWrite, 12, %A_ScriptDir%/data/configs/fishingsystem.ini, TimeBeforeScan, Time
}

IfNotExist, %A_ScriptDir%/data/configs/bdsystem.ini
{
	;Default Settings for Boot/Decons System.
	IniWrite, 001000, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
	IniWrite, Ctrl + F1, %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
	IniWrite, 238, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseX ; Relative 360, Client 352
	IniWrite, 71, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseY ; Relative 158, Client 127
	IniWrite, 55, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptX
	IniWrite, 210, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptY
	IniWrite, 140, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesX
	IniWrite, 135, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesY
	IniWrite, 0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|0|0|0|0|0|0|0|0|0|0, %A_ScriptDir%/data/configs/bdsystem.ini, InventorySlots, SelectedSlots
}

IfNotExist, %A_ScriptDir%/data/configs/miscsettings.ini
{
	;Default Settings for Misc Settings.
	IniWrite, Trove, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Type
	IniWrite, 120000, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Time
}

IfNotExist, %A_ScriptDir%/data/configs/notifysystem.ini
{
	;Default Settings for Notification System.
	IniWrite, G8aldIDL93ldFADFwp9032ADF2klj3ld, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, Token
	IniWrite, 010000, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, NotifyTime
	IniWrite, Yes, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, DelMsgOnStart
}