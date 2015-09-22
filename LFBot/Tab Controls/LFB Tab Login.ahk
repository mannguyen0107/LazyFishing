; Button Save Current Login.
SaveLogin:
	log("Saving current login account...", LogPath)
	
	if (GetGlyphVer = "Steam")
	{
		IfNotExist, %GetGlyphPath%\Cache\*.dat
		{
			log("Fail to save current login account: please login to save the account.", LogPath)
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
		log("Fail to save current login account: the account " . GetLoginName . " is already existed.", LogPath)
		Return
	}
	
	IfNotExist, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	{
		log("Creating " . GetLoginName . " folder to save the account info.", LogPath)
		FileCreateDir, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	
	if (GetGlyphVer = "Steam")
	{
		log("Copying .dat file of " . GetLoginName . " to it's folder.", LogPath)
		FileCopy, %GetGlyphPath%\Cache\*.dat, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	else
	{
		log("Copying .dat file of " . GetLoginName . " to it's folder.", LogPath)
		FileCopy, %StandaloneDataPath%\Cache\*.dat, %A_ScriptDir%/data/savedlogins/%GetLoginName%
	}
	
	FishingMode(GetLoginName)
	AccountListReload()
	AddFishingListView(LoginName, "Unknown", "0", "Unknown", "Idle", "Unknown")
	BDMode(GetLoginName)
	BDListReload()

	log("Saved " . GetLoginName . " to the Accounts List.", LogPath)
Return

; Button Remove Selected Account.
RemoveAcc:
	Gui, Main:ListView, AccountList
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		log("Fail to removed the selected account: you haven't select an account to remove yet.", LogPath)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	MsgBox, 36, REMOVE SELECTED ACCOUNT, Are you sure you want to delete %LoginName% from the account list?
	ifMsgBox Yes
	{
		FileRemoveDir, %A_ScriptDir%/data/savedlogins/%LoginName%, 1
		AccountListReload()
		BDListReload()
		DeleteListView("FishingList", LoginName)
		LV_Delete(FocusedRowNumber)  ; Clear the row from the ListView.
		log("Removed " . LoginName . " from the Accounts List.", LogPath)
	}
	else
	{
		Return
	}
Return

; Button Launch Glyph Client.
LaunchGlyph:
	log("Launching Glyph Client...", LogPath)
	
	if (GetGlyphVer = "Steam")
	{
		IfNotExist, %GetGlyphPath%/Cache
		{
			log("Fail to launch Glyph Client: please check the folder path again, this path is for Standalone version.", LogPath)
			Return
		}
		LaunchGlyph(GetGlyphPath)
	}
	else
	{
		IfExist, %GetGlyphPath%/Cache
		{
			log("Fail to launch Glyph Client: please check the folder path again, this path is for Steam version.", LogPath)
			Return
		}
		LaunchGlyph(GetGlyphPath)
	}
	log("Glyph Client has launched.", LogPath)
Return

; Button Launch Selected Account.
LaunchSelected:
	Gui, Main:ListView, AccountList
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		log("Fail to launch the selected account: you haven't select an account to launch yet.", LogPath)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	log("Launching " . LoginName . " ...", LogPath)
	AutoLogin(GetGlyphPath, LoginName, GetGlyphVer)
	if (LaunchGlyphFail = 1)
	{
		Return
	}
	log("Successfully launched " . LoginName, LogPath)
Return

; Button Launch All Account.
LaunchAll:
	log("Launching all the accounts...", LogPath)
	
	Loop, %A_ScriptDir%/data/savedlogins\*, 2
	{
		log("Launching account number " . A_Index . ": " . A_LoopFileName, LogPath)
		AutoLogin(GetGlyphPath, A_LoopFileName, GetGlyphVer)
		if (LaunchGlyphFail = 1)
		{
			Return
		}
		log("Account number " . A_Index . ": " . A_LoopFileName . " has lauched", LogPath)
	}

	log("Successfully launched all accounts.", LogPath)
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
	IniRead, GetGlyphVer, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphVer, Version
	IniRead, GetGlyphPath, %A_ScriptDir%/data/configs/loginsystem.ini, GlyphFolderPath, Path
	
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
			DeleteListView("FishingList", LoginName)
			BDListReload()
			log("Fishing is turned off for " . LoginName, LogPath)
		}
		else
		{
			NewFMode := "On"
			IniWrite, %NewFMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
			ModifyListView("AccountList", LoginName, 2, NewFMode)
			DeleteListView("FishingList", LoginName)
			BDListReload()
			log("Fishing is turned on for " . LoginName, LogPath)
		}
	}
Return