#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines -1
SetTitleMatchMode, 2
;#Persistent
;#Warn All ; Enable warnings to assist with detecting common errors.
;DetectHiddenWindows, On
;SetKeyDelay -1
;{ General Information for file management_____________________________________________
ScriptName=StayHydratedBot  
AU=Gewerd Strauss
VN=2.1.20.4                                                                     
PublicVersionNumber=1.0.0.1
LE=18 Mai 2021 15:47:03                                
;}_____________________________________________________________________________________
vsdb:=true
vUserName:="Gewerd-Strauss"
vProjectName:="GeneralHealthBots.ahk"
vFileName:="StayHydratedBot%20settingsGUI_16.05.2021.ahk"	; added testing stuff so I don't have to use this 
FolderStructIncludesRelativeToMainScript:="GeneralHealthBots/includes/"
FolderStructIniFileRelativeToMainScript:="GeneralHealthBots/StayHydratedBot settingsGUI_16.05.2021.ini"
LocalValues:=[]
GitPageURLComponents:=[]
LocalValues:=[AU,VN,FolderStructIncludesRelativeToMainScript]
GitPageURLComponents:=[vUserName,VProjectName,vFileName,FolderStructIniFileRelativeToMainScript]
;FolderStructIncludesRelativeToMainScript ← needs to be packaged into another array, probably localvalues

;_____________________________________________________________________________________
;_____________________________________________________________________________________

;{#[Autorun Section]
if WinActive(" Visual Studio Code")	; if run in vscode, deactivate notify-messages to avoid crashing the program.
	bRunNotify:=0
else
	bRunNotify:=1 	; otherwise 
bStandingposition:=0	;  0 = start sitting, 1 = start standing
WinSpyPath=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AutoHotkey\Window Spy.lnk
;Run, %WinSpyPath%
/*
	Date: 18 Mai 2021 15:47:46: TODO:  
	1. finish implementation of "other settings" (stuff like checkbox for which bot to natively start is missing) 
	2. separate this file into several include files
	2. refine readme.md to include swap, other settings 3. add subsetting to create verkn?pfung in startup menu, and to remove said verkn?pfung again 
	3. implement updater routine to github, linked to Update in Help-gui: ask on reddit.
*/



/*
	GeneralHealthBots
	repo: https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/
	author: Gewerd Strauss, https://github.com/Gewerd-Strauss
	
	Code by others:	
	WriteINI/ReadINI | wolf_II | adopted from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
	Notify | maestrith | https://github.com/maestrith/Notify
	f_ConvertRelativeWavPath_StayHydratedBot | u/anonymous1184 | https://www.reddit.com/r/AutoHotkey/comments/myti1k/ihatesoundplay_how_do_i_get_the_string_converted/gvwtwlb?utm_source=share&utm_medium=web2x&context=3
	f_ConvertRelativeWavPath_StayHydratedBot | u/anonymous1184 | https://www.reddit.com/r/AutoHotkey/comments/myti1k/ihatesoundplay_how_do_i_get_the_string_converted/gvwtwlb?utm_source=share&utm_medium=web2x&context=3
	
	Code may or may not be heavily edited, in that case the original code has been added as well.
	______
	
	Date: 27 April 2021 13:44:42: TO ADD:  
	
	
	3. clean up the code (by "creating "a 
	data-object to pass around) and pack as much into a function as possible  
	4. Rebuild this into a tripple-purpose timer (SHB, SUB, GRB, in short general) StayHydrated-/StandUp-/GeneralReminder-Bot** 
	** GRB requires extra additional features, to create custom reminder names to run via notify
	
*/

;}_____________________________________________________________________________________
;{ Tray Menu___________________________________________________________________________
f_CreateTrayMenu_Bots()
;}_____________________________________________________________________________________
;{ Load Settings from Ini-File_________________________________________________________

;OnExit("f_OnExit_StayHydratedBot")


; 1. Initialise and load settings
IniObj:=f_ReadBackSettings_StayHydratedBot()
;m(IniObj)
; 2. Extract relevant values

sFullFilePathToAudioFile_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot	; extract values for notify
sNotifyMessagePause_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessagePause_StayHydratedBot
sNotifyMessageRemember_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessageRemember_StayHydratedBot
sNotifyMessageResume_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessageResume_StayHydratedBot
sNotifyTitle_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyTitle_StayHydratedBot
SoundStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"].SoundStatus_StayHydratedBot
sPathToNotifyPicture_StayHydratedBot:=f_ConvertRelativePath(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
vMinutes_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot*1 ; get rid of those pesky quotes. Need to remember this trick ._.
vNotificationTimeInMilliSeconds_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot
HUDStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"].HUDStatus_StayHydratedBot

sFullFilePathToAudioFile_StandUpBot:=IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot	; extract values for notify
sNotifyMessageDown_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageDown_StandUpBot
sNotifyMessagePause_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessagePause_StandUpBot
sNotifyMessageResume_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageResume_StandUpBot
sNotifyMessageUp_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageUp_StandUpBot
sNotifyTitle_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyTitle_StandUpBot
SoundStatus_StandUpBot:=IniObj["Settings StandUpBot"].SoundStatus_StandUpBot
sPathToNotifyPicture_StandUpBot:=f_ConvertRelativePath(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot)
vMinutes_StandUpBot:=IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot
vNotificationTimeInMilliSeconds_StandUpBot:=IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot
HUDStatus_StandUpBot:=IniObj["Settings StandUpBot"].HUDStatus_StandUpBot
if bRunNotify
{
	;d=%A_ScriptDir%\WaterBottle.PNG
	;notify().AddWindow("Startup",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:1000,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15,Icon: d}) ; 
	notify().AddWindow("Startup",{Title:"General Health Bots",TitleColor:"0xFFFFFF",Time:1000,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15}) ; 
	sleep,1100
}
gosub, Submit_StayHydratedBot
sleep, 3000
gosub, Submit_StandUpBot 	

/*
	Date: 18 Mai 2021 16:05:10: todo:  wrap this into a function to call from
	different sfcripts, inputs:  f_AddStartupToggleToTrayMenu(ScriptName,MenuNameName) 
	MenuName is the name of the tray-submenu to put the thingie into. if empty just
	put to main menu. 
*/
sleep, 3000

;SkipLabel_StartUp:


;return

;}_____________________________________________________________________________________
;{ GuiEscape/GuiSubmit____________________________________________________________
GuiEscape_StandUpBot:				;**
{
	f_UnstickModKeys()
	f_DestroyGuis()
	gui, destroy, 
}
return 
GuiEscape_StayHydratedBot:			;**
{
	f_UnstickModKeys()
	f_DestroyGuis()
	gui, destroy
}
return
GuiEscape_GeneralReminderBot:			;**
{
	f_UnstickModKeys()
	f_DestroyGuis()
	gui, destroy
}
return


Submit_StayHydratedBot: 				;**
{
	gui, Submit
	gui, destroy
	vTimerPeriod_StayHydratedBot:=vMinutes_StayHydratedBot*60*1000
	SetTimer,PlayTune_StayHydratedBot, %vTimerPeriod_StayHydratedBot% ; this does fully work, but the above (calling a function timer) does not. Why?
	if SoundStatus_StayHydratedBot
		menu, StayHydratedBot, Check, Sound
	if HUDStatus_StayHydratedBot
		menu, StayHydratedBot, Check, HUD
	if bRunNotify
		Notify().AddWindow("Setting Timer to " vMinutes_StayHydratedBot  " minutes",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
}
return

Submit_StandUpBot: 					;**
{
	gui, Submit
	gui, destroy
	vTimerPeriod_StandUpBot:=vMinutes_StandUpBot*60*1000
	SetTimer,PlayTune_StandUpBot, %vTimerPeriod_StandUpBot% ; this does fully work, but the above (calling a function timer) does not. Why?
	; m(sPathToNotifyPicture_StandUpBot)
	if SoundStatus_StandUpBot
		menu, StandUpBot, Check, Sound
	if HUDStatus_StandUpBot
		menu, StandUpBot, Check, HUD
	;m(IniObj)
	if bRunNotify		
		Notify().AddWindow("Setting Timer to " vMinutes_StandUpBot " minutes",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
}
return

/*
	Submit_GeneralReminderBot: 					;**
	{
		gui, Submit
		gui, destroy
		vTimerPeriod_GeneralReminderBot:=vMinutes_GeneralReminderBot*60*1000
		SetTimer,PlayTune_GeneralReminderBot, %vTimerPeriod_GeneralReminderBot% ; this does fully work, but the above (calling a function timer) does not. Why?
		
		if SoundStatus_GeneralReminderBot
			menu, GeneralReminderBot, Check, Sound
		if HUDStatus_StandUpBot
			menu, GeneralReminderBot, Check, HUD
		if bRunNotify
		{
			PathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
			Notify().AddWindow("Setting Timer to "vMinutes_GeneralReminderBot " minutes",{Title:"(~???)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_GeneralReminderBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedBot})
		}
	}
	return
*/


;}_____________________________________________________________________________________
;{ Tray Menu linked Labels_____________________________________________________________

; Tray Menu Labels - need to be swapped out for functions if/where possible. Some are redundant in functionality or overly complicated. 	SubmitChangedSettings_StayHydratedBot is in progress and the point of current problems. 





Numpad0::
lHelp_StayHydratedBot:				;**
f_Help_GeneralHealthBots(AU,VN)
return






lSetCurrentDelay_StayHydratedBot:		;**
{ 
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, Font, s7 cWhite, Verdana 
	Gui, Font, s11 cWhite, Segoe UI 
	gui, add, text,xm ym+10,Set Time in minutes till the next`ndrinking reminder
	Gui, add, Edit, %gui_control_options%  vvMinutes_StayHydratedBot -VScroll 
	Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmit_StayHydratedBot ; hidden button
	Gui, Font, s7 cWhite, Verdana
	;Hotkey, Esc, GuiEscape_StayHydratedBot,On
	Gui, Add, Text,x25, Version: %VN%	Author: %AU% 
	gui, show,autosize, %A_ThisLabel% ; gui_
} 
return

lSetCurrentDelay_StandUpBot:			;**
{
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, Font, s7 cWhite, Verdana
	Gui, Font, s11 cWhite, Segoe UI 
	gui, add, text,xm ym+10,Set Time in minutes till the next`nstanding reminder
	Gui, add, Edit, %gui_control_options%  vvMinutes_StandUpBot -VScroll 
	Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmit_StandUpBot ; hidden button
	Gui, Font, s7 cWhite, Verdana
	;Hotkey, Esc, GuiEscape_StandUpBot,On
	Gui, Add, Text,x25, Version: %VN%	Author: %AU% 
	gui, show,autosize, %A_ThisLabel% 
	
}
return


lToggleBotHUD_StayHydratedBot:		;***
{
	HUDStatus_StayHydratedBot:=!HUDStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, HUD
	sleep, 20
	PathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
	if HUDStatus_StayHydratedBot
	 	Notify().AddWindow("HUD Alert toggled on , Period: " vDefaultTimeInMinutes_StayHydratedBot " minutes",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("HUD Alert toggled off",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return

lToggleBotHUD_StandUpBot:			;***
{
	HUDStatus_StandUpBot:=!HUDStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, HUD
	sleep, 20
	PathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
	if HUDStatus_StandUpBot
	 	Notify().AddWindow("HUD Alert toggled on , Period: "vMinutes_StandUpBot " minutes",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("HUD Alert toggled off",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return


lToggleBotAudio_StayHydratedBot:		;***
{
	SoundStatus_StayHydratedBot:=!SoundStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, Sound
	sleep, 20
	PathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
	if SoundStatus_StayHydratedBot
	 	Notify().AddWindow("Audio Alert toggled on, Period: " vDefaultTimeInMinutes_StayHydratedBot " minutes",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("Audio Alert toggled off",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return

lToggleBotAudio_StandUpBot:			;***
{
	SoundStatus_StandUpBot:=!SoundStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, Sound
	sleep, 20
	PathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
	if SoundStatus_StandUpBot
	 	Notify().AddWindow("Audio Alert toggled on, Period: "vMinutes_StandUpBot " minutes",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("Audio Alert toggled off",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return


PlayTune_StayHydratedBot: 			;***
{
	if HUDStatus_StayHydratedBot
	{
		sFullFilePathToAudioFile_StayHydratedBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot)
		sFullFilePathToAudioFile_StayHydratedBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot)
		if bRunNotify
			Notify().AddWindow(sNotifyMessageRemember_StayHydratedBot,{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedBot})
	}
	if (StrLen(sFullFilePathToAudioFile_StayHydratedBot) >= 127) and InStr(sFullFilePathToAudioFile_StayHydratedBot,".wav")
		Throw, "The Pathlength of the absolute path to the .wav-audiofile is greater than 127 characters. For .wav-files, this is an error of SoundPlay."
	if SoundStatus_StayHydratedBot
		SoundPlay, % sFullFilePathToAudioFile_StayHydratedBot
	sleep, 500
	tooltip, 
}
return

PlayTune_StandUpBot: 				;***
{
	if HUDStatus_StandUpBot
	{
		sFullFilePathToAudioFile_StandUpBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StandUpBot)
		sFullFilePathToAudioFile_StandUpBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StandUpBot)
		if bRunNotify
		{
			
			if bStandingposition
			{
				Notify().AddWindow(sNotifyMessageUp_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedBot})
				bStandingposition:=0
			}
			else
			{
				Notify().AddWindow(sNotifyMessageDown_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedBot})
				bStandingposition:=1
			}
		}
	}
	if (StrLen(sFullFilePathToAudioFile_StandUpBot) >= 127) and InStr(sFullFilePathToAudioFile_StandUpBot,".wav")
		Throw, "The Pathlength of the absolute path to the .wav-audiofile is greater than 127 characters. For .wav-files, this is an error of SoundPlay."
	if SoundStatus_StandUpBot
		SoundPlay, % sFullFilePathToAudioFile_StandUpBot
	sleep, 500
	tooltip, 
}
return


lPause_StayHydratedBot:				;*** 
{
	PauseStatus_StayHydratedBot:=!PauseStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, Pause
	if PauseStatus_StayHydratedBot
	{
		Notify().AddWindow(sNotifyMessagePause_StayHydratedBot,{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
		menu, StayHydratedBot, UnCheck, Sound
		menu, StayHydratedBot, UnCheck, HUD
		menu, StayHydratedBot, ToggleEnable, Sound
		menu, StayHydratedBot, ToggleEnable, HUD
		SoundStatus_StayHydratedBot:=0
		HUDStatus_StayHydratedBot:=0
	}
	Else
	{
		Notify().AddWindow(sNotifyMessageResume_StayHydratedBot,{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
		menu, StayHydratedBot, Check, Sound
		menu, StayHydratedBot, Check, HUD
		menu, StayHydratedBot, Enable, Sound
		menu, StayHydratedBot, Enable, HUD
		SoundStatus_StayHydratedBot:=1
		HUDStatus_StayHydratedBot:=1
	}
	sleep, 20
	
}
return

lPause_StandUpBot:  				;***
{
	PauseStatus_StandUpBot:=!PauseStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, Pause
	if PauseStatus_StandUpBot
	{
		
		Notify().AddWindow(sNotifyMessagePause_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
		menu, StandUpBot, UnCheck, Sound
		menu, StandUpBot, UnCheck, HUD
		menu, StandUpBot, ToggleEnable, Sound
		menu, StandUpBot, ToggleEnable, HUD
		SoundStatus_StandUpBot:=0
		HUDStatus_StandUpBot:=0
	}
	Else
	{
		
		Notify().AddWindow(sNotifyMessageResume_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
		menu, StandUpBot, Check, Sound
		menu, StandUpBot, Check, HUD
		menu, StandUpBot, Enable, Sound
		menu, StandUpBot, Enable, HUD
		SoundStatus_StandUpBot:=1
		HUDStatus_StandUpBot:=1
	}
	sleep, 20
	
}
return

;Numpad7:: ; trigger code section
lEditSettings_StandUpBot:			;**
{
	gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	gui, add, button, xm+190 w28 ym+1 glSwapActiveBackup_StandUpBot, Swp
	gui, add, button, xm+223 w28 ym+1 glTriggerAdvancedSettingsGUI_StandUpBot, Othr
	gui, add, button, xm+256 w28 ym+1 glRestoreActiveBackup_StandUpBot, Res
	gui, add, text, 
	Gui, Font, s11 cWhite, Segoe UI 
	gui, add, text, xm ym-17 w0 h0 ; reposition next elements
	Gui, Add, Tab3,, Active|Backup|Original
	Gui, Font, s11 cWhite, Verdana
	; Hotkey, ^S, lSwapActiveBackup_StandUpBot,On
	;Hotkey, Enter, SubmitChangedSettings_StandUpBot,On
	;Hotkey, Esc, GuiEscape_StandUpBot,On
	gui, tab, Active
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBot_Active, % IniObj["Settings StandUpBot"]["sFullFilePathToAudioFile_StandUpBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll  vDefaultTimeInMinutes_StandUpBot_Active, % IniObj["Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StandUpBot_Active, % IniObj["Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StandUpBot ; hidden button
	gui, tab, Backup
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["sFullFilePathToAudioFile_StandUpBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll  vDefaultTimeInMinutes_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	gui, tab, Original
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab ReadOnly r3 vPathToNewFileNew_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["sFullFilePathToAudioFile_StandUpBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll ReadOnly vDefaultTimeInMinutes_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll ReadOnly vNotificationTimeInMilliSeconds_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	gui, tab
	Gui, Font, s7 cWhite, Verdana
	Gui, Add, Text,x25, StandUpBot v.%VN%	Author: %AU% 
	GuiControl, focus, PathToNewFileNew_StandUpBot_Active
	gui, show,autosize, %A_ThisLabel% 
	
}
return

;Numpad6::
lEditSettings_StayHydratedBot:		;**
{
	gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	gui, add, button, xm+190 w28 ym+1 glSwapActiveBackup_StayHydratedBot, Swp
	gui, add, button, xm+223 w28 ym+1 glTriggerAdvancedSettingsGUI_StayHydratedBot, Othr
	gui, add, button, xm+256 w28 ym+1 glRestoreActiveBackup_StayHydratedBot, Res
	gui, add, text, 
	Gui, Font, s11 cWhite, Segoe UI 
	gui, add, text, xm ym-17 w0 h0 ; reposition next elements
	Gui, Add, Tab3,, Active|Backup|Original
	Gui, Font, s11 cWhite, Verdana
	;Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,On
	;Hotkey, Esc, GuiEscape_StayHydratedBot,On
	
	gui, tab, Active
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll  vDefaultTimeInMinutes_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StayHydratedBot ; hidden button
	gui, tab, Backup
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll  vDefaultTimeInMinutes_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StayHydratedBot ; hidden button
	gui, tab, Original
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab ReadOnly r3 vPathToNewFileNew_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll ReadOnly  vDefaultTimeInMinutes_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll ReadOnly  vNotificationTimeInMilliSeconds_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StayHydratedBot ; hidden button
	gui, tab
	Gui, Font, s7 cWhite, Verdana
	Gui, Add, Text,x25, StayHydratedBot v.%VN% Author: %AU% 
	;Gui, Add, Text,x25, StayHydratedBot v%VN% Author: %AU% 
	gui, show,autosize, %A_ThisLabel% 
}
return

lSwapActiveBackup_StandUpBot:
{
	gui, destroy
	;f_UnstickModKeys()
	vTempActiveINISettings_StandUpBot:=[]
	vTempBackupINISettings_StandUpBot:=[]
	vTempActiveINISettings_StandUpBot:=IniObj["Settings StandUpBot"].clone()
	vTempBackupINISettings_StandUpBot:=IniObj["Backup Settings StandUpBot"].clone()
	IniObj["Settings StandUpBot"]:=vTempBackupINISettings_StandUpBot
	IniObj["Backup Settings StandUpBot"]:=vTempActiveINISettings_StandUpBot
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
	sFullFilePathToAudioFile_StandUpBot:=IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot	; extract values for notify
	sNotifyMessageDown_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageDown_StandUpBot
	sNotifyMessagePause_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessagePause_StandUpBot
	sNotifyMessageResume_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageResume_StandUpBot
	sNotifyMessageUp_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageUp_StandUpBot
	sNotifyTitle_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyTitle_StandUpBot
	SoundStatus_StandUpBot:=IniObj["Settings StandUpBot"].SoundStatus_StandUpBot
	sPathToNotifyPicture_StandUpBot:=f_ConvertRelativePath(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot)
	vMinutes_StandUpBot:=IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot
	vNotificationTimeInMilliSeconds_StandUpBot:=IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot
	HUDStatus_StandUpBot:=IniObj["Settings StandUpBot"].HUDStatus_StandUpBot
	if bRunNotify
		Notify().AddWindow("Swapping Settings",{Title:sNotifyTitle_StandUpBot,TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0})
	sleep, 1100
	gosub, Submit_StandUpBot
	
}
return

lSwapActiveBackup_StayHydratedBot:
{
	gui, destroy
	f_UnstickModKeys()
	;m(IniObj["Settings StayHydratedBot"])
	vTempActiveINISettings_StayHydratedBot:=[]
	vTempBackupINISettings_StayHydratedBot:=[]
	vTempActiveINISettings_StayHydratedBot:=IniObj["Settings StayHydratedBot"].clone()
	vTempBackupINISettings_StayHydratedBot:=IniObj["Backup Settings StayHydratedBot"].clone()
	IniObj["Settings StayHydratedBot"]:=vTempBackupINISettings_StayHydratedBot
	IniObj["Backup Settings StayHydratedBot"]:=vTempActiveINISettings_StayHydratedBot
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
	;m(IniObj["Original Settings StayHydratedBot"])
	sFullFilePathToAudioFile_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot	; extract values for notify
	sNotifyMessagePause_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessagePause_StayHydratedBot
	sNotifyMessageRemember_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessageRemember_StayHydratedBot
	sNotifyMessageResume_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessageResume_StayHydratedBot
	sNotifyTitle_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyTitle_StayHydratedBot
	SoundStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"].SoundStatus_StayHydratedBot
	sPathToNotifyPicture_StayHydratedBot:=f_ConvertRelativePath(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
	vMinutes_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot*1 ; get rid of those pesky quotes. Need to remember this trick ._.
	vNotificationTimeInMilliSeconds_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot
	HUDStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"].HUDStatus_StayHydratedBot
	if bRunNotify
		Notify().AddWindow("Swapping Settings",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0,Icon:sPathToNotifyPicture_StayHydratedBot})
	sleep, 1100
	gosub, Submit_StayHydratedBot
}
return

lRestoreActiveBackup_StandUpBot:				;**
{
	gui, cQ: destroy
	gui, destroy
	answer:=f_Confirm_Question("Do you want to reset the settings?",AU,VN)
	
	if answer="1"
	{
		IniObj["Backup Settings StandUpBot"]:=IniObj["Original Settings StandUpBot"].clone()
		SplitPath, A_ScriptName,,,, ScriptName
		FileNameIniRead:=ScriptName . ".ini"
		f_WriteINI_Bots(IniObj,ScriptName)
		Notify().AddWindow("Resetting 'Active'- and 'Backup'-settings",{Title:sNotifyMessageDown_StandUpBot,TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0,Icon:sPathToNotifyPicture_StandUpBot})
		sleep, 1300
		gosub, Submit_StayHydratedBot
	}
	else	; reactivate previous hotkeys.
	{
		gui, cQ: destroy
		gui, destroy
		gosub, lEditSettings_StayHydratedBot
	}
}
return
lRestoreActiveBackup_StayHydratedBot:			;**
{
	gui, cQ: destroy
	gui, destroy
	answer:=f_Confirm_Question("Do you want to reset the settings?",AU,VN)
	if answer="1"
	{
		IniObj["Settings StayHydratedBot"]:=IniObj["Original Settings StayHydratedBot"].clone()
		SplitPath, A_ScriptName,,,, ScriptName
		FileNameIniRead:=ScriptName . ".ini"
		f_WriteINI_Bots(IniObj,ScriptName)
		Notify().AddWindow("Resetting 'Active'- and 'Backup'-settings",{Title:sNotifyMessageDown_StayHydratedBot,TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0,Icon:sPathToNotifyPicture_StayHydratedBot})
		sleep, 1300
		gosub, Submit_StayHydratedBot
	}
	else
	{
		;m(false,"ylol"	)
		gui, cQ: destroy
		gui, destroy
		gosub, lEditSettings_StayHydratedBot
		;Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,On
		;Hotkey, Esc, GuiEscape_StayHydratedBot,On
	}
}
return


lTriggerAdvancedSettingsGUI_StandUpBot:

lTriggerAdvancedSettingsGUI_StayHydratedBot:
m("add a shorthand of my own m()-function for simple information giving, with temporary esc/enter keys")
return
	;_____________________________________________________________________________________
	;_____________________________________________________________________________________
SubmitChangedSettings_StayHydratedBot: 	;**
{
	gui, submit
	gui, destroy
	f_UnstickModKeys()
	; active
	if PathToNewFileNew_StayHydratedBot_Active
		IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot:=PathToNewFileNew_StayHydratedBot_Active
	DefaultTimeInMinutes_StayHydratedBot_Active:=DefaultTimeInMinutes_StayHydratedBot_Active+0
	if DefaultTimeInMinutes_StayHydratedBot_Active and (DefaultTimeInMinutes_StayHydratedBot_Active is in [integer number digit float])
		IniObj["Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot:=DefaultTimeInMinutes_StayHydratedBot_Active
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	NotificationTimeInMilliSeconds_StayHydratedBot_Active:=NotificationTimeInMilliSeconds_StayHydratedBot_Active+0
	if NotificationTimeInMilliSeconds_StayHydratedBot_Active and (NotificationTimeInMilliSeconds_StayHydratedBot_Active is in [integer number digit float])
		IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot:=NotificationTimeInMilliSeconds_StayHydratedBot_Active
	else
		throw,"Error occured: The notification time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	; backup
	if PathToNewFileNew_StayHydratedBot_Backup
		IniObj["Backup Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot:=PathToNewFileNew_StayHydratedBot_Backup
	DefaultTimeInMinutes_StayHydratedBot_Backup:=DefaultTimeInMinutes_StayHydratedBot_Backup+0
	if DefaultTimeInMinutes_StayHydratedBot_Backup and (DefaultTimeInMinutes_StayHydratedBot_Backup is in [integer number digit float])
		IniObj["Backup Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot:=DefaultTimeInMinutes_StayHydratedBot_Backup
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	NotificationTimeInMilliSeconds_StayHydratedBot_Backup:=NotificationTimeInMilliSeconds_StayHydratedBot_Backup+0
	if NotificationTimeInMilliSeconds_StayHydratedBot_Backup and (NotificationTimeInMilliSeconds_StayHydratedBot_Backup is in [integer number digit float])
		IniObj["Backup Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot:=NotificationTimeInMilliSeconds_StayHydratedBot_Backup
	else
		throw,"Error occured: The notification time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
}
return

SubmitChangedSettings_StandUpBot:		;**
{
	gui, submit
	gui, destroy
	f_UnstickModKeys()
	; active 
	if PathToNewFileNew_StandUpBot_Active
		IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot:=PathToNewFileNew_StandUpBot_Active
	DefaultTimeInMinutes_StandUpBot_Active:=DefaultTimeInMinutes_StandUpBot_Active+0
	if DefaultTimeInMinutes_StandUpBot_Active and (DefaultTimeInMinutes_StandUpBot_Active is in [integer number digit float])
		IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot:=DefaultTimeInMinutes_StandUpBot_Active
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	NotificationTimeInMilliSeconds_StandUpBot_Active:=NotificationTimeInMilliSeconds_StandUpBot_Active+0
	if NotificationTimeInMilliSeconds_StandUpBot_Active and NotificationTimeInMilliSeconds_StandUpBot_Active is in [integer number digit float]
		IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot:=NotificationTimeInMilliSeconds_StandUpBot_Active
	else
		throw,"Error occured: The notification time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	; 	
	if PathToNewFileNew_StandUpBot_Backup
		IniObj["Backup Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot:=PathToNewFileNew_StandUpBot_Backup
	DefaultTimeInMinutes_StandUpBot_Backup:=DefaultTimeInMinutes_StandUpBot_Backup+0
	if DefaultTimeInMinutes_StandUpBot_Backup and (DefaultTimeInMinutes_StandUpBot_Backup is in [integer number digit float])
		IniObj["Backup Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot:=DefaultTimeInMinutes_StandUpBot_Backup
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	NotificationTimeInMilliSeconds_StandUpBot_Backup:=NotificationTimeInMilliSeconds_StandUpBot_Backup+0
	if NotificationTimeInMilliSeconds_StandUpBot_Backup and (NotificationTimeInMilliSeconds_StandUpBot_Backup is in [integer number digit float])
		IniObj["Backup Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot:=NotificationTimeInMilliSeconds_StandUpBot_Backup
	else
		throw,"Error occured: The notification time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
}
return


RemoveToolTip_StandUpBot:			;**
RemoveToolTip_StayHydratedBot: 		;**
Tooltip,
return

GuiEscape_AboutStandUpBot: 			;**
GuiEscape_AboutStayHydratedBot:		;**
f_UnstickModKeys()
gui, destroy
return

	;}______________________________________________________________________________________







; scrapped functions for archive in case I need to dig out these ideas again.
/*
	f_SubmitAndWriteChangedSettings_StayHydratedBot(IniObj,PathToNewFileNew,DefaultTimeInMinutesNew,NotificationTimeInMilliSecondsNew)
	{
	; rework this: (mind the order!)
	; functionalise this, instead of making it a label. We only need to pass in the current settings obj, as well as values given above
	; f_SubmitAndWriteChangedSettings_StayHydratedBot(IniObj,PathToNewFileNew,DefaultTimeInMinutesNew,NotificationTimeInMilliSecondsNew)
	; 1. Read back current settings (should be passed via IniObj)
	; 2. Move current Settings to "Backup Settings StayHydratedBot" 
	; 3. Write new settings from the settings mentioned above to "Settings StayHydratedBot" [Note: this _can_ be hard-coded even]
		
		
		
	; 4. Reload. The new settings will be put into affect when the script is reloaded and the new settings are read into the 
	;Reload ; Reload the script, then get the new settings into affect
		
	}
*/
/* 
	f_PlayTune_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot,vNotificationTimeInMilliSeconds_StayHydratedBot,HUDStatus_StayHydratedBot) ;  not used, and not functional: can't be stopped. 
	{
		; Date: 26 April 2021 13:25:10: this needs to be fixed: the callback to the
		; function needs to be checked when stopping the timer properly.
		; That currently doesn't work properly. 
		if HUDStatus_StayHydratedBot
		{
			sFullFilePathToAudioFile_StayHydratedBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot)
			sFullFilePathToAudioFile_StayHydratedBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot)
			SoundPlay % sFullFilePathToAudioFile_StayHydratedBot
			PathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
			;Notify().AddWindow("Remember to stay hydrated...",{Title:"(~???)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedBot})
		}
	}
*/ 











;; Hotkeys:
;#IfWinActive gui_EditSettings_StayHydratedBot
;Escape:: gosub, GuiEscape_StayHydratedBot
;Enter::  
;m("hi there")
;gosub, SubmitChangedSettings_StayHydratedBot

;Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,On
;Hotkey, Esc, GuiEscape_StayHydratedBot,On







#IfWinactive, lHelp_StayHydratedBot
Esc:: 
gosub, GuiEscape_AboutStayHydratedBot
return

Enter:: 
gosub, GuiEscape_AboutStayHydratedBot
return
#IfWinActive, lEditSettings_StayHydratedBot

Enter:: 
gosub, SubmitChangedSettings_StayHydratedBot
return

Esc:: 
gosub, GuiEscape_StayHydratedBot
return

#IfWinActive, Numpad6
Enter:: 
gosub, SubmitChangedSettings_StayHydratedBot
return

Esc:: 
gosub, GuiEscape_StayHydratedBot
return

;Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,On
;Hotkey, Esc, GuiEscape_StayHydratedBot,On
#IfWinActive, lRestoreActiveBackup_StayHydratedBot
#IfWinActive, lSetCurrentDelay_StayHydratedBot

Esc:: 
gosub, GuiEscape_StayHydratedBot
return

;Hotkey, Esc, GuiEscape_StayHydratedBot,On
#IfWinActive, 
#IfWinActive, 


#IfWinActive, ; other-tabs in settings missing
#IfWinActive, ; other-tabs in settings missing
#IfWinActive, lEditSettings_StandUpBot
Enter:: 
gosub,SubmitChangedSettings_StandUpBot
return

Esc:: 
gosub, GuiEscape_StandUpBot
return

#IfWinActive, Numpad7
Enter:: 
gosub,SubmitChangedSettings_StandUpBot
return

Esc:: 
gosub, GuiEscape_StandUpBot
return

;Hotkey, Enter, SubmitChangedSettings_StandUpBot,On
;Hotkey, Esc, GuiEscape_StandUpBot,On
#IfWinActive, lRestoreActiveBackup_StandUpBot
#IfWinActive, lSetCurrentDelay_StandUpBot
Esc:: 
gosub, GuiEscape_StandUpBot
return

;Hotkey, Esc, GuiEscape_StandUpBot,On
#IfWinActive, 

#IfWinActive, CQlRestoreActiveBackup_StayHydratedBot

Esc:: 
pause off
Gosub, GuiEscape_StayHydratedBot

return

Enter:: 
gosub, SubmitChangedSettings_StayHydratedBot
return

#IfWinActive, CQlRestoreActiveBackup_StandUpBot
;Esc:: gosub, GuiEscape_ConfirmQuestion_f_ConfirmQuestion

Esc:: 
pause off
gosub, GuiEscape_StandUpBot
return

Enter:: 
gosub, SubmitChangedSettings_StandUpBot
return

;{ INCLUDE_____________________________________________________________________________


#Include GeneralHealthBots\includes\f_Confirm_Question.ahk
#Include GeneralHealthBots\includes\f_AddStartupToggleToTrayMenu.ahk
#Include GeneralHealthBots\includes\f_CreateTrayMenu_Bots.ahk
#Include GeneralHealthBots\includes\f_ConvertRelativePath.ahk
#Include GeneralHealthBots\includes\f_ConvertRelativeWavPath_StayHydratedBot.ahk
#Include GeneralHealthBots\includes\f_Help_GeneralHealthBots.ahk
#Include GeneralHealthBots\includes\notify.ahk
#Include GeneralHealthBots\includes\f_OnExit_StayHydratedBot.ahk
#Include GeneralHealthBots\includes\f_ReadINI_Bots.ahk
#Include GeneralHealthBots\includes\f_ReadBackSettings_StayHydratedBot.ahk
#Include GeneralHealthBots\includes\f_ToggleOffAllGuiHotkeys.ahk 	; not used right now, as is obsolete
#Include GeneralHealthBots\includes\f_UnstickModKeys.ahk
#Include GeneralHealthBots\includes\f_WriteINI_Bots.ahk
#Include GeneralHealthBots\includes\f_DestroyGuis.ahk
#Include GeneralHealthBots\includes\m.ahk
;#Include Updater.ahk
f_UpdateRoutine(VersionNumberDefSubScripts:="VNI=",VersionNumberDefMainScript:="VN=",vNumberOfBackups:=0,IniObjFlag:=-1)
{
	; facilitates all subfunctions for 
	; m(GitPageURLComponents,"`n",LocalValues)
	; add input verification: 
	; does gitpage connect successfully, 
	; does gitpage4 contain a valid path on the harddrive
	; 
	global GitPageURLComponents 
	global LocalValues
	
	/*
		Date: 22 Mai 2021 10:57:45: an alternative way would be to use the ini-file
		only for fetching file-urls, then check for missing files. all other files are
		compared on a line-by-line basis to check if they match everywhere. you could
		make this a "cutting edge"-feature (possibly search another git branch for this?
		) and ask the user if they want to use experimental versions. Much more prone to
		error,  but in theory possible.
	*/
	gui, destroy
	vFileCountToUpdate:=0
	ReturnPackage:=f_CheckForUpdates(GitPageURLComponents,LocalValues,VersionNumberDefMainScript)
	vFileCountToUpdate:=ReturnPackage[2].Count()
	if ReturnPackage[1]!=0
		vFileCountToUpdate++
		;tooltip, updating 	; insert f_PerformUpdate here
	if vFileCountToUpdate!=0 			; MainFile's VN doesn't match → update (insert assume-all function? Not necessary, as each file with unique name is also loggged by vn.)
		if f_Confirm_Question_Updater("Do you want to update?`nNew Version is "GitPageURLComponents[1],LocalValues[1],LocalValues[2])
			f_PerformUpdate(ReturnPackage,GitPageURLComponents,LocalValues,IniObjFlag,vNumberOfBackups)
	else if (lIsDifferent=-1) 	; vn-identifier string not found
		if !vsdb
		{
			Notify().AddWindow("No update available",{Title:"Checking for updates.",TitleColor:"0xFFFFFF",Time:1200,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1200,FlashColor:0x5555})
			UpdateCheck:=-1
			return UpdateCheck ; insert notify guis to tell no update is available
		}
	else if (lIsDifferent=0) 	; vn's match
		return
}

f_CheckForUpdates(GitPageURLComponents,LocalValues,VersionNumberDefSubScripts,VersionNumberDefMainScript:="VN=")
{
	; returns:
	;  0 - match
	;  1 - don't match
	; -1 - VersionNumberDefMainScript could not be found 
	;__________________________________________
	
	
	;__________________________________________
	;__________________________________________
	; Check main script against github instance
	;__________________________________________
	;__________________________________________
	; taken from https://www.autohotkey.com/docs/commands/URLDownloadToFile.htm#WHR example 3
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	; https://raw.githubusercontent.com/Gewerd-Strauss/GeneralHealthBots.ahk/main/StayHydratedBot%20settingsGUI_16.05.2021.ahk
	url:="https://raw.githubusercontent.com/" GitPageURLComponents[1] "/" GitPageURLComponents[2] "/main/" GitPageURLComponents[3]""
	;m(url)
	whr.Open("GET","https://raw.githubusercontent.com/" GitPageURLComponents[1] "/" GitPageURLComponents[2] "/main/" GitPageURLComponents[3]"", true)
	whr.Send()
	; Using 'true' above and the call below allows the script to remain responsive.
	whr.WaitForResponse()
	ReadLine := strsplit(whr.ResponseText,"`r`n")
	vNumel:=ReadLine.length()
	loop, %vNumel%
		if Instr(ReadLine[A_Index],VersionNumberDefMainScript)
		{
			; if (substr(vNumel))
			vVNOnline:=ReadLine[A_Index]
			; m(vVNOnline,VN)
			;d:=SubStr(vVNOnline,1,1)
 			;if (d="") 	; this doesn't work, how do I get the fucking string of the thing? ffs. 
			;	MsgBox, hi
			vVNOnline:=StrReplace(vVNOnline," ")
			vVNOnline:=StrReplace(vVNOnline,VersionNumberDefMainScript,"")
			if (vVNOnline != LocalValues[2])		; vVNOnline is the github version, GitpageURLComponents1 is the local version, this needs to be switched
				VersionDifference_MainScript:=true
			Else
				VersionDifference_MainScript:=false
			break
		}
	Else
		VersionDifference_MainScript:=-1
	;MsgBox % vVNOnline "`n" LocalValues[2] "`nDifference:" VersionDifference_MainScript
	
	
	;________________________________________________
	;________________________________________________
	; Get Local include version Numbers (VNs)
	; write to common ini-file to query when uploaded
	;________________________________________________
	;________________________________________________
	
	
	
	OfflineVNs:=[]
	OfflineVNs["local"]:=[]
	OfflineVNs["local"]:=f_PullLocalVersionsFromIncludeFiles("GeneralHealthBots\includes")
	OfflineVNs["local"][A_ScriptName]:=LocalValues[2]	; this throws an error in the testfile, but won't do so in the actual file. 
	OfflineVNs["localend"]:=[]
	f_WriteINI(OfflineVNs,"StayHydratedBot settingsGUI_16.05.2021")		; figure out how to write this array to the ini-file
	;m(OfflineVNs)
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	INiObj:=f_ReadINI("StayHydratedBot settingsGUI_16.05.2021.ini") ;; replace this with FileNameIniRead later once this is written out fully. 
	; now we have the VN's of all subscripts locally, and they are always updated to the ini-file itself. 
	
	; now we have: Function pulls vn's from local files, with OfflineVNs being an array of filename - vn created at start of mainscript
	; 
	
	;________________________________________________
	;________________________________________________
	; Get online include version Numbers (VNs) from the online ini.file ← this is important to go over the ini-file as we need to make 
	; sure we also catch the files that are new, but for those we cannot assemble the url-string yet, as we would be lacking the filenames. 
	; Hence, we need to read back the ini-file to get the names of the functions existing on github
	
	
	
	; for v, k in OfflineVNs.local
	; {
	; 	m(v)
	
	; wrap this code in a function OnlineVNs:=f_PullOnlineVersionsFromIniFile(GitPageURLComponents) ; returns OnlineVNs
	OnlineVNs:=f_PullOnlineVersionsFromIniFile(GitPageURLComponents)
	
	OnlineVNs.Remove("")
	FilesToDownload:=f_CompareVersions(OnlineVNs,OfflineVNs,GitPageURLComponents)
	
	
	ReturnPackage:=[]
	ReturnPackage:=[VersionDifference_MainScript,FilesToDownload]
	/*
		Date: 21 Mai 2021 23:00:37: todo tomorrow:  1. verify that my filtering
		function does indeed work correctly. 2. write the downloader-fn (which really is
		just a https-request linked to a FileOpen/FileClose to properly edit all. Make
		sure you have all necessary values passed.)
	*/
	
	return ReturnPackage
	
}

f_CompareVersions(OnlineVNs,OfflineVNs,GitPageURLComponents)
{ ; returns array of filenames to download. Files with version mismatch and files not existing on the local instance/ini-file are selected, and marked to be downloaded
	; 1. Check if vn's are equal
		; this doesn't work because files are not in the same order, hence if a new file is inserted one pattern will shift by 1 completely, resulting in permanent hits where there aren't any irl.
		; fix:
		; 1. Collect the Keys of the OFFLINE array in a separate array (which is non-associative)
		; 2. Loop through the keys of ONLINE arr and check if they exist in the new offline-key-array
		; 2.1 YES: compare the vn's of that key between both arrays and check if unequal → download
		; 2.2 NO:  key of an online-fn doesn't exist in the offline-fn, hence the function doesn't exist either. → download to file
		
	FilesToDownload:=[]
	Ind:=1
	k:=""
	OfflineFiles:=[]
	for k,v in OfflineVNs.local
		OfflineFiles[A_Index]:=k		; contains all keys of offline files: these files exist on the pc.
	for k, v in OnlineVNs			; loop through the keys of Online files to check if they exist within the offline files. 
	{
		HV:=HasVal(OfflineFiles,k)
		if HV!=0	; if HV!=0 OfflineFiles does have the key, hence the file exists. now compare the respective VNs
		{
			a:=OfflineVNs.local[k]
			b:=OnlineVNs[k]
			if !Instr(a,b)	; if a!=b the file VNs are unequal, hence download
			{
				FilesToDownload[Ind]:=k
				Ind++
			}
		}
		Else		; if HV=0, the file doesn't exist locally, hence add it. 
		{
			;m(HV,"doesn't exist, hence download directly")
			;m(k,"very much news","`nLocal:",a,LocalVN_current,"`nOnline:",b,VN_kOn)
			FilesToDownload[Ind]:=k
			Ind++
		}	
	}
	return FilesToDownload
}

f_PerformUpdate(ReturnPackage,GitPageURLComponents,LocalValues,IniObjFlag:=1,vNumberOfBackups:=0)
{
	/*
		OLD Steps:
		{
		0. Read ALL files in directory to an object
		1.  run github
		2.  inform user to download  AND UNZIP to A_ScriptDir/update_files
		3.  create directories A_ScriptDir/UserBackup <- copy there. user's current ini-file and the "user"-folder which can contain any user-specific files. If that folder doesn't exist, do nothing
		4.  let ahk save the current settings to the old ini-file, 
		5.  let ahk read the new ini-file
		6.  let ahk compare both files and merge the array (keeping old settings, without removing the new ini-files additional settings (difficult, as it is a associative array, not a normal one))
		6.1 write the updated array to A_ScriptDir/update_files/.../Settings***
		7.  delete all files from the old version * this will most likely not delete the active script, so use the ReadLine-replacer way of writing to the file itself
		8.  finish up: check if all files exist (compare object path's names with all files in /update_files)
		8.1 if successful, cut and paste all contents of /update_files to the parent directory <- make sure /update_files is empty at the end
		8.2 check for existance of ini-file in correct directory
		
		{
			; 1.  run github
			sProjectUrl:="https://github.com/" GitPageURLComponents[2] "/" GitPageURLComponents[3]
			H:="Please download the new version, save it and unzip it to" A_ScriptDir "\update_files"
			f_InformOfNextSteps(H)
			; run, %sProjectUrl%
			sleep, 250
			; 2.  inform user to download  AND UNZIP to A_ScriptDir/update_files
			; 2.1 check if A_ScriptDir/update_files exists
			IfNotExist, %A_ScriptDir%\update_files
				FileCreateDir, %A_ScriptDir%\update_files
			IfNotExist, %A_ScriptDir%\
				MsgBox, finished creating
			; 3.  create directories A_ScriptDir/UserBackup <- copy there. user's current ini-file and 
			; the "user"-folder which can contain any user-specific files. 
			; If that folder doesn't exist, do nothing
			if vNumberOfBackups!=0
				f_CreateBackup()
			; f_AssembleDownloadURLs(ReturnPackage )
			sleep, 2500
	
			m("finsh")	
		}




		NEW PROCEDURE: 
		0. Create Backup
		
			1. Parse throught ReturnPackage[2]
			1.1. Create dummy-values "FileNotReadFromGitPage"
		1.2. attempt to read each file from gitpage into the respective variable.
			 The files that remain unchanged couldn't be downloaded for some reason
			 	- faulty vn, faulty name f.e.
		2. Assemble the respective url's and write them to an array DownloadURLs
		3. Check if ReturnPackage[1]=1 ← download MainScript
		4. pass that to f_downloadfiles, returning array (FileArray) of filenames (keys) and the entire files (vals)
		5. pass that to f_writedownloads, which takes the FileArray and all paths ()
		}
	*/
	
	; 0. Create Backup
	if vNumberOfBackups>0
	{
		ExcludedFolders:=["AHK-Studio Backup","PrivateMusic"]
		f_CreateBackup(vNumberOfBackups,ExcludedFolders)
	}
	; 1. Parse throught ReturnPackage[2]
	FilesReadFromGitPage:=[]
	for k,v in ReturnPackage[2]
		FilesReadFromGitPage[k]:="-1: File Not read from gitpage"
	GitPageURLComponents[5]:=LocalValues[3]
	FileTexts:=f_DownloadFilesFromGitPage(FilesReadFromGitPage,GitPageURLComponents,ReturnPackage)
	ReturnPackage[2].Push(A_ScriptName)
	f_WriteFilesFromArray(ReturnPackage[2],FileTexts,GitPageURLComponents)
	f_NotifyUserOfUpdates()
	return ; VersionDifference_MainScript
} 

f_NotifyUserOfUpdates()
{
	m("remember to create the notifyuserofupdates_fn")
	/*
		Date: 22 Mai 2021 13:34:03: todo: notify what has changed, where the old files
		are, etc etc  1. Old files are dropped to 
	*/
}

f_WriteFilesFromArray(FileNames,FileTexts,GitPageURLComponents)
{
	global vsdb
	m(FileNames)
	m(GitPageURLComponents[5])
	m(FileTexts)
	FilePathsLocal:=f_AssembleLocalFilePaths(FileNames,GitPageURLComponents[5])
	for k,v in FilePathsLocal
	{
		if FileTexts[k]!="404: Not Found"
		{
			if  vsdb ;!
			{
				CurrFile:=FileOpen(v,"rw") ; backup is handled already, so I don't have to worry about it. Or I do a better backup, and do it here just for the files that are updated. 101
				CurrFile.Write(FileTexts[k])
				CurrFile.Close()

			}
						
		}
		else
			m("File not found online: Reference exists, file itself does not")
	}
	; and now we only have to write the files to the files, duh.
	if !vsdb
		m("f_writeFilesFromArray:`nremember to finish thee notify-msgs")
}

f_AssembleLocalFilePaths(FileNames,FileDirIncludes)
{
	FilePathsLocal:=[]
	for k,v in FileNames
	{
		CurrFilePath:=A_ScriptDir "\" FileDirIncludes FileNames[A_Index]
		CurrFilePath:=StrReplace(CurrFilePath,"/","\" )
		FilePathsLocal[A_Index]:=CurrFilePath
		Ind:=A_Index
	}
	FilePathsLocal[Ind]:=A_ScriptFullPath
	return FilePathsLocal
}

f_DownloadFilesFromGitPage(FilesReadFromGitPage,GitPageURLComponents,ReturnPackage)
{
	DownloadURLs:=f_AssembleDownloadURLs(FilesReadFromGitPage,GitPageURLComponents,ReturnPackage)

	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	for k,v in DownloadURLs
	{
		whr.Open("GET",DownloadURLs[A_Index]"", true)
		whr.Send()	
		whr.WaitForResponse()
		FileNameArr:=StrSplit(DownloadURLs[A_Index],"/")
		ArrayVal:=whr.ResponseText ;"||" FileNameArr[FileNameArr.MaxIndex()]
			FilesReadFromGitPage[A_Index]:=ArrayVal
		;Clipboard:=ArrayVal
	}
	
	return FilesReadFromGitPage
}

f_AssembleDownloadURLs(FilesReadFromGitPage,GitPageURLComponents,ReturnPackage)
{
	DownloadURLs:=[]
	for k,v in ReturnPackage[2]
		DownloadURLs[A_Index]:="https://raw.githubusercontent.com/" GitPageURLComponents[1] "/" GitPageURLComponents[2] "/main/" GitPageURLComponents[5] ReturnPackage[2][A_Index]
	MaxIndPlusOne:=DownloadURLs.MaxIndex()+1
	DownloadURLs[MaxIndPlusOne]:="https://raw.githubusercontent.com/" GitPageURLComponents[1] "/" GitPageURLComponents[2] "/main/" GitPageURLComponents[3]""		; figure out if the %20 is valid or f_InformOfNextSteps(
 
	return DownloadURLs
}

f_PullOnlineVersionsFromIniFile(GitPageURLComponents)
{




   	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	url:="https://raw.githubusercontent.com/" GitPageURLComponents[1] "/" GitPageURLComponents[2] "/main/" GitPageURLComponents[4]""
	whr.Open("GET","https://raw.githubusercontent.com/" GitPageURLComponents[1] "/" GitPageURLComponents[2] "/main/" GitPageURLComponents[4]"", true)
	whr.Send()
	; Using 'true' above and the call below allows the script to remain responsive.
	whr.WaitForResponse()
	ReadLine := strsplit(whr.ResponseText,"`r`n")
	vNumel:=ReadLine.length()
 	RunCount:=0
	OnlineVNs:=[]
	lCatchLines:=false
	loop, %vNumel%
	{
		
		
		if lCatchLines or lCatchLines=2 ; assuming these 
		{
			lCatchLines:=2
			RunCount++
			; if (substr(vNumel))
			LineReadInd:=A_INdex
			vVNOnline:=ReadLine[LineReadInd]
			; m(vVNOnline,VN)
		 	;d:=SubStr(vVNOnline,1,1)
			;if (d="") 	; this doesn't work, how do I get the fucking string of the thing? ffs. 
			;	MsgBox, hi
			vVNOnline:=StrReplace(vVNOnline," ")
			vVNOnline:=StrReplace(vVNOnline,VersionNumberDefMainScript,"")
			RegExMatch(vVNOnline, "(?<FileName>[a-z A-Z _\- 0-9]+.ahk)(=)(?<VersionNumberOfFileName>[0-9]+.[0-9]+.[0-9]+.[0-9]+)",v)
			; how do I get the contents of vFileName and vVersionNUmberOfFileName into an array?
			OnlineVNs[vFileName]:=vVersionNumberOfFileName
		}
		if Instr(ReadLine[A_Index],"[local]") and ((lCatchLines=false) or (lCatchLines=true))
			lCatchLines:=true
		else if Instr(ReadLine[A_Index] ,"[local end]") and lCatchLines and ((lCatchLines=false) or (lCatchLines=true))		;; remember to edit the ini-write function to add this section at the end as well to signify the end of the include-files-ini-section.
			lCatchLines:=false
		else
			if lCatchLines!=2
				lCatchLines:=false
	}
	return OnlineVNs
}

f_PullLocalVersionsFromIncludeFiles(DirectoryOfIncludeFilesRelativeFromMainFile)
{
 	VNI=1.0.0.1
	FilesOfProject:=f_ListFiles(A_ScriptDir "\" DirectoryOfIncludeFilesRelativeFromMainFile)
 	versions := []
	loop files, % A_ScriptDir "\GeneralHealthBots\includes\*.ahk", F ;R
	{
		FileRead buffer, % A_LoopFileFullPath
		RegExMatch(buffer, "VNI[^\d]+([\d\.]+)", ReadLine)
		versions[A_LoopFileName] := ReadLine1
	}
  	FileInd:=1
	; vLocalVNArray:=["Ini Local"]
	
	/*
		
		vLocalVNArray:={}
		loop, % FilesOfProject.length()
		{
			CurrFile:=FilesOfProject[FileInd]
			CurrFilePath:=A_ScriptDir "\" DirectoryOfIncludeFilesRelativeFromMainFile "\" CurrFile
			
			
			
			
			
			
			
			
			
			
			loop, files, %CurrFilePath%
			{
				self_o:=FileOpen(A_LoopFileFullPath,"r")
				loop,
				{
					colours := Object("red", 0xFF0000, "blue", 0x0000FF, "green", 0x00FF00)
				; The above expression could be used directly in place of "colours" below:
					for k, v in colours
						s .= k "=" v "`n"
					MsgBox % s
					lineStart:=self_o.Tell
					sVersionLocal:=self_o.ReadLine()
					if Instr(sVersionLocal,"VNI=")
					{
						sVNPure:=StrReplace(StrReplace(StrReplace(sVersionLocal,"VNI=",""),"`t",""),"`r`n","")
						s:=A_LoopFileName
						for k,v in FilesOfProject
							vLocalVNArray:=sVNPure
				;vLocalVNArray.A_LoopFileName:=sVNPure
					;vLocalVNArray["Ini Local"].push(A_LoopFileNamesVNPure)
						break
					}
					else
						vLocalVNArray.A_LoopFileName:="Error:noVNFound"
				}
			}
			FileInd++
		}
		
	*/
	
	return versions
}

f_CreateBackup(vNumberOfBackups,ExcludeFolders)
{
	global vsdb 
	if vNumberOfBackups>1
	{
		m("finish the multi-backup paths.")
	}
	m("implement logic for number of backups")
	SourceCD:=A_ScriptDir ;"\"
	DestCD:=A_ScriptDir "\UserBackup"
	loop, files, %A_ScriptDir%
	{
		m(A_LoopFileName)
		if !HasVal(ExcludeFolders,A_LoopFileName)
			FileCopyDir, A_LoopFileFullPath, %DestCD%
	}
	
	; 	FileCopyDir, %SourceCD%,%DestCD%,1
	; SourceRD:=A_ScriptDir "\UserBackup\UserBackup"
	;Notify().AddWindow("Backup completed",{Title:"",TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0})
	if !vsdb
		Notify().AddWindow("Backup completed",{Title:"Updating " A_ScriptName,TitleColor:"0xFFFFFF",Time:1300,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	;FileRemoveDir, %SourceRD
}

HasVal(haystack, needle) 
{	; code from jNizM on the ahk forums: https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

f_ListFiles(Directory)
{
	files:=[]
	Loop %Directory%\*.ahk
	{
		files[A_Index]:=A_LoopFileName
	}
	return files
}

f_WriteINI(ByRef Array2D, INI_File)  ; write 2D-array to INI-file
{
	m(INI_File)
	VNI=1.0.0.12
	if !FileExist("INI-Files") ; check for ini-files directory
	{
		MsgBox, Creating "INI-Files"-directory at Location`n"%A_ScriptDir%", containing an ini-file named "%INI_File%.ini"
		FileCreateDir, INI-Files
	}
	OrigWorkDir:=A_WorkingDir
	SetWorkingDir, INI-Files
	for SectionName, Entry in Array2D 
	{
		Pairs := ""
		for Key, Value in Entry
			Pairs .= Key "=" Value "`n"
		IniWrite, %Pairs%, %INI_File%.ini, %SectionName%
	}
	if A_WorkingDir!=OrigWorkDir
		SetWorkingDir, %OrigWorkDir%
	/* Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
		
	;-------------------------------------------------------------------------------
		WriteINI(ByRef Array2D, INI_File) { ; write 2D-array to INI-file
	;-------------------------------------------------------------------------------
			for SectionName, Entry in Array2D {
				Pairs := ""
				for Key, Value in Entry
					Pairs .= Key "=" Value "`n"
				IniWrite, %Pairs%, %INI_File%, %SectionName%
			}
		}
	*/
}

f_ReadINI(INI_File) ; return 2D-array from INI-file
{
	VNI=1.0.0.10
	Result := []
	OrigWorkDir:=A_WorkingDir
	SetWorkingDir, INI-Files
	IniRead, SectionNames, %INI_File%
	for each, Section in StrSplit(SectionNames, "`n") {
		IniRead, OutputVar_Section, %INI_File%, %Section%
		for each, Haystack in StrSplit(OutputVar_Section, "`n")
			RegExMatch(Haystack, "(.*?)=(.*)", $)
         , Result[Section, $1] := $2
	}
	if A_WorkingDir!=OrigWorkDir
		SetWorkingDir, %OrigWorkDir%
	return Result
	
	/* Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
	;-------------------------------------------------------------------------------
	ReadINI(INI_File) { ; return 2D-array from INI-file
	;-------------------------------------------------------------------------------
		Result := []
		IniRead, SectionNames, %INI_File%
		for each, Section in StrSplit(SectionNames, "`n") {
			IniRead, OutputVar_Section, %INI_File%, %Section%
			for each, Haystack in StrSplit(OutputVar_Section, "`n")
				RegExMatch(Haystack, "(.*?)=(.*)", $)
            , Result[Section, $1] := $2
		}
		return Result
	*/
}

f_Confirm_Question_Updater(Question,AU,VN)
{
	; returns:
	;  0 - answered no
	;  1 - answered yes
	; -1 - user canceled ()
	gui, cQ: new
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	gui, cQ: Margin, 16, 16
	gui, cQ: +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	cBackground := "c" . "1d1f21"
	cCurrentLine := "c" . "282a2e"
	cSelection := "c" . "373b41"
	cForeground := "c" . "c5c8c6"
	cComment := "c" . "969896"
	cRed := "c" . "cc6666"
	cOrange := "c" . "de935f"
	cYellow := "c" . "f0c674"
	cGreen := "c" . "b5bd68"
	cAqua := "c" . "8abeb7"
	cBlue := "c" . "81a2be"
	cPurple := "c" . "b294bb"
	Gui, cQ: Color, 1d1f21, 373b41, 
	Gui, cQ: Font, s11 cWhite, Segoe UI 
	gui, cQ: add, text,xm ym, %Question%
	gui, cQ: add, button, xm+20 ym+50 w30 gConfirmQuestion_f_ConfirmQuestion_Updater, &Yes
	gui, cQ: add, button, xm+170 ym+50 w30 gDenyQuestion_f_ConfirmQuestion_Updater, &No
	Gui, cQ: Font, s7 cWhite, Verdana
	if VN!="" and AU!=""
		Gui, cQ: Add, Text,x25, Version: %VN%
	else if VN!="" and AU=""
		Gui, cQ: Add, Text,x25, Version: %VN%
	else if VN="" and AU!=""
		Gui, cQ: Add, Text,x25, Author: %AU% 
	
	yc:=A_ScreenHeight-200
	xc:=A_ScreenWidth-300
	gui, cQ: show,autosize  x%xc% y%yc%, CQ%A_ThisLabel%
	winactivate, CQ
	WinWaitClose, CQ%A_ThisFun%
	return answer
	
	GuiEscape_ConfirmQuestion_f_ConfirmQuestion_Updater:
	gui, cQ: destroy
	return answer:=-1
	
	ConfirmQuestion_f_ConfirmQuestion_Updater:
	gui, cQ: submit
	gui, cQ: destroy
	return answer:=true
	
	DenyQuestion_f_ConfirmQuestion_Updater:
	gui, cQ: submit
	gui, cQ: destroy
	return answer:=false
	
	
}

f_InformOfNextSteps(H:="No info given for this step.",XtOffset:=300,YtOffset:=400)
{
	global
	x:=A_ScreenWidth-XtOffset
	y:=A_ScreenHeight-YtOffset
	tooltip, % st_wordwrap(H), x,y
	; 1
}

st_wordWrap(string, column=56, indentChar="")
{
	indentLength := StrLen(indentChar)
	
	Loop, Parse, string, `n, `rff
	{
		If (StrLen(A_LoopField) > column)
		{
			pos := 1
			Loop, Parse, A_LoopField, %A_Space%
				If (pos + (loopLength := StrLen(A_LoopField)) <= column)
					out .= (A_Index = 1 ? "" : " ") A_LoopField
                    , pos += loopLength + 1
			Else
				pos := loopLength + 1 + indentLength
                    , out .= "`n" indentChar A_LoopField
			
			out .= "`n"
		} Else
			out .= A_LoopField "`n"
	}
	
	Return SubStr(out, 1, -1)
}
