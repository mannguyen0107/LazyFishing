PB_PushDelete(PB_Token)
{
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.SetProxy(0)
	WinHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", 0)
	WinHTTP.SetCredentials(PB_Token, "", 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	WinHTTP.Send()
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
	return Status
}

PB_PushNote(PB_Token, PB_Title, PB_Message)
{
	StringReplace, PB_Message, PB_Message, `n, \n, All
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.SetProxy(0)
	WinHTTP.Open("POST", "https://api.pushbullet.com/v2/pushes", 0)
	WinHTTP.SetCredentials(PB_Token, "", 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	PB_Body := "{""type"": ""note"", ""title"": """ PB_Title """, ""body"": """ PB_Message """}"
	WinHTTP.Send(PB_Body)
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
	return Status
}

PB_Result(Mode, Result)
{
	Global TimeStamp
	Global LogPath
	if (Result = 200)
	{
		if (Mode = "Delete")
		{
			log("Successful delete all PushBullet message.", LogPath)
		}
		else
		{
			log("Successful push note to PushBullet.", LogPath)
		}
	}
	else if (Result = 401 OR Result = 403)
	{
		log("Please check your access token again.", LogPath)
	}
	else if (Result > 500)
	{
		log("PushBullet server is not available at the moment.", LogPath)
	}
	return
}