BDList:	
	Gui, Main:Default
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
			ModifyListView("BDList", LoginName, 2, NewBMode)
			log("Boot Drop Mode is turned off for " . LoginName, LogPath)
		}
		else
		{
			NewBMode := "On"
			IniWrite, %NewBMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Boot, Mode
			ModifyListView("BDList", LoginName, 2, NewBMode)
			log("Boot Drop Mode is turned on for " . LoginName, LogPath)
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
			ModifyListView("BDList", LoginName, 3, NewDMode)
			log("Decons Mode is turned off for " . LoginName, LogPath)
		}
		else
		{
			NewDMode := "On"
			IniWrite, %NewDMode%, %A_ScriptDir%/data/savedlogins/%LoginName%/BDMode.ini, Decons, Mode
			ModifyListView("BDList", LoginName, 3, NewDMode)
			log("Decons Mode is turned on for " . LoginName, LogPath)
		}
	}
Return

BDStart:
	log("Started auto drop boot and auto decons.", LogPath)
	GuiControl, Main:Disable, BDStart
	StringMid, BDTimeH, GetBDTime, 1, 2
	StringMid, BDTimeM, GetBDTime, 3, 2
	StringMid, BDTimeS, GetBDTime, 5, 2
	BDTimeSec := ((BDTimeH*3600) + (BDTimeM*60) + BDTimeS)*1000
	SetTimer, BDTimeCheck, %BDTimeSec%
	Gosub, RunBD
Return

BDTimeCheck:
	Gosub, RunBD
Return

RunBD:
	Run, BootDecons.ahk, %A_ScriptDir%
Return

HKBDStop:
BDStop:
	SetTimer, BDTimeCheck, Off
	DetectHiddenWindows, On 
	WinClose, %A_ScriptDir%\BootDecons.ahk ahk_class AutoHotkey
	DetectHiddenWindows, Off
	GuiControl, Main:Enable, BDStart
	log("Stopped auto drop boot and auto decons.", LogPath)
Return

BDSetting:
	Gui, BDSetting:Show, x180 y0 w265 h590, Boot/Decons Settings
	
	IniRead, GetBDDelay, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
	StringMid, BDTimeH, GetBDDelay, 1, 2
	StringMid, BDTimeM, GetBDDelay, 3, 2
	StringMid, BDTimeS, GetBDDelay, 5, 2
	GuiControl, BDSetting:, BDHour, %BDTimeH%
	GuiControl, BDSetting:, BDMin, %BDTimeM%
	GuiControl, BDSetting:, BDSec, %BDTimeS%
	IniRead, BDStopHK,  %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
	ControlSetText, , %BDStopHK%, ahk_id %HHK_BDStop%
Return

BDSettingSave:
	GuiControlGet, BDHour
	GuiControlGet, BDMin
	GuiControlGet, BDSec
	GuiControlGet, HK_BDStop
	
	BDDelay = %BDHour%%BDMin%%BDSec%
	IniWrite, %BDDelay%, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
	IniWrite, %HK_BDStop%,  %A_ScriptDir%/data/configs/bdsystem.ini, HotKey, Stop
	IniRead, GetBDTime, %A_ScriptDir%/data/configs/bdsystem.ini, SessionDelay, Time
	
	GetHotKey := StrSplit(HK_BDStop, " + ") 
	HK_BDStop := GetHotKey[2]
	HotKey, ^%HK_BDStop%, HKBDStop, On
	
	NewSelectedSlots =
    TotalSlots := SelectedSlots.MaxIndex()

    for index, element in SelectedSlots
    {
        if (index = TotalSlots)
		{
			if (SelectedSlots[index, 1] = "")
			{
				State := 0
			} 
			else 
			{
				State := SelectedSlots[index, 1]
			}
			NewSelectedSlots .= State
        } 
		else 
		{	
			if (SelectedSlots[index, 1] = "")
			{
				State := 0
			} 
			else 
			{
				State := SelectedSlots[index, 1]
			}
			NewSelectedSlots .= State . "|"
		}
    }
	IniWrite, %NewSelectedSlots%, %A_ScriptDir%/data/configs/bdsystem.ini, InventorySlots, SelectedSlots
	
	Gui, BDSetting:Hide
	MsgBox, 64, Boot/Decons Settings, Settings are successfully saved.
Return

Slot1:
	GuiControl, % ( SelectedSlots[1, 1] := !SelectedSlots[1, 1] ) ? "Show" : "Hide", Selected1 ; 0 = Off, 1 = On
Return

Slot2:
	GuiControl, % ( SelectedSlots[2, 1] := !SelectedSlots[2, 1] ) ? "Show" : "Hide", Selected2
Return

Slot3:
	GuiControl, % ( SelectedSlots[3, 1] := !SelectedSlots[3, 1] ) ? "Show" : "Hide", Selected3
Return

Slot4:
	GuiControl, % ( SelectedSlots[4, 1] := !SelectedSlots[4, 1] ) ? "Show" : "Hide", Selected4
Return

Slot5:	
	GuiControl, % ( SelectedSlots[5, 1] := !SelectedSlots[5, 1] ) ? "Show" : "Hide", Selected5
Return

Slot6:
	GuiControl, % ( SelectedSlots[6, 1] := !SelectedSlots[6, 1] ) ? "Show" : "Hide", Selected6
Return

Slot7:
	GuiControl, % ( SelectedSlots[7, 1] := !SelectedSlots[7, 1] ) ? "Show" : "Hide", Selected7
Return

Slot8:
	GuiControl, % ( SelectedSlots[8, 1] := !SelectedSlots[8, 1] ) ? "Show" : "Hide", Selected8
Return

Slot9:
	GuiControl, % ( SelectedSlots[9, 1] := !SelectedSlots[9, 1] ) ? "Show" : "Hide", Selected9
Return

Slot10:
	GuiControl, % ( SelectedSlots[10, 1] := !SelectedSlots[10, 1] ) ? "Show" : "Hide", Selected10
Return

Slot11:
	GuiControl, % ( SelectedSlots[11, 1] := !SelectedSlots[11, 1] ) ? "Show" : "Hide", Selected11
Return

Slot12:
	GuiControl, % ( SelectedSlots[12, 1] := !SelectedSlots[12, 1] ) ? "Show" : "Hide", Selected12
Return

Slot13:
	GuiControl, % ( SelectedSlots[13, 1] := !SelectedSlots[13, 1] ) ? "Show" : "Hide", Selected13
Return

Slot14:
	GuiControl, % ( SelectedSlots[14, 1] := !SelectedSlots[14, 1] ) ? "Show" : "Hide", Selected14
Return

Slot15:
	GuiControl, % ( SelectedSlots[15, 1] := !SelectedSlots[15, 1] ) ? "Show" : "Hide", Selected15
Return

Slot16:
	GuiControl, % ( SelectedSlots[16, 1] := !SelectedSlots[16, 1] ) ? "Show" : "Hide", Selected16
Return

Slot17:
	GuiControl, % ( SelectedSlots[17, 1] := !SelectedSlots[17, 1] ) ? "Show" : "Hide", Selected17
Return

Slot18:
	GuiControl, % ( SelectedSlots[18, 1] := !SelectedSlots[18, 1] ) ? "Show" : "Hide", Selected18
Return

Slot19:
	GuiControl, % ( SelectedSlots[19, 1] := !SelectedSlots[19, 1] ) ? "Show" : "Hide", Selected19
Return

Slot20:
	GuiControl, % ( SelectedSlots[20, 1] := !SelectedSlots[20, 1] ) ? "Show" : "Hide", Selected20
Return

Slot21:
	GuiControl, % ( SelectedSlots[21, 1] := !SelectedSlots[21, 1] ) ? "Show" : "Hide", Selected21
Return

Slot22:
	GuiControl, % ( SelectedSlots[22, 1] := !SelectedSlots[22, 1] ) ? "Show" : "Hide", Selected22
Return

Slot23:
	GuiControl, % ( SelectedSlots[23, 1] := !SelectedSlots[23, 1] ) ? "Show" : "Hide", Selected23
Return

Slot24:
	GuiControl, % ( SelectedSlots[24, 1] := !SelectedSlots[24, 1] ) ? "Show" : "Hide", Selected24
Return

Slot25:
	GuiControl, % ( SelectedSlots[25, 1] := !SelectedSlots[25, 1] ) ? "Show" : "Hide", Selected25
Return

Slot26:
	GuiControl, % ( SelectedSlots[26, 1] := !SelectedSlots[26, 1] ) ? "Show" : "Hide", Selected26
Return

Slot27:
	GuiControl, % ( SelectedSlots[27, 1] := !SelectedSlots[27, 1] ) ? "Show" : "Hide", Selected27
Return

Slot28:
	GuiControl, % ( SelectedSlots[28, 1] := !SelectedSlots[28, 1] ) ? "Show" : "Hide", Selected28
Return

Slot29:
	GuiControl, % ( SelectedSlots[29, 1] := !SelectedSlots[29, 1] ) ? "Show" : "Hide", Selected29
Return

Slot30:
	GuiControl, % ( SelectedSlots[30, 1] := !SelectedSlots[30, 1] ) ? "Show" : "Hide", Selected30
Return

Slot31:
	GuiControl, % ( SelectedSlots[31, 1] := !SelectedSlots[31, 1] ) ? "Show" : "Hide", Selected31
Return

Slot32:
	GuiControl, % ( SelectedSlots[32, 1] := !SelectedSlots[32, 1] ) ? "Show" : "Hide", Selected32
Return

Slot33:
	GuiControl, % ( SelectedSlots[33, 1] := !SelectedSlots[33, 1] ) ? "Show" : "Hide", Selected33
Return

Slot34:
	GuiControl, % ( SelectedSlots[34, 1] := !SelectedSlots[34, 1] ) ? "Show" : "Hide", Selected34
Return

Slot35:
	GuiControl, % ( SelectedSlots[35, 1] := !SelectedSlots[35, 1] ) ? "Show" : "Hide", Selected35
Return

Slot36:	
	GuiControl, % ( SelectedSlots[36, 1] := !SelectedSlots[36, 1] ) ? "Show" : "Hide", Selected36
Return

Slot37:
	GuiControl, % ( SelectedSlots[37, 1] := !SelectedSlots[37, 1] ) ? "Show" : "Hide", Selected37
Return

Slot38:
	GuiControl, % ( SelectedSlots[38, 1] := !SelectedSlots[38, 1] ) ? "Show" : "Hide", Selected38
Return

Slot39:
	GuiControl, % ( SelectedSlots[39, 1] := !SelectedSlots[39, 1] ) ? "Show" : "Hide", Selected39
Return

Slot40:
	GuiControl, % ( SelectedSlots[40, 1] := !SelectedSlots[40, 1] ) ? "Show" : "Hide", Selected40
Return

Slot41:
	GuiControl, % ( SelectedSlots[41, 1] := !SelectedSlots[41, 1] ) ? "Show" : "Hide", Selected41
Return

Slot42:
	GuiControl, % ( SelectedSlots[42, 1] := !SelectedSlots[42, 1] ) ? "Show" : "Hide", Selected42
Return

Slot43:
	GuiControl, % ( SelectedSlots[43, 1] := !SelectedSlots[43, 1] ) ? "Show" : "Hide", Selected43
Return

Slot44:
	GuiControl, % ( SelectedSlots[44, 1] := !SelectedSlots[44, 1] ) ? "Show" : "Hide", Selected44
Return

Slot45:
	GuiControl, % ( SelectedSlots[45, 1] := !SelectedSlots[45, 1]) ? "Show" : "Hide", Selected45
Return