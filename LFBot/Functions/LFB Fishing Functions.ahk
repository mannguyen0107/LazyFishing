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
			LV_Add("", A_LoopFileName, "Unknown", "0", "Unknown", "Idle", "Unknown")
		}
	}
	Return
}

GetAddress(PID, Base, Address, Offset)  
{
	pointerBase := Base + Address
	y := ReadMemory(PID, pointerBase)       
	OffsetSplit := StrSplit(Offset, "+")
	OffsetCount := OffsetSplit.MaxIndex()
	Loop, %OffsetCount%
	{
		if (a_index = OffsetCount) 
		{
			Address := (y + OffsetSplit[a_index])
		} 
		else
		{
			if(a_index = 1) {
				y := ReadMemory(PID, y + OffsetSplit[a_index])
			} 
			else 
			{
				y := ReadMemory(PID, y + OffsetSplit[a_index])
			}
			 
		}
	}
	Return Address
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

Help() {
	ToolTip 

	CurrControl := A_GuiControl 

	IfEqual, CurrControl, FishingSettingHelp1
	{
		Help := "This is the fishing base address this address will change everytime`nTrove update. Thus everytime Trove update please go onto the forum`nto check for new address."
	}
	else IfEqual, CurrControl, FishingSettingHelp2
	{
		Help := "This is the time before the checking for fishing bite start. It is`nused for reduce CPU usage purpose. Default: 12 seconds"
	}
	else IfEqual, CurrControl, FishingSettingHelp3
	{
		Help := "This is the offset for checking fish bite in water. It might or`nmight not changes when Trove update. Hence, please check`nthe forum for more info."
	}
	else IfEqual, CurrControl, FishingSettingHelp4
	{
		Help := "This is the offset for checking fish bite in lava. It might or`nmight not changes when Trove update. Hence, please check`nthe forum for more info."
	}
	else IfEqual, CurrControl, FishingSettingHelp5
	{
		Help := "This is the offset for checking fish bite in Chocolate. It might`nor might not changes when Trove update. Hence, please check`nthe forum for more info."
	}
	else IfEqual, CurrControl, FishingSettingHelp6
	{
		Help := "This is the offset for checking fishing in water. It might or`nmight not changes when Trove update. Hence, please check`nthe forum for more info."
	}
	else IfEqual, CurrControl, FishingSettingHelp7
	{
		Help := "This is the offset for checking fishing in lava. It might or`nmight not changes when Trove update. Hence, please check`nthe forum for more info."
	}
	else IfEqual, CurrControl, FishingSettingHelp8
	{
		Help := "This is the offset for checking fishing in Chocolate. It might`nor might not changes when Trove update. Hence, please check`nthe forum for more info."
	}

	ToolTip % Help
	
	Return
}