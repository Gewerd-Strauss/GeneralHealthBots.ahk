f_CreateTrayMenu_Bots()
{
	VNI=1.0.0.5
	menu, tray, add,
	menu, Misc, Add, Help, lHelp_StayHydratedBot
	
	SplitPath, A_ScriptName,,,, ScriptName
	f_AddStartupToggleToTrayMenu(ScriptName,"Misc")
	Menu, tray, add, Miscellaneous, :Misc
	;f_AddStartupToggleToTrayMenu(ScriptName,"StayHydratedBot")
	
	menu, tray, add,
	{
		
		menu, StayHydratedBot, Add, Settings, lEditSettings_StayHydratedBot
		menu, StayHydratedBot, Add, Pause, lPause_StayHydratedBot
		menu, StayHydratedBot, Add, Set Timer, lSetCurrentDelay_StayHydratedBot
		menu, StayHydratedBot, Add, HUD, lToggleBotHUD_StayHydratedBot
		menu, StayHydratedBot, Add, Sound, lToggleBotAudio_StayHydratedBot
		menu, Tray, add, StayHydratedBot, :StayHydratedBot
		
		menu, StandUpBot, add, Settings, lEditSettings_StandUpBot
		menu, StandUpBot, add, Pause, lPause_StandUpBot
		menu, StandUpBot, add, Set Timer, lSetCurrentDelay_StandUpBot
		menu, StandUpBot, add, HUD, lToggleBotHUD_StandUpBot
		menu, StandUpBot, add, Sound, lToggleBotAudio_StandUpBot
		menu, tray, Add, StandUpBot,:StandUpBot
	}
	menu, tray, icon, %A_ScriptDir%\WaterBottle.PNG
	menu, tray, add,
	return
}
