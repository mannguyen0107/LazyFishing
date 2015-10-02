FishingStartAll:
	log("Starting fishing on all accounts...", LogPath)
	if (CheckSetTimer = 0)
	{
		SetTimer, FishBiteMemoryScan, 1000
		SetTimer, Recast, 2000
		SetTimer, Anti-AFK, 60000
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
			TotalClientsOnAFKList := AFKList.MaxIndex()
			Loop, %TotalClientsOnAFKList%
			{
				if (AFKList[a_index, 1] = A_LoopFileName)
				{
					AFKList.Remove(a_index)
				}
			}
			
			TotalClientsOnList := BotList.MaxIndex()
			Loop, %TotalClientsOnAFKList%
			{
				if (BotList[a_index, 15] = A_LoopFileName)
				{
					Continue
				}
			}
			
			WinGet, PID, PID, %A_LoopFileName%
			WinGet, Handle, ID, %A_LoopFileName%
			If (pID = "" or Handle = "")
			{
				Return
			}
			
			HumanPressButton("f", PID)
			Sleep 400
			
			Base := getProcessBaseAddress(Handle)
			WaterAddress := GetAddress(PID, Base, LoadAddress, LoadFishBiteWaterOffsets)
			Sleep 100
			LavaAddress := GetAddress(PID, Base, LoadAddress, LoadFishBiteLavaOffsets)
			ChocoAddress := GetAddress(PID, Base, LoadAddress, LoadFishBiteChocoOffsets)
			Sleep 100
			GetFishingStateWaterAddress := GetAddress(PID, Base, LoadAddress, LoadLiquidTypeWaterOffsets)
			GetFishingStateLavaAddress := GetAddress(PID, Base, LoadAddress, LoadLiquidTypeLavaOffsets)
			Sleep 100
			GetFishingStateChocoAddress := GetAddress(PID, Base, LoadAddress, LoadLiquidTypeChocoOffsets)
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
			
			BotList.Insert(Array(PID ,Handle, Base, WaterAddress, LavaAddress, ChocoAddress, StartTime, LastReelCast, GetFishingStateWaterAddress, GetFishingStateLavaAddress, GetFishingStateChocoAddress , DetectedLiquidType, "0", "0", A_LoopFileName, "0", "0"))
			
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
			FormatTime, FishingStartTime, StartTime, dd.MM.yyyy HH:mm:ss
			ModifyListView("FishingList", A_LoopFileName, 2, FishingStartTime)
			ModifyListView("FishingList", A_LoopFileName, 4, LiquidType)
			ModifyListView("FishingList", A_LoopFileName, 5, "Fishing")
			ModifyListView("FishingList", A_LoopFileName, 6, "Unknown")
			log("Started fishing for " . A_LoopFileName, LogPath)
			TotalClients++
		}
	}
	log("Finish started fishing on all accounts. Total account started: " . TotalClients, LogPath)
Return

FishBiteMemoryScan:
    for index, element in BotList
    {
		this_index := index ; keep the index static
		FishingAccountName := BotList[this_index, 15]
        WinID :=
        ;Checking to make sure the next scan that the client is running. If not found it will auto remove form the list and move on to next.
        WinID := BotList[this_index, 2]
        IfWinNotExist, ahk_id %WinID%
		{
			PB_PushNote(GetToken, "Error", "the account: " . FishingAccountName . " no longer found. It will now get remove from fishing.")
			log(FishingAccountName . " account no longer found. It will now get remove from fishing.", LogPath)
			ModifyListView("FishingList", FishingAccountName, 2, "Unknown")
			ModifyListView("FishingList", FishingAccountName, 3, "0")
			ModifyListView("FishingList", FishingAccountName, 4, "Unknown")
			ModifyListView("FishingList", FishingAccountName, 5, "Idle")
			ModifyListView("FishingList", FishingAccountName, 6, "Unknown")
			BotList.Remove(this_index)
			Return
		}

        ; if (BotList[this_index, 13] = 0) 
        ; {
			; ModifyListView("FishingList", FishingAccountName, 4, "Unknown")
			; ModifyListView("FishingList", FishingAccountName, 5, "Idle")
        ; }
        
		if (BotList[this_index, 13] = 0) ; Checking to make sure the recast flag is set to 1 being on.
		{
			ModifyListView("FishingList", FishingAccountName, 5, "Fishing")
			; Checking last cast on record with current time.
			CurrentTime := 
			LastCastTime := BotList[this_index, 8]
			EnvSub, CurrentTime, LastCastTime, Seconds ; Converting last last cast time to Seconds.

			; Error handling to check to make sure it is still fishing.
			If (8 < CurrentTime && CurrentTime < 11 or 45 < CurrentTime)
			{
				FishingState := "0"
				;Checking all 3 fishing states.
				CaughtFishingStateWater := ReadMemory(BotList[this_index, 1], BotList[this_index, 9])
				CaughtFishingStateLava := ReadMemory(BotList[this_index, 1], BotList[this_index, 10])
				CaughtFishingStateChoco := ReadMemory(BotList[this_index, 1], BotList[this_index, 11])

				; If fishing state = 1 ignores the error logging. 15
				If (CaughtFishingStateWater = 1 or CaughtFishingStateLava = 1 or CaughtFishingStateChoco = 1)
				{
					FishingState := "1"
					BotList[this_index, 14] := "0" ;Since fishing is detected it will wipe out the Error Count.
				}

				If (FishingState = 0)
				{
					If (BotList[this_index, 13] <> 1) ; If recast is not 1 it trigers the Error Report. 
					{ 
						SetTimer, Recast, Off
						BotList[this_index, 14] := BotList[this_index, 14] + 1 ; Adds 1 for each time it is found not fishing. v1.2 Var Cleanup
						BotList[this_index, 13] := 1 ;Turning on the recast flag.
						SetTimer, Recast, 2000
						if (BotList[this_index, 14] > 2 && BotList[this_index, 14] <= 9)
						{
							if (BotList[this_index, 14] = 3)
							{
								PB_PushNote(GetToken, "Error", "the account: " . BotList[this_index, 15] . " seems to be not fishing. Possible causes could be the client/character is frozen, full inventory or no more lures left. Please check on the account.")
							}
							log("the account: " . BotList[this_index, 15] . " seems to be not be fishing. Possible causes could be the client/character is frozen, full inventory or no more lures left. Please check on the account.", LogPath)
						}
						else if (BotList[this_index, 14] > 9) ; Checking to see if it erros = 10+ if so automatic stop on tht client.
						{
							;Automatic Stop
							PB_PushNote(GetToken, "Error", "the account: " . BotList[this_index, 15] . " had more than 10 errors in a row, it will now be move to Anti-AFK list.")
							log("the account: " . BotList[this_index, 15] . " had more than 10 errors in a row, it will now be move to Anti-AFK list.", LogPath)
							AFKTime := a_now
							AFKList.Insert(Array(BotList[this_index, 15], BotList[this_index, 1], AFKTime))
							BotList.Remove(this_index)
						}
					}
				}
			}

			;Memory scan for current client to check for fish bite
			If (CurrentTime > LoadScanTime)
			{
				If (BotList[this_index, 12] = 1) ;Water type found scan only water type
				{
					ModifyListView("FishingList", FishingAccountName, 4, "Water")
					CaughtWater := ReadMemory(BotList[this_index, 1], BotList[this_index, 4])
				}	
				Else If (BotList[this_index, 12] = 2)	;Lava type found scan only lava type
				{
					ModifyListView("FishingList", FishingAccountName, 4, "Lava")
					CaughtLava := ReadMemory(BotList[this_index, 1], BotList[this_index, 5])
				}	
				Else If (BotList[this_index, 12] = 3) ;Choco type found only scan Choco type
				{
					ModifyListView("FishingList", FishingAccountName, 4, "Chocolate")
					CaughtChoco := ReadMemory(BotList[this_index, 1], BotList[this_index, 6])
				}	
				Else 
				{
					;Unknown type so we can all 3. This will use more cpu.
					ModifyListView("FishingList", FishingAccountName, 4, "Unknown")
					CaughtWater := ReadMemory(BotList[this_index, 1], BotList[this_index, 4])
					CaughtLava := ReadMemory(BotList[this_index, 1], BotList[this_index, 5])
					CaughtChoco := ReadMemory(BotList[this_index, 1], BotList[this_index, 6])
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
				If (BotList[this_index, 13] <> 1) 
				{
					SetTimer, Recast, Off
					BotList[this_index, 8] := a_now
					HumanPressButton("f", BotList[this_index, 1])
					Sleep 200
					BotList[this_index, 13] := 1   ;Turning on the recast flag.
					BotList[this_index, 16] := BotList[this_index, 16] + 1 ;Padding the reeled in Counter.
					; ReelIn := BotList[this_index, 16]
					ModifyListView("FishingList", FishingAccountName, 3, BotList[this_index, 16])
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
		If (BotList[a_index, 13] = 1)
		{
			BotList[a_index, 17] := BotList[a_index, 17] + 1 ;Pading the recast Count by 1
			RandomSleep(200, 2000)
			HumanPressButton("f", BotList[a_index, 1])
			BotList[a_index, 13] := "0"  ;Reseting the recast it recasted. Lure used?
			BotList[a_index, 8] := A_Now ;Setting the last cast time to current time.
		}
	}
Return

Anti-AFK:
    TotalClientsOnAFKList := AFKList.MaxIndex()
    Loop, %TotalClientsOnAFKList%
	{
		FormatTime, AFKStartTime, AFKList[a_index][3], dd.MM.yyyy HH:mm:ss
		ModifyListView("FishingList", AFKList[a_index, 1], 3, "0")
		ModifyListView("FishingList", AFKList[a_index, 1], 4, "Unknown")
		ModifyListView("FishingList", AFKList[a_index, 1], 5, "Anti-AFK")
		ModifyListView("FishingList", AFKList[a_index, 1], 6, AFKStartTime)
		HumanPressButton("rctrl", AFKList[a_index, 2])
	}
Return

FishingStopAll:
	log("Stopping fishing on all accounts...", LogPath)
	CheckSetTimer := 0
	SetTimer, FishBiteMemoryScan, Off
	SetTimer, Recast, Off
	SetTimer, Anti-AFK, Off
	
	Global BotList := Object()
	Global AFKList := Object()
	
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IniRead, GetFMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		if (GetFMode = "On")
		{
			ModifyListView("FishingList", A_LoopFileName, 2, "Unknown")
			ModifyListView("FishingList", A_LoopFileName, 3, "0")
			ModifyListView("FishingList", A_LoopFileName, 4, "Unknown")
			ModifyListView("FishingList", A_LoopFileName, 5, "Idle")
			ModifyListView("FishingList", A_LoopFileName, 6, "Unknown")
			log("Stopped fishing for: " . A_LoopFileName, LogPath)
		}
	}
	log("Stopped fishing on all accounts.", LogPath)
Return

FishingStartSelected:
	if (CheckSetTimer = 0)
	{
		SetTimer, FishBiteMemoryScan, 1000
		SetTimer, Recast, 2000
		SetTimer, Anti-AFK, 60000
		CheckSetTimer := 1
	}
	
	Gui, Main:ListView, FishingList
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		; SB_SetText("Error: Fail to remove selceted account (See log for details).", 2)
		log("Fail to start fishing on the selected account: you haven't select any account yet.", LogPath)
		; SB_SetText("", 2)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	log("Starting fishing for: " . LoginName . " ...", LogPath)
	
	TotalClientsOnAFKList := AFKList.MaxIndex()
    Loop, %TotalClientsOnAFKList%
	{
		if (AFKList[a_index, 1] = LoginName)
		{
			AFKList.Remove(a_index)
		}
	}
	
	; Getting the pID and Handle that is used for memory scans.
	WinGet, PID, PID, %LoginName%
    WinGet, Handle, ID, %LoginName%
	
	;First cast also to detect liquid type.
	HumanPressButton("f", PID)
	
	;Setting up addresses for Memory scan
	Base := getProcessBaseAddress(Handle)
	WaterAddress := GetAddress(PID, Base, LoadAddress, LoadFishBiteWaterOffsets)
	Sleep 200
	LavaAddress := GetAddress(PID, Base, LoadAddress, LoadFishBiteLavaOffsets)
	ChocoAddress := GetAddress(PID, Base, LoadAddress, LoadFishBiteChocoOffsets)
	Sleep 200
	GetFishingStateWaterAddress := GetAddress(PID, Base, LoadAddress, LoadLiquidTypeWaterOffsets)
	GetFishingStateLavaAddress := GetAddress(PID, Base, LoadAddress, LoadLiquidTypeLavaOffsets)
	Sleep 200
	GetFishingStateChocoAddress := GetAddress(PID, Base, LoadAddress, LoadLiquidTypeChocoOffsets)
	
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
	
	BotList.Insert(Array(PID ,Handle, Base, WaterAddress, LavaAddress, ChocoAddress, StartTime, LastReelCast, GetFishingStateWaterAddress, GetFishingStateLavaAddress, GetFishingStateChocoAddress , DetectedLiquidType, "0", "0", LoginName, "0", "0"))

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
	FormatTime, FishingStartTime, StartTime, dd.MM.yyyy HH:mm:ss
	ModifyListView("FishingList", LoginName, 2, FishingStartTime)
	ModifyListView("FishingList", LoginName, 4, LiquidType)
	ModifyListView("FishingList", LoginName, 5, "Fishing")
	ModifyListView("FishingList", LoginName, 6, "Unknown")
	log("Fishing started for " . LoginName, LogPath)
Return

FishingStopSelected:
	Gui, Main:ListView, FishingList
	; Gui, Main:Submit, Nohide
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
    {
		; SB_SetText("Error: Fail to remove selceted account (See log for details).", 2)
		log("Fail to start fishing on the selected account: you haven't select any account yet.", LogPath)
		; SB_SetText("", 2)
		Return
	}
	LV_GetText(LoginName, FocusedRowNumber, 1)
	
	TotalClientsOnList := BotList.MaxIndex()
	Loop, %TotalClientsOnList%
	{
		if (BotList[a_index, 15] = LoginName)
		{
			log("Stopped fishing for " . BotList[a_index, 15], LogPath)
			BotList.Remove(a_index)
		}
	}
	
	ModifyListView("FishingList", LoginName, 2, "Unknown")
	ModifyListView("FishingList", LoginName, 3, "0")
	ModifyListView("FishingList", LoginName, 4, "Unkown")
	ModifyListView("FishingList", LoginName, 5, "Idle")
	ModifyListView("FishingList", LoginName, 6, "Unknown")
	
	if (TotalClientsOnList = 0)
	{
		CheckSetTimer := 0
		SetTimer, FishBiteMemoryScan, Off
		SetTimer, Recast, Off
		SetTimer, Anti-AFK, Off
	}
Return

FishingSetting:
	Gui, FishingSetting:Show, x180 y0 w380 h380, Fishing Settings
	OnMessage(0x200, "Help")
	
	IniRead, LoadAddress, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
	IniRead, LoadFishBiteWaterOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Water
	IniRead, LoadFishBiteLavaOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Lava
	IniRead, LoadFishBiteChocoOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Choco
	IniRead, LoadLiquidTypeWaterOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Water
	IniRead, LoadLiquidTypeLavaOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Lava
	IniRead, LoadLiquidTypeChocoOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Choco
	IniRead, LoadScanTime, %A_ScriptDir%/data/configs/fishingsystem.ini, TimeBeforeScan, Time
	GuiControl, FishingSetting:, Address, %LoadAddress%
	GuiControl, FishingSetting:, FishBiteWaterOffsets, %LoadFishBiteWaterOffsets%
	GuiControl, FishingSetting:, FishBiteLavaOffsets, %LoadFishBiteLavaOffsets%
	GuiControl, FishingSetting:, FishBiteChocoOffsets, %LoadFishBiteChocoOffsets%
	GuiControl, FishingSetting:, LiquidTypeWaterOffsets, %LoadLiquidTypeWaterOffsets%
	GuiControl, FishingSetting:, LiquidTypeLavaOffsets, %LoadLiquidTypeLavaOffsets%
	GuiControl, FishingSetting:, LiquidTypeChocoOffsets, %LoadLiquidTypeChocoOffsets%
	GuiControl, FishingSetting:, ScanTime, %LoadScanTime%
Return

; Button Setting Save
FishingSettingSave:
	GuiControlGet, Address
	GuiControlGet, FishBiteWaterOffsets
	GuiControlGet, FishBiteLavaOffsets
	GuiControlGet, FishBiteChocoOffsets
	GuiControlGet, LiquidTypeWaterOffsets
	GuiControlGet, LiquidTypeLavaOffsets
	GuiControlGet, LiquidTypeChocoOffsets
	GuiControlGet, ScanTime
	
	IniWrite, %Address%, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
	IniWrite, %FishBiteWaterOffsets%, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Water
	IniWrite, %FishBiteLavaOffsets%, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Lava
	IniWrite, %FishBiteChocoOffsets%, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Choco
	IniWrite, %LiquidTypeWaterOffsets%, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Water
	IniWrite, %LiquidTypeLavaOffsets%, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Lava
	IniWrite, %LiquidTypeChocoOffsets%, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Choco
	IniWrite, %ScanTime%, %A_ScriptDir%/data/configs/fishingsystem.ini, TimeBeforeScan, Time
	
	IniRead, LoadAddress, %A_ScriptDir%/data/configs/fishingsystem.ini, MemoryAddress, Address
	IniRead, LoadFishBiteWaterOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Water
	IniRead, LoadFishBiteLavaOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Lava
	IniRead, LoadFishBiteChocoOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, FishBiteOffsets, Choco
	IniRead, LoadLiquidTypeWaterOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Water
	IniRead, LoadLiquidTypeLavaOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Lava
	IniRead, LoadLiquidTypeChocoOffsets, %A_ScriptDir%/data/configs/fishingsystem.ini, LiquidTypeOffsets, Choco
	IniRead, LoadScanTime, %A_ScriptDir%/data/configs/fishingsystem.ini, TimeBeforeScan, Time

	Gui, FishingSetting:Hide
	MsgBox, 64, Fishing Settings, Settings are successfully saved.
Return

FishingSettingCancel:
	Gui, FishingSetting:Hide
Return

Help:
Return