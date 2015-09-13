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
				BotName := BotList[a_index, 15]
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
		SetTimer, BDUpdateOSD, 200
		Periodsec := GetBDTime/1000
		BDStartTime = %A_Now%
		BDEndTime = %A_Now%
		EnvAdd BDEndTime, Periodsec, seconds
		EnvSub BDStartTime, BDEndTime, seconds
		BDStartTime := Abs(BDStartTime)
		BDPercent := 0 ; Resets percentage to 0, otherwise this loop never sees the counter reset
		Loop
		{
			if BDPercent = 100
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

BDUpdateOSD:
	if (BDActive = 0)
	{
		BDPercent = 100
		SetTimer, BDUpdateOSD, Off
		GuiControl, Main:, BDCDTime, 00:00:00
	}
	else 
	{
		BDTimeNow := BDEndTime
		EnvSub, BDTimeNow, %A_Now%, seconds
		GuiControl, Main:, BDCDTime, % FormatSeconds(BDTimeNow)
		BDPercent := ((BDStartTime-BDTimeNow)/BDStartTime)*100
		BDPercent := Floor(BDPercent)
		If (BDPercent = 100)
		{
			SetTimer, BDUpdateOSD, Off
		}
	}
Return

Decons(PID)
{
	WinActivate, ahk_pid %PID%
		
	TotalSlot := SelectedSlots.MaxIndex()
	Loop, %TotalSlot%
	{
		if (BDActive = 0)
		{
			return
		}
		if (SelectedSlots[a_index, 1] = 0)
		{
			Continue
		}
		else
		{
			CoordSlotX := SelectedSlots[a_index, 2]
			CoordSlotY := SelectedSlots[a_index, 3]
			MouseClick, Right, CoordSlotX, CoordSlotY
			RandomSleep(250, 500)
		}
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
	
	TotalSlot := SelectedSlots.MaxIndex()
	Loop, %TotalSlot%
	{
		if (BDActive = 0)
		{
			return
		}
		if (SelectedSlots[a_index, 1] = 0)
		{
			Continue
		}
		else
		{
			CoordSlotX := SelectedSlots[a_index, 2]
			CoordSlotY := SelectedSlots[a_index, 3]
			MouseClickDrag, Left, CoordSlotX, CoordSlotY, 240, 150, 4
			Sleep, 200
			Click, 240, 150
			RandomSleep(1000, 1500)
			Click, 270, 205
			RandomSleep(500, 1000)
		}
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
		IniRead, FMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		if (FMode = "On")
		{
			IniRead, BMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/BDMode.ini, Boot, Mode
			IniRead, DMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/BDMode.ini, Decons, Mode
			LV_Add("", A_LoopFileName, BMode, DMode)
		}
	}
	Return
}