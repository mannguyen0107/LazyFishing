#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Relative
EnvGet, LOCALAPPDATA, LOCALAPPDATA

; Check if the script is run as Admin or not
IF NOT A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

; Showing Loading image.
SplashImage, %A_ScriptDir%/data/img/launcher/loadingstart.png, B, , , loading
WinSet, TransColor, White, loading

; Declares global variables.
#Include %A_ScriptDir%/LFBot/GlobalVariables.ahk
; Creates config files at first launch.
#Include %A_ScriptDir%/LFBot/FirstLaunchCheck.ahk
; GUI creation.
#Include %A_ScriptDir%/LFBot/GUICreation.ahk
; GUI preparation.
#Include %A_ScriptDir%/LFBot/GUIPreperation.ahk

SplashImage, Off

; Show Main GUI.
Gui, Main:Show, x0 y0 h670 w550, LazyFishing v%BotVer%

; Prepare log file.
FormatTime, TimeStamp, A_Now, dd.MM.yyyy-HH:mm:ss
StringReplace, LogTimeStamp, TimeStamp, :, ., 1
LogPath := % A_ScriptDir . "\data\log\" . LogTimeStamp . ".txt"
log("Started LazyFishing Bot v" . BotVer, TimeStamp, LogPath)
Return

; -------------------------------------------------------------------------
; ~Start~ Buttons that don't belong to any tabs.

; Button Clean Log Folder.
CleanLogFolder:
	log("Cleaning log folder.", TimeStamp, LogPath)
	Loop, %A_ScriptDir%\data\log\*
	{
		CurrentLogFileName := LogTimeStamp . ".txt"
		if (A_LoopFileName = CurrentLogFileName)
		{
			Continue
		}
		else
		{
			FileDelete, %A_ScriptDir%\data\log\%A_LoopFileName%
		}
	}
	log("Log folder is cleaned.", TimeStamp, LogPath)
Return

; Button Donate.
Donate:
	Run, https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HKA9MDHXMQ7HS , , Max
Return
; ~End~ Buttons that don't belong to any tabs.
; -------------------------------------------------------------------------


; Login Tab
#Include %A_ScriptDir%/LFBot/Tab_LoginBot.ahk
; Fishing Tab
#Include %A_ScriptDir%/LFBot/Tab_FishingBot.ahk
; Boot/Decons Tab
#Include %A_ScriptDir%/LFBot/Tab_BootDeconsBot.ahk
; Misc Tab
#Include %A_ScriptDir%/LFBot/Tab_Misc.ahk


; Misc Functions.
#Include %A_ScriptDir%/LFBot/Functions_Misc.ahk
#Include %A_ScriptDir%/LFBot/Functions_Memory.ahk


MainGuiClose:
ExitApp