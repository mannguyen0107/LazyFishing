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
	if (LaunchGlyphFail = 1)
	{
		log("Your Glyph Path is wrong please check again.", LogPath)
		Return
	}
	
	sleep, 5000
	ClickPlay()
	Sleep, 5000
	SetWinTitleAtLaunch(LoginName)
	sleep, 2000
	Return
}
 
LaunchGlyph(GlyphPath)
{
	LaunchGlyphFail := 0
	Process, Exist, GlyphClient.exe
	if (ErrorLevel = 0)
	{
		Run, GlyphClient.exe, %GlyphPath%, UseErrorLevel
		if ErrorLevel = ERROR
		{
			MsgBox, 16, LAUNCH GLYPH, Please check the folder path again!
			LaunchGlyphFail := 1
			Return
		}
		WinWait, Glyph
	}
}

; Click Play Function.
ClickPlay()
{
	Global TimeStamp
	Global LogPath
	log("Waiting to click Play button...", LogPath)
	; Click on Play
	ToolTip, "If your mouse get frozen it is because the bot cannot find the Play button`n then please use Ctrl+Shift+Q to reload and check your settings again."
	Loop
	{
		WinActivate, Glyph
		MouseClick, Left, 470, 530
		ifWinExist, Trove
		{
			ToolTip
			Break
		}
	}
	log("Done. Play button has clicked, the game has launch.", LogPath)
	Return
}

SetWinTitleAtLaunch(LoginName)
{
	Global TimeStamp
	Global LogPath
	log("Renaming Trove window to the account name: " . LoginName . " ...", LogPath)
	Global ClientWidth
	Global ClientHeight
	
	WinWait, Trove
	WinSetTitle, Trove, , %LoginName% 
	WinMove, %LoginName%, , , , %ClientWidth%, %ClientHeight%
	log("Finish rename Trove window to: " . LoginName, LogPath)
}

FishingMode(LoginName)
{
	Global TimeStamp
	Global LogPath
	MsgBox, 36, SAVE CURRENT LOGIN ACCOUNT, Do you want to enable fishing for %LoginName%?`r`nYou can change this later by double click on %LoginName%.
	ifMsgBox Yes
	{
		IniWrite, On, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
		log("Fishing is turned on for " . LoginName, LogPath)
	}
	else
	{
		IniWrite, Off, %A_ScriptDir%/data/savedlogins/%LoginName%/Fishing.ini, Fishing, Mode
		log("Fishing is turned off for " . LoginName, LogPath)
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
		log("Boot/Decons is turned on for " . LoginName, LogPath)
	}
	else
	{
		IniWrite, Off, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Boot, Mode
		IniWrite, Off, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Decons, Mode
		log("Boot/Decons is turned off for " . LoginName, LogPath)
	}
	Return
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