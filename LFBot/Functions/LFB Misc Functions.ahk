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

DeleteListView(ListViewVar, AccountName)
{
	Gui, Main:Default
	Gui, Main:ListView, %ListViewVar%
	Loop % LV_GetCount()
	{
		LV_GetText(RetrievedAccountName, A_Index)
		if InStr(RetrievedAccountName, AccountName)
		{
			LV_Delete(A_Index)
		}
	}
	Return
}

AddFishingListView(Col1, Col2, Col3, Col4, Col5, Col6)
{
	Gui, Main:Default
	Gui, Main:ListView, FishingList
	LV_Add("", Col1, Col2, Col3, Col4, Col5, Col6)
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

log(msg, txtpath)
{
	Gui, Main:Default
	FormatTime, TimeStamp, A_Now, dd.MM.yyyy HH:mm:ss
	FileAppend, ;Text file write
	(
	[%TimeStamp%]: %msg%`n
	), %txtpath%
	GuiControlGet, Console
	GuiControl, Main:, Console, [%TimeStamp%]: %msg%`r`n%Console% ; GUI write
}

getProcessTimes(PID)    
{
    static aPIDs := [], hasSetDebug
    ; If called too frequently, will get mostly 0%, so it's better to just return the previous usage 
    if aPIDs.HasKey(PID) && A_TickCount - aPIDs[PID, "tickPrior"] < 250
        return aPIDs[PID, "usagePrior"] 
    ; Open a handle with PROCESS_QUERY_LIMITED_INFORMATION access
    if !hProc := DllCall("OpenProcess", "UInt", 0x1000, "Int", 0, "Ptr", pid, "Ptr")
        return -2, aPIDs.HasKey(PID) ? aPIDs.Remove(PID, "") : "" ; Process doesn't exist anymore or don't have access to it.
         
    DllCall("GetProcessTimes", "Ptr", hProc, "Int64*", lpCreationTime, "Int64*", lpExitTime, "Int64*", lpKernelTimeProcess, "Int64*", lpUserTimeProcess)
    DllCall("CloseHandle", "Ptr", hProc)
    DllCall("GetSystemTimes", "Int64*", lpIdleTimeSystem, "Int64*", lpKernelTimeSystem, "Int64*", lpUserTimeSystem)
   
    if aPIDs.HasKey(PID) ; check if previously run
    {
        ; find the total system run time delta between the two calls
        systemKernelDelta := lpKernelTimeSystem - aPIDs[PID, "lpKernelTimeSystem"] ;lpKernelTimeSystemOld
        systemUserDelta := lpUserTimeSystem - aPIDs[PID, "lpUserTimeSystem"] ; lpUserTimeSystemOld
        ; get the total process run time delta between the two calls 
        procKernalDelta := lpKernelTimeProcess - aPIDs[PID, "lpKernelTimeProcess"] ; lpKernelTimeProcessOld
        procUserDelta := lpUserTimeProcess - aPIDs[PID, "lpUserTimeProcess"] ;lpUserTimeProcessOld
        ; sum the kernal + user time
        totalSystem :=  systemKernelDelta + systemUserDelta
        totalProcess := procKernalDelta + procUserDelta
        ; The result is simply the process delta run time as a percent of system delta run time
        result := 100 * totalProcess / totalSystem
    }
    else result := -1

    aPIDs[PID, "lpKernelTimeSystem"] := lpKernelTimeSystem
    aPIDs[PID, "lpKernelTimeSystem"] := lpKernelTimeSystem
    aPIDs[PID, "lpUserTimeSystem"] := lpUserTimeSystem
    aPIDs[PID, "lpKernelTimeProcess"] := lpKernelTimeProcess
    aPIDs[PID, "lpUserTimeProcess"] := lpUserTimeProcess
    aPIDs[PID, "tickPrior"] := A_TickCount
    return aPIDs[PID, "usagePrior"] := result 
}
