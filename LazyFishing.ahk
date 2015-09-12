#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Relative
EnvGet, LOCALAPPDATA, LOCALAPPDATA

; Check if the script is run as Admin or not
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
Global BotVer := "1.6.1"
Global BDActive
Global DefaultGlyphPath := "C:\Program Files (x86)\Steam\SteamApps\common\Trove"
Global ClientWidth
Global ClientHeight
Global StandaloneDataPath := LOCALAPPDATA . "\Glyph\"
Global LoadAddress
Global BotList := Object() ;The array where the clients are added.
Global CoordSlot := Object() ; Array for coordinate slot
Global CheckSetTimer := 0
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

IfNotExist, %A_ScriptDir%/data/log
{
	FileCreateDir, %A_ScriptDir%/data/log
}

IfNotExist, %A_ScriptDir%/data/configs/loginsystem.ini
{
	;Default Settings for Login System.
	IniWrite, %DefaultGlyphPath%, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
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
	IniWrite, 158, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseY ; Relative 158, Client 127
	IniWrite, 80, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptX
	IniWrite, 310, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptY
	IniWrite, 210, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesX
	IniWrite, 200, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesY
}
; ~End~ Creates config files at first launch.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ GUI Creation.

; Main GUI.
Gui, Main:Default
Gui, Main:Add, Picture, x5 y15 w550 h95 , %A_ScriptDir%/data/img/launcher/banner.png
Gui, Main:Font, S10 Q4, Verdana
Gui, Main:Add, Tab2, x5 y110 w540 h460 -Wrap -Background, Log Screen||Login Bot|Fishing Bot|Boot/Decons Bot
Gui, Main:Add, Tab2, x5 y570 w540 h70 -Wrap -Background

; Log Screen Tab
Gui, Main:Tab, 1, 1
Gui, Main:Add, Edit, x15 y140 w520 h420 vConsole

; Login Bot Tab
Gui, Main:Tab, 2, 1
Gui, Main:Add, ListView, x15 y140 w320 h420 NoSortHdr Grid -Multi AltSubmit vAccountList gAccountList, Login Account|Fishing Mode
Gui, Main:Add, Button, x345 y140 w190 h40 gSaveLogin, Save Current Login
Gui, Main:Add, Button, x345 y190 w190 h40 gRemoveAcc, Remove Selected Account
Gui, Main:Add, Button, x345 y280 w190 h40 gLaunchGlyph, Launch Glyph
Gui, Main:Add, Button, x345 y330 w190 h40 gLaunchSelected, Launch Selected Account
Gui, Main:Add, Button, x345 y380 w190 h40 gLaunchAll, Launch All Account
Gui, Main:Add, Button, x345 y520 w190 h40 gLoginSetting, Config Glyph Path/Version

; Fishing Bot Tab
Gui, Main:Tab, 3, 1
Gui, Main:Add, ListView, x15 y140 w520 h300 NoSortHdr Grid vFishingList, Account Name|Reel In|Fish In|Fishing Status

Gui, Main:Add, GroupBox, x335 y450 w200 h100 , Setting
Gui, Main:Add, Text, x345 y480 w60 h20 +Left, Address:
Gui, Main:Add, Edit, x415 y480 w110 h20 +Center vAddress
Gui, Main:Add, Button, x405 y515 w60 h20 gFishingSettingSave, Save

Gui, Main:Add, Button, x15 y457 w120 h40 gFishingStartAll, Start All
Gui, Main:Add, Button, x15 y507 w120 h40 gFishingStopAll, Stop All
Gui, Main:Add, Button, x145 y457 w180 h40 gFishingStartSelected, Start Selected Account
Gui, Main:Add, Button, x145 y507 w180 h40 gFishingStopSelected, Stop Selected Account

; Boot/Decons Bot Tab
Gui, Tab, 4, 1
Gui, Main:Add, ListView, x15 y140 w520 h260 NoSortHdr Grid AltSubmit vBDList gBDList, Account Name|Boot Drop Mode|Decons Mode

hotkeylist := "Ctrl + Numpad0|Ctrl + Numpad1|Ctrl + Numpad2|Ctrl + Numpad3|Ctrl + Numpad4|Ctrl + Numpad5|Ctrl + Numpad6|Ctrl + Numpad7|Ctrl + Numpad8|Ctrl + Numpad9|Ctrl + F1|Ctrl + F2|Ctrl + F3|Ctrl + F4|Ctrl + F5|Ctrl + F6|Ctrl + F7|Ctrl + F8|Ctrl + F9|Ctrl + F10|Ctrl + F11|Ctrl + F12"

Gui, Main:Add, GroupBox, x285 y410 w250 h150 , Setting
Gui, Main:Add, Text, x300 y435 w100 h20 +Left, Session Delay:
Gui, Main:Add, Edit, x410 y435 w110 h20 +Center vBDDelay
Gui, Main:Add, Text, x300 y467 w100 h20 +Left, Drop Method:
Gui, Main:Add, ComboBox, x410 y465 w110 vBootDropMethod hwndHBootDropMethod, Image Search|Manual
Gui, Main:Add, Text, x300 y502 w100 h20 +Left, Stop Hotkey:
Gui, Main:Add, ComboBox, x410 y500 w110 vHK_BDStop hwndHHK_BDStop, %hotkeylist%
Gui, Main:Add, Button, x385 y533 w60 h20 gBDSettingSave, Save

Gui, Main:Add, Button, x15 y417 w120 h40 gBDStart, Start
Gui, Main:Add, Button, x145 y417 w120 h40 gBDStop, Stop

Gui, Main:Add, GroupBox, x15 y470 w250 h90, Next Session Start In
Gui, Main:Font, S35 Q4, Verdana
Gui, Main:Add, Text, x30 y490 h20 vBDCDTime, 00:00:00

Gui, Main:Font, S10 Q4, Verdana
Gui, Main:Add, StatusBar
SB_SetParts(20, 450, 80)
SB_SetIcon(A_ScriptDir . "/data/img/main.ico", 1, 1) 
SB_SetText("By: TaeJim", 3)

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

; ~End~ GUI Creation.
; -------------------------------------------------------------------------


; -------------------------------------------------------------------------
; ~Start~ GUI preparation.

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

LoadingCoordOut()

AccountListReload()
Gui, Main:ListView, AccountList
LV_ModifyCol(1, 215)
LV_ModifyCol(1, "Center")
LV_ModifyCol(2, "AutoHdr")
LV_ModifyCol(2, "Center")

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

IniRead, ClientWidth, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Width
IniRead, ClientHeight, %A_ScriptDir%/data/configs/loginsystem.ini, ClientSize, Height

SplashImage, Off
; ~End~ GUI preparation.
; -------------------------------------------------------------------------

; Show Main GUI.
Gui, Main:Show, x0 y0 h670 w550, LazyFishing v%BotVer%

FormatTime, TimeStamp, A_Now, dd.MM.yyyy-HH:mm:ss
StringReplace, LogTimeStamp, TimeStamp, :, ., 1
LogPath := % A_ScriptDir . "\data\log\" . LogTimeStamp . ".txt"
log("Started LazyFishing Bot v" . BotVer, TimeStamp, LogPath)
Return






; -------------------------------------------------------------------------
; ~Start~ Buttons don't belong to any tabs.

; Button Clean Log Folder.
CleanLogFolder:
	log("Cleaning log folder.", TimeStamp, LogPath)
	Loop, %A_ScriptDir%\data\log\*
	{
		CurrentLogFileName := LogTimeStamp . ".txt"
		if (A_LoopFileName = CurrentLogFileName)
		{
			Continue
		}
		else
		{
			FileDelete, %A_ScriptDir%\data\log\%A_LoopFileName%
		}
	}
	log("Log folder is cleaned.", TimeStamp, LogPath)
Return

; Button Donate.
Donate:
	Run, https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HKA9MDHXMQ7HS , , Max
Return
; ~End~ Buttons don't belong to any tabs.
; -------------------------------------------------------------------------






; -------------------------------------------------------------------------
; ~Start~ Login System.

; Button Save Current Login.
SaveLogin:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
	; SB_SetText("Saving current login account...", 2)
	log("Saving current login account...", TimeStamp, LogPath)
	
	if (GetGlyphVer = "Steam")
	{
		IfNotExist, %GetGlyphPath%\Cache\*.dat
		{
			; SB_SetText("Error: fail to save current login (See log for more details).", 2)
			log("Fail to save current login account: please login to save the account.", TimeStamp, LogPath)
			; SB_SetText("", 2)
			;MsgBox, 16, SAVE CURREN LOGIN, Please check the folder path again!
			Return
		}
		IniRead, GetLoginName, %GetGlyphPath%/GlyphClient.cfg, Glyph, Login
	}
	else
	{
		IniRead, GetLoginName, %StandaloneDataPath%/GlyphClient.cfg, Glyph, Login
	}
	
	IfExist, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	{
		; SB_SetText("Error: The account " . GetLoginName . " is already existed.", 2)
		log("Fail to save current login account: the account " . GetLoginName . " is already existed.", TimeStamp, LogPath)
		; SB_SetText("", 2)
		;MsgBox, 64, SAVE CURREN LOGIN, The account %GetLoginName% is already exist!
		Return
	}
	
	IfNotExist, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	{
		log("Creating " . GetLoginName . " folder to save the account info.", TimeStamp, LogPath)
		FileCreateDir, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	
	if (GetGlyphVer = "Steam")
	{
		log("Copying .dat file of " . GetLoginName . " to it's folder.", TimeStamp, LogPath)
		FileCopy, %GetGlyphPath%\Cache\*.dat, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	else
	{
		log("Copying .dat file of " . GetLoginName . " to it's folder.", TimeStamp, LogPath)
		FileCopy, %StandaloneDataPath%\Cache\*.dat, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	
	FishingMode(GetLoginName)
	AccountListReload()
	FishingListReload()
	BDMode(GetLoginName)
	BDListReload()
	
	; SB_SetText("Saved " . GetLoginName . " to the Accounts List.", 2)
	log("Saved " . GetLoginName . " to the Accounts List.", TimeStamp, LogPath)
	; SB_SetText("", 2)
	;MsgBox, 64, SAVE LOGIN ACCOUNT, Saved %GetLoginName% to the Accounts List!
Return

; Button Remove Selected Account.
RemoveAcc:
	Gui, Main:ListView, AccountList
	; Gui, Main:Submit, Nohide
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		; SB_SetText("Error: Fail to remove selceted account (See log for details).", 2)
		log("Fail to removed the selected account: you haven't select an account to remove yet.", TimeStamp, LogPath)
		; SB_SetText("", 2)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	MsgBox, 36, REMOVE SELECTED ACCOUNT, Are you sure you want to delete %LoginName% from the account list?
	ifMsgBox Yes
	{
		FileRemoveDir, %A_ScriptDir%/data/savedlogins/%LoginName%, 1
		AccountListReload()
		BDListReload()
		FishingListReload()
		LV_Delete(FocusedRowNumber)  ; Clear the row from the ListView.
		; SB_SetText("Removed " . LoginName . " from the Accounts List.", 2)
		log("Removed " . LoginName . " from the Accounts List.", TimeStamp, LogPath)
		; SB_SetText("", 2)
	}
	else
	{
		Return
	}
	;MsgBox, 64, REMOVE SELECTED ACCOUNT, Removed %LoginName% from the Accounts List!
Return

; Button Launch Glyph Client.
LaunchGlyph:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
	; SB_SetText("Launching Glyph Client...", 2)
	log("Launching Glyph Client...", TimeStamp, LogPath)
	
	if (GetGlyphVer = "Steam")
	{
		IfNotExist, %GetGlyphPath%/Cache
		{
			; SB_SetText("Error: Fail to launch Glyph Client (See log for details).", 2)
			log("Fail to launch Glyph Client: please check the folder path again, this path is for Standalone version.", TimeStamp, LogPath)
			; SB_SetText("", 2)
			;MsgBox, 16, LAUNCH GLYPH CLIENT, Please check the folder path again. This path is for Standalone version!
			Return
		}
		LaunchGlyph(GetGlyphPath)
	}
	else
	{
		IfExist, %GetGlyphPath%/Cache
		{
			; SB_SetText("Error: Fail to launch Glyph Client (See log for details).", 2)
			log("Fail to launch Glyph Client: please check the folder path again, this path is for Steam version.", TimeStamp, LogPath)
			; SB_SetText("", 2)
			;MsgBox, 16, LAUNCH GLYPH CLIENT, Please check the folder path again. This path is for Steam version!
			Return
		}
		LaunchGlyph(GetGlyphPath)
	}
	; SB_SetText("Glyph Client has lauched.", 2)
	log("Glyph Client has launched.", TimeStamp, LogPath)
	; SB_SetText("", 2)
Return

; Button Launch Selected Account.
LaunchSelected:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
	Gui, Main:ListView, AccountList
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		; SB_SetText("Error: Fail to launch selected account (See log for details).", 2)
		log("Fail to launch the selected account: you haven't select an account to launch yet.", TimeStamp, LogPath)
		; SB_SetText("", 2)
		;MsgBox, 64, REMOVE SELECTED ACCOUNT, You haven't select an account you want to delete.
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	; SB_SetText("Launching " . LoginName . " ...", 2)
	log("Launching " . LoginName . " ...", TimeStamp, LogPath)
	AutoLogin(GetGlyphPath, LoginName, GetGlyphVer)
	; SB_SetText("Successfully launched " . LoginName, 2)
	log("Successfully launched " . LoginName, TimeStamp, LogPath)
	; SB_SetText("", 2)
	;MsgBox, 64, START SELECTED ACCOUNT, Successfully started %LoginName% account!
Return

; Button Launch All Account.
LaunchAll:
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
	; SB_SetText("Launching all the accounts...", 2)
	log("Launching all the accounts...", TimeStamp, LogPath)
	
	Loop, %A_ScriptDir%/data/savedlogins\*, 2
	{
		log("Launching account number " . A_Index . ": " . A_LoopFileName, TimeStamp, LogPath)
		AutoLogin(GetGlyphPath, A_LoopFileName, GetGlyphVer)
		log("Account number " . A_Index . ": " . A_LoopFileName . " has lauched", TimeStamp, LogPath)
	}

		; SB_SetText("Error: Fail to launch all accounts (See log for details).")
		; log("Fail to launch all accounts: you don't have any saved account.", TimeStamp, LogPath)
		; Return

	; SB_SetText("Successfully launched all accounts.", 2)
	log("Successfully launched all accounts.", TimeStamp, LogPath)
	; SB_SetText("", 2)
	;MsgBox, 64, START ALL ACCOUNT, Successfully started all accounts!
Return

; Button Config Glyph Path/Version
LoginSetting:
	Gui, LoginSetting:Submit, nohide
	Gui, LoginSetting:Show, x127 y87 h140 w480, Config Glyph Path/Version
	
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
	ControlSetText, , %GetGlyphVer%, ahk_id %HGlyphVer%
	GuiControl, LoginSetting:, GlyphPathDisplay, %GetGlyphPath%
Return

LoginSettingBrowsePath:
	Gui LoginSetting:+OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
	Gui, LoginSetting:Submit, nohide
	FileSelectFolder, GlyphFolder, , , Please select the Glyph folder:
	if not GlyphFolder  ; The user canceled the dialog.
	{
		Return
	}
	GuiControl, LoginSetting:, GlyphPathDisplay, %GlyphFolder%
	GuiControlGet, GlyphPathDisplay
	IniWrite, %GlyphPathDisplay%, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
Return

LoginSettingSave:
	GuiControlGet, GlyphVer
	GuiControlGet, GlyphPathDisplay
	
	IniWrite, %GlyphVer%, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniWrite, %GlyphPathDisplay%, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
	Gui, LoginSetting:Hide
	MsgBox, 64, LOGIN BOT SETTINGS, Settings are successfully saved.
Return

LoginSettingGuiClose:
LoginSettingCancel:
	Gui, LoginSetting:Hide
Return

AccountList:
	Gui, Main:ListView, AccountList
	if A_GuiEvent = DoubleClick
	{
		FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
		if not FocusedRowNumber  ; No row is focused.
		{
			Return
		}
		LV_GetText(LoginName, FocusedRowNumber, 1)
		LV_GetText(FishingTF, FocusedRowNumber, 2)  ; Get the text from the row's first field.
		if (FishingTF = "On")
		{
			NewFMode := "Off"
			IniWrite, %NewFMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
			ModifyListView("AccountList", LoginName, 2, NewFMode)
			FishingListReload()
			log("Fishing is turned off for " . LoginName, TimeStamp, LogPath)
		}
		else
		{
			NewFMode := "On"
			IniWrite, %NewFMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
			ModifyListView("AccountList", LoginName, 2, NewFMode)
			FishingListReload()
			log("Fishing is turned on for " . LoginName, TimeStamp, LogPath)
		}
	}
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
	
	LaunchGlyph(GlyphFolder)
		
	sleep, 6000
	ClickPlay()
	Sleep, 5000
	SetWinTitleAtLaunch(LoginName)
	sleep, 2000
}
 
LaunchGlyph(GlyphPath)
{
	Process, Exist, GlyphClient.exe
	if (ErrorLevel = 0)
	{
		Run, GlyphClient.exe, %GlyphPath%, UseErrorLevel
		if ErrorLevel = ERROR
		{
			MsgBox, 16, LAUNCH GLYPH, Please check the folder path again!
			Return
		}
		WinWait, Glyph
	}
}
 
AccountListReload()
{
	Gui, Main:Default
	Gui, Main:ListView, AccountList
	LV_Delete()
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IniRead, FishingMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		LV_Add("", A_LoopFileName, FishingMode)
	}
	Return
}

; Click Play Function.
ClickPlay()
{
	Global TimeStamp
	Global LogPath
	log("Waiting to click Play button...", TimeStamp, LogPath)
	; Click on Play
	Loop
	{
		WinActivate, Glyph
		MouseClick, Left, 470, 530
		ifWinExist, Trove
		{
			Break
		}
	}
	log("Done. Play button has clicked, the game has launch.", TimeStamp, LogPath)
	Return
}

SetWinTitleAtLaunch(LoginName)
{
	Global TimeStamp
	Global LogPath
	log("Renaming Trove window to the account name: " . LoginName . " ...", TimeStamp, LogPath)
	Global ClientWidth
	Global ClientHeight
	
	WinWait, Trove
	WinSetTitle, Trove, , %LoginName% 
	WinMove, %LoginName%, , , , %ClientWidth%, %ClientHeight%
	log("Finish rename Trove window to: " . LoginName, TimeStamp, LogPath)
}
; ~End~ Login System.
; -------------------------------------------------------------------------






; -------------------------------------------------------------------------
; ~Start~ Fishing System.

FishingStartAll:
	log("Starting fishing on all accounts...", TimeStamp, LogPath)
	if (CheckSetTimer = 0)
	{
		SetTimer, FishBiteMemoryScan, 1000
		SetTimer, Recast, 2000
		CheckSetTimer := 1
	}
	TotalClients =
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IfWinNotExist, %A_LoopFileName%
		{
			Continue
		}
		IniRead, GetFMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		if (GetFMode = "On")
		{
			WinGet, PID, PID, %A_LoopFileName%
			WinGet, Handle, ID, %A_LoopFileName%
			If (pID = "" or Handle = "")
			{
				Return
			}
			
			HumanPressButton("f", PID)
			Sleep 400
			
			Base := getProcessBaseAddress(Handle)
			WaterAddress := GetAddressWater(PID, Base, LoadAddress)
			Sleep 100
			LavaAddress := GetAddressLava(PID, Base, LoadAddress)
			ChocoAddress := GetAddressChoco(PID, Base, LoadAddress)
			Sleep 100
			GetFishingStateWaterAddress := GetFishingStateWaterAddress(PID, Base, LoadAddress)
			GetFishingStateLavaAddress := GetFishingStateLavaAddress(PID, Base, LoadAddress)
			Sleep 100
			GetFishingStateChocoAddress := GetFishingStateChocoAddress(PID, Base, LoadAddress)
			Sleep 200
			
			;Detecting Liquid type via memory read.
			DetectedLiquidType := 0 ;Default = for unknown type.

			If (ReadMemory(PID, GetFishingStateWaterAddress) = 1)
				DetectedLiquidType := 1
			Else If (ReadMemory(PID, GetFishingStateLavaAddress) = 1)
				DetectedLiquidType := 2
			Else If (ReadMemory(PID, GetFishingStateChocoAddress) = 1)
				DetectedLiquidType := 3
			;Adding bot to botlist array
			StartTime := a_now
			LastReelCast := a_now
			ActiveFishing := 1 ;Turns it on.
			Recast := 0
			ErrorCount := 0
			ReelinCount := 0
			RecastCount := 0
			
			BotList.Insert(Array(PID ,Handle, Base, WaterAddress, LavaAddress, ChocoAddress, StartTime, LastReelCast, GetFishingStateWaterAddress, GetFishingStateLavaAddress, GetFishingStateChocoAddress , DetectedLiquidType, ActiveFishing, Recast, ErrorCount, A_LoopFileName, ReelinCount, RecastCount))
			
			;This to change the detectedliqidtype from a number to the word for displaying
			If (DetectedLiquidType = 1) ;Water found scan only water type
			{
				LiquidType = Water
			}
			Else If (DetectedLiquidType = 2) ;Lava found scan only lava type
			{
				LiquidType = Lava
			}
			Else If (DetectedLiquidType = 3) ;Choco found only scan Choco type
			{
				LiquidType = Chocolate
			}	
			Else
			{
				LiquidType = Unknown
			}
			ModifyListView("FishingList", A_LoopFileName, 3, LiquidType)
			ModifyListView("FishingList", A_LoopFileName, 4, "Active")
			log("Started fishing for " . A_LoopFileName, TimeStamp, LogPath)
			TotalClients++
		}
	}
	log("Finish started fishing on all accounts. Total account started: " . TotalClients, TimeStamp, LogPath)
Return

FishBiteMemoryScan:
    for index, element in BotList
    {
		FishingAccountName := BotList[index, 16]
        ;Setting Current time of scan. Used to compair for bot error hang
        CurrentTime = %a_now%
        WinID :=
        ;Checking to make sure the next scan that the client is running. If not found it will auto remove form the list and move on to next.
        WinID := BotList[index, 2]
        IfWinNotExist, ahk_id %WinID%
		{
			log(FishingAccountName . " account no longer found. It will now get remove from fishing.", TimeStamp, LogPath)
			ModifyListView("FishingList", FishingAccountName, 2, "0")
			ModifyListView("FishingList", FishingAccountName, 3, "Unknown")
			ModifyListView("FishingList", FishingAccountName, 4, "Idle")
			BotList.Remove(index)
			Return
		}

        if (BotList[index, 13] = 0) ; Checking to make sure the fishing flag and the recast flag are both set to 1 being on.
        {
			ModifyListView("FishingList", FishingAccountName, 4, "Idle")
        }
        
		if (BotList[index, 13] = 1 && BotList[index, 14] = 0)
		{
			ModifyListView("FishingList", FishingAccountName, 4, "Active")
			; Checking last cast on record with current time.
			LastCastTime := BotList[index, 8]
			EnvSub, CurrentTime, LastCastTime, Seconds ; Converting last last cast time to Seconds.

			; Error handling to check to make sure it is still fishing.
			If (8 < CurrentTime && CurrentTime < 11 or 45 < CurrentTime)
			{
				FishingState := "0"
				;Checking all 3 fishing states.
				CaughtFishingStateWater := ReadMemory(BotList[index, 1], BotList[index, 9])
				CaughtFishingStateLava := ReadMemory(BotList[index, 1], BotList[index, 10])
				CaughtFishingStateChoco := ReadMemory(BotList[index, 1], BotList[index, 11])

				; If fishing state = 1 ignores the error logging. 15
				If (CaughtFishingStateWater = 1 or CaughtFishingStateLava = 1 or CaughtFishingStateChoco = 1)
				{
					FishingState := "1"
					BotList[index, 15] := "0" ;Since fishing is detected it will wipe out the Error Count.
				}

				If (FishingState = 0)
				{
					If (BotList[index, 14] <> 1) ;If recast is not 1 it trigers the Error Report.
					{ 
							SetTimer, Recast, Off
							BotList[index, 15] := BotList[index, 15] + 1 ; Adds 1 for each time it is found not fishing.
							BotList[index, 14] := 1 ;Turning on the recast flag.
							SetTimer, Recast, 2000
							If (BotList[index, 15] > 2)
							{
								log("the account: " . BotList[index, 16] . " seems to be not be fishing. Possible causes could be frozen client/character or full inventory.", TimeStamp, LogPath)
								Text := "the account: " . BotList[index, 16] . " seems to be not be fishing. Possible causes could be frozen client/character or full inventory. Click this window to remove client from list and bring the window to the foreground."
								TransSplashText_On("Error", Text, 600, "Arial", "Black", 0, 10, , , 7000)
							}
							;Fix this by adding a var yes or no to skip next parts do not use return Return
					}
				}
			}

			;Memory scan for current client to check for fish bite
			If (12 < CurrentTime) ;Wont start a memory scan till 12Seconds has passed. This is to Lower cpu usage.
			{
				If (BotList[index, 12] = 1) ;Water type found scan only water type
				{
					CaughtWater := ReadMemory(BotList[index, 1], BotList[index, 4])
					ModifyListView("FishingList", FishingAccountName, 3, "Water")
				}	
				Else If (BotList[index, 12] = 2)	;Lava type found scan only lava type
				{
					CaughtLava := ReadMemory(BotList[index, 1], BotList[index, 5])
					ModifyListView("FishingList", FishingAccountName, 3, "Lava")
				}	
				Else If (BotList[index, 12] = 3) ;Choco type found only scan Choco type
				{
					CaughtChoco := ReadMemory(BotList[index, 1], BotList[index, 6])
					ModifyListView("FishingList", FishingAccountName, 3, "Chocolate")
				}	
				Else 
				{
					;Unknown type so we can all 3. This will use more cpu.
					CaughtWater := ReadMemory(BotList[index, 1], BotList[index, 4])
					CaughtLava := ReadMemory(BotList[index, 1], BotList[index, 5])
					CaughtChoco := ReadMemory(BotList[index, 1], BotList[index, 6])
				}
			} 
			Else 
			{
				CaughtWater := 0
				CaughtLava := 0
				CaughtChoco := 0
			}

			;Preforming reelin
			If (CaughtWater = 1 or CaughtLava = 1 or CaughtChoco = 1)
			{
				;Checking to see if the bot is already recasting. And if so it will ignore below.
				If (BotList[index, 14] <> 1) 
				{
					SetTimer, Recast, Off
					HumanPressButton("f", BotList[index, 1])
					Sleep 200
					BotList[index, 14] := 1   ;Turning on the recast flag.
					BotList[index, 17] := BotList[index, 17] + 1 ;Padding the reeled in Counter.
					ReelIn := BotList[index, 17]
					ModifyListView("FishingList", FishingAccountName, 2, ReelIn)
					SetTimer, Recast, 2000
				}
			}
		}
    }
Return

Recast:
    TotalClientsOnList := BotList.MaxIndex()
    Loop, %TotalClientsOnList%
	{
		If (BotList[a_index, 14] = 1) ; Checking ot make sure the fishing flag and the recast flag are both set to 1 being on.
		{
			BotList[a_index, 18] := BotList[a_index, 18] + 1 ;Pading the recast Count by 1
			HumanPressButton("f", BotList[a_index, 1])
			BotList[a_index, 14] := "0"  ;Reseting the recast it recasted. Lure used?
			BotList[a_index, 8] := A_Now ;Setting the last cast time to current time.
		}
	}
Return

FishingStopAll:
	log("Stopping fishing on all accounts...", TimeStamp, LogPath)
	CheckSetTimer := 0
	SetTimer, FishBiteMemoryScan, Off
	SetTimer, Recast, Off
	
	Global BotList := Object()
	
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IniRead, GetFMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		if (GetFMode = "On")
		{
			ModifyListView("FishingList", A_LoopFileName, 2, "0")
			ModifyListView("FishingList", A_LoopFileName, 3, "Unknown")
			ModifyListView("FishingList", A_LoopFileName, 4, "Idle")
			log("Stopped fishing for: " . A_LoopFileName, TimeStamp, LogPath)
		}
	}
	log("Stopped all fishing accounts.", TimeStamp, LogPath)
Return

FishingStartSelected:
	if (CheckSetTimer = 0)
	{
		SetTimer, FishBiteMemoryScan, 1000
		SetTimer, Recast, 2000
		CheckSetTimer := 1
	}
	Gui, Main:ListView, FishingList
	; Gui, Main:Submit, Nohide
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		; SB_SetText("Error: Fail to remove selceted account (See log for details).", 2)
		log("Fail to start fishing on the selected account: you haven't select any account yet.", TimeStamp, LogPath)
		; SB_SetText("", 2)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	log("Starting fishing for: " . LoginName . " ...", TimeStamp, LogPath)
	; Getting the pID and Handle that is used for memory scans.
	WinGet, PID, PID, %LoginName%
    WinGet, Handle, ID, %LoginName%
	
	;First cast also to detect liquid type.
	HumanPressButton("f", PID)
	
	;Setting up addresses for Memory scan
    Base := getProcessBaseAddress(Handle)
    WaterAddress := GetAddressWater(PID, Base, LoadAddress)
    Sleep 200
    LavaAddress := GetAddressLava(PID, Base, LoadAddress)
    ChocoAddress := GetAddressChoco(PID, Base, LoadAddress)
    Sleep 200
    GetFishingStateWaterAddress := GetFishingStateWaterAddress(PID, Base, LoadAddress)
    GetFishingStateLavaAddress := GetFishingStateLavaAddress(PID, Base, LoadAddress)
    Sleep 200
    GetFishingStateChocoAddress := GetFishingStateChocoAddress(PID, Base, LoadAddress)
	
	;Detecting Liquid type via memory read.
    DetectedLiquidType := 0 ;Default = for unknown type.
    If (ReadMemory(PID, GetFishingStateWaterAddress) = 1)
        DetectedLiquidType := 1
    Else If (ReadMemory(PID, GetFishingStateLavaAddress) = 1)
		DetectedLiquidType := 2
    Else If (ReadMemory(PID, GetFishingStateChocoAddress) = 1)
		DetectedLiquidType := 3

	;Adding bot to botlist array
    StartTime := a_now
    LastReelCast := a_now
    ActiveFishing := 1 ;Turns it on.
    Recast := 0
    ErrorCount := 0
    ReelinCount := 0
    RecastCount := 0
	
	BotList.Insert(Array(PID ,Handle, Base, WaterAddress, LavaAddress, ChocoAddress, StartTime, LastReelCast, GetFishingStateWaterAddress, GetFishingStateLavaAddress, GetFishingStateChocoAddress , DetectedLiquidType, ActiveFishing, Recast, ErrorCount, LoginName, ReelinCount, RecastCount))

	;This to change the detectedliqidtype from a number to the word for displaying
	If (DetectedLiquidType = 1) ;Water found scan only water type
	{
		LiquidType = Water
	}
	Else If (DetectedLiquidType = 2) ;Lava found scan only lava type
	{
		LiquidType = Lava
	}
	Else If (DetectedLiquidType = 3) ;Choco found only scan Choco type
	{
		LiquidType = Chocolate
	}	
	Else
	{
		LiquidType = Unknown
	}
	
	ModifyListView("FishingList", LoginName, 3, LiquidType)
	ModifyListView("FishingList", LoginName, 4, "Active")
	log("Fishing started for " . LoginName, TimeStamp, LogPath)
Return

FishingStopSelected:
	Gui, Main:ListView, FishingList
	; Gui, Main:Submit, Nohide
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		; SB_SetText("Error: Fail to remove selceted account (See log for details).", 2)
		log("Fail to start fishing on the selected account: you haven't select any account yet.", TimeStamp, LogPath)
		; SB_SetText("", 2)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	
	ModifyListView("FishingList", LoginName, 2, "0")
	ModifyListView("FishingList", LoginName, 3, "Unkown")
	ModifyListView("FishingList", LoginName, 4, "Idle")
	
	WinGet, PID, PID, %LoginName%

    for index, element in BotList
    {
        If (BotList[index][1] = PID)
            {
				log("Stopped fishing for " . BotList[index, 17], TimeStamp, LogPath)
				BotList.Remove(index)
                Return
            }
    }
	
	TotalClientsOnList := BotList.MaxIndex()
	if (TotalClientsOnList = 0)
	{
		CheckSetTimer := 0
		SetTimer, FishBiteMemoryScan, Off
		SetTimer, Recast, Off
	}
Return

; Button Setting Save
FishingSettingSave:
	GuiControlGet, Address
	
	IniWrite, %Address%, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
	
	; SB_SetText("Successfully saved fishing address.", 2)
	log("Saved fishing address for Fishing Bot. New address is: " . Address, TimeStamp, LogPath)
	; SB_SetText("", 2)
Return

; Reload Fishing List Function.
FishingListReload()
{
	Gui, Main:Default
	Gui, Main:ListView, FishingList
	LV_Delete()
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IniRead, FMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		if (FMode = "On")
		{
			LV_Add("", A_LoopFileName, "0", "Unknown", "Idle")
		}
	}
	Return
}

FishingMode(LoginName)
{
	Global TimeStamp
	Global LogPath
	MsgBox, 36, SAVE CURRENT LOGIN ACCOUNT, Do you want to enable fishing for %LoginName%?`r`nYou can change this later by double click on %LoginName%.
	ifMsgBox Yes
	{
		IniWrite, On, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
		log("Fishing is turned on for " . LoginName, TimeStamp, LogPath)
	}
	else
	{
		IniWrite, Off, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
		log("Fishing is turned off for " . LoginName, TimeStamp, LogPath)
	}
	Return
}
; ~End~ Fishing System.
; -------------------------------------------------------------------------






; -------------------------------------------------------------------------
; ~Start~ Boot/Decons System.

BDList:
	Gui, Main:ListView, BDList
	if A_GuiEvent = Normal
	{
		FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
		if not FocusedRowNumber  ; No row is focused.
		{
			Return
		}
		LV_GetText(LoginName, FocusedRowNumber, 1)
		LV_GetText(GetBMode, FocusedRowNumber, 2)  ; Get the text from the row's first field.
		if (GetBMode = "On")
		{
			NewBMode := "Off"
			IniWrite, %NewBMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Boot, Mode
			LV_Modify(FocusedRowNumber, "", , NewBMode)
			log("Boot Drop Mode is turned off for " . LoginName, TimeStamp, LogPath)
		}
		else
		{
			NewBMode := "On"
			IniWrite, %NewBMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Boot, Mode
			LV_Modify(FocusedRowNumber, "", , NewBMode)
			log("Boot Drop Mode is turned on for " . LoginName, TimeStamp, LogPath)
		}
	}
	
	Gui, Main:ListView, BDList
	if A_GuiEvent = RightClick
	{
		FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
		if not FocusedRowNumber  ; No row is focused.
		{
			Return
		}
		LV_GetText(LoginName, FocusedRowNumber, 1)
		LV_GetText(GetDMode, FocusedRowNumber, 3)  ; Get the text from the row's first field.
		if (GetDMode = "On")
		{
			NewDMode := "Off"
			IniWrite, %NewDMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Decons, Mode
			LV_Modify(FocusedRowNumber, "", , , NewDMode)
			log("Decons Mode is turned off for " . LoginName, TimeStamp, LogPath)
		}
		else
		{
			NewDMode := "On"
			IniWrite, %NewDMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Decons, Mode
			LV_Modify(FocusedRowNumber, "", , , NewDMode)
			log("Decons Mode is turned on for " . LoginName, TimeStamp, LogPath)
		}
	}
Return

BDStart:
	BDActive := 1
	log("Started auto drop boot and auto decons.", TimeStamp, LogPath)
	Loop
	{
		if (BDActive = 0)
		{
			Return
		}
		else
		{
			TotalClientsOnList := BotList.MaxIndex()
			Loop, %TotalClientsOnList%
			{
				if (BDActive = 0)
				{
					return
				}
				PID := BotList[a_index, 1]
				BotName := BotList[a_index, 16]
				IniRead, BMode, %A_ScriptDir%/data/savedlogins/%BotName%/BDMode.ini, Boot, Mode
				IniRead, DMode, %A_ScriptDir%/data/savedlogins/%BotName%/BDMode.ini, Decons, Mode
				if (DMode = "On")
				{
					Decons(PID)
					RandomSleep(1000, 2000)
				}
				if (BMode = "On")
				{
					BootDrop(PID)
					RandomSleep(1000, 2000)
				}
			}
		}
		
		IniRead, GetBDTime, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
		SetTimer, UpdateOSD, 200
		Periodsec := GetBDTime/1000
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

Decons(PID)
{
	WinActivate, ahk_pid %PID%
		
	TotalSlot := CoordSlot.MaxIndex()
	Loop, %TotalSlot%
	{
		if (BDActive = 0)
		{
			return
		}
		CoordSlotX := CoordSlot[a_index, 1]
		CoordSlotY := CoordSlot[a_index, 2]
		MouseClick, Right, CoordSlotX, CoordSlotY
		RandomSleep(250, 500)
	}
	
	IniRead, BtnAcceptX, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptX
	IniRead, BtnAcceptY, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptY
	IniRead, BtnYesX, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesX
	IniRead, BtnYesY, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesY
		
	WinActivate, ahk_pid %PID%
	;Decons Accept
	Sleep, 1000
	MouseClick, left, BtnAcceptX, BtnAcceptY
		
	;Decons Yes
	Sleep, 1500
	MouseClick, left, BtnYesX, BtnYesY
	
	Return	
}

BootDrop(PID)
{
	WinActivate, ahk_pid %PID%
	
	TotalSlot := CoordSlot.MaxIndex()
	Loop, %TotalSlot%
	{
		if (BDActive = 0)
		{
			return
		}
		CoordSlotX := CoordSlot[a_index, 1]
		CoordSlotY := CoordSlot[a_index, 2]
		MouseClickDrag, Left, CoordSlotX, CoordSlotY, 240, 150, 4
		Sleep, 200
		Click, 240, 150
		RandomSleep(1000, 1500)
		Click, 270, 205
		RandomSleep(500, 1000)
	}
	
	Return
}

HKBDStop:
BDStop:
	BDActive := 0
	log("Stopped auto drop boot and auto decons.", TimeStamp, LogPath)
Return

BDSettingSave:
	GuiControlGet, BDDelay
	GuiControlGet, BootDropMethod
	GuiControlGet, HK_BDStop
	
	IniWrite, %BDDelay%, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
	IniWrite, %BootDropMethod%, %A_ScriptDir%/data/configs/bdsystem.ini, DropMethod, Method
	IniWrite, %HK_BDStop%,  %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
	
	GetHotKey := StrSplit(HK_BDStop, " + ") 
	HK_BDStop := GetHotKey[2]
	HotKey, ^%HK_BDStop%, HKBDStop, On
	
	log("Saved new session delay time, boot drop method and boot drop stop hotkey for Boot/Decons Bot. New settings are: " . BDDelay . ", " . BootDropMethod . ", Ctrl + " . HK_BDStop, TimeStamp, LogPath)
Return

BDListReload()
{
	Gui, Main:Default
	Gui, Main:ListView, BDList
	LV_Delete()
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IniRead, BMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/BDMode.ini, Boot, Mode
		IniRead, DMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/BDMode.ini, Decons, Mode
		LV_Add("", A_LoopFileName, BMode, DMode)
	}
	Return
}

LoadingCoordOut()
{
	Loop, 20
	{
		IniRead, GetBaseX, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseX
		IniRead, GetBaseY, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseY
		
		BaseX_1 := BaseX_6 := BaseX_11 := BaseX_16 := GetBaseX
		BaseX_2 := BaseX_7 := BaseX_12 := BaseX_17 := BaseX_1+20 ;Relative 20, Client 20
		BaseX_3 := BaseX_8 := BaseX_13 := BaseX_18 := BaseX_2+21 ;Relative 21, Client 21
		BaseX_4 := BaseX_9 := BaseX_14 := BaseX_19 := BaseX_3+21 ;Relative 21, Client 21
		BaseX_5 := BaseX_10 := BaseX_15 := BaseX_20 := BaseX_4+21 ;Relative 21, Client 21
		
		if (a_index <= 5)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY
			CoordSlot.Insert(Array(BaseX, BaseY))
		}
		else if (a_index >5 and a_index <= 10)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+20
			CoordSlot.Insert(Array(BaseX, BaseY))
		}
		else if (a_index >10 and a_index <= 15)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+40
			CoordSlot.Insert(Array(BaseX, BaseY))
		}
		else if (a_index >15 and a_index <= 20)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+60
			CoordSlot.Insert(Array(BaseX, BaseY))
		}
	}
	Return
}

BDMode(LoginName)
{
	Global TimeStamp
	Global LogPath
	MsgBox, 36, SAVE CURRENT LOGIN ACCOUNT, Do you want to enable Boot/Decons for %LoginName%?`r`nYou can change this later by either left click or right click on %LoginName%.
	ifMsgBox Yes
	{
		IniWrite, On, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Boot, Mode
		IniWrite, On, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Decons, Mode
		log("Boot/Decons is turned on for " . LoginName, TimeStamp, LogPath)
	}
	else
	{
		IniWrite, Off, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Boot, Mode
		IniWrite, Off, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Decons, Mode
		log("Boot/Decons is turned off for " . LoginName, TimeStamp, LogPath)
	}
	Return
}
; ~End~ Boot/Decons System.
; -------------------------------------------------------------------------






; -------------------------------------------------------------------------
; ~Start~ Ultilities Functions.

ModifyListView(ListViewVar, AccountName, Column, Text)
{
	Gui, Main:Default
	Gui, Main:ListView, %ListViewVar%
	Loop % LV_GetCount()
	{
		LV_GetText(RetrievedAccountName, A_Index)
		if InStr(RetrievedAccountName, AccountName)
		{
			LV_Modify(A_Index, "Col" Column, Text)
		}
	}
}

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

ToolTipDisplay(Message) {
        ToolTip, %Message%
        SetTimer, RemoveToolTip, 5000
        Return
    }
RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
Return

TransSplashText_On(Title="",Text="",Width="",Font="",TC="",SC="",TS="",xPos="",yPos="",TimeOut="")
{
	TransSplashText_Off()
	If Title = 
	{
		Title = %A_ScriptName%
	}
	If Text = 
	{
		Text = TransSplashText
	}
	If Width = 
	{
		Width = 200
	}
	If Font = 
	{
		Font = Impact
	}
	If TC = 
	{
		TC = White
	}
	If SC = 
	{
		SC = 828284
	}
	If TS = 
	{
		TS = 20
	}
	If xPos = 
	{
		xPos = Center
	}
	If yPos = 
	{
		yPos = Center
	}
	If TimeOut = 
	{
		TimeOut = 0
	}
	If SC != 0
	{
		Gui, 99:Font, S%TS% C%SC%, %Font%
		Gui, 99:Add, Text, x7 y7 w%Width%, %Text%
	}
	Gui, 99:Font, S%TS% C%TC%, %Font%
	Gui, 99:Add, Text, x5 y5 w%Width% gGUITextClick, %Text%

	;Gui, 99:Color, EEAA99
	Gui, 99:+LastFound +AlwaysOnTop +ToolWindow ;-Caption
	;WinSet, TransColor, EEAA99
	Gui, 99:Show, x%xPos% y%yPos% AutoSize, %Title%
	If TimeOut != 0
	{
		SetTimer, TextOff, %TimeOut%
		Return
		TextOff:
		TransSplashText_Off()
		Return
	}
}

GUITextClick:
    TransSplashText_Off() ;Turns off any active splash Screens.
    TotalClientsOnList := BotList.MaxIndex()
    Loop, %TotalClientsOnList%
	{
		If (1 < BotList[a_index, 15]) ;If client has any erors Counts it will automatic remove form active fishing when Gui is Clicked
		{
			ClientWindow := BotList[a_index, 2]
			WinActivate, ahk_id %ClientWindow% ;Brings the erroed client to the foregound.
			BotList[a_index, 13] := 0 ;Removing client from active scan list.
			BotList[a_index, 15] := 0 ;Resetting errot Count as it is no longer on the active list.
			BotList[a_index, 14] := 0 ;Removing Recast just incase. If it is activly fishing it wont try and recast lure.
			ToolTipDisplay("Removed " . BotList[a_index, 16] . " account from active fishing list.")
		}
	}
Return

TransSplashText_Off()
{
	Gui, 99:Destroy
	SetTimer, TextOff, Off
}

log(msg, timestamp, txtpath)
{
	FileAppend, ;Text file write
	(
	[%timestamp%]: %msg%`n
	), %txtpath%
	GuiControlGet, Console
	GuiControl, Main:, Console, %Console%[%timestamp%]: %msg%`r`n ; GUI write
	sleep 1000 ; Pause for smooth log scrolling
}

GetAddressWater(PID, Base, Address)
{
    pointerBase := base + Address
    y1 := ReadMemory(PID, pointerBase)
    y2 := ReadMemory(PID, y1 + 0x144)
    y3 := ReadMemory(PID, y2 + 0xe4)
    Return @ := (y3 + 0x70)   
}

GetAddressLava(PID, Base, Address)
{
	pointerBase := base + Address
	y1 := ReadMemory(PID, pointerBase)
	y2 := ReadMemory(PID, y1 + 0x144)
	y3 := ReadMemory(PID, y2 + 0xe4)
	Return @ := (y3 + 0x514) 
}

GetAddressChoco(PID, Base, Address)
{
	pointerBase := base + Address
	y1 := ReadMemory(PID, pointerBase)
	y2 := ReadMemory(PID, y1 + 0x144)
	y3 := ReadMemory(PID, y2 + 0xe4)
	Return @ := (y3 + 0x2c0)
}  

GetFishingStateWaterAddress(PID, Base, Address)
{
 pointerBase := base + Address
 y1 := ReadMemory(PID, pointerBase)
 y2 := ReadMemory(PID, y1 + 0x5d8)
 y3 := ReadMemory(PID, y2 + 0x7d4)
 Return @ := (y3 + 0x5a0)
}
 
GetFishingStateChocoAddress(PID, Base, Address)
{
 pointerBase := base + Address
 y1 := ReadMemory(PID, pointerBase)
 y2 := ReadMemory(PID, y1 + 0x5d8)
 y3 := ReadMemory(PID, y2 + 0x7d8)
 Return @ := (y3 + 0x684)
}
 
GetFishingStateLavaAddress(PID, Base, Address)
{
 pointerBase := base + Address
 y1 := ReadMemory(PID, pointerBase)
 y2 := ReadMemory(PID, y1 + 0x5d8)
 y3 := ReadMemory(PID, y2 + 0x7d8)
 Return @ := (y3 + 0x1e4)
}

getProcessBaseAddress(Handle)
{
	return DllCall( A_PtrSize = 4
                            ? "GetWindowLong"
                            : "GetWindowLongPtr"
                        , "Ptr", Handle
                        , "Int", -6
                        , "Int64") ; Use Int64 to prevent negative overflow when AHK is 32 bit and target process is 64bit
     ; If DLL call fails, returned value will = 0
}   

ReadMemory(PID, MADDRESS)
{
	VarSetCapacity(MVALUE,4,0)
	ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", PID, "UInt")
	DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", MADDRESS, "Ptr", &MVALUE, "Uint",4)
	Loop, 4
	{
		result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
	}
	Return result
}
; ~End~ Ultilities Functions.
; -------------------------------------------------------------------------

MainGuiClose:
ExitApp
