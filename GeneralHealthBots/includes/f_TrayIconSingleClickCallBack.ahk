f_TrayIconSingleClickCallBack(wParam, lParam)
{ ; taken from https://autohotkey.com/board/topic/26639-tray-menu-show-gui/
	VNI:=1.0.3.12
	; 0x201 WM_LBUTTONDOWN
	; 0x202 WM_LBUTTONUP
	if (lParam = 0x202)
	{
		menu, tray, show
		return 0
	}
}