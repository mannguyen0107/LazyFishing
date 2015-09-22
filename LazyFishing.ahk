#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Relative
EnvGet, LOCALAPPDATA, LOCALAPPDATA

; Showing Loading image.
SplashImage, %A_ScriptDir%/data/img/launcher/loadingstart.png, B, , , loading
WinSet, TransColor, White, loading

BotPID := DllCall("GetCurrentProcessId")
SetTimer, CheckCPU, 500

#Include %A_ScriptDir%/LFBot/LFB First Launch.ahk
#Include %A_ScriptDir%/LFBot/LFB Global Variables.ahk
#Include %A_ScriptDir%/LFBot/LFB GUI Design.ahk
#Include %A_ScriptDir%/LFBot/LFB GUI Loading Data.ahk

SplashImage, Off

; Show Main GUI.
Gui, Main:Show, x0 y0 w730 h430, LazyFishing v%BotVer%

; Prepare log file.
FormatTime, LogFileName, A_Now, dd.MM.yyyy-HH.mm.ss
LogPath := % A_ScriptDir . "\data\log\" . LogFileName . ".txt"
log("Started LazyFishing Bot v" . BotVer, LogPath)
return

CheckCPU:
	CPU := Round(GetProcessTimes(BotPID), 1)
	GuiControl, Main:, CPU, %CPU%`%
Return

#Include %A_ScriptDir%/LFBot/LFB Tab Controls.ahk

#Include %A_ScriptDir%/LFBot/LFB Functions.ahk

^+Q::
	Reload
Return

MainGuiClose:
ExitApp