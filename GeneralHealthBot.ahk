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
		
*/
; Default sounds queried from: 
; https://freesound.org/people/puneet222/sounds/349174/
; 
; TODO: add documentation on the "Intrusive"-mode



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.0
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
VN=2.3.5.4                                                                     
PublicVersionNumber=1.0.4.1
LE=08 Juli 2021 09:10:04                               
;}_____________________________________________________________________________________
; Initialise 
vUserName:="Gewerd-Strauss"
vProjectName:="GeneralHealthBots.ahk"
vFileName:="GeneralHealthBot.ahk"	; added testing stuff so I don't have to use this 
FolderStructIncludesRelativeToMainScript:="GeneralHealthBots/includes/"
FolderStructIniFileRelativeToMainScript:="GeneralHealthBots/FileVersions/FileVersions GeneralHealthBot.ini"
FolderOfVersioningFile:="GeneralHealthBots/FileVersions"
LocalValues:=[]
GitPageURLComponents:=[]
LocalValues:=[AU,VN,FolderStructIncludesRelativeToMainScript,FolderOfVersioningFile]
GitPageURLComponents:=[vUserName,VProjectName,vFileName,FolderStructIniFileRelativeToMainScript]
	;sFullFilePathToAudioFile_StayHydratedBotDown:=IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFileDown_StayHydratedBot	; extract values for notify
	;sFullFilePathToAudioFile_StayHydratedBotUp:=IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFileUp_StayHydratedBot	; extract values for notify


; FolderStructIniFileRelativeToMainScript is the path of the versioning-file, NOT the ini-file storing the script settings.
;______________________________________________________________________________________
;______________________________________________________________________________________
;{#[Autorun Section]
if WinActive("Visual Studio Code")	; if run in vscode, deactivate notify-messages to avoid crashing the program.
{
	bRunNotify:=0
	vsdb:=1
}
else
{
	bRunNotify:=1 	; otherwise 
	vsdb:=0
}
;strLegend=Bot|Time|min     |S|H "`n"
;}_____________________________________________________________________________________
;{ Load Settings from Ini-File_________________________________________________________
IniObj:=f_ReadBackSettings_StayHydratedBot()
;}_____________________________________________________________________________________
;{ Tray Menu___________________________________________________________________________
f_CreateTrayMenu_Bots(IniObj)
if bRunNotify
{
	notify().AddWindow("Startup",{Title:"General Health Bots",TitleColor:"0xFFFFFF",Time:1000,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15}) ; 
	sleep,1100
}
vMinutes_StandUpBot_Temp:="empty"
vMinutes_StayHydratedBot_Temp:="empty"
lIsIntrusive_StayHydratedBot:="empty"
lIsIntrusive_StandUpBot:="empty"
PauseStatus_StandUpBot:=0
PauseStatus_StayHydratedBot:=0
gosub, Submit_StayHydratedBot
sleep, 3000
gosub, Submit_StandUpBot
sleep, 3000
return
;}_____________________________________________________________________________________
;{ GuiEscape/GuiSubmit_________________________________________________________________
GuiEscape_StandUpBot:				;**
GuiEscape_StayHydratedBot:			;**
GuiEscape_AboutStayHydratedBot:		;**
{
	f_UnstickModKeys()
	f_DestroyGuis()
	Gui, destroy 
}
return 

Submit_StayHydratedBot: 				;**
{
	sFullFilePathToAudioFile_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sFullFilePathToAudioFile_StayHydratedBot	; extract values for notify
	sNotifyMessagePause_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessagePause_StayHydratedBot
	sNotifyMessageRemember_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessageRemember_StayHydratedBot
	sNotifyMessageResume_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyMessageResume_StayHydratedBot
	sNotifyTitle_StayHydratedBot:=IniObj["Settings StayHydratedBot"].sNotifyTitle_StayHydratedBot
	SoundStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"].SoundStatus_StayHydratedBot
	if (lIsIntrusive_StayHydratedBot="empty")
		lIsIntrusive_StayHydratedBot:=IniObj["Settings StayHydratedBot"].lIsIntrusive_StayHydratedBot
	if IniObj["Settings StayHydratedBot"].bNotifyIcons											; check if we want to load icons to the notifies
		if Instr(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot,"A_ScriptDir")	; replace relative paths by absolute ones
		{
			if FileExist(A_ScriptDir strreplace(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot,"A_ScriptDir",""))
				sPathToNotifyPicture_StayHydratedBot:=f_ConvertRelativePath(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
		}
	else if FileExist(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
		sPathToNotifyPicture_StayHydratedBot:=f_ConvertRelativePath(IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot)
	vMinutes_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vDefaultTimeInMinutes_StayHydratedBot*1 ; get rid of those pesky quotes. Need to remember this trick ._.
	vNotificationTimeInMilliSeconds_StayHydratedBot:=IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot
	HUDStatus_StayHydratedBot:=IniObj["Settings StayHydratedBot"].HUDStatus_StayHydratedBot
	Gui, Submit
	Gui, destroy
	if (vMinutes_StayHydratedBot_Temp!="empty")
	{
		vMinutes_StayHydratedBot:=vMinutes_StayHydratedBot_Temp
		vMinutes_StayHydratedBot_Temp:="empty"
	}
	vTimerPeriod_StayHydratedBot:=vMinutes_StayHydratedBot*60*1000
	sTrayTipSHB:=A_Now
	EnvAdd, sTrayTipSHB, vMinutes_StayHydratedBot ,Minutes ; add 15 minits
	FormatTime, sTrayTipSHB, %sTrayTipSHB%, HH:mm:ss tt
	if PauseStatus_StayHydratedBot
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|P|P|" lIsIntrusive_StayHydratedBot
	Else
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|" SoundStatus_StayHydratedBot "|" HUDStatus_StayHydratedBot "|" lIsIntrusive_StayHydratedBot
	outputStr:=strLegend strSHB "`n" strSUB
	SetTimer,PlayTune_StayHydratedBot, %vTimerPeriod_StayHydratedBot%
	Menu,Tray,Tip, %outputStr%
	if SoundStatus_StayHydratedBot
		menu, StayHydratedBot, Check, Sound
	if HUDStatus_StayHydratedBot
		menu, StayHydratedBot, Check, HUD
	if lIsIntrusive_StayHydratedBot
		menu, StayHydratedBot, Check, Intrusive
	if bRunNotify
		Notify().AddWindow("Setting Timer to " vMinutes_StayHydratedBot  " minutes",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
}
return


Submit_StandUpBot: 					;**
{
	sFullFilePathToAudioFileUp_StandUpBot:=IniObj["Settings StandUpBot"].sFullFilePathToAudioFileUp_StandUpBot ; extract values for notify
	sFullFilePathToAudioFileDown_StandUpBot:=IniObj["Settings StandUpBot"].sFullFilePathToAudioFileDown_StandUpBot ; extract values for notify
	sNotifyMessageDown_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageDown_StandUpBot
	sNotifyMessagePause_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessagePause_StandUpBot
	sNotifyMessageResume_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageResume_StandUpBot
	sNotifyMessageUp_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyMessageUp_StandUpBot
	sNotifyTitle_StandUpBot:=IniObj["Settings StandUpBot"].sNotifyTitle_StandUpBot
	SoundStatus_StandUpBot:=IniObj["Settings StandUpBot"].SoundStatus_StandUpBot
	if (lIsIntrusive_StandUpBot="empty")
		lIsIntrusive_StandUpBot:=IniObj["Settings StandUpBot"].lIsIntrusive_StandUpBot
	if IniObj["Settings StandUpBot"].bNotifyIcons
		if Instr(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot,"A_ScriptDir")
		{
			if FileExist(A_ScriptDir strreplace(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot,"A_ScriptDir",""))
				sPathToNotifyPicture_StandUpBot:=f_ConvertRelativePath(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot)
		}
	else if FileExist(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot)
		sPathToNotifyPicture_StandUpBot:=f_ConvertRelativePath(IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot)
	vMinutes_StandUpBot:=IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot
	
	vNotificationTimeInMilliSeconds_StandUpBot:=IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot
	HUDStatus_StandUpBot:=IniObj["Settings StandUpBot"].HUDStatus_StandUpBot
	bStandingposition:=IniObj["Settings StandUpBot"].bStandingposition
	if bStandingposition
		sCurrentPosition:="↓"
	else
		sCurrentPosition:="↑"
	Gui, Submit
	Gui, destroy
	if (vMinutes_StandUpBot_Temp!="empty")
	{
		vMinutes_StandUpBot:=vMinutes_StandUpBot_Temp
		vMinutes_StandUpBot_Temp:="empty"
	}
	vTimerPeriod_StandUpBot:=vMinutes_StandUpBot*60*1000
	sTrayTipSUB:=A_Now
	EnvAdd, sTrayTipSUB, vMinutes_StandUpBot,Minutes
	FormatTime, sTrayTipSUB, %sTrayTipSUB%, HH:mm:ss tt
	if PauseStatus_StandUpBot
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|P|P|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	Else
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|" SoundStatus_StandUpBot "|" HUDStatus_StandUpBot "|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	
	outputStr:=strLegend strSHB "`n" strSUB
	SetTimer,PlayTune_StandUpBot, %vTimerPeriod_StandUpBot%
	Menu,Tray,Tip,%outputStr%
	if SoundStatus_StandUpBot
		menu, StandUpBot, Check, Sound
	if HUDStatus_StandUpBot
		menu, StandUpBot, Check, HUD
	if IsIntrusive_StandUpBot
		menu, StandUpBot, Check, Intrusive
	if bRunNotify		
		Notify().AddWindow("Setting Timer to " vMinutes_StandUpBot " minutes",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
}
return
;}_____________________________________________________________________________________
;{ Tray Menu linked Labels_____________________________________________________________
lHelp_StayHydratedBot:				;**
f_Help_GeneralHealthBots(AU,VN)
return

lOpenScriptFolder:
run, %A_ScriptDir%
return

lReload:
Notify().AddWindow("Reloading.",{Title:"",TitleColor:"0xFFFFFF",Time:1300,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
sleep, 1300
Reload
return


lSetCurrentDelay_StayHydratedBot:		;**
{ 
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, font, s7 cWhite, Verdana
	Gui, font, s11 cWhite, Segoe UI 
	Gui, add, text,xm ym+10,Set Time in minutes till the next`ndrinking reminder
	Gui, add, Edit, %gui_control_options%  vvMinutes_StayHydratedBot_Temp -VScroll 
	Gui, add, Button, x-10 y-10 w1 h1 +default gSubmit_StayHydratedBot ; hidden button
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,x25, Version: %VN%	Author: %AU% 
	Gui, show,autosize, %A_ThisLabel% ; gui_
} 
return

lSetCurrentDelay_StandUpBot:			;**
{
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, font, s7 cWhite, Verdana
	Gui, font, s11 cWhite, Segoe UI 
	Gui, add, text,xm ym+10,Set Time in minutes till the next`nstanding reminder
	Gui, add, Edit, %gui_control_options%  vvMinutes_StandUpBot_Temp -VScroll 
	Gui, add, Button, x-10 y-10 w1 h1 +default gSubmit_StandUpBot ; hidden button
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,x25, Version: %VN%	Author: %AU% 
	Gui, show,autosize, %A_ThisLabel% 
	
}
return 


lToggleBotHUD_StayHydratedBot:		;***
{
	HUDStatus_StayHydratedBot:=!HUDStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, HUD
	sleep, 20
	
	if HUDStatus_StayHydratedBot
		Notify().AddWindow("HUD Alert toggled on, Period: " vMinutes_StayHydratedBot " minutes",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	else
		Notify().AddWindow("HUD Alert toggled off",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	if PauseStatus_StayHydratedBot
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|P|P|" lIsIntrusive_StayHydratedBot
	Else
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|" SoundStatus_StayHydratedBot "|" HUDStatus_StayHydratedBot "|" lIsIntrusive_StayHydratedBot
	outputStr:=strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
}
return

lToggleBotHUD_StandUpBot:			;***
{
	HUDStatus_StandUpBot:=!HUDStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, HUD
	sleep, 20
	if HUDStatus_StandUpBot
		Notify().AddWindow("HUD Alert toggled on, Period: "vMinutes_StandUpBot " minutes",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	else
		Notify().AddWindow("HUD Alert toggled off",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	if PauseStatus_StandUpBot
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|P|P|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	else
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|" SoundStatus_StandUpBot "|" HUDStatus_StandUpBot "|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	outputStr:=strLegend strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
}
return


lToggleBotAudio_StayHydratedBot:		;***
{
	SoundStatus_StayHydratedBot:=!SoundStatus_StayHydratedBot
	menu, StayHydratedBot, ToggleCheck, Sound
	sleep, 20
	if SoundStatus_StayHydratedBot
		Notify().AddWindow("Audio Alert toggled on, Period: " vMinutes_StayHydratedBot " minutes",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	else
		Notify().AddWindow("Audio Alert toggled off",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	
	if PauseStatus_StayHydratedBot
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|P|P|" lIsIntrusive_StayHydratedBot
	Else
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|" SoundStatus_StayHydratedBot "|" HUDStatus_StayHydratedBot "|" lIsIntrusive_StayHydratedBot
	outputStr:=strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
}
return

lToggleBotAudio_StandUpBot:			;***
{
	SoundStatus_StandUpBot:=!SoundStatus_StandUpBot
	menu, StandUpBot, ToggleCheck, Sound
	sleep, 20
	sPathForNotify_StayHydratedBot=%A_ScriptDir%\Waterbottle.png
	if SoundStatus_StandUpBot
	{
		menu, StandUpBot, Check, Sound
		Notify().AddWindow("Audio Alert toggled on, Period: "vMinutes_StandUpBot " minutes",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	}
	else
	{
		menu, StandUpBot, UnCheck, Sound
		Notify().AddWindow("Audio Alert toggled off",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	}
	if PauseStatus_StandUpBot
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|P|P|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	Else
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|" SoundStatus_StandUpBot "|" HUDStatus_StandUpBot "|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	outputStr:=strLegend strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
}
return


lToggleBotIntrusive_StayHydratedBot:
{
	lIsIntrusive_StayHydratedBot:=!lIsIntrusive_StayHydratedBot
	sleep, 20
	if lIsIntrusive_StayHydratedBot
	{
		menu, StayHydratedBot, Check, Intrusive
		if bRunNotify
			Notify().AddWindow("Bot is intrusive now.",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	}
	else
	{
		menu, StayHydratedBot, UnCheck, Intrusive
		if bRunNotify
			Notify().AddWindow("Bot behaves normal now.",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	}
	if PauseStatus_StayHydratedBot
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|P|P|" lIsIntrusive_StayHydratedBot
	Else
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|" SoundStatus_StayHydratedBot "|" HUDStatus_StayHydratedBot "|" lIsIntrusive_StayHydratedBot
	outputStr:=strLegend strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
}
return
lToggleBotIntrusive_StandUpBot:
{
	lIsIntrusive_StandUpBot:=!lIsIntrusive_StandUpBot
	menu, StandUpBot, ToggleCheck, Intrusive
	sleep, 20
	if lIsIntrusive_StandUpBot
	{
		menu, StandUpBot, Check, Intrusive
		if bRunNotify
			Notify().AddWindow("Bot is intrusive now.",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	}
	else
	{
		menu, StandUpBot, UnCheck, Intrusive
		if bRunNotify
			Notify().AddWindow("Bot behaves normal now.",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	}
	if PauseStatus_StandUpBot
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|P|P|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	Else
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|" SoundStatus_StandUpBot "|" HUDStatus_StandUpBot "|" lIsIntrusive_StandUpBot "|" sCurrentPosition
	outputStr:=strLegend strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
}
return

PlayTune_StayHydratedBot: 			;***
{
	if !PauseStatus_StayHydratedBot
	{
		if (StrLen(sFullFilePathToAudioFile_StayHydratedBot) >= 127) and InStr(sFullFilePathToAudioFile_StayHydratedBot,".wav")
			Throw, "The Pathlength of the absolute path to the .wav-audiofile is greater than 127 characters. For .wav-files, this is an error of SoundPlay."
		if SoundStatus_StayHydratedBot
			SoundPlay, % sFullFilePathToAudioFile_StayHydratedBot
		if HUDStatus_StayHydratedBot
		{
			sFullFilePathToAudioFile_StayHydratedBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile_StayHydratedBot)
			if bRunNotify and !lIsIntrusive_StayHydratedBot
				Notify().AddWindow(sNotifyMessageRemember_StayHydratedBot,{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:IniObj["Settings StayHydratedBot"].vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:sPathToNotifyPicture_StayHydratedBot})
			if lIsIntrusive_StayHydratedBot
				f_AlertUserIntrusive(sNotifyMessageRemember_StayHydratedBot,AU,VN)
		}
		sTrayTipSHB:=A_Now
		EnvAdd, sTrayTipSHB, vMinutes_StayHydratedBot ,Minutes ; add 15 minits
		FormatTime, sTrayTipSHB, %sTrayTipSHB%, HH:mm:ss tt
		if PauseStatus_StayHydratedBot
			strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|P|P|" lIsIntrusive_StayHydratedBot
		Else
			strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|" SoundStatus_StayHydratedBot "|" HUDStatus_StayHydratedBot "|" lIsIntrusive_StayHydratedBot
		outputStr:=strLegend strSHB "`n" strSUB
		Menu,Tray,Tip,%outputStr%
		Settimer, RemoveToolTip,-500 
	}
}
return

PlayTune_StandUpBot: 				;***
{
	if !PauseStatus_StandUpBot
	{
		sFullFilePathToAudioFileUp_StandUpBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFileUp_StandUpBot)
		sFullFilePathToAudioFileDown_StandUpBot:=f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFileDown_StandUpBot)
		if (StrLen(sFullFilePathToAudioFileDown_StandUpBot) >= 127) and InStr(sFullFilePathToAudioFileDown_StandUpBot,".wav")
			Throw, "The Pathlength of the absolute path to the 'Sitting-down'-.wav-audiofile is greater than 127 characters. For .wav-files, this is an error of SoundPlay."
		if (StrLen(sFullFilePathToAudioFileUp_StandUpBot) >= 127) and InStr(sFullFilePathToAudioFileUp_StandUpBot,".wav")
			Throw, "The Pathlength of the absolute path to the 'Standing-up'-.wav-audiofile is greater than 127 characters. For .wav-files, this is an error of SoundPlay."
		if bStandingposition 	; if 1/standing, notify to sit down
		{
			if HUDStatus_StandUpBot and bRunNotify and !lIsIntrusive_StandUpBot
				Notify().AddWindow(sNotifyMessageDown_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:sPathToNotifyPicture_StandUpBot})
			if SoundStatus_StandUpBot
				SoundPlay, % sFullFilePathToAudioFileDown_StandUpBot
			if HUDStatus_StandUpBot  and lIsIntrusive_StandUpBot ; if HUDStatus_StandUpBot and bRunNotify and lIsIntrusive_StandUpBot
				f_AlertUserIntrusive(sNotifyMessageDown_StandUpBot,AU,VN)
			bStandingposition:=0
			sCurrentPosition:="↓" ;"Sitting"
		}
		else 					; if 0/sitting, notify to stand up
		{
			if HUDStatus_StandUpBot and bRunNotify and !lIsIntrusive_StandUpBot
				Notify().AddWindow(sNotifyMessageUp_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0xBBBB,Icon:sPathForNotify_StayHydratedBot})
			if SoundStatus_StandUpBot
				SoundPlay, % sFullFilePathToAudioFileUp_StandUpBot
			if HUDStatus_StandUpBot  and lIsIntrusive_StandUpBot ; if HUDStatus_StandUpBot and bRunNotify and lIsIntrusive_StandUpBot
				f_AlertUserIntrusive(sNotifyMessageUp_StandUpBot,AU,VN)
			bStandingposition:=1
			sCurrentPosition:="↑" ;"Standing"
		}
		sTrayTipSUB:=A_Now
		EnvAdd, sTrayTipSUB, vMinutes_StandUpBot,Minutes ; add 15 minits
		FormatTime, sTrayTipSUB, %sTrayTipSUB%, HH:mm:ss tt
		if PauseStatus_StandUpBot
			strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|P|P|" lIsIntrusive_StandUpBot "|" sCurrentPosition
		else
			strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|" SoundStatus_StandUpBot "|" HUDStatus_StandUpBot "|" lIsIntrusive_StandUpBot "|" sCurrentPosition
		outputStr:=strLegend strSHB "`n" strSUB
		Menu,Tray,Tip,%outputStr%
		Settimer, RemoveToolTip,-500 
	}
}
return


lPause_StayHydratedBot:				;*** 
{
	
	PauseStatus_StayHydratedBot:=!PauseStatus_StayHydratedBot
	
	if PauseStatus_StayHydratedBot
	{
		if bRunNotify
			Notify().AddWindow(sNotifyMessagePause_StayHydratedBot,{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
		menu, StayHydratedBot, UnCheck, Sound
		menu, StayHydratedBot, UnCheck, HUD
		menu, StayHydratedBot, Disable, Sound
		menu, StayHydratedBot, Disable, HUD
		menu, StayHydratedBot, Check, Pause
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|P|P|" lIsIntrusive_StayHydratedBot
	}
	Else
	{
		if bRunNotify
			Notify().AddWindow(sNotifyMessageResume_StayHydratedBot,{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
		if SoundStatus_StayHydratedBot
			menu, StayHydratedBot, Check, Sound
		menu, StayHydratedBot, Enable, Sound
		if HUDStatus_StayHydratedBot
			menu, StayHydratedBot, Check, HUD
		menu, StayHydratedBot, Enable, HUD
		Menu, StayHydratedBot, Uncheck, Pause
		strSHB:="SHB: " sTrayTipSHB "|" vMinutes_StayHydratedBot "|" SoundStatus_StayHydratedBot "|" HUDStatus_StayHydratedBot "|" lIsIntrusive_StayHydratedBot
	}
	outputStr:=strLegend strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
	sleep, 20
	Menu,Tray,Tip,%outputStr%
	sleep, 20
	Menu,Tray,Tip,%outputStr%
	sleep, 20
	Menu,Tray,Tip,%outputStr%
}
return

lPause_StandUpBot:  				;***
{
	PauseStatus_StandUpBot:=!PauseStatus_StandUpBot
	
	if PauseStatus_StandUpBot
	{
		if bRunNotify
			Notify().AddWindow(sNotifyMessagePause_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
		menu, StandUpBot, UnCheck, Sound
		menu, StandUpBot, UnCheck, HUD
		menu, StandUpBot, Disable, Sound
		menu, StandUpBot, Disable, HUD
		menu, StandUpBot, Check, Pause
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|P|P|" lIsIntrusive_StandUpBot
	}
	Else
	{
		if bRunNotify
			Notify().AddWindow(sNotifyMessageResume_StandUpBot,{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StandUpBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
		if SoundStatus_StandUpBot
			menu, StandUpBot, Check, Sound
		menu, StandUpBot, Enable, Sound
		if HUDStatus_StandUpBot
			menu, StandUpBot, Check, HUD
		menu, StandUpBot, Enable, HUD
		menu, StandUpBot, UnCheck, Pause
		strSUB:="SUB: " sTrayTipSUB "|" vMinutes_StandUpBot "|" SoundStatus_StandUpBot "|" HUDStatus_StandUpBot "|" lIsIntrusive_StandUpBot
	}
	outputStr:=strLegend strSHB "`n" strSUB
	Menu,Tray,Tip,%outputStr%
	sleep, 20
	Menu,Tray,Tip,%outputStr%
	sleep, 20
	Menu,Tray,Tip,%outputStr%
	sleep, 20
	Menu,Tray,Tip,%outputStr%
}
return

lEditSettings_StandUpBot:			;**
{
	Gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, add, button, xm+190 w28 ym+1 glSwapActiveBackup_StandUpBot, Swp
	Gui, add, button, xm+223 w28 ym+1 glEditAdvancedSettings_StandUpBot, Othr
	Gui, add, button, xm+256 w28 ym+1 glRestoreActiveBackup_StandUpBot, Res
	Gui, add, text, 
	Gui, font, s11 cWhite, Segoe UI 
	Gui, add, text, xm ym-17 w0 h0 ; reposition next elements
	Gui, add, Tab3,, Active|Backup|Original
	Gui, font, s11 cWhite, Verdana
	Gui, tab, Active
	Gui, add, text,xm+30 ym+30, Insert Path of AudioFile (Up)
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBotUp_Active, % IniObj["Settings StandUpBot"]["sFullFilePathToAudioFileUp_StandUpBot"]
	Gui, add, text,xm+30 ym+130, Insert Path of AudioFile (Down)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBotDown_Active, % IniObj["Settings StandUpBot"]["sFullFilePathToAudioFileDown_StandUpBot"]
	Gui, add, Text, xm+30 ym+230, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+255%gui_control_options% -VScroll  vDefaultTimeInMinutes_StandUpBot_Active, % IniObj["Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	Gui, add, text, xm+30 ym+290, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+315%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StandUpBot_Active, % IniObj["Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	Gui, tab, Backup
	Gui, add, text,xm+30 ym+30, Insert Path of AudioFile (Up)
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBotUp_Backup, % IniObj["Backup Settings StandUpBot"]["sFullFilePathToAudioFileUp_StandUpBot"]
	Gui, add, text,xm+30 ym+130, Insert Path of AudioFile (Down)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StandUpBotDown_Backup, % IniObj["Backup Settings StandUpBot"]["sFullFilePathToAudioFileDown_StandUpBot"]
	Gui, add, Text, xm+30 ym+230, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+255%gui_control_options% -VScroll  vDefaultTimeInMinutes_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	Gui, add, text, xm+30 ym+290, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+315%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	Gui, tab, Original
	Gui, add, text,xm+30 ym+30, Insert Path of AudioFile (Up)
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll ReadOnly -Tab r3 vPathToNewFileNew_StandUpBotUp_Original, % IniObj["Original Settings StandUpBot"]["sFullFilePathToAudioFileUp_StandUpBot"]
	Gui, add, text,xm+30 ym+130, Insert Path of AudioFile (Down)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll ReadOnly -Tab r3 vPathToNewFileNew_StandUpBotDown_Original, % IniObj["Original Settings StandUpBot"]["sFullFilePathToAudioFileDown_StandUpBot"]
	Gui, add, Text, xm+30 ym+230, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+255%gui_control_options% -VScroll ReadOnly vDefaultTimeInMinutes_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["vDefaultTimeInMinutes_StandUpBot"]
	Gui, add, text, xm+30 ym+290, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+315%gui_control_options% -VScroll ReadOnly vNotificationTimeInMilliSeconds_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["vNotificationTimeInMilliSeconds_StandUpBot"]
	Gui, tab
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,y377 x25, StandUpBot v.%VN%	Author: %AU% 
		;Gui, add, Text,y292 x25, requires Restart   
	GuiControl, focus, PathToNewFileNew_StandUpBot_Active
	Gui, show,autosize, %A_ThisLabel% 
}
return

lEditSettings_StayHydratedBot:		;**
{
	Gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, add, button, xm+190 w28 ym+1 glSwapActiveBackup_StayHydratedBot, Swp
	Gui, add, button, xm+223 w28 ym+1 glEditAdvancedSettings_StayHydratedBot, Othr
	Gui, add, button, xm+256 w28 ym+1 glRestoreActiveBackup_StayHydratedBot, Res
	Gui, add, text, 
	Gui, font, s11 cWhite, Segoe UI 
	Gui, add, text, xm ym-17 w0 h0 ; reposition next elements
	Gui, add, Tab3,, Active|Backup|Original
	Gui, font, s11 cWhite, Verdana
	Gui, tab, Active
	Gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll  vDefaultTimeInMinutes_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	Gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	Gui, tab, Backup
	Gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab r3 vPathToNewFileNew_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll  vDefaultTimeInMinutes_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	Gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll  vNotificationTimeInMilliSeconds_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	Gui, tab, Original
	Gui, add, text,xm+30 ym+30, Insert (full) FilePath of AudioFile
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll -Tab ReadOnly r3 vPathToNewFileNew_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["sFullFilePathToAudioFile_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+130, Set Def. Reminder Time (min)
	Gui, add, Edit, xm+30 ym+155%gui_control_options% -VScroll ReadOnly  vDefaultTimeInMinutes_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["vDefaultTimeInMinutes_StayHydratedBot"]
	Gui, add, text, xm+30 ym+190, Set Def. Notification Time (ms)
	Gui, add, Edit, xm+30 ym+215%gui_control_options% -VScroll ReadOnly  vNotificationTimeInMilliSeconds_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["vNotificationTimeInMilliSeconds_StayHydratedBot"]
	Gui, tab
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,y280 x25, StayHydratedBot v.%VN%	Author: %AU% 
		;Gui, add, Text,y292 x25, requires Restart   
	Gui, show,autosize, %A_ThisLabel% 
}
return


lSwapActiveBackupAdvanced_StandUpBot:
lSwapActiveBackup_StandUpBot:
{
	Gui, destroy
	Gui, submit
	f_UnstickModKeys()
	/*
				; this is the code-idea for partial swaps, instead of swapping entire settings. I am currently not setting this, as long as I am not having a settings-setting to control it. 
				; In that case, all switches switching those would have to to the same thing. 
				; Alternatively, I could create a general settings-menu to act upon general settings stuff 
				; 
				; which, at this point  would only be this one setting (toggling the swp-button behaviour, for this specific code.)
				; I have not yet decided what I want to do. 
				;sFullFilePathToAudioFile_StandUpBot_Active:=IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot
				;vDefaultTimeInMinutes_StandUpBot_Active:=IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot
				;vNotificationTimeInMilliSeconds_StandUpBot_Active:=IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot
		
				;sFullFilePathToAudioFile_StandUpBot_Backup:=IniObj["Backup Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot
				;vDefaultTimeInMinutes_StandUpBot_Backup:=IniObj["Backup Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot
				;vNotificationTimeInMilliSeconds_StandUpBot_Backup:=IniObj["Backup Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot
		
				;IniObj["Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot:=sFullFilePathToAudioFile_StandUpBot_Backup
				;IniObj["Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot:=vDefaultTimeInMinutes_StandUpBot_Backup
				;IniObj["Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot:=vNotificationTimeInMilliSeconds_StandUpBot_Backup
		
				;IniObj["Backup Settings StandUpBot"].sFullFilePathToAudioFile_StandUpBot:=sFullFilePathToAudioFile_StandUpBot_Active
				;IniObj["Backup Settings StandUpBot"].vDefaultTimeInMinutes_StandUpBot:=vDefaultTimeInMinutes_StandUpBot_Active
				;IniObj["Backup Settings StandUpBot"].vNotificationTimeInMilliSeconds_StandUpBot:=vNotificationTimeInMilliSeconds_StandUpBot_Active
	*/
	vTempActiveINISettings_StandUpBot:=[]
	vTempBackupINISettings_StandUpBot:=[]
	vTempActiveINISettings_StandUpBot:=IniObj["Settings StandUpBot"].clone()
	vTempBackupINISettings_StandUpBot:=IniObj["Backup Settings StandUpBot"].clone()
	IniObj["Settings StandUpBot"]:=vTempBackupINISettings_StandUpBot
	IniObj["Backup Settings StandUpBot"]:=vTempActiveINISettings_StandUpBot
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
	if bRunNotify
		Notify().AddWindow("Swapping Settings",{Title:sNotifyTitle_StandUpBot,TitleColor:"0xFFFFFF",Time:1300,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StandUpBot})
	sleep, 1100
	gosub, Submit_StandUpBot
}
return

lSwapActiveBackupAdvanced_StayHydratedBot:
lSwapActiveBackup_StayHydratedBot:
{
	Gui, destroy
	Gui, submit
	f_UnstickModKeys()
	vTempActiveINISettings_StayHydratedBot:=[]
	vTempBackupINISettings_StayHydratedBot:=[]
	vTempActiveINISettings_StayHydratedBot:=IniObj["Settings StayHydratedBot"].clone()
	vTempBackupINISettings_StayHydratedBot:=IniObj["Backup Settings StayHydratedBot"].clone()
	IniObj["Settings StayHydratedBot"]:=vTempBackupINISettings_StayHydratedBot
	IniObj["Backup Settings StayHydratedBot"]:=vTempActiveINISettings_StayHydratedBot
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
	if bRunNotify
		Notify().AddWindow("Swapping Settings",{Title:sNotifyTitle_StayHydratedBot,TitleColor:"0xFFFFFF",Time:1300,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555,Icon:sPathToNotifyPicture_StayHydratedBot})
	sleep, 1100
	gosub, Submit_StayHydratedBot
}
return


lRestoreActiveBackup_StandUpBot:				;**
{
	Gui, cQ: destroy
	Gui, destroy
	answer:=f_Confirm_Question("Do you want to reset the settings?",AU,VN)
	if (answer="1")
	{
		IniObj:=f_ReadBackSettings_StayHydratedBot(0,1)
		if bRunNotify
			Notify().AddWindow("Resetting 'Active'- and 'Backup'-settings",{Title:sNotifyMessageDown_StandUpBot,TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0,Icon:sPathToNotifyPicture_StandUpBot})
		sleep, 1300
		gosub, Submit_StandUpBot
	}
	else	; reactivate previous hotkeys.
	{
		Gui, cQ: destroy
		Gui, destroy
		gosub, lEditSettings_StandUpBot
	}
}
return

lRestoreActiveBackup_StayHydratedBot:			;**
{
	Gui, cQ: destroy
	Gui, destroy
	answer:=f_Confirm_Question("Do you want to reset the settings?",AU,VN)
	if (answer="1")
	{
		IniObj:=f_ReadBackSettings_StayHydratedBot(1,0)
		if bRunNotify
			Notify().AddWindow("Resetting 'Active'- and 'Backup'-settings",{Title:sNotifyMessageDown_StayHydratedBot,TitleColor:"0x000000",Time:1300,Color:"0x000000",Background:"0xFFFFFF",TitleSize:10,Size:10,ShowDelay:0,Icon:sPathToNotifyPicture_StayHydratedBot})
		sleep, 1300
		gosub, Submit_StayHydratedBot
	}
	else
	{
		Gui, cQ: destroy
		Gui, destroy
		gosub, lEditSettings_StayHydratedBot
	}
}
return


lEditAdvancedSettings_StandUpBot:
{
	Gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, add, button, xm+190 w28 ym+1 glSwapActiveBackupAdvanced_StandUpBot, Swp
	Gui, add, button, xm+223 w28 ym+1 glEditSettings_StandUpBot, Bck 
	Gui, add, button, xm+256 w28 ym+1 glRestoreActiveBackup_StandUpBot, Res
	Gui, add, text, 
	Gui, font, s11 cWhite, Segoe UI 
	Gui, add, text, xm ym-17 w0 h0 ; reposition next elements
	Gui, add, Tab3,, Active|Backup|Original
	Gui, font, s11 cWhite, Verdana
	Gui, tab, Active
	Gui, add, text,xm+30 ym+30, Set Def. HUD Status
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll vHUDStatus_StandUpBot_Active, % IniObj["Settings StandUpBot"]["HUDStatus_StandUpBot"]
	Gui, add, Text, xm+30 ym+90, Set Def. Sound Status
	Gui, add, Edit, xm+30 ym+110%gui_control_options% -VScroll  vSoundStatus_StandUpBot_Active, % IniObj["Settings StandUpBot"]["SoundStatus_StandUpBot"]
	Gui, add, text, xm+30 ym+150, Set a new Path (Notify-Image) %char32% ; this stupid non-printing char gets the perfect spacing for the tab control and the third button
	Gui, add, Edit, xm+30 ym+170%gui_control_options% -VScroll -Tab r3 vsPathToNotifyPicture_StandUpBot_Active, % IniObj["Settings StandUpBot"]["sPathToNotifyPicture_StandUpBot"]
	Gui, add, text, xm+30 ym+250, Set Notify-Title
	Gui, add, edit, xm+30 ym+270%gui_control_options% -VScroll  vsNotifyTitle_StandUpBot_StandUpBot_Active, % IniObj["Settings StandUpBot"]["sNotifyTitle_StandUpBot"]
	Gui, add, text, xm+30 ym+310, Set Starting Position U/D: 1/0
	Gui, add, edit, xm+30 ym+330%gui_control_options% -VScroll r1 vbStandingPosition_StandUpBot_Active, % IniObj["Settings StandUpBot"]["bStandingposition"]
	Gui, add, text, xm+30 ym+370, Show Icons on notify: 1/0
	Gui, add, edit, xm+30 ym+390%gui_control_options% -VScroll r1 vbNotifyIcons_StandUpBot_Active, % IniObj["Settings StandUpBot"]["bNotifyIcons"]
	gui, add, text, xm+30 ym+430, Set default Intrusivity status
	Gui, add, edit, xm+30 ym+450%gui_control_options% -VScroll r1  vlIsIntrusive_StandUpBot_Active, % IniObj["Settings StandUpBot"]["lIsIntrusive_StandUpBot"]
	Gui, tab, Backup
	Gui, add, text,xm+30 ym+30, Set Def. HUD Status
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll vHUDStatus_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["HUDStatus_StandUpBot"]
	Gui, add, Text, xm+30 ym+90, Set Def. Sound Status
	Gui, add, Edit, xm+30 ym+110%gui_control_options% -VScroll  vSoundStatus_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["SoundStatus_StandUpBot"]
	Gui, add, text, xm+30 ym+150, Set a new Path (Notify-Image) %char32%
	Gui, add, Edit, xm+30 ym+170%gui_control_options% -VScroll -Tab r3 vsPathToNotifyPicture_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["sPathToNotifyPicture_StandUpBot"]
	Gui, add, text, xm+30 ym+250, Set Notify-Title
	Gui, add, edit, xm+30 ym+270%gui_control_options% -VScroll  vsNotifyTitle_StayHydratedBot_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["sNotifyTitle_StandUpBot"]
	Gui, add, text, xm+30 ym+310, Set Starting Position U/D: 1/0
	Gui, add, edit, xm+30 ym+330%gui_control_options% -VScroll r1 vbStandingPosition_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["bStandingposition"]
	Gui, add, text, xm+30 ym+370, Show Icons on notify: 1/0
	Gui, add, edit, xm+30 ym+390%gui_control_options% -VScroll r1 vbNotifyIcons_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["bNotifyIcons"]
	gui, add, text, xm+30 ym+430, Set default Intrusivity status
	Gui, add, edit, xm+30 ym+450%gui_control_options% -VScroll r1  vlIsIntrusive_StandUpBot_Backup, % IniObj["Backup Settings StandUpBot"]["lIsIntrusive_StandUpBot"]
	Gui, tab, Original
	Gui, add, text,xm+30 ym+30, Set Def. HUD Status
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll ReadOnly vHUDStatus_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["HUDStatus_StandUpBot"]
	Gui, add, Text, xm+30 ym+90, Set Def. Sound Status
	Gui, add, Edit, xm+30 ym+110%gui_control_options% -VScroll ReadOnly  vSoundStatus_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["SoundStatus_StandUpBot"]
	Gui, add, text, xm+30 ym+150, Set Path to Notify-Image
	Gui, add, Edit, xm+30 ym+170%gui_control_options% -VScroll -Tab r3 ReadOnly vsPathToNotifyPicture_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["sPathToNotifyPicture_StandUpBot"]
	Gui, add, text, xm+30 ym+250, Set Notify-Title
	Gui, add, edit, xm+30 ym+270%gui_control_options% -VScroll  ReadOnly vsNotifyTitle_StayHydratedBot_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["sNotifyTitle_StandUpBot"]
	Gui, add, text, xm+30 ym+310, Set Starting Position U/D: 1/0
	Gui, add, edit, xm+30 ym+330%gui_control_options% -VScroll r1 ReadOnly vbStandingPosition_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["bStandingposition"]
	Gui, add, text, xm+30 ym+370, Show Icons on notify: 1/0
	Gui, add, edit, xm+30 ym+390%gui_control_options% -VScroll r1 ReadOnly vbNotifyIcons_StandUpBot_Original, % IniObj["Original Settings StandUpBot"]["bNotifyIcons"]
	gui, add, text, xm+30 ym+430, Set default Intrusivity status
	Gui, add, edit, xm+30 ym+450%gui_control_options% -VScroll r1 ReadOnly vlIsIntrusive_StandUpBot_ActiveOriginal, % IniObj["Original Settings StandUpBot"]["lIsIntrusive_StandUpBot"]
	Gui, tab
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,x25 y512, StandUpBot v.%VN% Author: %AU%     
	Gui, add, Text,x25 y524, requires Restart     ; offset to previous text: 12 in y, 0 in x 
	Gui, show,autosize,%A_ThisLabel% 
}
return
lEditAdvancedSettings_StayHydratedBot:
{
	Gui, destroy
	gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
	Gui, Margin, 16, 16
	Gui, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
	Gui, Color, 1d1f21, 373b41, 
	Gui, add, button, xm+190 w28 ym+1 glSwapActiveBackupAdvanced_StayHydratedBot, Swp
	Gui, add, button, xm+223 w28 ym+1 glEditSettings_StayHydratedBot, Bck 
	Gui, add, button, xm+256 w28 ym+1 glRestoreActiveBackup_StayHydratedBot, Res
	Gui, add, text, 
	Gui, font, s11 cWhite, Segoe UI 
	Gui, add, text, xm ym-17 w0 h0 ; reposition next elements
	Gui, add, Tab3,, Active|Backup|Original
	Gui, font, s11 cWhite, Verdana
	Gui, tab, Active
	Gui, add, text,xm+30 ym+30, Set Def. HUD Status
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll vHUDStatus_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["HUDStatus_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+90, Set Def. Sound Status
	Gui, add, Edit, xm+30 ym+110%gui_control_options% -VScroll  vSoundStatus_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["SoundStatus_StayHydratedBot"]
	Gui, add, text, xm+30 ym+150, Set a new Path (Notify-Image) %char32% ; this stupid non-printing char gets the perfect spacing for the tab control and the third button
	Gui, add, Edit, xm+30 ym+170%gui_control_options% -VScroll -Tab r3 vsPathToNotifyPicture_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["sPathToNotifyPicture_StayHydratedBot"]
	Gui, add, text, xm+30 ym+250, Set Notify-Title
	Gui, add, edit, xm+30 ym+270%gui_control_options% -VScroll r1 vsNotifyTitle_StayHydratedBot_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["sNotifyTitle_StayHydratedBot"]
	Gui, add, text, xm+30 ym+310, Show Icons on notify: 1/0
	Gui, add, edit, xm+30 ym+330%gui_control_options% -VScroll r1 vbNotifyIcons_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["bNotifyIcons"]
	gui, add, text, xm+30 ym+370, Set default Intrusivity status
	Gui, add, edit, xm+30 ym+390%gui_control_options% -VScroll r1  vlIsIntrusive_StayHydratedBot_Active, % IniObj["Settings StayHydratedBot"]["lIsIntrusive_StayHydratedBot"]
	Gui, tab, Backup
	Gui, add, text,xm+30 ym+30, Set Def. HUD Status
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll vHUDStatus_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["HUDStatus_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+90, Set Def. Sound Status
	Gui, add, Edit, xm+30 ym+110%gui_control_options% -VScroll  vSoundStatus_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["SoundStatus_StayHydratedBot"]
	Gui, add, text, xm+30 ym+150, Set a new Path (Notify-Image) %char32%
	Gui, add, Edit, xm+30 ym+170%gui_control_options% -VScroll -Tab r3 vsPathToNo tifyPicture_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["sPathToNotifyPicture_StayHydratedBot"]
	Gui, add, text, xm+30 ym+250, Set Notify-Title
	Gui, add, edit, xm+30 ym+270%gui_control_options% -VScroll r1 vsNotifyTitle_StayHydratedBot_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["sNotifyTitle_StayHydratedBot"]
	Gui, add, text, xm+30 ym+310, Show Icons on notify: 1/0
	Gui, add, edit, xm+30 ym+330%gui_control_options% -VScroll r1 vbNotifyIcons_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["bNotifyIcons"]
	gui, add, text, xm+30 ym+370, Set default Intrusivity status
	Gui, add, edit, xm+30 ym+390%gui_control_options% -VScroll r1  vlIsIntrusive_StayHydratedBot_Backup, % IniObj["Backup Settings StayHydratedBot"]["lIsIntrusive_StayHydratedBot"]
	Gui, tab, Original
	Gui, add, text,xm+30 ym+30, Set Def. HUD Status
	Gui, add, Edit, xm+30 ym+55%gui_control_options% -VScroll ReadOnly vHUDStatus_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["HUDStatus_StayHydratedBot"]
	Gui, add, Text, xm+30 ym+90, Set Def. Sound Status
	Gui, add, Edit, xm+30 ym+110%gui_control_options% -VScroll  ReadOnly vSoundStatus_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["SoundStatus_StayHydratedBot"]
	Gui, add, text, xm+30 ym+150, Set a new Path (Notify-Image) %char32%
	Gui, add, Edit, xm+30 ym+170%gui_control_options% -VScroll -Tab r3 ReadOnly vsPathToNotifyPicture_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["sPathToNotifyPicture_StayHydratedBot"]
	Gui, add, text, xm+30 ym+250, Set Notify-Title
	Gui, add, edit, xm+30 ym+270%gui_control_options% -VScroll r1 ReadOnly vsNotifyTitle_StayHydratedBot_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["sNotifyTitle_StayHydratedBot"]
	Gui, add, text, xm+30 ym+310, Show Icons on notify: 1/0
	Gui, add, edit, xm+30 ym+330%gui_control_options% -VScroll r1 ReadOnly vbNotifyIcons_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["bNotifyIcons"]
	gui, add, text, xm+30 ym+370, Set default Intrusivity status
	Gui, add, edit, xm+30 ym+390%gui_control_options% -VScroll r1  ReadOnly vlIsIntrusive_StayHydratedBot_Original, % IniObj["Original Settings StayHydratedBot"]["lIsIntrusive_StayHydratedBot"]
	Gui, tab
	Gui, font, s7 cWhite, Verdana
	Gui, add, Text,x25 y452, StayHydratedBot v.%VN% Author: %AU%     
	Gui, add, Text,x25 y464, requires Restart     
	Gui, show,autosize, %A_ThisLabel% 
}
return


SubmitChangedSettings_StayHydratedBot: 	;**
{
	Gui, submit
	Gui, destroy
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
	Gui, submit
	Gui, destroy
	f_UnstickModKeys()
		; active 
	if PathToNewFileNew_StandUpBotUp_Active
		IniObj["Settings StandUpBot"].sFullFilePathToAudioFileUp_StandUpBot:=PathToNewFileNew_StandUpBotUp_Active
	if PathToNewFileNew_StandUpBotDown_Active
		IniObj["Settings StandUpBot"].sFullFilePathToAudioFileDown_StandUpBot:=PathToNewFileNew_StandUpBotDown_Active
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
		; backup 	
	if PathToNewFileNew_StandUpBotUp_Backup
		IniObj["Backup Settings StandUpBot"].sFullFilePathToAudioFileUp_StandUpBot:=PathToNewFileNew_StandUpBotUp_Backup
	if PathToNewFileNew_StandUpBotDown_Backup
		IniObj["Backup Settings StandUpBot"].sFullFilePathToAudioFileDown_StandUpBot:=PathToNewFileNew_StandUpBotDown_Backup
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


SubmitChangedAdvancedSettings_StayHydratedBot: ;__
{
	Gui, submit
	Gui, destroy
	f_UnstickModKeys()
	m(lIsIntrusive_StandUpBot_Active,lIsIntrusive_StayHydratedBot_Active)
	bNotifyIcons_StayHydratedBot_Active:=bNotifyIcons_StayHydratedBot_Active+0
	HUDStatus_StayHydratedBot_Active:=HUDStatus_StayHydratedBot_Active+0
	SoundStatus_StayHydratedBot_Active:=SoundStatus_StayHydratedBot_Active+0
	lIsIntrusive_StayHydratedBot_Active:=lIsIntrusive_StayHydratedBot_Active+0
	bNotifyIcons_StayHydratedBot_Backup:=bNotifyIcons_StayHydratedBot_Backup+0
	HUDStatus_StayHydratedBot_Backup:=HUDStatus_StayHydratedBot_Backup+0
	SoundStatus_StayHydratedBot_Backup:=SoundStatus_StayHydratedBot_Backup+0
	lIsIntrusive_StayHydratedBot_Backup:=lIsIntrusive_StayHydratedBot_Backup+0
		; active
	if (bNotifyIcons_StayHydratedBot_Active=0) || (bNotifyIcons_StayHydratedBot_Active=1)
		IniObj["Settings StayHydratedBot"].bNotifyIcons:=bNotifyIcons_StayHydratedBot_Active	
	if (HUDStatus_StayHydratedBot_Active=0) || (HUDStatus_StayHydratedBot_Active=1) 
		IniObj["Settings StayHydratedBot"].HUDStatus_StayHydratedBot:=HUDStatus_StayHydratedBot_Active
	if (SoundStatus_StayHydratedBot_Active=0) || (SoundStatus_StayHydratedBot_Active=1) 
		IniObj["Settings StayHydratedBot"].SoundStatus_StayHydratedBot:=SoundStatus_StayHydratedBot_Active
	if (lIsIntrusive_StayHydratedBot_Active=0) || (lIsIntrusive_StayHydratedBot_Active=1)
		IniObj["Settings StayHydratedBot"].lIsIntrusive_StayHydratedBot:=lIsIntrusive_StayHydratedBot_Active
	if sPathToNotifyPicture_StayHydratedBot_Active
		IniObj["Settings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot:=sPathToNotifyPicture_StayHydratedBot_Active
	if sNotifyTitle_StayHydratedBot_StayHydratedBot_Active
		IniObj["Settings StayHydratedBot"].sNotifyTitle_StayHydratedBot:=sNotifyTitle_StayHydratedBot_StayHydratedBot_Active
		; backup 
	if (bNotifyIcons_StayHydratedBot_Backup=0) || (bNotifyIcons_StayHydratedBot_Backup=1)
		IniObj["Backup Settings StayHydratedBot"].bNotifyIcons:=bNotifyIcons_StayHydratedBot_Backup
	if (HUDStatus_StayHydratedBot_Backup=0) || (HUDStatus_StayHydratedBot_Backup=1)
		IniObj["Backup Settings StayHydratedBot"].HUDStatus_StayHydratedBot:=HUDStatus_StayHydratedBot_Backup
	if (SoundStatus_StayHydratedBot_Backup=0) || (SoundStatus_StayHydratedBot_Backup=1) 
		IniObj["Backup Settings StayHydratedBot"].SoundStatus_StayHydratedBot:=SoundStatus_StayHydratedBot_Backup
	if (lIsIntrusive_StayHydratedBot_Backup=0) || (lIsIntrusive_StayHydratedBot_Backup=1)
		IniObj["Backup Settings StayHydratedBot"].lIsIntrusive_StayHydratedBot:=lIsIntrusive_StayHydratedBot_Backup
	if sPathToNotifyPicture_StayHydratedBot_Backup
		IniObj["BackupSettings StayHydratedBot"].sPathToNotifyPicture_StayHydratedBot:=sPathToNotifyPicture_StayHydratedBot_Backup
	if sNotifyTitle_StayHydratedBot_StayHydratedBot_Backup
		IniObj["Backup Settings StayHydratedBot"].sNotifyTitle_StayHydratedBot:=sNotifyTitle_StayHydratedBot_StayHydratedBot_Backup
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
}

SubmitChangedAdvancedSettings_StandUpBot: ;__
{
	Gui, submit
	Gui, destroy
	f_UnstickModKeys()
	HUDStatus_StandUpBot_Active:=HUDStatus_StandUpBot_Active+0
	SoundStatus_StandUpBot_Active:=SoundStatus_StandUpBot_Active+0
	bStandingPosition_StandUpBot_Active:=bStandingPosition_StandUpBot_Active+0
	bNotifyIcons_StandUpBot_Active:=bNotifyIcons_StandUpBot_Active+0
	lIsIntrusive_StandUpBot_Active:=lIsIntrusive_StandUpBot_Active+0
	HUDStatus_StandUpBot_Backup:=HUDStatus_StandUpBot_Backup+0
	SoundStatus_StandUpBot_Backup:=SoundStatus_StandUpBot_Backup+0
	bStandingPosition_StandUpBot_Backup:=bStandingPosition_StandUpBot_Backup+0
	bNotifyIcons_StandUpBot_Backup:=bNotifyIcons_StandUpBot_Backup+0
	lIsIntrusive_StandUpBot_Backup:=lIsIntrusive_StandUpBot_Backup+0
	m(lIsIntrusive_StandUpBot_Active,lIsIntrusive_StayHydratedBot_Active)
		; active
	if (HUDStatus_StandUpBot_Active=0) || (HUDStatus_StandUpBot_Active=1) 
		IniObj["Settings StandUpBot"].HUDStatus_StandUpBot:=HUDStatus_StandUpBot_Active
	if (SoundStatus_StandUpBot_Active=0) || (SoundStatus_StandUpBot_Active=1) 
		IniObj["Settings StandUpBot"].SoundStatus_StandUpBot:=SoundStatus_StandUpBot_Active
	if (bStandingPosition_StandUpBot_Active=0) || (bStandingPosition_StandUpBot_Active=1) 
		IniObj["Settings StandUpBot"].bStandingPosition:=bStandingPosition_StandUpBot_Active
	if (bNotifyIcons_StandUpBot_Active=0) || (bNotifyIcons_StandUpBot_Active=1)
		IniObj["Settings StandUpBot"].bNotifyIcons:=bNotifyIcons_StandUpBot_Active
	if (lIsIntrusive_StandUpBot_Active=0) || (lIsIntrusive_StandUpBot_Active=1)
		IniObj["Settings StandUpBot"].lIsIntrusive_StandUpBot:=lIsIntrusive_StandUpBot_Active
	if sPathToNotifyPicture_StandUpBot_Active
		IniObj["Settings StandUpBot"].sPathToNotifyPicture_StandUpBot:=sPathToNotifyPicture_StandUpBot_Active
	if sNotifyTitle_StandUpBot_StandUpBot_Active
		IniObj["Settings StandUpBot"].sNotifyTitle_StandUpBot:=sNotifyTitle_StandUpBot_StandUpBot_Active
		; backup 
	if (HUDStatus_StandUpBot_Backup=0) || (HUDStatus_StandUpBot_Backup=1)
		IniObj["Backup Settings StandUpBot"].HUDStatus_StandUpBot:=HUDStatus_StandUpBot_Backup
	if (SoundStatus_StandUpBot_Backup=0) || (SoundStatus_StandUpBot_Backup=1)
		IniObj["Backup Settings StandUpBot"].SoundStatus_StandUpBot:=SoundStatus_StandUpBot_Backup
	If (bStandingPosition_StandUpBot_Backup=0) || (bStandingPosition_StandUpBot_Backup=1)
		IniObj["Backup Settings StandUpBot"].bStandingPosition:=bStandingPosition_StandUpBot_Backup
	if (bNotifyIcons_StandUpBot_Backup=0) || (bNotifyIcons_StandUpBot_Backup=1)
		IniObj["Backup Settings StandUpBot"].bNotifyIcons:=bNotifyIcons_StandUpBot_Backup
	if (lIsIntrusive_StandUpBot_Backup=0) || (lIsIntrusive_StandUpBot_Backup=1)
		IniObj["Backup Settings StandUpBot"].lIsIntrusive_StandUpBot:=lIsIntrusive_StandUpBot_Backup
	if sPathToNotifyPicture_StandUpBot_Backup
		IniObj["BackupSettings StandUpBot"].sPathToNotifyPicture_StandUpBot:=sPathToNotifyPicture_StandUpBot_Backup
	if sNotifyTitle_StandUpBot_StandUpBot_Backup
		IniObj["Backup Settings StandUpBot"].sNotifyTitle_StandUpBot:=sNotifyTitle_StandUpBot_StandUpBot_Backup
	SplitPath, A_ScriptName,,,, ScriptName
	FileNameIniRead:=ScriptName . ".ini"
	f_WriteINI_Bots(IniObj,ScriptName)
}
return

RemoveToolTip:
RemoveToolTip_StandUpBot:			;**
RemoveToolTip_StayHydratedBot: 		;**
Tooltip,
return
;}______________________________________________________________________________________
#IfWinactive, lHelp_StayHydratedBot
Esc:: 
gosub, GuiEscape_AboutStayHydratedBot
return

Enter:: 
gosub, GuiEscape_AboutStayHydratedBot
return

#IfWinActive, ; other-tabs in settings missing
#IfWinActive, ; other-tabs in settings missing
#IfWinActive, lEditSettings_StayHydratedBot
Enter::
gosub, SubmitChangedSettings_StayHydratedBot
return
Esc:: 
gosub, GuiEscape_StayHydratedBot
return

#IfWinActive, lEditAdvancedSettings_StayHydratedBot
Enter::
gosub, SubmitChangedAdvancedSettings_StayHydratedBot
return
Esc:: 
gosub, GuiEscape_StayHydratedBot
return

#IfWinActive, lRestoreActiveBackup_StayHydratedBot
#IfWinActive, lSetCurrentDelay_StayHydratedBot
Esc:: 
gosub, GuiEscape_StayHydratedBot
return

#IfWinActive, 
#IfWinActive, 


#IfWinActive, ; other-tabs in settings missing
#IfWinActive, lEditSettings_StandUpBot
Enter:: 
gosub,SubmitChangedSettings_StandUpBot
return
Esc:: 
gosub, GuiEscape_StandUpBot
return

#IfWinActive, lEditAdvancedSettings_StandUpBot
Enter::
gosub, SubmitChangedAdvancedSettings_StandUpBot
return
Esc:: 
gosub, GuiEscape_StandUpBot
return
#IfWinActive, lRestoreActiveBackup_StandUpBot
#IfWinActive, lSetCurrentDelay_StandUpBot
Esc:: 
gosub, GuiEscape_StandUpBot
return

#IfWinActive, AUf_AlertUserIntrusive
Enter:: 
Gui, AlUs: destroy
return

#IfWinActive, CQlRestoreActiveBackup_StayHydratedBot

Esc:: 
pause off
Gosub, GuiEscape_StayHydratedBot
return

Enter:: 
gosub, SubmitChangedSettings_StayHydratedBot
return

#IfWinActive, CQlRestoreActiveBackup_StandUpBot
Esc:: 
pause off
gosub, GuiEscape_StandUpBot
return

Enter:: 
gosub, SubmitChangedSettings_StandUpBot
return

;{ INCLUDE_____________________________________________________________________________
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_Confirm_Question.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_AddStartupToggleToTrayMenu.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_CreateTrayMenu_Bots.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_ConvertRelativePath.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_ConvertRelativeWavPath_StayHydratedBot.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_Help_GeneralHealthBots.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\notify.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_OnExit_StayHydratedBot.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_ReadINI_Bots.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_ReadBackSettings_StayHydratedBot.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_ToggleOffAllGuiHotkeys.ahk 	; not used right now, as is obsolete
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_UnstickModKeys.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_WriteINI_Bots.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_DestroyGuis.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\m.ahk
#Include %A_ScriptDir%\GeneralHealthBots\includes\f_AlertUserIntrusive.ahk

#Include %A_ScriptDir%\Updater.ahk
