f_Confirm_Question(q,AU,VN, b := "Yes", b2 := "No")
{
	VNI=1.0.1.3
	; thank you u/anonymous1184 for your help in reworking the previous version of this function.
	; https://www.reddit.com/r/AutoHotkey/comments/or8x0z/how_can_i_replace_my_labels_in_a_yesnoescapegui/h6gnlrf?utm_source=share&utm_medium=web2x&context=3
	global f_cQ_Callback := b3
	Gui, cQ: New, -Caption +LastFound +ToolWindow +LabelcQ_ +AlwaysOnTop ; <- this doesn't work
	Gui, cQ: Margin, 16, 16
	Gui, cQ: Color, 1d1f21, 373b41, 
	Gui, cQ: Font, s11 cWhite, Segoe UI 
	Gui, Add, Text, xm ym, % q
	Gui, Add, Button, xm+20  w30 gf_cQ_Callback, &%b%
	Gui, Add, Button, xm+170 yp w30 gf_cQ_Callback, &%b2%
	Gui, cQ: Font, s7 cWhite, Verdana
	Gui, cQ: Add, Text,x25, Version: %VN%	Author: %AU% 
	Gui, Show
	cQ_MoveOffset()
	GuiControl, Focus, %b2%
	SendInput, {Left}{Right}
	WinWaitClose
	;ttip(f_cQ_Callback)
	return {(b):1, (b2):0, (b3):-1}[f_cQ_Callback]
}
f_cQ_Callback()
{
	global f_cQ_Callback := StrReplace(A_GuiControl,"&","")
	Gui, cQ: Destroy
}
cQ_Escape()
{
	Gui, cQ:Destroy
}
cQ_MoveOffset()
{
	yc:=A_ScreenHeight-200
	xc:=A_ScreenWidth-300
	Gui, cQ: show,autosize  x%xc% y%yc%, CQ%A_ThisLabel%
	WinGetPos,,,Width,Height,CQ%A_ThisLabel%
	NewXGui:=A_ScreenWidth-Width
	NewYGui:=A_ScreenHeight-Height
	Gui, cQ: show,autosize  x%NewXGui% y%NewYGui%, CQ%A_ThisLabel%
	Gui, cQ: show,autosize, CQ%A_ThisLabel%
	winactivate, CQ
	return answer
}
