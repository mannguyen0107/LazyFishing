Global SelectedSlots := Object()
LoadSelectedSlot()
WinGet, ClientList, List, ahk_exe trove.exe
Loop, %ClientList%
{	
	WinGet, PID, PID, % "ahk_id" ClientList%A_Index%
	WinGetTitle, ClientTitle, ahk_pid %PID%
	
	IniRead, BMode, %A_ScriptDir%/data/savedlogins/%ClientTitle%/BDMode.ini, Boot, Mode
	IniRead, DMode, %A_ScriptDir%/data/savedlogins/%ClientTitle%/BDMode.ini, Decons, Mode
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
ExitApp

#Include %A_ScriptDir%/LFBot/LFB Functions.ahk