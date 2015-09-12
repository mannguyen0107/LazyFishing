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