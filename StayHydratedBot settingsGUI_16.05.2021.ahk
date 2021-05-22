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
#Include Updater.ahk
