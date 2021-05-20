f_Confirm_Question(Question,AU,VN)
{
	m("this is triggerrd")
	;f_ToggleOffAllGuiHotkeys()
	gui, cQ: new
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	gui, cQ: Margin, 16, 16
	gui, cQ: +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
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
	gui, cQ: add, text,xm ym, %Question%
	gui, cQ: add, button, xm+20 ym+50 w30 gConfirmQuestion_f_ConfirmQuestion, Yes
	gui, cQ: add, button, xm+170 ym+50 w30 gDenyQuestion_f_ConfirmQuestion, No
	Gui, cQ: Font, s7 cWhite, Verdana
	Gui, cQ: Add, Text,x25, Version: %VN%	Author: %AU% 
	Hotkey, Escape, GuiEscape_ConfirmQuestion_f_ConfirmQuestion,On
	gui, cQ: show,, CQ
	loop, 5
	{
		sleep, 200
		winactivate, CQ
	}
	;winactivate CQ
	;pause
	m(answer)
	return answer
	GuiEscape_ConfirmQuestion_f_ConfirmQuestion:
	gui, cQ: destroy
	Hotkey, Escape, GuiEscape_ConfirmQuestion_f_ConfirmQuestion,Off
	return
	
	ConfirmQuestion_f_ConfirmQuestion:
	gui, cQ: submit
	gui, cQ: destroy
	Hotkey, Escape, GuiEscape_ConfirmQuestion_f_ConfirmQuestion,Off
	
	pause off
	return answer:=true
	
	DenyQuestion_f_ConfirmQuestion:
	gui, cQ: submit
	gui, cQ: destroy
	Hotkey, Escape, GuiEscape_ConfirmQuestion_f_ConfirmQuestion,Off
	Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,On
	Hotkey, Esc, GuiEscape_StayHydratedBot,On
	pause off
	return answer:=false
	
}


