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
LE=17 Mai 2021 19:51:41                                
;}_____________________________________________________________________________________
;{#[Autorun Section]
if WinActive("GeneralHealthBot.ahk - Visual Studio Code")	; if run in vscode, deactivate notify-messages to avoid crashing the program.
	bRunNotify:=0
else
	bRunNotify:=1 	; otherwise 
bStandingposition:=0	;  0 = start sitting, 1 = start standing


/*
	GeneralHealthBots
	repo: https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/
	author: Gewerd Strauss, https://github.com/Gewerd-Strauss
	
	Code by others:	
	WriteINI/ReadINI | wolf_II | adopted from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
	Notify | maestrith | https://github.com/maestrith/Notify
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
if bRunNotify
{
	notify().AddWindow("Startup",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:1000,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15})
	sleep,1100
}


; 1. Initialise and load settings
IniObj:=f_ReadBackSettings_StayHydratedBot()
; 2. Extract relevant values
sFullFilePathToAudioFile_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot	; extract values for notify
vNotificationTimeInMilliSeconds_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot*1
vMinutes_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot*1 ; get rid of those pesky quotes. Need to remember this trick ._.
SoundStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"]["SoundStatus_StayHydratedBot"]
HUDStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"]["HUDStatus_StayHydratedBot"]
if vMinutes_StayHydratedBot is not integer
{
	throw,"Error occured: 'Set Def. Reminder Time (min)' and 'Set Def. Notification Time (ms)' do not contain integers (numbers). Please delete the ini-file in the StayHydratedBot-Folder"
}




sFullFilePathToAudioFile_StandUpBot:=IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot	; extract values for notify
vNotificationTimeInMilliSeconds_StandUpBot:=IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot*1
vMinutes_StandUpBot:=IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot*1 ; get rid of those pesky quotes. Need to remember this trick ._.
SoundStatus_StandUpBot:=IniObj["Settings StandUpBot"]["SoundStatus_StandUpBot"]
HUDStatus_StandUpBot:=IniObj["Settings StandUpBot"]["HUDStatus_StandUpBot"]


gosub, Submit_StayHydratedBot
sleep, 3000
gosub, Submit_StandUpBot 			
return

;}_____________________________________________________________________________________
;{ GuiEscape/GuiSubmit____________________________________________________________
GuiEscape_StandUpBot:				;**
Hotkey, Esc, GuiEscape_StandUpBot, Off
gui, destroy, 
return 
GuiEscape_StayHydratedBot:			;**
Hotkey, Esc, GuiEscape_StayHydratedBot,Off
gui, destroy
return
GuiEscape_GeneralReminderBot:			;**
Hotkey, Esc, GuiEscape_GeneralReminderBot,Off
gui, destroy
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
	{
		PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
		Notify().AddWindow("Setting Timer to "vMinutes_StayHydratedBot " minutes",{Title:"(~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
	}
}
return

Submit_StandUpBot: 					;**
{
	gui, Submit
	gui, destroy
	vTimerPeriod_StandUpBot:=vMinutes_StandUpBot*60*1000
	SetTimer,PlayTune_StandUpBot, %vTimerPeriod_StandUpBot% ; this does fully work, but the above (calling a function timer) does not. Why?
	
	if SoundStatus_StandUpBot
		menu, StandUpBot, Check, Sound
	if HUDStatus_StandUpBot
		menu, StandUpBot, Check, HUD
	if bRunNotify
	{
		PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
		Notify().AddWindow("Setting Timer to "vMinutes_StandUpBot " minutes",{Title:"(~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
	}
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
		PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
		Notify().AddWindow("Setting Timer to "vMinutes_GeneralReminderBot " minutes",{Title:"(~???)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_GeneralReminderBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
	}
}
return
*/


;}_____________________________________________________________________________________
;{ Tray Menu linked Labels_____________________________________________________________

; Tray Menu Labels - need to be swapped out for functions if/where possible. Some are redundant in functionality or overly complicated. 	SubmitChangedSettings_StayHydratedBot is in progress and the point of current problems. 


lHelp_StayHydratedBot:
lCallAboutFun_StayHydratedBot:
gui, destroy
gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
Gui, Margin, 16, 16
Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
Gui, Color, 1d1f21, 373b41, 
Gui, Font, s7 cWhite, Verdana
Gui, Font, s15 cWhite, Segoe UI 
gui, add, text,xm ym+10,GeneralHealthBots

Gui, Font, Underline s11 cBlue , Segoe UI 
gui, add, text, xm ym+40 w212 0x10  ;Horizontal Line > Etched Gray
gui, add, text, xm ym+30 w0 ; position the documentation link
Gui, Add, Text, glLinkDocumentation, Documentation

Gui, Font, Underline s09 cBlue , Segoe UI 
gui, add, text, xm ym+60 w0 ; position the documentation link
gui, add, text, glLinkReportABug,Report a bug

gui, font,
Gui, Font, s7 cWhite, Verdana
Hotkey, Esc, GuiEscape_AboutStayHydratedBot,On
Hotkey, Enter, GuiEscape_AboutStayHydratedBot, On
Gui, Add, Text,x25, VN: %VN%	Author: %AU% 
gui, show, autosize
return

lLinkDocumentation:
run, https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk
gui, destroy
return
lLinkReportABug:
run, https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/issues/new
gui,destroy
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
	Gui, add, Edit, %gui_control_options% vvMinutes_StayHydratedBot -VScroll 
	Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmit_StayHydratedBot ; hidden button
	Gui, Font, s7 cWhite, Verdana
	Hotkey, Esc, GuiEscape_StayHydratedBot,On
	Gui, Add, Text,x25, Version: %VN%	Author: %AU% 
	gui, show, autosize
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
	Gui, add, Edit, %gui_control_options% vvMinutes_StandUpBot -VScroll 
	Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmit_StandUpBot ; hidden button
	Gui, Font, s7 cWhite, Verdana
	Hotkey, Esc, GuiEscape_StandUpBot,On
	Gui, Add, Text,x25, Version: %VN%	Author: %AU% 
	gui, show, autosize
	
}
return


lToggleBotHUD_StayHydratedBot:		;**
{
	HUDStatus_StayHydratedBot:=!HUDStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, HUD
	sleep, 20
	PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
	if HUDStatus_StayHydratedBot
	 	Notify().AddWindow("HUD Alert toggled on , Period: "vMinutes_StayHydratedBot " minutes",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("HUD Alert toggled off",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return

lToggleBotHUD_StandUpBot:			;**
{
	HUDStatus_StandUpBot:=!HUDStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, HUD
	sleep, 20
	PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
	if HUDStatus_StandUpBot
	 	Notify().AddWindow("HUD Alert toggled on , Period: "vMinutes_StandUpBot " minutes",{Title:"StandUpBot (ง'̀-'́)ง ",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("HUD Alert toggled off",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return


lToggleBotAudio_StayHydratedBot:		;**
{
	SoundStatus_StayHydratedBot:=!SoundStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, Sound
	sleep, 20
	PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
	if SoundStatus_StayHydratedBot
	 	Notify().AddWindow("Audio Alert toggled on, Period: "vMinutes_StayHydratedBot " minutes",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("Audio Alert toggled off",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return

lToggleBotAudio_StandUpBot:			;**
{
	SoundStatus_StandUpBot:=!SoundStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, Sound
	sleep, 20
	PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
	if SoundStatus_StandUpBot
	 	Notify().AddWindow("Audio Alert toggled on, Period: "vMinutes_StandUpBot " minutes",{Title:"StandUpBot (ง'̀-'́)ง ",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	else
		Notify().AddWindow("Audio Alert toggled off",{Title:"StandUpBot (ง'̀-'́)ง ",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
}
return


PlayTune_StayHydratedBot: 			;**FileNameIniRead:=ScriptName . ".ini"
{
	if HUDStatus_StayHydratedBot
	{
		sFullFilePathToAudioFile_StayHydratedBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot)
		if bRunNotify
		{
			PathForNotify_StandUpBot=%A_ScriptDir%\Waterbottle.png
			Notify().AddWindow("Remember to stay hydrated...",{Title:"(~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedNot})
		}
	}
	if (StrLen(sFullFilePathToAudioFile_StayHydratedBot) >= 127) and InStr(sFullFilePathToAudioFile_StayHydratedBot,".wav")
		Throw, "The Pathlength of the absolute path to the .wav-audiofile is greater than 127 characters. For .wav-files, this is an error of SoundPlay."
	if SoundStatus_StayHydratedBot
		SoundPlay, % sFullFilePathToAudioFile_StayHydratedBot
	sleep, 500
	tooltip, 
}
return

PlayTune_StandUpBot: 				;**
{
	if HUDStatus_StandUpBot
	{
		sFullFilePathToAudioFile_StandUpBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StandUpBot)
		if bRunNotify
		{
			
			PathForNotify_StandUpBot=%A_ScriptDir%\Waterbottle.png
			if bStandingposition
			{
				Notify().AddWindow("Remember to stand up...",{Title:"(~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedNot})
				bStandingposition:=0
			}
			else
			{
				Notify().AddWindow("Remember to sit down...",{Title:"(~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedNot})
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


lPause_StayHydratedBot:				;**  * Anmerkung: changing image to StayHydratedBot-menu to reflect the state: red-red=SoundOffNotificationOff, red-green=SoundOffNotificationOn, green-green=SoundOnNotificationOn
{
	/*
		Date: 27 April 2021 18:18:24:
		todo: add changing image to this when deactivating, then reactivate if pressed again: rename the menuitem option
	*/
	
	PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
	PauseStatus_StayHydratedBot:=!PauseStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, Pause
	if PauseStatus_StayHydratedBot
	{
		Notify().AddWindow("Pausing StayHydratedBot",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
		menu, StayHydratedBot, UnCheck, Sound
		menu, StayHydratedBot, UnCheck, HUD
		menu, StayHydratedBot, ToggleEnable, Sound
		menu, StayHydratedBot, ToggleEnable, HUD
		SoundStatus_StayHydratedBot:=0
		HUDStatus_StayHydratedBot:=0
	}
	Else
	{
		
		Notify().AddWindow("Resuming StayHydratedBot",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
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

lPause_StandUpBot:  				;**
{
	PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
	PauseStatus_StandUpBot:=!PauseStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, Pause
	if PauseStatus_StandUpBot
	{
		Notify().AddWindow("Pausing StandUpBot",{Title:"StandUpBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
		menu, StandUpBot, UnCheck, Sound
		menu, StandUpBot, UnCheck, HUD
		menu, StandUpBot, ToggleEnable, Sound
		menu, StandUpBot, ToggleEnable, HUD
		SoundStatus_StandUpBot:=0
		HUDStatus_StandUpBot:=0
	}
	Else
	{
		
		Notify().AddWindow("Resuming StandUpBot",{Title:"StandUpBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:PathForNotify_StayHydratedNot})
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


lEditSettings_StandUpBot:			;**
{
	gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, Font, s11 cWhite, Segoe UI 
	Gui, Add, Tab3,, Active|Backup|Original
	Gui, Font, s11 cWhite, Verdana
	Hotkey, Enter, SubmitChangedSettings_StandUpBot,On
	Hotkey, Esc, GuiEscape_StandUpBot,On
	gui, tab, Active
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBot_Active, % IniObj["Settings StandUpBot"]["sFullFilePathToAudioFile_StandUpBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll vDefaultTimeInMinutes_StandUpBot_Active, % IniObj["Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll vNotificationTimeInMilliSeconds_StandUpBot_Active, % IniObj["Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StandUpBot ; hidden button
	gui, tab, Backup
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["sFullFilePathToAudioFile_StandUpBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll vDefaultTimeInMinutes_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll vNotificationTimeInMilliSeconds_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	gui, tab, Original
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab ReadOnly r3 vPathToNewFileNew_StandUpBot_Original, % IniObj["Settings StandUpBot"]["sFullFilePathToAudioFile_StandUpBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll ReadOnly vDefaultTimeInMinutes_StandUpBot_Original, % IniObj["Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll ReadOnly vNotificationTimeInMilliSeconds_StandUpBot_Original, % IniObj["Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	gui, tab
	Gui, Font, s7 cWhite, Verdana
	Gui, Add, Text,x25, Version: %VN%	Author: %AU% 
	gui, show, AutoSize
}
return

lEditSettings_StayHydratedBot:		;**
{
	gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, Font, s11 cWhite, Segoe UI 
	Gui, Add, Tab3,, Active|Backup|Original
	Gui, Font, s11 cWhite, Verdana
	Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,On
	Hotkey, Esc, GuiEscape_StayHydratedBot,On
	gui, tab, Active
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll vDefaultTimeInMinutes_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll vNotificationTimeInMilliSeconds_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StayHydratedBot ; hidden button
	gui, tab, Backup
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll vDefaultTimeInMinutes_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll vNotificationTimeInMilliSeconds_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StayHydratedBot ; hidden button
	gui, tab, Original
	gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab ReadOnly r3 vPathToNewFileNew_StayHydratedBot_Original, % IniObj["Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll ReadOnly vDefaultTimeInMinutes_StayHydratedBot_Original, % IniObj["Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll ReadOnly vNotificationTimeInMilliSeconds_StayHydratedBot_Original, % IniObj["Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	;Gui, Add, Button, x-10 y-10 w1 h1 +default gSubmitChangedSettings_StayHydratedBot ; hidden button
	gui, tab
	Gui, Font, s7 cWhite, Verdana
	Gui, Add, Text,x25, Version: %VN%	Author: %AU% 
	gui, show, AutoSize
}
return


	;_____________________________________________________________________________________
	;_____________________________________________________________________________________
SubmitChangedSettings_StayHydratedBot: 	;**
{
	gui, submit
	gui, destroy
	Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,Off
	Hotkey, Esc, GuiEscape_StayHydratedBot,Off
	; active
	if PathToNewFileNew_StayHydratedBot_Active
		IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot:=PathToNewFileNew_StayHydratedBot_Active
	if DefaultTimeInMinutes_StayHydratedBot_Active
		IniObj["Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot:=DefaultTimeInMinutes_StayHydratedBot_Active
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	if NotificationTimeInMilliSeconds_StayHydratedBot_Active
		IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot:=NotificationTimeInMilliSeconds_StayHydratedBot_Active
	else
		throw,"Error occured: The notification time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	;backup
	if PathToNewFileNew_StayHydratedBot_Backup
		IniObj["Backup Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot:=PathToNewFileNew_StayHydratedBot_Backup
	if DefaultTimeInMinutes_StayHydratedBot_Backup
		IniObj["Backup Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot:=DefaultTimeInMinutes_StayHydratedBot_Backup
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	if NotificationTimeInMilliSeconds_StayHydratedBot_Backup
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
	Hotkey, Enter, SubmitChangedSettings_StandUpBot,Off
	Hotkey, Esc, GuiEscape_StandUpBot,Off
	; active 
	if PathToNewFileNew_StandUpBot_Active
		IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot:=PathToNewFileNew_StandUpBot_Active
	if DefaultTimeInMinutes_StandUpBot_Active and DefaultTimeInMinutes_StandUpBot_Active is in integer
		IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot:=DefaultTimeInMinutes_StandUpBot_Active
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	if NotificationTimeInMilliSeconds_StandUpBot_Active and NotificationTimeInMilliSeconds_StandUpBot_Active is in integer
		IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot:=NotificationTimeInMilliSeconds_StandUpBot_Active
	else
		throw,"Error occured: The notification time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	; Backup
	if PathToNewFileNew_StandUpBot_Backup
		IniObj["Backup Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot:=PathToNewFileNew_StandUpBot_Backup
	if DefaultTimeInMinutes_StandUpBot_Backup and DefaultTimeInMinutes_StandUpBot_Backup is in integer
		IniObj["Backup Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot:=DefaultTimeInMinutes_StandUpBot_Backup
	else
		throw,"Error occured: The default reminder time entered is not an integer.`nThe value must be given as a plain integer such as 2000 for 2 seconds`nPlease either edit the file and resolve this or delete the ini-file in the GeneralHealthBot-Folder"
	if NotificationTimeInMilliSeconds_StandUpBot_Backup and NotificationTimeInMilliSeconds_StandUpBot_Backup is in integer
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
Hotkey, Esc, GuiEscape_AboutStayHydratedBot,Off
Hotkey, Enter, GuiEscape_AboutStayHydratedBot, Off
gui, destroy
return

	;}______________________________________________________________________________________

f_AboutStayHydratedBot(ScriptName,AU,VN,LE)
{
	MsgBox,, File Overview, Name: %ScriptName%`nAuthor: %AU%`nVersionNumber: %VN%`nLast Edit: %LE%`n`nScript Location: %A_ScriptDir%
}
return

f_OnExit_StayHydratedBot()
{
	Notify().AddWindow("Stay Hydrated. Bye Bye.",{Title:"StayHydratedBot (~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	sleep, 2000
	ExitApp
}

f_ReadBackSettings_StayHydratedBot()
{
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	
	CheckFilePathIniRead=%A_ScriptDir%\StayHydratedBot\%FileNameIniRead%
	/* DONE?
		Date: 16 Mai 2021 09:15:33: Figure out how you want userconfirmation to  be
		performed.  rewrite the gui for the settings edit to contain all six to nine
		fields per bot << prefer this version, as it is MUCH simpler.  	 or rename all
		sections into "A"/"B"/"C", then just make a button to set which one is actively
		loaded. ← this is the more versatile, albeit more complex version because it
		requires more extensive rewrites across the entire file (or, on rewrite replace
		the )
	*/
	if FileExist(CheckFilePathIniRead) ; read back settings from IniFile
		IniObj := f_ReadINI_Bots(FileNameIniRead) ; this does work
	Else 							; set default-settings in case ini-file doesn't exist
	{
		IniSections:=[]
		IniSections ["Settings StayHydratedBot"]
			:= {  	sFullFilePathToAudioFile_StayHydratedBot: 	"A_ScriptDir\beep-01a.wav"
				,   vDefaultTimeInMinutes_StayHydratedBot: 	45
				, 	vNotificationTimeInMilliSeconds_StayHydratedBot: 4000
				, 	HUDStatus_StayHydratedBot: 1
				, 	SoundStatus_StayHydratedBot: 1}
		IniSections ["Settings StandUpBot"]
			:= {  	sFullFilePathToAudioFile_StandUpBot: 	"A_ScriptDir\beep-01a.wav"
				,    vDefaultTimeInMinutes_StandUpBot: 	45
				, 	vNotificationTimeInMilliSeconds_StandUpBot: 4000
				, 	HUDStatus_StandUpBot: 1
				, 	SoundStatus_StandUpBot: 1}
		f_WriteINI_Bots(IniSections, ScriptName)
		IniObj:=f_ReadINI_Bots(FileNameIniRead) ; this works
		IniObj["Backup Settings StayHydratedBot"]:=IniObj["Settings StayHydratedBot"].clone()	;; cf above for explanation
		IniObj["Original Settings StayHydratedBot"]:=IniObj["Settings StayHydratedBot"].clone()
		IniObj["Backup Settings StandUpBot"]:=IniObj["Settings StandUpBot"].clone()	;; cf above for explanation
		IniObj["Original Settings StandUpBot"]:=IniObj["Settings StandUpBot"].clone()
		f_WriteINI_Bots(IniObj, ScriptName)		; super redundant, I will have to redo this once again. 
		
	}
	return IniObj
}

f_ReadINI_Bots(INI_File) ; return 2D-array from INI-file
{
	Result := [] 
	OrigWorkDir:=A_WorkingDir
	SetWorkingDir, StayHydratedBot
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

f_WriteINI_Bots(ByRef Array2D, INI_File)  ; write 2D-array to INI-file 
{
	if !FileExist("GeneralHealthBots") ; check for StayHydratedBot directory
	{
		MsgBox, "Creating ""GeneralHealthBots"-directory at Location`n"%A_ScriptDir%", containing an ini-file named "%INI_File%.ini"
		FileCreateDir, GeneralHealthBots
	}
	if IsObject(Array2D)	
	{
		OrigWorkDir:=A_WorkingDir
		SetWorkingDir, StayHydratedBot
		for SectionName, Entry in Array2D 
		{
			Pairs := ""
			for Key, Value in Entry
				Pairs .= Key "=" Value "`n"
			IniWrite, %Pairs%, %INI_File%.ini, %SectionName%
		}
		if A_WorkingDir!=OrigWorkDir
			SetWorkingDir, %OrigWorkDir%
	}
	Else
	{
		OrigWorkDir:=A_WorkingDir
		SetWorkingDir, StayHydratedBot
		for SectionName, Entry in Array2D 
		{
			Pairs := ""
			for Key, Value in Entry
				Pairs .= Key "=" Value "`n"
			IniWrite, %Pairs%, %INI_File%.ini, %SectionName%
		}
		if A_WorkingDir!=OrigWorkDir
			SetWorkingDir, %OrigWorkDir%
		
	}
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

f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile) ; A solution to .wav-files
{
	sFullFilePathToAudioFile=%sFullFilePathToAudioFile%
	sFullFilePathToAudioFile:=Trim(sFullFilePathToAudioFile, """ ")
	sFullFilePathToAudioFile:=StrReplace(sFullFilePathToAudioFile, "A_ScriptDir", A_ScriptDir)
	if (StrLen(sFullFilePathToAudioFile) >= 127)
	{
		loop % sFullFilePathToAudioFile
			sFullFilePathToAudioFile:=A_LoopFileShortPath
	}
	return sFullFilePathToAudioFile
	/*
	; thank you u/anonymous1184 for resolving this stupid bug with soundplay and wavfiles 
		https://www.reddit.com/r/AutoHotkey/comments/myti1k/ihatesoundplay_how_do_i_get_the_string_converted/gvwtwlb?utm_source=share&utm_medium=web2x&context=3
		f_ConvertRelativePath(RelativePath)
		{
			RelativePath = %RelativePath%
			RelativePath:=Trim(RelativePath, """ ")
			FullPath:=StrReplace(RelativePath, "A_ScriptDir", A_ScriptDir)
			if (StrLen(FullPath) >= 127)
			{
				loop % FullPath
					FullPath := A_LoopFileShortPath
			}
			return FullPath
		}
		
	*/
}

;XButton1::
;return
::bot.shb.::	; StayHydratedBot: Show Submenu
Menu, StayHydratedBot, Show
return 
:: bot.sub.::
Menu, StandUpBot, Show
return 




f_CreateTrayMenu_Bots()
{
	menu, tray, add,
	;menu, Tray, Add, About these bots, lCallAboutFun_StayHydratedBot
	menu, Tray, Add, Help, lHelp_StayHydratedBot
	{
		menu, tray, add,
		
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
}

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
			SoundPlay % sFullFilePathToAudioFile_StayHydratedBot
			PathForNotify_StayHydratedNot=%A_ScriptDir%\Waterbottle.png
			;Notify().AddWindow("Remember to stay hydrated...",{Title:"(~˘▾˘)~",TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:PathForNotify_StayHydratedNot})
		}
	}
*/ 








;{
;#SingleInstance,Force
Count:=0
Notify:=Notify(20)
/*
	Usage:
	Notify:=Notify()
	Window:=Notify.AddWindow("Your Text Here",{Icon:4,Background:"0xAA00AA"})
	|---Window ID                                          |--------Options
	Options:
	
	Window ID will be used when making calls to Notify.SetProgress(Window,ProgressValue)
	
	Animate: Ways that the window will animate in eg. {Animate:""} Can be Bottom, Top, Left, Right, Slide, Center, or Blend (Some work together, and some override others)
	Background: Color value in quotes eg. {Background:"0xAA00AA"}
	Buttons: Comma Delimited list of names for buttons eg. {Buttons:"One,Two,Three"}
	Color: Font color eg.{Color:"0xAAAAAA"}
	Destroy: Comma Delimited list of Bottom, Top, Left, Right, Slide, Center, or Blend
	Flash: Flashes the background of the notification every X ms eg. {Flash:1000}
	FlashColor: Sets the second color that your notification will change to when flashing eg. {FlashColor:"0xFF00FF"}
	Font: Face of the message font eg. {Font:"Consolas"}
	Icon: Can be either an Integer to pull an icon from Shell32.dll or a full path to an EXE or full path to a dll.  You can add a comma and an integer to select an icon from within that file eg. {Icon:"C:\Windows\HelpPane.exe,2"}
	IconSize: Width and Height of the Icon eg. {IconSize:20}
	Hide: Comma Separated List of Directions to Hide the Notification eg. {Hide:"Left,Top"}
	Progress: Adds a progress bar eg. {Progress:10} ;Starts with the progress set to 10%
	Radius: Size of the border radius eg. {Radius:10}
	Size: Size of the message text eg {Size:20}
	ShowDelay: Time in MS of how long it takes to show the notification
	Sound: Plays either a beep if the item is an integer or the sound file if it exists eg. {Sound:500}
	Time: Sets the amount of time that the notification will be visible eg. {Time:2000}
	Title: Sets the title of the notification eg. {Title:"This is my title"}
	TitleColor: Title font color eg. {TitleColor:"0xAAAAAA"}
	TitleFont: Face of the title font eg. {TitleFont:"Consolas"}
	TitleSize: Size of the title text eg. {TitleSize:12}
*/
if(1){
	Notify.AddWindow("Testing",{Background:"0xFF00FF",Color:"0xFF0000",ShowDelay:1000,Hide:"Top,Left",Buttons:"This,One,Here",Radius:40})
	return
}
Text:=["Longer text for a longer thing","Taller Text`nfor`na`ntaller`nthing"]
SetTimer,RandomProgress,500
Loop,2
{
	Random,Time,3000,8000
	/*
		Time:=A_Index=40?1000:Time
		Random,Sound,500,800
	*/
	Random,TT,1,2
	Random,Background,0x0,0xFFFFFF
	Random,Color,0x0,0xFFFFFF
	Random,Icon,20,200
	Notify.AddWindow(Text[TT],{Icon:300,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,Color:Color})
	Notify.AddWindow(Text[TT],{Icon:"D:\AHK\AHK-Studio\AHK-Studio.exe",IconSize:20,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,FlashColor:"0xAA00AA",Color:Color,Time:Time,Sound:Sound})
	Notify.AddWindow(Text[TT],{Icon:Icon,IconSize:80,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,FlashColor:"0xAA00AA",Color:Color,Time:Time,Sound:Sound})
	ID:=Notify.AddWindow(Text[TT],{Progress:0,Icon:Icon,IconSize:80,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,FlashColor:"0xAA00AA",Color:Color,Time:Time,Sound:Sound})
	Notify.AddWindow("This is my text",{Title:"My Title"})
	Random,Ico,1,5
	Notify.AddWindow("Odd icon",{Icon:A_AhkPath "," Ico,IconSize:20,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Time:Time,Background:Background,Flash:1000,Color:Color,Time:Time})
	Random,Delay,100,400
	Delay:=1000
	Notify.AddWindow(Text[TT],{Radius:20,Hide:"Left,Bottom",Animate:"Right,Slide",ShowDelay:Delay,Icon:Icon,IconSize:20,Title:"This is my title",TitleFont:"Tahoma",TitleSize:10,Background:Background,Color:Color,Time:Time,Progress:0})
}
return
RandomProgress:
for a,b in NotifyClass.Windows{
	Random,Pro,10,100
	Notify.SetProgress(a,Pro)
}
return
Click(Obj){
	for a,b in Obj
		Msg.=a " = " b "`n"
    	;MsgBox,%Msg% ;; this msg-box is activated whenever any editfield of any gui within a script containing notify is clicked.
}
;Actual code starts here
Notify(Margin:=5){
	static Notify:=New NotifyClass()
	Notify.Margin:=Margin
	return Notify
}
Class NotifyClass{
	__New(Margin:=10){
		this.ShowDelay:=40,this.ID:=0,this.Margin:=Margin,this.Animation:={Bottom:0x00000008,Top:0x00000004,Left:0x00000001,Right:0x00000002,Slide:0x00040000,Center:0x00000010,Blend:0x00080000}
		if(!this.Init)
			OnMessage(0x201,NotifyClass.Click.Bind(this)),this.Init:=1
	}AddWindow(Text,Info:=""){
		(Info?Info:Info:=[])
		for a,b in {Background:0,Color:"0xAAAAAA",TitleColor:"0xAAAAAA",Font:"Consolas",TitleSize:12,TitleFont:"Consolas",Size:20,Font:"Consolas",IconSize:20}
			if(Info[a]="")
				Info[a]:=b
		if(!IsObject(Win:=NotifyClass.Windows))
			Win:=NotifyClass.Windows:=[]
		Hide:=0
		for a,b in StrSplit(Info.Hide,",")
			if(Val:=this.Animation[b])
				Hide|=Val
		Info.Hide:=Hide
		DetectHiddenWindows,On
		this.Hidden:=Hidden:=A_DetectHiddenWindows,this.Current:=ID:=++this.ID,Owner:=WinActive("A")
 		Gui,Win%ID%:Default
		if(Info.Radius)
			Gui,Margin,% Floor(Info.Radius/3),% Floor(Info.Radius/3)
		Gui,-Caption +HWNDMain +AlwaysOnTop +Owner%Owner%
		Gui,Color,% Info.Background,% Info.Background
		NotifyClass.Windows[ID]:={ID:"ahk_id" Main,HWND:Main,Win:"Win" ID,Text:Text,Background:Info.Background,FlashColor:Info.FlashColor,Title:Info.Title,ShowDelay:Info.ShowDelay,Destroy:Info.Destroy}
		for a,b in Info
			NotifyClass.Windows[ID,a]:=b
		if((Ico:=StrSplit(Info.Icon,",")).1)
			Gui,Add,Picture,% (Info.IconSize?"w" Info.IconSize " h" Info.IconSize:""),% "HBITMAP:" LoadPicture(Foo:=(Ico.1+0?"Shell32.dll":Ico.1),Foo1:="Icon" (Ico.2!=""?Ico.2:Info.Icon),2)
		if(Info.Title){
			Gui,Font,% "s" Info.TitleSize " c" Info.TitleColor,% Info.TitleFont
			Gui,Add,Text,x+m,% Info.Title
		}Gui,Font,% "s" Info.Size " c" Info.Color,% Info.Font
		Gui,Add,Text,HWNDText,%Text%
		SysGet,Mon,MonitorWorkArea
		if(Info.Sound+0)
			SoundBeep,% Info.Sound
		if(FileExist(Info.Sound))
			SoundPlay,% Info.Sound
		this.MonBottom:=MonBottom,this.MonTop:=MonTop,this.MonLeft:=MonLeft,this.MonRight:=MonRight
		if(Info.Time){
			TT:=this.Dismiss.Bind({this:this,ID:ID})
			SetTimer,%TT%,% "-" Info.Time
		}if(Info.Flash){
			TT:=this.Flash.Bind({this:this,ID:ID})
			SetTimer,%TT%,% Info.Flash
			NotifyClass.Windows[ID].Timer:=TT
		}
		for a,b in StrSplit(Info.Buttons,","){
			Gui,Margin,% Info.Radius?Info.Radius/2:5,5
			Gui,Font,s10
			Gui,Add,Button,% (a=1?"xm":"x+m"),%b%
		}
		if(Info.Progress!=""){
			Gui,Win%ID%:Font,s4
			ControlGetPos,x,y,w,h,,ahk_id%Text%
			Gui,Add,Progress,w%w% HWNDProgress,% Info.Progress
			NotifyClass.Windows[ID].Progress:=Progress
		}Gui,Win%ID%:Show,Hide
		WinGetPos,x,y,w,h,ahk_id%Main%
		if(Info.Radius)
			WinSet, Region, % "0-0 w" W " h" H " R" Info.Radius "-" Info.Radius,ahk_id%Main%
		Obj:=this.SetPos(),Flags:=0
		for a,b in StrSplit(Info.Animate,",")
			Flags|=Round(this.Animation[b])
		DllCall("AnimateWindow","UInt",Main,"Int",(Info.ShowDelay?Info.ShowDelay:this.ShowDelay),"UInt",(Flags?Flags:0x00000008|0x00000004|0x00040000|0x00000002))
		for a,b in StrSplit((Obj.Destroy?Obj.Destroy:"Top,Left,Slide"),",")
			Flags|=Round(this.Animation[b])
		Flags|=0x00010000,NotifyClass.Windows[ID].Flags:=Flags
		DetectHiddenWindows,%Hidden%
		return ID
	}Click(){
		Obj:=NotifyClass.Windows[RegExReplace(A_Gui,"\D")],Obj.Button:=A_GuiControl,(Fun:=Func("Click"))?Fun.Call(Obj):"",this.Delete(A_Gui)
	}Delete(Win){
		Win:=RegExReplace(Win,"\D"),Obj:=NotifyClass.Windows[Win],NotifyClass.Windows.Delete(Win)
		if(WinExist("ahk_id" Obj.HWND)){
			DllCall("AnimateWindow","UInt",Obj.HWND,"Int",Obj.ShowDelay,"UInt",Obj.Flags)
			Gui,% Obj.Win ":Destroy"
		}if(TT:=Obj.Timer)
			SetTimer,%TT%,Off
		this.SetPos()
	}Dismiss(){
		this.this.Delete(this.ID)
	}Flash(){
		Obj:=NotifyClass.Windows[this.ID]
		Obj.Bright:=!Obj.Bright
		Color:=Obj.Bright?(Obj.FlashColor!=""?Obj.FlashColor:Format("{:06x}",Obj.Background+800)):Obj.Background
		if(WinExist(Obj.ID))
			Gui,% Obj.Win ":Color",%Color%,%Color%
	}SetPos(){
		Width:=this.MonRight-this.MonLeft,MH:=this.MonBottom-this.MonTop,MinX:=[],MinY:=[],Obj:=[],Height:=0,Sub:=0,MY:=MH,MaxW:={0:1},Delay:=A_WinDelay,Hidden:=A_DetectHiddenWindows
		DetectHiddenWindows,On
		SetWinDelay,-1
		for a,b in NotifyClass.Windows{
			WinGetPos,x,y,w,h,% b.ID
			Height+=h+this.Margin
			if(MH<=Height)
				Sub:=Width-MinX.MinIndex()+this.Margin,MY:=MH,MinY:=[],MinX:=[],Height:=h,MaxW:={0:1},Reset:=1
			MaxW[w]:=1,MinX[Width-w-Sub]:=1,MinY[MY:=MY-h-this.Margin]:=y,XPos:=MinX.MinIndex()+(Reset?0:MaxW.MaxIndex()-w)
			WinMove,% b.ID,,%XPos%,MinY.MinIndex()
			Obj[a]:={x:x,y:y,w:w,h:h},Reset:=0
		}DetectHiddenWindows,%Hidden%
		SetWinDelay,%Delay%
	}SetProgress(ID,Progress){
		GuiControl,,% NotifyClass.Windows[ID].Progress,%Progress%
	}
}

;Actual Code Ends Here
return
;Escape::
;ExitApp
;return
;}



