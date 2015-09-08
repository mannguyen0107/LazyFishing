#SingleInstance Off ; The word OFF allows multiple instances of the script to run concurrently.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#WinActivateForce
SetKeyDelay, 0, 2

IF NOT A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

IniRead, LoadAddress, %A_ScriptDir%/data/configs/fishingconfig.ini, Memory, Address

IniRead, PID, %A_ScriptDir%/data/savedlogins/%1%/%1%.ini, PID, PID
IniRead, Handle, %A_ScriptDir%/data/savedlogins/%1%/%1%.ini, Handle, Handle

IniRead, Break, %A_ScriptDir%/data/configs/fishingconfig.ini, Break, Break
; IniRead, GetChangeName, %A_ScriptDir%/data/configs/launcherconfig.ini, Game Window, ChangeName

; if (GetChangeName = "Yes")
; {
	; WinGetTitle, Title, ahk_pid %PID%
	; Menu, tray, Tip, %Title%
; }

Base := getProcessBaseAddress()
WaterAddress := GetAddressWater(PID, Base, LoadAddress) 
LavaAddress := GetAddressLava(PID, Base, LoadAddress) 
ChocoAddress := GetAddressChoco(PID, Base, LoadAddress)
StateWaterAddress := GetFishingStateWaterAddress(PID, Base, Address)
StateLavaAddress := GetFishingStateLavaAddress(PID, Base, Address)
StateChocoAddress := GetFishingStateChocoAddress(PID, Base, Address)

Loop
{
    IniRead, Break, %A_ScriptDir%/data/configs/fishingconfig.ini, Break, Break
	if (Break = 1)
	{
		break 
	}
	
	HumanPressButton("f", PID)
	Timer := 0 
       
	While Timer = 0
	{
		Loop   
		{
			CaughtWater := ReadMemory(PID, WaterAddress)
			CaughtLava := ReadMemory(PID, LavaAddress)
			CaughtChoco := ReadMemory(PID, ChocoAddress)
			If (CaughtWater = 1 or CaughtLava = 1 or CaughtChoco = 1)
			{
				HumanPressButton("f", PID)
				RandomSleep(500, 1500)
				Break
			}
			if Timer >= 45
			{
				StateWater := ReadMemory(PID, StateWaterAddress)
				StateLava := ReadMemory(PID, StateLavaAddress)
				StateChoco := ReadMemory(PID, StateChocoAddress)
				If (StateWater = 1 or StateLava = 1 or StateChoco = 1)
				{
					HumanPressButton("f", PID)
					break
				}
				else
				{
					break
				}
			}
			Sleep, 1000
			Timer++
		}
	}
	Timer := 0
   
	IniRead, GetSessionTime, %A_ScriptDir%/data/configs/fishingconfig.ini, Time Between Session, FishingSessionDelay
	Sleep, %GetSessionTime%
}
ExitApp

HumanSleep() {
	Random, SleepTime, 66, 122
	Sleep, %SleepTime%
}

HumanPressButton(hpbtn, hppid)
{
    ControlSend, , {%hpbtn% down}, ahk_pid %hppid%
    HumanSleep()
    ControlSend, , {%hpbtn% up}, ahk_pid %hppid%
	HumanSleep()
}

RandomSleep(time1, time2)
{
	Random, SleepTime, %time1%, %time2%
    Sleep, %SleepTime%
}

GetAddressWater(PID, Base, Address)
{
    pointerBase := base + Address
    y1 := ReadMemory(PID, pointerBase)
    y2 := ReadMemory(PID, y1 + 0x144)
    y3 := ReadMemory(PID, y2 + 0xe4)
    Return WaterAddress := (y3 + 0x70)   
}

GetAddressLava(PID, Base, Address)
{
	pointerBase := base + Address
	y1 := ReadMemory(PID, pointerBase)
	y2 := ReadMemory(PID, y1 + 0x144)
	y3 := ReadMemory(PID, y2 + 0xe4)
	Return LavaAddress := (y3 + 0x514) 
}

GetAddressChoco(PID, Base, Address)
{
	pointerBase := base + Address
	y1 := ReadMemory(PID, pointerBase)
	y2 := ReadMemory(PID, y1 + 0x144)
	y3 := ReadMemory(PID, y2 + 0xe4)
	Return ChocoAddress := (y3 + 0x2c0)
}  

GetFishingStateWaterAddress(PID, Base, Address)
{
 pointerBase := base + Address
 y1 := ReadMemory(PID, pointerBase)
 y2 := ReadMemory(PID, y1 + 0x5d8)
 y3 := ReadMemory(PID, y2 + 0x7d4)
 Return FishingStateWater := (y3 + 0x5a0)
}
 
GetFishingStateChocoAddress(PID, Base, Address)
{
 pointerBase := base + Address
 y1 := ReadMemory(PID, pointerBase)
 y2 := ReadMemory(PID, y1 + 0x5d8)
 y3 := ReadMemory(PID, y2 + 0x7d8)
 Return FishingStateChoco := (y3 + 0x684)
}
 
GetFishingStateLavaAddress(PID, Base, Address)
{
 pointerBase := base + Address
 y1 := ReadMemory(PID, pointerBase)
 y2 := ReadMemory(PID, y1 + 0x5d8)
 y3 := ReadMemory(PID, y2 + 0x7d8)
 Return FishingStateLava := (y3 + 0x1e4)
}

getProcessBaseAddress()
{
	Global Handle
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
	;DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",4,"UInt *",0)
	DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", MADDRESS, "Ptr", &MVALUE, "Uint",4)
	Loop 4
		result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
	return, result
}
