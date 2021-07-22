f_TrayIconSingleClickCallBack(wParam, lParam)
{ ; taken from https://autohotkey.com/board/topic/26639-tray-menu-show-gui/
	VNI:=1.0.1.13
	if (lParam = 0x201) ; WM_LBUTTONDOWN
	{
		menu, tray, show
		return 0
	}
}