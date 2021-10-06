f_ReadBackSettings_StayHydratedBot(ResetSHB:=0,ResetSUB:=0)
{
	VNI=1.0.0.10
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	IniSections:=[]
	IniSections ["Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				, 	sPathToStartupPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle_setup.PNG"
				,    vDefaultTimeInMinutes_StayHydratedBot: 	45
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				,	sNotifyTitle_StayHydratedBot: "StayHydratedBot"
				, 	sNotifyMessageRemember_StayHydratedBot: "Remember to stay hydrated"
				,	sNotifyMessagePause_StayHydratedBot: "Pausing StayHydratedBot"
				,	sNotifyMessageResume_StayHydratedBot: "Resuming StayHydratedBot"
				, 	bNotifyIcons: 1
				, 	lIsIntrusive_StayHydratedBot: 0
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
	IniSections ["Backup Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				, 	sPathToStartupPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle_setup.PNG"
				,    vDefaultTimeInMinutes_StayHydratedBot: 	90
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				,	sNotifyTitle_StayHydratedBot: "StayHydratedBot"
				, 	sNotifyMessageRemember_StayHydratedBot: "Remember to stay hydrated"
				,	sNotifyMessagePause_StayHydratedBot: "Pausing StayHydratedBot"
				,	sNotifyMessageResume_StayHydratedBot: "Resuming StayHydratedBot"
				, 	bNotifyIcons: 1
				, 	lIsIntrusive_StayHydratedBot: 0
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
	IniSections ["Original Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sPathToNotifyPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				, 	sPathToStartupPicture_StayHydratedBot: "A_ScriptDir\GeneralHealthBots\WaterBottle_setup.PNG"
				,    vDefaultTimeInMinutes_StayHydratedBot: 	45
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				,	sNotifyTitle_StayHydratedBot: "StayHydratedBot"
				, 	sNotifyMessageRemember_StayHydratedBot: "Remember to stay hydrated"
				,	sNotifyMessagePause_StayHydratedBot: "Pausing StayHydratedBot"
				,	sNotifyMessageResume_StayHydratedBot: "Resuming StayHydratedBot"
				, 	bNotifyIcons: 1
				, 	lIsIntrusive_StayHydratedBot: 0
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
	
	
	IniSections ["Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFileUp_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sFullFilePathToAudioFileDown_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-02.mp3"
				, 	sPathToNotifyPicture_StandUpBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StandUpBot: 	30
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	sNotifyTitle_StandUpBot: "StandUpBot"
				,	sNotifyMessageUp_StandUpBot: "Remember to stand up."
				,	sNotifyMessageDown_StandUpBot: "Remember to sit down."
				,	sNotifyMessagePause_StandUpBot: "Pausing StandUpBot"
				,	sNotifyMessageResume_StandUpBot: "Resuming StandUpBot"
				, 	bStandingPosition: 0
				, 	vAllowedTogglesCount: 3
				, 	bNotifyIcons: 1
				, 	lIsIntrusive_StandUpBot: 0
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
	IniSections ["Backup Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFileUp_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sFullFilePathToAudioFileDown_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-02.mp3"
				, 	sPathToNotifyPicture_StandUpBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StandUpBot: 	60
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	sNotifyTitle_StandUpBot: "StandUpBot"
				,	sNotifyMessageUp_StandUpBot: "Remember to stand up."
				,	sNotifyMessageDown_StandUpBot: "Remember to sit down."
				,	sNotifyMessagePause_StandUpBot: "Pausing StandUpBot"
				,	sNotifyMessageResume_StandUpBot: "Resuming StandUpBot"
				, 	bStandingPosition: 0
				, 	vAllowedTogglesCount: 3
				, 	bNotifyIcons: 1
				, 	lIsIntrusive_StandUpBot: 0
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
	IniSections ["Original Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFileUp_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-01a.mp3"
				, 	sFullFilePathToAudioFileDown_StandUpBot: 	"A_ScriptDir\GeneralHealthBots\beep-02.mp3"
				, 	sPathToNotifyPicture_StandUpBot: "A_ScriptDir\GeneralHealthBots\WaterBottle.PNG"
				,    vDefaultTimeInMinutes_StandUpBot: 	90
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	sNotifyTitle_StandUpBot: "StandUpBot"
				,	sNotifyMessageUp_StandUpBot: "Remember to stand up."
				,	sNotifyMessageDown_StandUpBot: "Remember to sit down."
				,	sNotifyMessagePause_StandUpBot: "Pausing StandUpBot"
				,	sNotifyMessageResume_StandUpBot: "Resuming StandUpBot"
				, 	bStandingPosition: 0
				, 	vAllowedTogglesCount: 3
				, 	bNotifyIcons: 1
				, 	lIsIntrusive_StandUpBot: 0
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
	CheckFilePathIniRead=%A_ScriptDir%\GeneralHealthBots\%FileNameIniRead%
	if FileExist(CheckFilePathIniRead) ; read back settings from IniFile
	{
		if ResetSHB
		{
			IniObj:=f_ReadINI_Bots(FileNameIniRead) ; this does work
			IniObj["Settings StayHydratedBot"]:=IniSections["Settings StayHydratedBot"]
			IniObj["Backup Settings StayHydratedBot"]:=IniSections["Backup Settings StayHydratedBot"]
			IniObj["Original Settings StayHydratedBot"]:=IniSections["Original Settings StayHydratedBot"]
			f_WriteINI_Bots(IniObj,ScriptName)
		}
		if ResetSUB
		{
			IniObj:=f_ReadINI_Bots(FileNameIniRead) ; this does work
			IniObj["Settings StandUpBot"]:=IniSections["Settings StandUpBot"]
			IniObj["Backup Settings StandUpBot"]:=IniSections["Backup Settings StandUpBot"]
			IniObj["Original Settings StandUpBot"]:=IniSections["Original Settings StandUpBot"]
			f_WriteIni_Bots(IniObj,FileNameIniRead) ; this does work
		}
		IniObj:=f_ReadINI_Bots(FileNameIniRead) ; this does work
	}
	Else 							; set default-settings in case ini-file doesn't exist
	{
		f_WriteINI_Bots(IniSections, ScriptName)
		IniObj:=f_ReadINI_Bots(FileNameIniRead) ; this works
	}
	return IniObj
}

