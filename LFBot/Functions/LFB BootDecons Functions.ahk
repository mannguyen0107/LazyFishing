BDListReload()
{
	Gui, Main:Default
	Gui, Main:ListView, BDList
	LV_Delete()
	loop, %A_ScriptDir%\data\savedlogins\*, 2
	{
		IniRead, FMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/Fishing.ini, Fishing, Mode
		if (FMode = "On")
		{
			IniRead, BMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/BDMode.ini, Boot, Mode
			IniRead, DMode, %A_ScriptDir%/data/savedlogins/%A_LoopFileName%/BDMode.ini, Decons, Mode
			LV_Add("", A_LoopFileName, BMode, DMode)
		}
	}
	Return
}

Decons(PID)
{
	WinActivate, ahk_pid %PID%
		
	TotalSlot := SelectedSlots.MaxIndex()
	Loop, %TotalSlot%
	{
		if (BDActive = 0)
		{
			return
		}
		if (SelectedSlots[a_index, 1] = 0)
		{
			Continue
		}
		else
		{
			CoordSlotX := SelectedSlots[a_index, 2]
			CoordSlotY := SelectedSlots[a_index, 3]
			MouseClick, Right, CoordSlotX, CoordSlotY
			RandomSleep(250, 500)
		}
	}
	
	IniRead, BtnAcceptX, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptX
	IniRead, BtnAcceptY, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnAcceptY
	IniRead, BtnYesX, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesX
	IniRead, BtnYesY, %A_ScriptDir%/data/configs/bdsystem.ini, DeconsCoord, BtnYesY
		
	WinActivate, ahk_pid %PID%
	;Decons Accept
	Sleep, 1000
	MouseClick, left, BtnAcceptX, BtnAcceptY
		
	;Decons Yes
	Sleep, 1500
	MouseClick, left, BtnYesX, BtnYesY
	
	Return	
}

BootDrop(PID)
{
	WinActivate, ahk_pid %PID%
	
	TotalSlot := SelectedSlots.MaxIndex()
	Loop, %TotalSlot%
	{
		if (BDActive = 0)
		{
			return
		}
		if (SelectedSlots[a_index, 1] = 0)
		{
			Continue
		}
		else
		{
			CoordSlotX := SelectedSlots[a_index, 2]
			CoordSlotY := SelectedSlots[a_index, 3]
			MouseMove, CoordSlotX, CoordSlotY, 15
			RandomSleep(20, 80)
			Send, {Click , CoordSlotX, CoordSlotY, Down}
			RandomSleep(50, 150)
			MouseMove, 155, 115, 15
			RandomSleep(20, 80)
			Send, {Click , 155, 115, Up}
			RandomSleep(600, 1500)
			Click, 180, 140
			RandomSleep(500, 1000)
		}
	}
	
	Return
}

LoadSelectedSlot()
{
	IniRead, GetSelectedSlots, %A_ScriptDir%/data/configs/bdsystem.ini, InventorySlots, SelectedSlots
	LoadSelectedSlots := StrSplit(GetSelectedSlots, "|") 

	Loop, 45
	{
		IniRead, GetBaseX, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseX
		IniRead, GetBaseY, %A_ScriptDir%/data/configs/bdsystem.ini, SlotsCoord, BaseY
		
		BaseX_1 := BaseX_6 := BaseX_11 := BaseX_16 := BaseX_21 := BaseX_26 := BaseX_31 := BaseX_36 := BaseX_41 := GetBaseX
		BaseX_2 := BaseX_7 := BaseX_12 := BaseX_17 := BaseX_22 := BaseX_27 := BaseX_32 := BaseX_37 := BaseX_42 := BaseX_1+13 
		BaseX_3 := BaseX_8 := BaseX_13 := BaseX_18 := BaseX_23 := BaseX_28 := BaseX_33 := BaseX_38 := BaseX_43 := BaseX_2+14 
		BaseX_4 := BaseX_9 := BaseX_14 := BaseX_19 := BaseX_24 := BaseX_29 := BaseX_34 := BaseX_39 := BaseX_44 := BaseX_3+14
		BaseX_5 := BaseX_10 := BaseX_15 := BaseX_20 := BaseX_25 := BaseX_30 := BaseX_35 := BaseX_40 := BaseX_45 := BaseX_4+14 
		
		if (a_index <= 5)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >5 and a_index <= 10)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+13
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >10 and a_index <= 15)
		{
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*2)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >15 and a_index <= 20)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*3)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >20 and a_index <= 25)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*4)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >25 and a_index <= 30)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*5)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >30 and a_index <= 35)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*6)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >35 and a_index <= 40)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*7)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
		else if (a_index >40 and a_index <= 45)
		{	
			BaseX := BaseX_%a_index%
			BaseY := GetBaseY+(13*8)
			SelectedSlots.Insert(Array(LoadSelectedSlots[a_index], BaseX, BaseY))
		}
	}
	
	Loop % SelectedSlots.MaxIndex()
	{
		if (SelectedSlots[a_index, 1] = 0)
		{
			Guicontrol, BDSetting:Hide, Selected%a_index%
		}
		else
		{
			Guicontrol, BDSetting:Show, Selected%a_index%
		}
	}
	Return
}

LoadGUIImgSetSlots()
{
	Global
		Loop, 45
		{
			ImgSlotX_1 := ImgSlotX_6 := ImgSlotX_11 := ImgSlotX_16 := ImgSlotX_21 := ImgSlotX_26 := ImgSlotX_31 := ImgSlotX_36 := ImgSlotX_41 := 41
			ImgSlotX_2 := ImgSlotX_7 := ImgSlotX_12 := ImgSlotX_17 := ImgSlotX_22 := ImgSlotX_27 := ImgSlotX_32 := ImgSlotX_37 := ImgSlotX_42 := ImgSlotX_1+37
			ImgSlotX_3 := ImgSlotX_8 := ImgSlotX_13 := ImgSlotX_18 := ImgSlotX_23 := ImgSlotX_28 := ImgSlotX_33 := ImgSlotX_38 := ImgSlotX_43 := ImgSlotX_2+38
			ImgSlotX_4 := ImgSlotX_9 := ImgSlotX_14 := ImgSlotX_19 := ImgSlotX_24 := ImgSlotX_29 := ImgSlotX_34 := ImgSlotX_39 := ImgSlotX_44 := ImgSlotX_3+38 
			ImgSlotX_5 := ImgSlotX_10 := ImgSlotX_15 := ImgSlotX_20 := ImgSlotX_25 := ImgSlotX_30 := ImgSlotX_35 := ImgSlotX_40 := ImgSlotX_45 := ImgSlotX_4+39
			
			ImgSlotY_Base := 61
			
			if (a_index <= 5)
			{
				ImgSlotX := ImgSlotX_%a_index%
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY_Base + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY_Base% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >5 and a_index <= 10)
			{
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 36
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >10 and a_index <= 15)
			{
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 73
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >15 and a_index <= 20)
			{	
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 110
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >20 and a_index <= 25)
			{	
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 146
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >25 and a_index <= 30)
			{	
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 183
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >30 and a_index <= 35)
			{	
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 219
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >35 and a_index <= 40)
			{	
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 255
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
			else if (a_index >40 and a_index <= 45)
			{	
				ImgSlotX := ImgSlotX_%a_index%
				ImgSlotY := ImgSlotY_Base + 292
				ImgSelectedX := ImgSlotX + 6
				ImgSelectedY := ImgSlotY + 4
				Gui, BDSetting:Add, Picture, x%ImgSlotX% y%ImgSlotY% w31 h31 gSlot%a_index%, %A_ScriptDir%/data/img/inv/slots/%a_index%.png
				Gui, BDSetting:Add, Picture, x%ImgSelectedX% y%ImgSelectedY% w21 h22 BackgroundTrans vSelected%a_index% gSlot%a_index%, %A_ScriptDir%/data/img/inv/tick.png
			}
		}
	Return
}