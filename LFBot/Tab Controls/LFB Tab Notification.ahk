TestToken:
	IniRead, GetToken, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, Token
	PushNote := PB_PushNote(GetToken, "Test Token", "This is a test to see whether your token is correct.")
	PB_Result("Note", PushNote)
Return

NotifySaveSetting:
	GuiControlGet, Token
	GuiControlGet, PBHour
	GuiControlGet, PBMin
	GuiControlGet, PBSec
	GuiControlGet, DelMsgOnStart
	
	PBTime = %PBHour%%PBMin%%PBSec%
	IniWrite, %PBTime%, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, NotifyTime
	IniWrite, %Token%, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, Token
	IniWrite, %DelMsgOnStart%, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, DelMsgOnStart
	IniRead, GetToken, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, Token
	IniRead, GetDelMsgOnStart, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, DelMsgOnStart
	IniRead, GetPBNTime, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, NotifyTime
	
	log("PushBullet settings are successfully saved.", LogPath)
Return

EnableNotify:
	log("PushBullet notification has been enabled.", LogPath)
	GuiControl, Main:Disable, EnableNotify
	
	if (GetDelMsgOnStart = "Yes")
	{
		PushDelete := PB_PushDelete(GetToken)
		PB_Result("Delete", PushDelete)
	}
	
	StringMid, PBTimeH, GetPBNTime, 1, 2
	StringMid, PBTimeM, GetPBNTime, 3, 2
	StringMid, PBTimeS, GetPBNTime, 5, 2
	PBTimeDelay := ((PBTimeH*3600) + (PBTimeM*60) + PBTimeS)*1000
	SetTimer, PushTimeCheck, %PBTimeDelay%
	Gosub, PushNoti
Return

PushTimeCheck:
	Gosub, PushNoti
Return

PushNoti:
	IniRead, GetToken, %A_ScriptDir%/data/configs/notifysystem.ini, PushBullet, Token
	TotalFishingClient := BotList.MaxIndex()
	PB_PushNote(GetToken, "Fishing Report", "You are currently running " . TotalFishingClient . " accounts. Here are their info.")
	Loop, %TotalFishingClient%
	{
		Loop % LV_GetCount()
		{
			LV_GetText(RetrievedName, A_Index)
			if InStr(RetrievedName, BotList[a_index, 15])
			{
				LV_GetText(RetrievedFishingStatus, A_Index, 5)
				Break
			}
		}
		PB_PushNote(GetToken, "Info on " . BotList[a_index, 15], "- Reel-In: " . BotList[a_index, 16] . "`n- Status: " . RetrievedFishingStatus)
	}
Return

DisableNotify:
	GuiControl, Main:Enable, EnableNotify
	SetTimer, PushTimeCheck, Off
	log("PushBullet notification has been disabled.", LogPath)
Return