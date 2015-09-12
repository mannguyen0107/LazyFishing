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
			BDListReload()
			log("Fishing is turned off for " . LoginName, TimeStamp, LogPath)
		}
		else
		{
			NewFMode := "On"
			IniWrite, %NewFMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
			ModifyListView("AccountList", LoginName, 2, NewFMode)
			FishingListReload()
			BDListReload()
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
		
	sleep, 5000
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