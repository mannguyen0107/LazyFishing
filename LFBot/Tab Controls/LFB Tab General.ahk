CleanLogFolder:
	log("Cleaning log folder.", LogPath)
	Loop, %A_ScriptDir%\data\log\*
	{
		CurrentLogFileName := LogFileName . ".txt"
		if (A_LoopFileName = CurrentLogFileName)
		{
			Continue
		}
		else
		{
			FileDelete, %A_ScriptDir%\data\log\%A_LoopFileName%
		}
	}
	log("Log folder is cleaned.", LogPath)
Return

; Button Read Me.
ReadMe:	
	Run, Notepad.exe %A_ScriptDir%/readme.txt
Return

; Button Donate.
Donate:
	Run, https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HKA9MDHXMQ7HS , , Max
Return