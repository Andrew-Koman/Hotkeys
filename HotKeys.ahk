#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxHotkeysPerInterval 1000
#SingleInstance Force
SetTitleMatchMode, 2


Tooltip, Script is loaded and running...
Sleep, 500
ToolTip


;reload script
!F5::reload


;OBS Hotkeys
Alt & Numpad0::F23
Alt & Numpad1::F24


;start screensaver
#s::
{
	KeyWait, s, L
	KeyWait, LWin, L
	Run, "C:\Programs\NirCmd\nircmd.exe" screensaver
	return
}

;hibernate
#h::
{
	KeyWait, h, L
	KeyWait, LWin, L
	; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
	; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
	; Parameter #3: Pass 1 instead of 0 to disable all wake events.
	DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
	return
}


;copy and search with DuckDuckGo
^+c::
{
	prevClipboard := Clipboard
	Clipboard := None
	Send, ^c
	ClipWait
	Run, http://www.duckduckgo.com/?q=%Clipboard%
	Clipboard := prevClipboard
	return
}


;	Old context menu shortcut in Windows Explorer (Alt + Right Click)
#IfWinActive, ahk_exe explorer.exe
!RButton::
{
	KeyWait, Alt, L
	KeyWait, RButton, L
	Send, {CtrlDown}{Space}{CtrlUp}
	MouseClick, Left
	Send, {AppsKey}
	return
}

;Add new equation to google doc
#IfWinActive, Google Docs
^e::
{
	Send, {AltDown}i{AltUp}
	Sleep, 100
	Send, e
	return
}