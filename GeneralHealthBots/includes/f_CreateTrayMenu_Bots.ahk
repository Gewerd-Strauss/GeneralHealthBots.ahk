f_CreateTrayMenu_Bots()
{
	VNI=1.0.0.5
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
		menu, StayHydratedBot, add, HUD, lToggleBotHUD_StayHydratedBot
		menu, StayHydratedBot, add, Sound, lToggleBotAudio_StayHydratedBot
		menu, Tray, add, StayHydratedBot, :StayHydratedBot
		
		menu, StandUpBot, add, Settings, lEditSettings_StandUpBot
		;menu, StandUpBot, add, Restart, lRestartBot_StandUpBot
		menu, StandUpBot, add, Pause, lPause_StandUpBot
		menu, StandUpBot, add, Set Timer, lSetCurrentDelay_StandUpBot
		menu, StandUpBot, add, HUD, lToggleBotHUD_StandUpBot
		menu, StandUpBot, add, Sound, lToggleBotAudio_StandUpBot
		menu, tray, Add, StandUpBot,:StandUpBot
	}
	menu, tray, icon, %A_ScriptDir%\GeneralHealthBots\WaterBottle.PNG
	menu, tray, add,
	return
}
