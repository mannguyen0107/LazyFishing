SDStart:
	SDActive := 1
	GuiControlGet, SDHour
	GuiControlGet, SDMin
	GuiControlGet, SDSec
	GuiControlGet, ShutdownType
	log("Auto shutdown for: " . ShutdownType . " has started.", LogPath)
	
	SDTime = %SDHour%%SDMin%%SDSec%
	IniWrite, %SDTime%, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Time
	IniWrite, %ShutdownType%, %A_ScriptDir%/data/configs/miscsettings.ini, AutoShutdown, Type
	
	SDTimeSec := (SDHour*3600) + (SDMin*60) + SDSec
	SetTimer, SDUpdateOSD, 200
	StartTime := a_now
	EnvAdd, StartTime, SDTimeSec, Seconds
Return

SDUpdateOSD:
	if (SDActive = 0)
	{
		SDTimeSec := 0
		SetTimer, SDUpdateOSD, Off
		GuiControl, Main:, SDCDTime, 00:00:00
	}
	else 
	{
		SDTimeNow := StartTime
		EnvSub, SDTimeNow, %A_Now%, seconds
		GuiControl, Main:, SDCDTime, % FormatSeconds(SDTimeNow)
		If (SDTimeNow <= 0)
		{
			if (ShutdownType = "Trove")
			{
				log("Auto shutdown time's up going to shutdown all Trove window now.", LogPath)
				TotalClientToShutdown := BotList.MaxIndex()
				Loop, %TotalClientsOnList%
				{
					SDPID := BotList[a_index, 1]
					Process, Close, %SDPID%
				}
			}
			else
			{
				log("Auto shutdown time's up going to shutdown your computer now.", LogPath)
				Shutdown, 5
			}
			SetTimer, SDUpdateOSD, Off
		}
	}
Return

SDStop:
	SDActive := 0
	log("Auto shutdown has stopped.", LogPath)
Return

Resize:
	WinGet, ClientList, List, ahk_exe trove.exe
	Loop, %ClientList%
	{	
		WinGet, PID, PID, % "ahk_id" ClientList%A_Index%
		WinMove, ahk_pid %PID%, , , , %ClientWidth%, %ClientHeight%
	}
Return