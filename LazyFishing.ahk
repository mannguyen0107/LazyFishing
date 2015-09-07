#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
CoordMode, Mouse, Relative
CoordMode, Pixel, Relative

IF NOT A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

; Showing Loading image.
SplashImage, %A_ScriptDir%/data/img/launcher/loadingstart.png, B, , , loading
WinSet, TransColor, White, loading


; -------------------------------------------------------------------------
; ~Start~ Declares Global vars.
Global BotVer := "1.5"
Global BDActive
Global DefaultGPath := "C:\Program Files (x86)\Steam\SteamApps\common\Trove"
Global FoundDat
Global ClientWidth
Global ClientHeight
Global StandaloneDataPath
; ~End~ Declares Global vars
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Creates config files at first launch.
IfNotExist, %A_ScriptDir%/data/savedlogins
{
	FileCreateDir, %A_ScriptDir%/data/savedlogins
}

IfNotExist, %A_ScriptDir%/data/configs
{
	FileCreateDir, %A_ScriptDir%/data/configs
}

IfNotExist, %A_ScriptDir%/data/configs/launcherconfig.ini
{
;Default Settings for Launcher.
	IniWrite, 0, %A_ScriptDir%/data/configs/launcherconfig.ini, AccountNum, Account_Num
	IniWrite, %A_ScriptDir%, %A_ScriptDir%/data/configs/launcherconfig.ini, WorkingDir, Dir
	IniWrite, %BotVer%, %A_ScriptDir%/data/configs/launcherconfig.ini, LazyFishing, Version
	IniWrite, %DefaultGPath%, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
	IniWrite, Image Search, %A_ScriptDir%/data/configs/launcherconfig.ini, Boot Drop Method, BootDropMethod
	IniWrite, No, %A_ScriptDir%/data/configs/launcherconfig.ini, Game Window, ChangeName
	IniWrite, Steam, %A_ScriptDir%/data/configs/launcherconfig.ini, GlyphVer, Version
	IniWrite, F1, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, StartAllAccount
	IniWrite, F2, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStart
	IniWrite, F3, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStop
	IniWrite, F4, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStart
	IniWrite, F5, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStop
}

IfNotExist, %A_ScriptDir%/data/configs/fishingconfig.ini
{
;Default Settings for Fishing.
	IniWrite, 0x00A682D0, %A_ScriptDir%/data/configs/fishingconfig.ini, Memory, Address
	IniWrite, 0, %A_ScriptDir%/data/configs/fishingconfig.ini, Break, Break
	IniWrite, 480, %A_ScriptDir%/data/configs/fishingconfig.ini, Client, Width
	IniWrite, 360, %A_ScriptDir%/data/configs/fishingconfig.ini, Client, Height
	IniWrite, 0, %A_ScriptDir%/data/configs/fishingconfig.ini, Account Number, AccNum
	IniWrite, 2000, %A_ScriptDir%/data/configs/fishingconfig.ini, Time Between Session, FishingSessionDelay
}

IfNotExist, %A_ScriptDir%/data/configs/bootdeconsconfig.ini
{
;Default Settings for Boot and Decons.
	IniWrite, 0x4c3000, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Empty Slot Pixel Color, Color
	IniWrite, 600000, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Time Between Session, BootDeconsTime
	IniWrite, 360, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, BaseX ; Relative 360, Client 352
	IniWrite, 158, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, BaseY ; Relative 158, Client 127
	IniWrite, 80, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnAcceptX
	IniWrite, 310, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnAcceptY
	IniWrite, 210, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnYesX
	IniWrite, 200, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnYesY
	IniWrite, 70, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, DeconsWindowX
	IniWrite, 220, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, DeconsWindowY
	Loop, 20
	{
		IniRead, GetBaseX, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, BaseX
		IniRead, GetBaseY, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, BaseY
		
		BaseX_1 := BaseX_6 := BaseX_11 := BaseX_16 := GetBaseX
		BaseX_2 := BaseX_7 := BaseX_12 := BaseX_17 := BaseX_1+20 ;Relative 20, Client 20
		BaseX_3 := BaseX_8 := BaseX_13 := BaseX_18 := BaseX_2+21 ;Relative 21, Client 21
		BaseX_4 := BaseX_9 := BaseX_14 := BaseX_19 := BaseX_3+21 ;Relative 21, Client 21
		BaseX_5 := BaseX_10 := BaseX_15 := BaseX_20 := BaseX_4+21 ;Relative 21, Client 21
		
		if (a_index <= 5)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY
			IniWrite, %BaseX%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_X
			IniWrite, %BaseY%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_Y
		}
		else if (a_index >5 and a_index <= 10)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+20
			IniWrite, %BaseX%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_X
			IniWrite, %BaseY%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_Y
		}
		else if (a_index >10 and a_index <= 15)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+40
			IniWrite, %BaseX%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_X
			IniWrite, %BaseY%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_Y
		}
		else if (a_index >15 and a_index <= 20)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+60
			IniWrite, %BaseX%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_X
			IniWrite, %BaseY%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_Y
		}
	}
}
; ~End~ Creates config files at first launch.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ GUI Creation.

; Main GUI.
Gui, Main:Font, S11 Q4, Verdana
Gui, Main:Add, Text, x10 y10 w140 h20 , Glyph Folder Path:
Gui, Main:Add, Button, x650 y10 w60 h20 gChooseGlyphButton, ...

Gui, Main:Font, S10 Q4, Verdana
Gui, Main:Add, Edit, x160 y10 w480 h20 vGlyphPathDisplay
Gui, Main:Add, Button, x10 y40 w200 h40 gLaunchGlyph, Launch Glyph Client
Gui, Main:Add, Button, x10 y90 w200 h40 gSaveLogin, Save Current Login
Gui, Main:Add, Button, x10 y140 w200 h40 gRemoveAcc, Remove Selected Account
Gui, Main:Add, ListBox, x220 y67 w280 h220 vAccountName hwndHAccountList
Gui, Main:Add, Button, x10 y270 w200 h40 gStartSelected, Start Selected Account
Gui, Main:Add, Button, x10 y320 w200 h40 gStartAll, Start All Accounts
Gui, Main:Add, Button, x510 y40 w200 h40 gInstruction, Instruction
Gui, Main:Add, Button, x510 y90 w200 h40 gSetting, Settings
Gui, Main:Add, Button, x510 y170 w200 h40 gFishingStart, Fishing Start (All Account)
Gui, Main:Add, Button, x510 y220 w200 h40 gFishingStop, Fishing Stop (All Account)
Gui, Main:Add, Button, x510 y270 w200 h40 gBootDeconsStart, Boot and Decons Start
Gui, Main:Add, Button, x510 y320 w200 h40 gBootDeconsStop, Boot and Decons Stop

Gui, Main:Add, GroupBox, x220 y287 w280 h70, Timer
Gui, Main:Add, Text, x230 y307 h20 vBDCountDown, Boot/Decons Start In:
Gui, Main:Add, Text, x230 y330 h20 vShutDown, Auto Shutdown In:
Gui, Main:Add, Text, x430 y307 h20 vBDCDTime, 00:00:00
Gui, Main:Add, Text, x430 y330 h20 vSDTime, 00:00:00

Gui, Main:Font, S12 Q4 Bold Underline, Verdana
Gui, Main:Add, Text, x285 y40 w150 h20 +Center, Account List

; Settings GUI.
Gui, Setting:Font, S10 Q4, Verdana
Gui, Setting:Add, Text, x10 y40 w180 h20 +Left, Address:
Gui, Setting:Add, Text, x10 y70 w180 h20 +Left, Empty Slot Color:
Gui, Setting:Add, Text, x10 y100 w180 h20 +Left, BootDecons Session Delay:
Gui, Setting:Add, Text, x10 y130 w180 h20 +Left, Fishing Session Delay:
Gui, Setting:Add, Text, x10 y162 w180 h20 +Left, Boot Drop Method:
Gui, Setting:Add, Text, x10 y232 w180 h20 +Left, Glyph Version:
Gui, Setting:Add, Text, x10 y262 w180 h20 +Left, Game Window Naming:
Gui, Setting:Add, Text, x10 y292 w180 h20 +Left, Start All Account Hotkey:
Gui, Setting:Add, Text, x10 y322 w180 h20 +Left, Fishing Start Hotkey:
Gui, Setting:Add, Text, x10 y352 w180 h20 +Left, Fishing Stop Hotkey:
Gui, Setting:Add, Text, x10 y382 w180 h20 +Left, BootDecons Start Hotkey:
Gui, Setting:Add, Text, x10 y412 w180 h20 +Left, BootDecons Stop Hotkey:


Gui, Setting:Add, Text, x210 y293 w40 h20 +Left, Ctrl +
Gui, Setting:Add, Text, x210 y323 w40 h20 +Left, Ctrl +
Gui, Setting:Add, Text, x210 y353 w40 h20 +Left, Ctrl +
Gui, Setting:Add, Text, x210 y383 w40 h20 +Left, Ctrl +
Gui, Setting:Add, Text, x210 y413 w40 h20 +Left, Ctrl +

hotkeylist := "Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12"

Gui, Setting:Add, Edit, x210 y40 w140 h20 +Center vAddress
Gui, Setting:Add, Edit, x210 y70 w75 h20 +Center vPixelColor
Gui, Setting:Add, Button, x290 y69 w60 h22 gUpdatePixel, Update
Gui, Setting:Add, Edit, x210 y100 w140 h20 +Center vBDTime
Gui, Setting:Add, Edit, x210 y130 w140 h20 +Center vFishingTime
Gui, Setting:Add, ComboBox, x210 y160 w140 vBootDropMethod hwndHBootDropMethod, Image Search|Manual
Gui, Setting:Add, ComboBox, x210 y230 w140 vGlyphVer hwndHGlyphVer, Steam|Standalone
Gui, Setting:Add, ComboBox, x210 y260 w140 vChangeWindowName hwndHChangeWindowName, Yes|No
Gui, Setting:Add, ComboBox, x250 y290 w100 vSAA_HK hwndHSAA_HK,, %hotkeylist%
Gui, Setting:Add, ComboBox, x250 y320 w100 vFStart_HK hwndHFStart_HK, %hotkeylist%
Gui, Setting:Add, ComboBox, x250 y350 w100 vFStop_HK hwndHFStop_HK, %hotkeylist%
Gui, Setting:Add, ComboBox, x250 y380 w100 vBDStart_HK hwndHBDStart_HK, %hotkeylist%
Gui, Setting:Add, ComboBox, x250 y410 w100 vBDStop_HK hwndHBDStop_HK, %hotkeylist%

Gui, Setting:Add, Picture, x360 y103 w14 h14 vSettingHelp1 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, Setting:Add, Picture, x360 y133 w14 h14 vSettingHelp2 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, Setting:Add, Picture, x360 y165 w14 h14 vSettingHelp3 gHelp, %A_ScriptDir%/data/img/launcher/help.png
Gui, Setting:Add, Picture, x360 y265 w14 h14 vSettingHelp4 gHelp, %A_ScriptDir%/data/img/launcher/help.png

Gui, Setting:Add, Button, x60 y460 w100 h30 gSaveButtonSetting, Save
Gui, Setting:Add, Button, x230 y460 w100 h30 gCancelButtonSetting, Cancel

Gui, Setting:Font, S12 Q4 Bold Underline, Verdana
Gui, Setting:Add, Text, x128 y10 w130 h20 +Center, Game Settings
Gui, Setting:Add, Text, x128 y200 w130 h20 +Center, Bot Settings
; ~End~ GUI Creation.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ GUI preparation.

; Get Glyph Path from config.
IniRead, LoadGlyphPath, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder

; Get Glyph standalone saved account info folder
EnvGet, LOCALAPPDATA, LOCALAPPDATA
StandaloneDataPath := LOCALAPPDATA "\Glyph\"

; Check if setting of Glyph set to exit glyph after launch or not.
IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, GlyphVer, Version
if (GetGlyphVer = "Steam")
{
	IniRead, AfterLaunch, %LoadGlyphPath%/GlyphClient.cfg, Glyph, AfterLaunch
	if (AfterLaunch != "Exit")
	{
		IniWrite, Exit, %LoadGlyphPath%/GlyphClient.cfg, Glyph, AfterLaunch
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

; Display Glyph folder path and Accounts' info into Main GUI.
Gui, Main:Submit, nohide
GuiControl, Main:, GlyphPathDisplay, %LoadGlyphPath%

GuiControl, Main:, AccountName, |
Global FolderList := 
	loop, %A_ScriptDir%\data\savedlogins\*, 2 
FolderList .= A_LoopFileName . "|"
GuiControl, Main:, AccountName, %FolderList%

; Get all the hotkey from config.
IniRead, SAAHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, StartAllAccount
IniRead, FStartHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStart
IniRead, FStopHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStop
IniRead, BDStartHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStart
IniRead, BDStopHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStop

; Set hotkey to appropriate function.
HotKey, ^%SAAHK%, SAA, On
HotKey, ^%FStartHK%, FStart, On
HotKey, ^%FStopHK%, FStop, On
HotKey, ^%BDStartHK%, BDStart, On
HotKey, ^%BDStopHK%, BDStop, On

; Get Width and Height of Client (used to resize later).
IniRead, ClientWidth, %A_ScriptDir%/data/configs/fishingconfig.ini, Client, Width
IniRead, ClientHeight, %A_ScriptDir%/data/configs/fishingconfig.ini, Client, Height

IniWrite, %BotVer%, %A_ScriptDir%/data/configs/launcherconfig.ini, LazyFishing, Version

SplashImage, Off

; Show Main GUI.
Gui, Main:Show, x150 y100 w720 h370, LazyFishing v%BotVer%
Return
; ~End~ GUI preparation.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Button Choose glyph folder path.
ChooseGlyphButton:
	Gui, Submit, nohide
	FileSelectFolder, GlyphFolder, , , Please select the Glyph folder:
	GuiControl, Main:, GlyphPathDisplay, %GlyphFolder%
	GuiControlGet, GlyphPathDisplay
	IniWrite, %GlyphPathDisplay%, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
Return
; ~End~ Button Choose glyph folder path.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Button Launch GlyphClient.exe.
LaunchGlyph:
	IniRead, LoadGlyphFolder, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
	
	Process, Exist, GlyphClient.exe
	if (ErrorLevel = 0)
	{
		Run, GlyphClient.exe, %LoadGlyphFolder%, UseErrorLevel
		if ErrorLevel = ERROR
		{
			MsgBox, 16, LAUNCH GLYPH, Please check the folder path again!
			Return
		}
		WinWait, Glyph
	}
	else 
	{
		WinActivate, Glyph
	}
Return
; ~End~ Button Launch GlyphClient.exe.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Button Save Current Login.
SaveLogin:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, GlyphVer, Version
	IniRead, LoadGlyphFolder, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
	
	if (GetGlyphVer = "Steam")
	{
		IfNotExist, %LoadGlyphFolder%\Cache\*.dat
		{
			MsgBox, 16, SAVE CURREN LOGIN, Please check the folder path again!
			Return
		}
		IniRead, GetLoginName, %LoadGlyphFolder%/GlyphClient.cfg, Glyph, Login
	}
	else
	{
		IniRead, GetLoginName, %StandaloneDataPath%/GlyphClient.cfg, Glyph, Login
	}
	
	IfExist, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	{
		MsgBox, 64, SAVE CURREN LOGIN, The account %GetLoginName% is already exist!
		Return
	}
	
	IfNotExist, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	{
		FileCreateDir, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	
	if (GetGlyphVer = "Steam")
	{
		FileCopy, %LoadGlyphFolder%\Cache\*.dat, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	else
	{
		FileCopy, %StandaloneDataPath%\Cache\*.dat, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	
	AccountListReload()
	
	MsgBox, 64, SAVE LOGIN ACCOUNT, Saved %GetLoginName% to the Accounts List!
Return
; ~End~ Button Save Current Login.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Button Remove Selected Account.
RemoveAcc:
	GuiControlGet, SelectedAccount,, %HAccountList%
	
	if (SelectedAccount = "")
	{
		MsgBox, 64, REMOVE SELECTED ACCOUNT, You haven't select an account you want to delete.
		Return
	}
	else
	{
		FileRemoveDir, %A_ScriptDir%/data/savedlogins/%SelectedAccount%, 1
		AccountListReload()
		MsgBox, 64, REMOVE SELECTED ACCOUNT, Removed %SelectedAccount% from the Accounts List!
	}
Return
; ~End~ Button Remove Selected Account.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Button Start Selected Account / Start All Account and related functions.



; Button Start Selected Account.
StartSelected:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, GlyphVer, Version
	IniRead, LoadGlyphFolder, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
	
	GuiControlGet, SelectedAccount,, %HAccountList%
	if (SelectedAccount = "")
	{
		MsgBox, 64, START SELECTED ACCOUNT, You need to select an account to start!
		Return
	}
	
	AutoLogin(LoadGlyphFolder, SelectedAccount, GetGlyphVer)

	MsgBox, 64, START SELECTED ACCOUNT, Successfully started %SelectedAccount% account!
Return

; Button Start All Account.
SAA:
StartAll:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, GlyphVer, Version
	IniRead, LoadGlyphFolder, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
	
	Loop, %A_ScriptDir%/data/savedlogins\*, 2
	{
		AutoLogin(LoadGlyphFolder, A_LoopFileName, GetGlyphVer)
	}

	MsgBox, 64, START ALL ACCOUNT, Successfully started all accounts!
Return

AutoLogin(GlyphFolder, LoginName, GlyphVer)
{
	Process, Exist, GlyphClient.exe
	if (ErrorLevel != 0)
	{
		Process, Close, GlyphClient.exe
		Process, WaitClose, GlyphClient.exe
	}
	
	if (GlyphVer = "Steam")
	{
		FileDelete, %GlyphFolder%/Cache\*.dat
		FileCopy, %A_ScriptDir%/data/savedlogins/%LoginName%\*.dat, %GlyphFolder%/Cache, 1
		IniWrite, %LoginName%, %GlyphFolder%/GlyphClient.cfg, Glyph, Login
	}
	else
	{
		FileDelete, %StandaloneDataPath%\Cache\*.dat
		FileCopy,  %A_ScriptDir%/data/savedlogins/%LoginName%\*.dat, %StandaloneDataPath%/Cache
		IniWrite, %LoginName%, %StandaloneDataPath%/GlyphClient.cfg, Glyph, Login
	}
	
	Process, Exist, GlyphClient.exe
	if (ErrorLevel = 0)
	{
		Run, GlyphClient.exe, %GlyphFolder%, UseErrorLevel
		if ErrorLevel = ERROR
		{
			MsgBox, 16, START SELECTED ACCOUNT, Please check the folder path again!
			Return
		}
		WinWait, Glyph
	}
		
	sleep, 5000
	ClickPlay()
	Sleep, 2000
	WindowsHandle(LoginName)
	sleep, 2000
}
 
AccountListReload()
{
	GuiControl, Main:, AccountName, |
	FolderList := 
		loop, %A_ScriptDir%\data\savedlogins\*, 2 
	FolderList .= A_LoopFileName . "|"
    GuiControl, Main:, AccountName, %FolderList%
	Return
}

; Click Play Function.
ClickPlay()
{
	; Click on Play
	Loop
	{
		WinActivate, Glyph
		Imagesearch, LoginX, LoginY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %A_ScriptDir%\data\img\glyph\playglyph.png
		if ErrorLevel = 0
		{
			MouseClick, Left, %LoginX%, %LoginY%
			;ControlClick, x%LoginX% y%LoginY%, Glyph
			Sleep, 200
			break
		}
	}
	Return
}

WindowsHandle(LoginName)
{
	WinActivate, Trove
	WinWaitActive, Trove
	
	WinGet, active_id, ID, Trove
	vHandle := active_id
	WinGet, vPID, PID, ahk_id %vHandle%
	vPID := vPID
	IfNotExist, %A_ScriptDir%/data/savedlogins/%LoginName%/%LoginName%.ini
	{
		IniWrite, %vPID%, %A_ScriptDir%/data/savedlogins/%LoginName%/%LoginName%.ini, PID, PID
		IniWrite, %vHandle%, %A_ScriptDir%/data/savedlogins/%LoginName%/%LoginName%.ini, Handle, Handle	 
	}
	IniWrite, %vPID%, %A_ScriptDir%/data/savedlogins/%LoginName%/%LoginName%.ini, PID, PID
	IniWrite, %vHandle%, %A_ScriptDir%/data/savedlogins/%LoginName%/%LoginName%.ini, Handle, Handle
	WinMove, ahk_pid %vPID%, , , , %ClientWidth%, %ClientHeight%
	Return
}
; ~End~ Button Start Selected Account / Start All Account and related functions.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Button Instruction.
Instruction:
	MsgBox, 64, INSTRUCTION, Coming Soon!, 3
Return
; ~End~ Button Instruction.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ All buttons and functions related to Settings GUI.

; Show Settings GUI.
Setting:
	Gui, Setting:Submit, nohide
	Gui, Setting:Show, x300 y220 h500 w385, SETTINGS
	OnMessage(0x200, "Help")
	
	IniRead, GetAddress, %A_ScriptDir%/data/configs/fishingconfig.ini, Memory, Address
	IniRead, GetBDTime, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Time Between Session, BootDeconsTime
	IniRead, GetFishingTime, %A_ScriptDir%/data/configs/fishingconfig.ini, Time Between Session, FishingSessionDelay
	IniRead, GetChangeName, %A_ScriptDir%/data/configs/launcherconfig.ini, Game Window, ChangeName
	IniRead, SAAHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, StartAllAccount
	IniRead, FStartHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStart
	IniRead, FStopHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStop
	IniRead, BDStartHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStart
	IniRead, BDStopHK, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStop
	IniRead, BDMethod, %A_ScriptDir%/data/configs/launcherconfig.ini, Boot Drop Method, BootDropMethod
	IniRead, GetPixelColor, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Empty Slot Pixel Color, Color
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/launcherconfig.ini, GlyphVer, Version
	
	GuiControl, Setting:, Address, %GetAddress%
	GuiControl, Setting:, PixelColor, %GetPixelColor%
	GuiControl, Setting:, BDTime, %GetBDTime%
	GuiControl, Setting:, FishingTime, %GetFishingTime%
	
	ControlSetText, , %GetChangeName%, ahk_id %HChangeWindowName%
	ControlSetText, , %GetGlyphVer%, ahk_id %HGlyphVer%
	GuiControl, Setting:Disable, ChangeWindowName
	ControlSetText, , %SAAHK%, ahk_id %HSAA_HK%
	ControlSetText, , %FStartHK%, ahk_id %HFStart_HK%
	ControlSetText, , %FStopHK%, ahk_id %HFStop_HK%
	ControlSetText, , %BDStartHK%, ahk_id %HBDStart_HK%
	ControlSetText, , %BDStopHK%, ahk_id %HBDStop_HK%
	ControlSetText, , %BDMethod%, ahk_id %HBootDropMethod%
Return

; Button Save Settings.
SaveButtonSetting:
	Gui, Setting:Submit, nohide
	
	GuiControlGet, Address
	GuiControlGet, PixelColor
	GuiControlGet, BDTime
	GuiControlGet, FishingTime
	GuiControlGet, BootDropMethod
	GuiControlGet, ChangeWindowName
	GuiControlGet, GlyphVer
	GuiControlGet, SAA_HK
	GuiControlGet, FStart_HK
	GuiControlGet, FStop_HK
	GuiControlGet, BDStart_HK
	GuiControlGet, BDStop_HK
	
	if (SAA_HK = FStart_HK or SAA_HK = FStop_HK or SAA_HK = BDStart_HK or SAA_HK = BDStop_HK or FStart_HK = FStop_HK or FStart_HK = BDStart_HK or FStart_HK = BDStop_HK or FStop_HK = BDStart_HK or FStop_HK = BDStop_HK or BDStart_HK = BDStop_HK or)
	{
		MsgBox, 64, SETTING, One or more of your Hotkey is duplicated please check again!
		return
	}
	else
	{
		IniWrite, %Address%, %A_ScriptDir%/data/configs/fishingconfig.ini, Memory, Address
		IniWrite, %PixelColor%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Empty Slot Pixel Color, Color
		IniWrite, %BDTime%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Time Between Session, BootDeconsTime
		IniWrite, %FishingTime%, %A_ScriptDir%/data/configs/fishingconfig.ini, Time Between Session, FishingSessionDelay
		IniWrite, %BootDropMethod%, %A_ScriptDir%/data/configs/launcherconfig.ini, Boot Drop Method, BootDropMethod
		IniWrite, %ChangeWindowName%, %A_ScriptDir%/data/configs/launcherconfig.ini, Game Window, ChangeName
		IniWrite, %GlyphVer%, %A_ScriptDir%/data/configs/launcherconfig.ini, GlyphVer, Version
		IniWrite, %SAA_HK%, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, StartAllAccount
		IniWrite, %FStart_HK%, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStart
		IniWrite, %FStop_HK%, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, FishingStop
		IniWrite, %BDStart_HK%, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStart
		IniWrite, %BDStop_HK%, %A_ScriptDir%/data/configs/launcherconfig.ini, HotKey, BootDeconsStop

		HotKey, ^%SAA_HK%, SAA, On
		HotKey, ^%FStart_HK%, FStart, On
		HotKey, ^%FStop_HK%, FStop, On
		HotKey, ^%BDStart_HK%, BDStart, On
		HotKey, ^%BDStop_HK%, BDStop, On
		
		Gui, Setting:Hide
		MsgBox, 64, SETTING, Settings are successfully saved!
	}
Return

; Button Update Pixel Color.
UpdatePixel:
	Gui, Setting:Submit, nohide
	
	WinActivate, Trove
	
	Loop
	{
		Imagesearch, UpdatePCX, UpdatePCY, ClientWidth-140, 0, ClientWidth, ClientHeight, *10 %A_ScriptDir%\data\img\inv\emptyslot.png
		if ErrorLevel = 0
		{
			WinActivate, Trove
			PixelGetColor, UpdateColor, UpdatePCX+2, UpdatePCY+5
			IniWrite, %UpdateColor%, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Empty Slot Pixel Color, Color
			break
		}
	}
	
	GuiControl, Setting:, PixelColor, %UpdateColor%
	
	Msgbox, 64, UPDATE EMPTY SLOT PIXEL, Empty slot pixel color is updated. New color is: %UpdateColor%.
Return

Help:
Return

; Showing ToolTip when hover "?" image.
Help() {

	ToolTip 
	
	CurrControl := A_GuiControl 
	Help := ""
	
	IfEqual, CurrControl, SettingHelp1
	{
		Help := "BootDecons Session Delay is the delay time between each`nauto drop boot and auto decons trophy fish session. Time is`nin ms, 1s = 1000ms. Default: 10 minutes."
	}
	else IfEqual, CurrControl, SettingHelp2
	{
		Help := "Fishing Session Delay is the delay time between each fishing`nsession. Time is in ms, 1s = 1000ms. Default: 2 seconds."
	}
	else IfEqual, CurrControl, SettingHelp3
	{
		Help := "If image search method doesn't work for you then choose`nmanual method. Default: Image Search"
	}
	else IfEqual, CurrControl, SettingHelp4
	{
		Help := "Game Window Naming is changing the game window`nname from Trove to something else. If checked the bot`nwill change the game window name to the account name`nyou set. Default: No."
	}

	ToolTip % Help
	
	Return
}

; Close Settings GUI.
SettingGuiClose:
CancelButtonSetting:
	Gui, Setting:Hide
Return
; ~End~ All buttons and functions related to Settings GUI.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Fishing Bot.

;Start Fishing
FStart:
FishingStart:
	IniWrite, 0, %A_ScriptDir%/data/configs/fishingconfig.ini, Break, Break

	Loop, %A_ScriptDir%/data/savedlogins\*, 2
	{
		Run, %A_AhkPath% "%A_ScriptDir%\FishingClient.ahk" %A_LoopFileName%
	}
	
	MsgBox, 64, FISHING START, Successfully started fishing bot on all accounts.
Return

;Stop Fishing
FStop:
FishingStop:
	IniWrite, 1, %A_ScriptDir%/data/configs/fishingconfig.ini, Break, Break
	
	MsgBox, 64, FISHING STOP, Successfully stopped fishing bot on all accounts.
Return
; ~End~ Fishing Bot.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Auto Throw Boot (ATB)/ Auto Decons (AD) Bot.
BDStart:
BootDeconsStart:
	BDActive := 1
	MsgBox, 64, BOOT AND DECONS START, Successfully started auto throw boot and auto decons trophy`nfish for all accounts., 2
	BDActiveLoop1:
	Loop
	{
		if (BDActive = 0)
		{
			Break BDActiveLoop1
		}
		else
		{
			BDActiveLoop2:
			Loop, %A_ScriptDir%/data/savedlogins\*, 2
			{
				if (BDActive = 0)
				{
					Break BDActiveLoop1
				}
				else
				{
					IniRead, PID, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/%A_LoopFileName%.ini, PID, PID
					BootDrop(PID)
					RandomSleep(2000, 3000)
					Decons(PID)
					RandomSleep(2000, 3000)
				}
			}
		}
		
		IniRead, GetBDTime, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Time Between Session, BootDeconsTime
		SetTimer, UpdateOSD, 200
		Period := milli2hms(GetBDTime, h, m, s) ; Specified a known static Period (15 seconds for testing purposes)
		StringMid ,Periodh, Period,1, 2
		StringMid ,Periodm, Period,3, 2
		StringMid ,Periods, Period,5, 2
		Periodsec := (Periodh*3600) + (Periodm*60) + Periods
		StartTime = %A_Now%
		EndTime = %A_Now%
		EnvAdd EndTime, Periodsec, seconds
		EnvSub StartTime, EndTime, seconds
		StartTime := Abs(StartTime)
		perc := 0 ; Resets percentage to 0, otherwise this loop never sees the counter reset
		Loop
		{
			if perc = 100
			{
				break ; Terminate the loop
			} 
			else
			{
				continue ; Skip the below and start a new iteration
			}
		}
	}
Return

UpdateOSD:
	; msgbox % BDActive
	if (BDActive = 0)
	{
		perc = 100
		SetTimer, UpdateOSD, Off
		GuiControl, Main:, BDCDTime, 00:00:00
	}
	else 
	{
		mysec := EndTime
		EnvSub, mysec, %A_Now%, seconds
		GuiControl, Main:, BDCDTime, % FormatSeconds(mysec)
		perc := ((StartTime-mysec)/StartTime)*100
		perc := Floor(perc)
		If (perc = 100)
		{
			SetTimer, UpdateOSD, Off
		}
	}
	
Return

BDStop:
BootDeconsStop:
	BDActive := 0

	MsgBox, 64, BOOT AND DECONS START, Successfully stopped auto throw boot and auto decons trophy`nfish for all accounts., 2
	;Reload
Return

Decons(PID)
{
	IniRead, GetDWX, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, DeconsWindowX
	IniRead, GetDWY, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, DeconsWindowY
	
	IniRead, GetPColor, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Empty Slot Pixel Color, Color
	
	DeconsLoop1:
	Loop, 20
	{	
		if (BDActive = 0)
		{
			Break DeconsLoop1
		}
		WinActivate, ahk_pid %PID%
		
		IniRead, GetSlotX, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_X
		IniRead, GetSlotY, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_Y
		
		PixelGetColor, ColorDecons, GetSlotX, GetSlotY
		if (ColorDecons != GetPColor)
		{
			MouseClickDrag, Left, GetSlotX, GetSlotY, GetDWX, GetDWY, 4
			RandomSleep(500, 1000)
			MouseClick, Left, GetDWX, GetDWY
			RandomSleep(500, 1000)
			Imagesearch, ConfirmDeX, ConfirmDeY, ClientWidth-300, 160, ClientWidth-180, 220, *50 %A_ScriptDir%\data\img\confirm\confirmdecons.png
			if ErrorLevel = 0
			{
				WinActivate, ahk_pid %PID%
				MouseClick, Left, %ConfirmDeX%, %ConfirmDeY%
				RandomSleep(350, 500)
			}
		}
		else
		{
			RandomSleep(250, 500)
		}
	}
	
	IniRead, BtnAcceptX, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnAcceptX
	IniRead, BtnAcceptY, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnAcceptY
	IniRead, BtnYesX, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnYesX
	IniRead, BtnYesY, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, DeconsCoord, BtnYesY
		
	WinActivate, ahk_pid %PID%
	;Decons Accept
	Sleep, 1000
	MouseClick, left, BtnAcceptX, BtnAcceptY
		
	;Decons Yes
	Sleep, 1500
	MouseClick, left, BtnYesX, BtnYesY
	
	return
}

BootDrop(PID)
{	
	IniRead, GetBDMethod, %A_ScriptDir%/data/configs/launcherconfig.ini, Boot Drop Method, BootDropMethod
	
	WinActivate, ahk_pid %PID%
	
	if (GetBDMethod = "Image Search")
	{
		HumanPressButton("b", PID)
		RandomSleep(1000, 1500)
		HumanPressButton("b", PID)
		RandomSleep(1000, 1500)
		
		BootDropLoop1:
		Loop
		{
			if (BDActive = 0)
			{
				Break BootDropLoop1
			}
			N = 0
			BootDropLoop2:
			Loop, 4
			{
				if (BDActive = 0)
				{
					Break BootDropLoop2
				}
				WinActivate, ahk_pid %PID%
				Imagesearch, FoundBootX, FoundBootY, ClientWidth-140, 150, ClientWidth, ClientHeight, *50 %A_ScriptDir%\data\img\boot\%a_index%.png
				if ErrorLevel = 0
				{
					N++
					WinActivate, ahk_pid %PID%
					MouseClickDrag, Left, %FoundBootX%, %FoundBootY%, FoundBootX-160, FoundBootY-60, 4
					Sleep, 200
					break
				}
			}
			if N = 0
			{
				break
			}
		}
	}
	else
	{
		BootDropLoop3:
		Loop, 20
		{	
			if (BDActive = 0)
			{
				Break BootDropLoop3
			}
			WinActivate, ahk_pid %PID%
			IniRead, GetSlotX, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_X
			IniRead, GetSlotY, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, SlotsCoord, Slot_%a_index%_Y
			IniRead, GetPColor, %A_ScriptDir%/data/configs/bootdeconsconfig.ini, Empty Slot Pixel Color, Color
			
			PixelGetColor, Color, GetSlotX, GetSlotY
			if (Color != GetPColor)
			{
				MouseClickDrag, Left, GetSlotX, GetSlotY, GetSlotX-160, GetSlotY-60, 4
				RandomSleep(520, 750)
				Imagesearch, ConfirmDrX, ConfirmDrY, ClientWidth-340, 160, ClientWidth-140, 220, *50 %A_ScriptDir%\data\img\confirm\confirmdrop.png
				if ErrorLevel = 0
				{
					WinActivate, ahk_pid %PID%
					MouseClick, Left, %ConfirmDrX%, %ConfirmDrY%
					Sleep, 200
				}
				RandomSleep(520, 750)
			}
		}
	}
	return
}
; ~End~ Auto Throw Boot (ATB)/ Auto Decons (AD) Bot.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ Ultilities Functions.
FormatSeconds(NumberOfSeconds)  ; Convert the specified number of seconds to hh:mm:ss format.
{
    time = 19990101  ; *Midnight* of an arbitrary date.
    time += %NumberOfSeconds%, seconds
    FormatTime, mmss, %time%, mm:ss
    hours := NumberOfSeconds // 3600 ; This method is used to support more than 24 hours worth of sections.
    hours := hours < 10 ? "0" . hours : hours
    return hours ":" mmss
}

HumanPressButton(hpbtn, hppid)
{
    ControlSend, , {%hpbtn% down}, ahk_pid %hppid%
    HumanSleep()
    ControlSend, , {%hpbtn% up}, ahk_pid %hppid%
	HumanSleep()
}

HumanSleep() {
	Random, SleepTime, 66, 122
	Sleep, %SleepTime%
}

RandomSleep(time1, time2)
{
	Random, SleepTime, %time1%, %time2%
    Sleep, %SleepTime%
}

$TIME()
{
	Static @S
	Static @M
	Static @H
	Static @T
	Static @@T

	IF @S =
	{
		@S = 0
		@M = 0
		@H = 0
	}
	
	@T := A_Now
	IF @T != %@@T%
	{
		@S++
		IF @S = 60
		{
			@S = 0
			@M++
			IF @M = 60
			{
				@M = 0
				@H++
			}
		}
	}
	@@T := @T
	@ = SMH
	Loop,Parse,@
	{
		StringLen,@,% @%A_LoopField%
		IF @ = 1
		{
			@ := @%A_LoopField%
			@%A_LoopField% = 0%@%
		}
	}
	
	@ = %@H%:%@M%:%@S%
	
	Return @
}

milli2hms(milli, ByRef hours=0, ByRef mins=0, ByRef secs=0, secPercision=0)
{
	SetFormat, FLOAT, 0.%secPercision%
	milli /= 1000.0
	@s := mod(milli, 60)
	SetFormat, FLOAT, 0.0
	milli //= 60
	@m := mod(milli, 60)
	@h := milli //60
	@ = smh
	Loop,Parse,@
	{
		StringLen,@,% @%A_LoopField%
		IF @ = 1
		{
			@ := @%A_LoopField%
			@%A_LoopField% = 0%@%
		}
	}
	@ = %@h%%@m%%@s%
	return  @ 
}
; ~End~ Ultilities Functions.
; -------------------------------------------------------------------------


; Close Main GUI.
MainGuiClose:
	GuiControlGet, GlyphPathDisplay
	IniWrite, %GlyphPathDisplay%, %A_ScriptDir%/data/configs/launcherconfig.ini, Glyph Folder, Glyph_Folder
	ExitApp
Return