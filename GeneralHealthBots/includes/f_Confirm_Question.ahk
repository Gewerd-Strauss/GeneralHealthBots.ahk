f_Confirm_Question(Question,AU,VN,BttnYes:="Yes",BttnNo:="No")
{
	VNI=1.0.0.3
	Gui, cQ: new
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, cQ: Margin, 16, 16
	Gui, cQ: +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	cBackground := "c" . "1d1f21"
	cCurrentLine := "c" . "282a2e"
	cSelection := "c" . "373b41"
	cForeground := "c" . "c5c8c6"
	cComment := "c" . "969896"
	cRed := "c" . "cc6666"
	cOrange := "c" . "de935f"
	cYellow := "c" . "f0c674"
	cGreen := "c" . "b5bd68"
	cAqua := "c" . "8abeb7"
	cBlue := "c" . "81a2be"
	cPurple := "c" . "b294bb"
	Gui, cQ: Color, 1d1f21, 373b41, 
	Gui, cQ: Font, s11 cWhite, Segoe UI 
	Gui, cQ: add, text,xm ym, %Question%
	Gui, cQ: add, button, xm+20 ym+50 w30 gConfirmQuestion_f_ConfirmQuestion, &%BttnYes%
	Gui, cQ: add, button, xm+170 ym+50 w30 gDenyQuestion_f_ConfirmQuestion, &%BttnNo%
	Gui, cQ: Font, s7 cWhite, Verdana
	Gui, cQ: Add, Text,x25, Version: %VN%	Author: %AU% 
	yc:=0
	xc:=0
	yc:=A_ScreenHeight-200
	xc:=A_ScreenWidth-300
	Gui, cQ: show,autosize  x%xc% y%yc%, CQ%A_ThisLabel%
	WinGetPos,,,Width,Height,CQ%A_ThisLabel%
	NewXGui:=A_ScreenWidth-Width
	NewYGui:=A_ScreenHeight-Height
	Gui, cQ: show,autosize  x%NewXGui% y%NewYGui%, CQ%A_ThisLabel%
	Gui, cQ: show,autosize, CQ%A_ThisLabel%
	winactivate, CQ
	sleep, 200	
	WinWaitClose, CQ%A_ThisLabel%
	return answer
	
	GuiEscape_ConfirmQuestion_f_ConfirmQuestion:
	Gui, cQ: destroy
	pause, off
	return
	
	ConfirmQuestion_f_ConfirmQuestion:
	pause off
	Gui, cQ: submit
	Gui, cQ: destroy
	return answer:=true
	
	DenyQuestion_f_ConfirmQuestion:
	pause off
	Gui, cQ: submit
	Gui, cQ: destroy
	return answer:=false
	
}

