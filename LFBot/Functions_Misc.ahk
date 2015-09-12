ModifyListView(ListViewVar, AccountName, Column, Text)
{
	Gui, Main:Default
	Gui, Main:ListView, %ListViewVar%
	Loop % LV_GetCount()
	{
		LV_GetText(RetrievedAccountName, A_Index)
		if InStr(RetrievedAccountName, AccountName)
		{
			LV_GetText(RetrievedColInfo, A_Index, Column)
			if (RetrievedColInfo != Text)
			{
				LV_Modify(A_Index, "Col" Column, Text)
				Break
			}
		}
	}
	Return
}

FormatSeconds(NumberOfSeconds)  ; Convert the specified number of seconds to hh:mm:ss format.
{
    time = 19990101  ; *Midnight* of an arbitrary date.
    time += %NumberOfSeconds%, seconds
    FormatTime, mmss, %time%, mm:ss
    hours := NumberOfSeconds // 3600 ; This method is used to support more than 24 hours worth of sections.
    hours := hours < 10 ? "0" . hours : hours
    return hours ":" mmss
}

HumanPressButton(hpbtn, hppid)
{
    ControlSend, , {%hpbtn% down}, ahk_pid %hppid%
    HumanSleep()
    ControlSend, , {%hpbtn% up}, ahk_pid %hppid%
	HumanSleep()
}

HumanSleep() {
	Random, SleepTime, 66, 122
	Sleep, %SleepTime%
}

RandomSleep(time1, time2)
{
	Random, SleepTime, %time1%, %time2%
    Sleep, %SleepTime%
}

log(msg, timestamp, txtpath)
{
	FileAppend, ;Text file write
	(
	[%timestamp%]: %msg%`n
	), %txtpath%
	GuiControlGet, Console
	GuiControl, Main:, Console, %Console%[%timestamp%]: %msg%`r`n ; GUI write
	sleep 1000 ; Pause for smooth log scrolling
}