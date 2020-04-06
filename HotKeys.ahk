#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;setup
enableGoodbye := -1
msg := ""
msg2 := ""
onOff := ""

SetRegView 64
RegRead, enableGoodbye, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon, EnableGoodbye

if(enableGoodbye == 0){
	onOff := "OFF"
}
else if(enableGoodbye == 1){
	onOff := "ON"
}
else{
	onOff := "ERROR!"
}

;Media controls with USB mouse
^!WheelUp::Send {Volume_Up}
^!WheelDown::Send {Volume_Down}
^!MButton::Send {Media_Play_Pause}
^!XButton2::Send {Media_Next}
^!XButton1::Send {Media_Prev}



;Media Downloader

;now supports custom file name

DestinationFolder := "C:\users\Andrew\Documents" ;default destination
MediaType := "None"

^!d::
{
	clipboard := ""
	Send, {F6}
	Sleep, 100
	Send, {Ctrl down}c{Ctrl up}
	ClipWait
	Send,{Alt}{Ctrl}d
	Send, {Esc}
	Send, {Esc}
	
}
+^!d::
{
	url := clipboard
	setName = 0
	newName := ""
	Gui, New, , Select Media Type
	Gui -MaximizeBox -MinimizeBox +Owner
	
	Gui, Add, Text,,Select the type of media to download:
	Gui, Add, ListBox, Choose1 x10 vMediaType, Video and Audio|Audio Only|Video Only
	
	Gui, Add, Text, x10 y80, Location where the media will be saved:
	Gui, Add, Button, x275 w60 y75, Browse
	
	Gui, Font,s8 , Courier New
	Gui, Add, Text, w330 r3 x10 vPathLbl, %DestinationFolder%

	Gui, Font
	
	
	Gui, Add, CheckBox, x10 y150 gchkb vsetName, Change the output name:
	
	Gui, Add, Text, vnewName_title, File Name:
	Gui, Add, Edit, vnewName
	
	guicontrol, Show%setName%, newName_title
	guicontrol, Show%setName%, newName
	
	
	Gui, Add, Button, Default w60 x60 y250, OK
	Gui, Add, Button, w60 x225 y250, Cancel
	
	Gui, Show
	;Gui, Show, w350 h220
	return
	
	
	chkb: 
	gui, submit, nohide
	guicontrol, Show%setName%, newName_title
	guicontrol, Show%setName%, newName 
	return

	ButtonBrowse:
	FileSelectFolder, DestinationFolder, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
	GuiControl, Text, PathLbl, %DestinationFolder%
	return
	
	GuiEscape:
	GuiClose:
	ButtonCancel:
	Gui, Destroy
	return
	
	ButtonOK:
	Gui, Submit
	
	if (setName == 0){
		if(MediaType = "Audio Only"){
			Run, youtube-dl -f bestaudio --extract-audio --audio-format m4a --audio-quality 0 -o ""`%(title)s.`%(ext)s"" %url%, %DestinationFolder%, ,
		}
		else if(MediaType = "Video and Audio"){
			Run, youtube-dl -f bestvideo[ext!=webm]‌​+bestaudio[ext!=webm]‌​/best[ext!=webm] -o ""`%(title)s.`%(ext)s"" %url%, %DestinationFolder%, ,
		}
		else if(MediaType = "Video Only"){
			Run, youtube-dl -f bestvideo[ext!=webm]/best[ext!=webm] -o ""`%(title)s.`%(ext)s"" %url%, %DestinationFolder%, ,
		}
	}
	else{
		if(MediaType = "Audio Only"){
			Run, youtube-dl -f bestaudio --extract-audio --audio-format m4a --audio-quality 0 -o ""%newName%.`%(ext)s"" %url%, %DestinationFolder%, ,
		}
		else if(MediaType = "Video and Audio"){
			Run, youtube-dl -f bestvideo[ext!=webm]‌​+bestaudio[ext!=webm]‌​/best[ext!=webm] -o ""%newName%.`%(ext)s"" %url%, %DestinationFolder%, ,
		}
		else if(MediaType = "Video Only"){
			Run, youtube-dl -f bestvideo[ext!=webm]/best[ext!=webm] -o ""%newName%.`%(ext)s"" %url%, %DestinationFolder%, ,
		}
	}
	return
}

;Toggle Dynamic Lock with {Ctrl} Power Button

^~SC176::
{
	;4, 262144
	MsgBox, 262148, Dynamic Lock, Dynamic Lock is currently %onOFf%`nToggle Dynamic Lock?
	IfMsgBox No
		return
	
	RegRead, enableGoodbye, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon, EnableGoodbye
	if(enableGoodbye == 0){
		onOff := "ON"
		RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon, EnableGoodbye, 1
		msg := "Dynamic Lock"
		msg2 := "ENABLED`n`nWait for phone to connect..."
	}
	else if(enableGoodbye == 1){
		onOff := "OFF"
		RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon, EnableGoodbye, 0
		msg := "Dynamic Lock"
		msg2 := "DISABLED"
	}
	else{
		msg := "ERROR!"
		msg2 := "ERROR!"
	}
	SplashTextOn, 200, 75, %msg%, %msg2%
	Sleep 3000
	SplashTextOff
}
return





;Double press power button to open Acer Power Button application, something that should be native
~SC176::
if (A_PriorHotkey <> "~SC176" or A_TimeSincePriorHotkey > 500)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, SC176
    return
}
Run "C:\Program Files\Acer\Acer Quick Access\ePowerButton_NB.exe"
return

;Allow <Esc> to close the Acer Power Button aplication
#IfWinActive Acer Power Button
Escape::Send, !{F4}

;Do not add blow here ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------