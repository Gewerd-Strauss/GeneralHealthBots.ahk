f_CreateTrayMenu_Bots(IniObj)
{
	VNI=1.0.0.6
	menu, tray, add,
	Menu, Misc, add, Open Script-folder, lOpenScriptFolder
	menu, Misc, Add, Help, lHelp_StayHydratedBot
	menu, Misc, Add, Reload, lReload
	SplitPath, A_ScriptName,,,, ScriptName
	f_AddStartupToggleToTrayMenu(ScriptName,"Misc")
	Menu, tray, add, Miscellaneous, :Misc
	menu, tray, add,
	{
		menu, StayHydratedBot, add, Settings, lEditSettings_StayHydratedBot
		;menu, StayHydratedBot, add, Restart, lRestartBot_StayHydratedBot
		menu, StayHydratedBot, add, Pause, lPause_StayHydratedBot
		menu, StayHydratedBot, add, Set Timer, lSetCurrentDelay_StayHydratedBot
		menu, StayHydratedBot, add, Intrusive, lToggleBotIntrusive_StayHydratedBot
		menu, StayHydratedBot, add, HUD, lToggleBotHUD_StayHydratedBot
		menu, StayHydratedBot, add, Sound, lToggleBotAudio_StayHydratedBot
		menu, Tray, add, StayHydratedBot, :StayHydratedBot
		
		menu, StandUpBot, add, Settings, lEditSettings_StandUpBot
		;menu, StandUpBot, add, Restart, lRestartBot_StandUpBot
		menu, StandUpBot, add, Pause, lPause_StandUpBot
		menu, StandUpBot, add, Set Timer, lSetCurrentDelay_StandUpBot
		menu, StandUpBot, add, Intrusive, lToggleBotIntrusive_StandUpBot
		menu, StandUpBot, add, HUD, lToggleBotHUD_StandUpBot
		menu, StandUpBot, add, Sound, lToggleBotAudio_StandUpBot
		menu, tray, Add, StandUpBot,:StandUpBot
	}
	if IniObj["Settings StayHydratedBot"].bNotifyIcons
		if Instr(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot,"A_ScriptDir")
		{
			if FileExist(A_ScriptDir strreplace(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot,"A_ScriptDir",""))
				sPathToNotifyPicture_StayHydratedBot:=f_ConvertRelativePath(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
		}
	else
		sPathToNotifyPicture_StayHydratedBot:=f_ConvertRelativePath(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
	if FileExist(sPathToNotifyPicture_StayHydratedBot)
		menu, tray, icon, %sPathToNotifyPicture_StayHydratedBot%
	menu, tray, add,
	return
}

