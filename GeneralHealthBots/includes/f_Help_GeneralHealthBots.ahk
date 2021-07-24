f_Help_GeneralHealthBots(AU,VN)
{
	VNI=1.0.1.8
	global GitPageURLComponents
	global LocalValues
	f_DestroyGuis()
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, font, s7 cWhite, Verdana
	Gui, font, s15 cWhite, Segoe UI 
	Gui, add, text,xm ym+10,GeneralHealthBots
	
	Gui, font, Underline s11 cBlue , Segoe UI 
	Gui, add, text, xm ym+40 w212 0x10  ;Horizontal Line > Etched Gray
	Gui, add, text, xm ym+30 w0 ; position the documentation link
	Gui, add, Text, glLinkDocumentation, Documentation
	
	Gui, font, Underline s09 cBlue , Segoe UI 
	Gui, add, text, xm ym+60 w0 ; position the documentation link
	Gui, add, text, glLinkCheckforUpdates, Check for Updates
	
	Gui, font, Underline s09 cBlue , Segoe UI 
	Gui, add, text, xm ym+90 w0 ; position the documentation link
	Gui, add, text, glLinkReportABug,Report a bug
	
	Gui, font,
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,x25, VN: %VN%	Author: %AU% 
	Gui, show,autosize,%A_ThisLabel% ; win_gui_Help_GeneralHealthBots
	return
	lLinkCheckforUpdates:
	{
		f_UpdateRoutine()
		f_DestroyGuis()
	}
	return
	lLinkDocumentation:					;**
	{
		f_DestroyGuis()
		run, https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk
	}
	return
	lLinkReportABug:					;**
	{
		f_DestroyGuis()
		run, https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/issues/new
	}
	return
}

