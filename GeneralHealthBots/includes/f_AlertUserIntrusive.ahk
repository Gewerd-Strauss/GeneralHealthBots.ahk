f_AlertUserIntrusive(AlertText,AU,VN)
{
	VNI=1.0.0.2
	Gui, AlUs: new
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, AlUs: Margin, 16, 16
	Gui, AlUs: +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, AlUs: Color, 1d1f21, 373b41, 
	Gui, AlUs: Font, s11 cWhite, Segoe UI 
	Gui, AlUs: add, text,xm ym, %AlertText%
	Gui, AlUs: Font, s7 cWhite, Verdana
	Gui, AlUs: Add, Text,x25, Version: %VN%	Author: %AU% 
	Gui, AlUs: show,autosize ,AU%A_ThisFunc%
	winactivate, AlUs
	WinWaitClose, AU%A_ThisFunc%
	return
}
