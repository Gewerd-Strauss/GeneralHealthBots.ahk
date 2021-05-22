f_Help_GeneralHealthBots(AU,VN)
{
	global GitPageURLComponents
	global LocalValues
	VNI=1.0.0.7
	f_ToggleOffAllGuiHotkeys()
	;m("hi tehrer")
	gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, Font, s7 cWhite, Verdana
	Gui, Font, s15 cWhite, Segoe UI 
	gui, add, text,xm ym+10,GeneralHealthBots
	
	Gui, Font, Underline s11 cBlue , Segoe UI 
	gui, add, text, xm ym+40 w212 0x10  ;Horizontal Line > Etched Gray
	gui, add, text, xm ym+30 w0 ; position the documentation link
	Gui, Add, Text, glLinkDocumentation, Documentation
	
	Gui, Font, Underline s09 cBlue , Segoe UI 
	gui, add, text, xm ym+60 w0 ; position the documentation link
	gui, add, text, glLinkCheckforUpdates, Check for Updates
	
	Gui, Font, Underline s09 cBlue , Segoe UI 
	gui, add, text, xm ym+90 w0 ; position the documentation link
	gui, add, text, glLinkReportABug,Report a bug
	
	
	
	gui, font,
	Gui, Font, s7 cWhite, Verdana
	;Hotkey, Esc, GuiEscape_AboutStayHydratedBot,On
	;Hotkey, Enter, GuiEscape_AboutStayHydratedBot, On
	Gui, Add, Text,x25, VN: %VN%	Author: %AU% 
	gui, show,autosize,%A_ThisLabel% ; win_gui_Help_GeneralHealthBots
	return
	lLinkCheckforUpdates:
	{
		f_UpdateRoutine(,,,1)
		gui, destroy
	}
	return
	lLinkDocumentation:					;**
	{
		run, https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk
		gui, destroy
	}
	return
	lLinkReportABug:					;**
	{
		run, https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/issues/new
		gui,destroy
	}
	return
}
