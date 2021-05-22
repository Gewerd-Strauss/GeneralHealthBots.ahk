f_ReadBackSettings_StayHydratedBot()
{
	VNI=1.0.0.9
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	
	CheckFilePathIniRead=%A_ScriptDir%\GeneralHealthBots\%FileNameIniRead%
	/* DONE?
		Date: 16 Mai 2021 09:15:33: Figure out how you want userconfirmation to  be
		performed.  rewrite the gui for the settings edit to contain all six to nine
		fields per bot << prefer this version, as it is MUCH simpler.  	 or rename all
		sections into "A"/"B"/"C", then just make a button to set which one is actively
		loaded. ? this is the more versatile, albeit more complex version because it
		requires more extensive rewrites across the entire file (or, on rewrite replace
		the )
	*/
	if FileExist(CheckFilePathIniRead) ; read back settings from IniFile
		IniObj := f_ReadINI_Bots(FileNameIniRead) ; this does work
	Else 							; set default-settings in case ini-file doesn't exist
	{
		IniSections:=[]
		IniSections ["Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StayHydratedBot: 	45
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				,	sNotifyTitle_StayHydratedBot: "StayHydratedBot (~˘▾˘)~"
				, 	sNotifyMessageRemember_StayHydratedBot: "Remember to stay hydrated"
				,	sNotifyMessagePause_StayHydratedBot: "Pausing StayHydratedBot"
				,	sNotifyMessageResume_StayHydratedBot: "Resuming StayHydratedBot"
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
		IniSections ["Backup Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StayHydratedBot: 	90
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				,	sNotifyTitle_StayHydratedBot: "StayHydratedBot (~˘▾˘)~"
				, 	sNotifyMessageRemember_StayHydratedBot: "Remember to stay hydrated"
				,	sNotifyMessagePause_StayHydratedBot: "Pausing StayHydratedBot"
				,	sNotifyMessageResume_StayHydratedBot: "Resuming StayHydratedBot"
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
		IniSections ["Original Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StayHydratedBot: 	45
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				,	sNotifyTitle_StayHydratedBot: "StayHydratedBot (~˘▾˘)~"
				, 	sNotifyMessageRemember_StayHydratedBot: "Remember to stay hydrated"
				,	sNotifyMessagePause_StayHydratedBot: "Pausing StayHydratedBot"
				,	sNotifyMessageResume_StayHydratedBot: "Resuming StayHydratedBot"
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
		
		
		IniSections ["Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFile_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StandUpBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StandUpBot: 	90
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	sNotifyTitle_StandUpBot: "StandUpBot \ (•◡•) /"
				,	sNotifyMessageUp_StandUpBot: "Remember to stand up."
				,	sNotifyMessageDown_StandUpBot: "Remember to sit down."
				,	sNotifyMessagePause_StandUpBot: "Pausing StandUpBot"
				,	sNotifyMessageResume_StandUpBot: "Resuming StandUpBot"
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
		IniSections ["Backup Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFile_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StandUpBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StandUpBot: 	120
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	sNotifyTitle_StandUpBot: "StandUpBot \ (•◡•) /"
				,	sNotifyMessageUp_StandUpBot: "Remember to stand up."
				,	sNotifyMessageDown_StandUpBot: "Remember to sit down."
				,	sNotifyMessagePause_StandUpBot: "Pausing StandUpBot"
				,	sNotifyMessageResume_StandUpBot: "Resuming StandUpBot"
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
		IniSections ["Original Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFile_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StandUpBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StandUpBot: 	90
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	sNotifyTitle_StandUpBot: "StandUpBot \ (•◡•) /"
				,	sNotifyMessageUp_StandUpBot: "Remember to stand up."
				,	sNotifyMessageDown_StandUpBot: "Remember to sit down."
				,	sNotifyMessagePause_StandUpBot: "Pausing StandUpBot"
				,	sNotifyMessageResume_StandUpBot: "Resuming StandUpBot"
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
		f_WriteINI_Bots(IniSections, ScriptName)
		IniObj:=f_ReadINI_Bots(FileNameIniRead) ; this works
		;IniObj["Backup Settings StayHydratedBot"]:=IniObj["Settings StayHydratedBot"].clone()	;; cf above for explanation
		; IniObj["Original Settings StayHydratedBot"]:=IniObj["Settings StayHydratedBot"].clone()
		;IniObj["Backup Settings StandUpBot"]:=IniObj["Settings StandUpBot"].clone()	;; cf above for explanation 	; as I am starting with two different sets out by default, I no longer have to duplicate one set of settings
		; IniObj["Original Settings StandUpBot"]:=IniObj["Settings StandUpBot"].clone()
		; f_WriteINI_Bots(IniObj, ScriptName)		; super redundant, I will have to redo this once again. 
		
		
	}
	return IniObj
}
