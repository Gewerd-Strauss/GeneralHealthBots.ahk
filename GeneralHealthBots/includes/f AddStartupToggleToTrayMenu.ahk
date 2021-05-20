f_AddStartupToggleToTrayMenu(ScriptName,MenuNameToInsertAt:="Tray")
{
	global startUpDir 
	global MenuNameToInsertAt2
	global bBootSetting
	MenuNameToInsertAt2:=MenuNameToInsertAt
	startUpDir:=("C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" A_ScriptName " - Shortcut.lnk")
	Menu, %MenuNameToInsertAt%, add, Start at Boot, lStartUpToggle
	If FileExist(startUpDir)
	{
		Menu, %MenuNameToInsertAt%, Check, Start at Boot
		bBootSetting:=1
		
	}
	else
	{
		Menu, %MenuNameToInsertAt%, UnCheck, Start at Boot
		bBootSetting:=0
	}
	return
	lStartUpToggle: ; I could really use a better way to know the name of the menu item that was selected
	if !bBootSetting 
	{
		bBootSetting:=1
		FileCreateShortcut, %A_ScriptFullPath%, %startUpDir%
		Menu, %MenuNameToInsertAt2%, Check, Start at Boot
	}
	else if bBootSetting
	{
		bBootSetting:=0
		FileDelete, %startUpDir%
		Menu, %MenuNameToInsertAt2%, UnCheck, Start at Boot
	}
	return
	
	/* Original from Exaskryz: https://www.autohotkey.com/boards/viewtopic.php?p=176247#p176247
		Menu, Tray, UseErrorLevel
		
		If FileExist(startUpDir:=("C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" A_ScriptName " - Shortcut.lnk"))
			Menu, Tray, Add, Remove from StartUp, StartUpToggle
		else
			Menu, Tray, Add, Add to StartUp, StartUpToggle
		GoSub, SkipLabel_StartUp
		return
		
		StartUpToggle: ; I could really use a better way to know the name of the menu item that was selected
; Using now errorlevel to determine if the menu item name exists
		Menu, Tray, Rename, Remove from StartUp, Add to StartUp
		If ErrorLevel ; Remove from StartUp doesn't exist. So Add to StartUp does. So we're adding this script to startup
		{
			FileCreateShortcut, %A_ScriptFullPath%, %startUpDir%
			Menu, Tray, Rename, Add to StartUp, Remove from StartUp
		}
		else ; we successfully renamed the Remove from StartUp, which means that was selected, so we need to remove the script from startup
			FileDelete, %startUpDir%
		return
		
		SkipLabel_StartUp:
		
		
	*/
}