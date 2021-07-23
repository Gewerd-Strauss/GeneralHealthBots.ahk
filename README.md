Checklist v.2.3.9.4::
- [x] code - uploaded
- [ ] documentation 50% (missing: left-click trayicon stuff)
- [ ] supplementary files (Settings-files, FileVersions-Files)
- [ ] proofing all
- [ ] known bug: the arrows indicating which state `StandUpBot` is in do not survive the download from github. This is a formatting problem with UTF-8, can and will be changed once I am done with checking for other bugs. 


# GeneralHealthBots.ahk v.2.3.3.4

This is a small script for setting independent reminders to drink and switch from a sitting to a standing working position and back. Originally, this was only intended to be a locally run analogue of the [Stay_Hydrated_Bot](https://www.twitch.tv/stay_hydrated_bot/about) on twitch. 
However, as I am myself suffering from a bad posture as a result of way too much time hunched over in front of a pc, this script will double as a reminder to regularly stand up and sit down again as well. Both bots can be used completely independent of each other.

## Overview 1
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_Submenu_Overview2.jpeg?raw=true)



## Open Script Folder

Pretty self-explanatory, this opens the folder containing all files related to this script. The files within and names of the folders "FileVersions","GeneralHealthBots", as well as the scripts "GeneralHealthBot" and "Updater" should not be changed personally, or stuff is guaranteed to break.


## Help
Go to this documentation, report a bug directly on GitHub or check for updates. 

Note 1:
For the upates to be installed properly, one cannot change any of the files and filestructure within the folder this script resides in, neither the subfolders _FileVersions_ and _GeneralHealthBots_. As a rule of thumb, don't edit, move, remove any include- or _FileVersions_-file, and you should be good to go. Pre-update backups are not implemented yet, and that will depend on wether or not I find the time to implement it. In addition, the file _updater.ahk_ shouldn't be changed/moved/etc either.

Note 2: 
Warning: I tested _updater.ahk_ as best as I could, but I am not 100% sure it works completely flawlessly. In addition, there are a few textboxes that will pop up that are clearly not directed at the normal user - you can just skip those. If you want to perform an update through this addon, I suggest backing up the script and all related files before confirming to update. The code for the backup should be updated in the coming weeks, and this documentation will be edited accordingly. If you do go forward with installing updates through this addon, please open an issue on github if something breaks. 

If you want to take the safer route, visit this repository and download the new version yourself. Note however that settings cannot be automatically updated this way, so you will have to set up your customised settings again yourself.


## Reload
Restarts all bots and reloads settings from file. 

## Start at boot
Create or remove a shortcut in the Autostart-folder. Note that this is currently only working in Windows 10, as the startup folder is at different locations in other versions, and the respective code is not (yet) implemented. I am not sure it will ever be.


## Overview 2
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_Submenu_Overview.jpeg?raw=true)
dd
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SUB_Submenu_Overview.jpeg?raw=true)

## Settings
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_Submenu_Settings_ActiveBackup.jpg?raw=true)
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SUB_Submenu_Settings_Othr_StandUpBot.jpeg)

The sections "Active" and "Backup" can be edited, the section "Original" can not be edited and only serves as a simple way of retrieving the factory-default settings. 
Only the "Active" settings are used. 
Pressing _Swp_ will interchange all settings between the active and backup set for that respective bot, and restarts said timer. 
Pressing _Res_ will reset all settings to [factory default]. Note that factory-default is not the same as the "Original"-settings in the third set. Those are reserved for restoring by hand. 
Pressing _Res_ will reset all settings to [factory default](#overview-over-factory-default-settings). Note that factory-default is not the same as the "Original"-settings in the third set. Those are reserved for restoring by hand. 

___
1. Insert (full) File Path of Audiofile
   
   Mp3- and WAV-files are possible, although wav-files may not work depending on path length. If the full path to the .wav-file is greater than 127 characters, the script cannot use that file. However, that is checked for the path, so the user is notified if that is the case. In that case, either move the audiofile and possibly script to a different location to ensure a shorter pathlength or choose a different file. 
   
   For StandUpBot, there are two paths to be set, to give different sounds on "standing up" and "sitting down". By default, two different sounds are played.

2. Set default reminder time in minutes
   
   This is the time between each reminder, given in minutes. Default: Active/Backup: (SHB 45/90), (SUB 90/20)

3. Set default notification time in milliseconds
   
   This is the time each notification remains visible on screen, given in milliseconds. 1 second equals 1000 milliseconds. Default: 4000 (4s)
___
4. Set Def. HUD/Sound Status

   Setting this to 1 ("on") or 0 ("off") will result in said feature to (not) be active when starting up. 
   Note that pressing enter in any edit field saves the current edits into Settings. Default: True/True

5. Set a new Path (Notify-Image)
   
   Set the path of the image used in the notify-picture when issuing alerts. Paths can be relative to script dir (as seen on picture) or not.
   
6. Set Notify-Title

   Set the title of the notification.
   
7. Set Starting Position U/D: 1/0

   This is exclusive to the StandUpBot, and decides which setting the bot assumes at start. After that, on each alert-cycle, the notification-messages alternates between "standing up" and "sitting down". Default: (Down/0) assumes you start each setting sitting, and will ask you first to stand up hence.  
   
8. Show Icons on Notify 1/0
   
   Decide wether or not the respective notify-messages should contain an image as icon or not. The image shown if true is the one set under _5. Set a new Path (Notify-Image)_ Default: True
   
9. Set default intrusivity-status 1/0

   Decide wether or not a bot is set to be intrusive by default. Look here for more information on the [intrusive mode](#intrusive).

___
### Overview over factory default settings 
The following settings are set by default at first initiation. The settings in the "Settings"-columns are also the settings a respective bot reverts to when one presses the _Reset_-button:

#### Basic Settings
   | StayHydratedBot| Settings | Backup |
   | :-----------------|:-------------:|:-----:|
   | AudioFile-Path    |A_ScriptDir\GeneralHealthBots\beep-01a.mp3|see "Settings"
   | Default reminder Time (min)|45|90|
   | Default Notification Time (ms)|4000 |see "Settings"|

   | StandUpBot| Settings | Backup |
   | :-----------------|:-------------:|:-----:|
   | AudioFile-Path Up |A_ScriptDir\GeneralHealthBots\beep-01a.mp3|see "Settings"
   | AudioFile-Path Down|A_ScriptDir\GeneralHealthBots\beep-02.mp3|see "Settings"
   | Default reminder Time (min)|30|60|
   | Default Notification Time (ms)|4000 |see "Settings"|
   
#### Advanced Settings
   
   | StayHydratedBot| Settings | Backup |
   | :-----------------|:-------------:|:-----:|
   | Default HUD Status|On|see "Settings"
   | Default Sound Status|On|see "Settings"
   | Notify-Image Path|A_ScriptDir\GeneralHealthBots\WatterBottle.PNG|see "Settings"
   | Notify-Title|StayHydratedBot|see "Settings"
   | Display Icon on notify-message|1|see "Settings"
   | Intrusive|0|see "Settings"
   
   
   | StandUpBot| Settings | Backup |
   | :-----------------|:-------------:|:-----:|
   | Default HUD Status|On|see "Settings"
   | Default Sound Status|On|see "Settings"
   | Notify-Image Path|A_ScriptDir\GeneralHealthBots\WatterBottle.PNG|see "Settings"
   | Notify-Title|StandUpBot|see "Settings"
   | Starting Position|0/Sitting|see "Settings"
   | Intrusive|0|see "Settings"
   
As both the "normal" as well as the "advanced" settings are switched alongside one another when one presses _Swp_, I have decided against providing two different sets of advanced settings. In addition, they affect minor things, compared to the normal settings. However, feel free to edit them to your heart's content.
The "Original" Settings are never edited, ever. 

## Pause

Deactivate the notification and sound played whenever the timer goes off. Note that the timer itself continues running, however it will not execute any code when it triggers.

## Set Timer

Set the respective time inbetween reminders, in minutes. This time will not be reused after restarting the bot again. For that, look at [Settings](#settings).

![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_Submenu_Set_Timer.jpeg?raw=true)

## Toggle Position - X

This button is exclusive to StandUpBot, and is best explained by an example.

Assume you have been asked to stand at 1100 sharp, your period is set to 50 minutes. After 15 minutes standing, you decide to switch back to sitting again. 
Here, you can then "convert" the remainder of your standing-period to a sitting-period. 

**However**, as it is currently implemented, this completely inverses the state assumed by the bot. As a result, after the 35 minutes you have spent sitting again, you will be asked to **stand up**. At this point, the bot will continue with the normal period as before you have used this feature.

In order to not completely annul the point of this whole thing, usage of the feature is restricted to X uses, and editing the setting requires a little bit of work.
In addition, the respective setting can't be directly edited. For doing so, open the Ini-file under A_ScriptDir/GeneralHealthBots/GeneralhealthBot.ini.
Within said file, edit the setting `vAllowDirectEditOfStateToggles_StandUpBot` to true/1. It is found within the `metaSettings`-section.
After that is changed, you can access the gui-edit fields under the "Advanced"-settings of StandUpBot.


## Intrusive

By default, the bot will use _notify_ by maestrith to inform users. By checking or setting the _Intrusive_-setting, a gui will be created to notify the user. Press Enter to close the gui. While active, the next iteration  of the respective timer will not be started. 


## HUD & Sound
Toggle wether or not a HUD or Sound is used to notify the user when the timer goes off.
Note that pausing the bot has the same effect as unchecking both "HUD" and "Sound" for the respective bot. 
Functionally this also just prohibits the respective aspect from triggering, the timer itself doesn't stop.
Not available if the respective timer is officially [paused](#pause). 

## Hovering the tray-symbol

When hovering over the tray symbol, the following information is displayed:

![Information on both bots](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_IconHover.jpeg)

The Time signifies when the next reminder will be issued by the respective bot.

The second number (here 45 and 90) displays the set delay between alerts

The next two slots display the current alert settings of that respective bot: P for paused (no alerts whatsoever), 0 for off, 1 for on. 

The third place (here 1 and P for SHB and SUB respectively) gives information on the sound-alert, and the fourth place (here 0 and P) gives information on the notification-alert. The last place (1 and 0) gives information on wether or not a bot is configured as "intrusive" or not.


___

# Credits
All code except where noted otherwhise is mine, as bad as it is.
Autohotkey-code used within this script:
* maestrith's [Notify.ahk](https://github.com/maestrith/Notify)
* wolf_II's [INI-file object maker functions](https://www.autohotkey.com/boards/viewtopic.php?p=256940#p256940)
* Exaskryz' [solution to adding a startup-toggle to a menu](https://www.autohotkey.com/boards/viewtopic.php?p=176247#p176247)
* jNizM's [HasVal](https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173)


Other mentions:
* anonymous1184's [help for solving the .wav-file bug in soundplay for me](https://www.reddit.com/r/AutoHotkey/comments/myti1k/ihatesoundplay_how_do_i_get_the_string_converted/gvwtwlb?utm_source=share&utm_medium=web2x&context=3)
* maestrith's [messageboxfunction](https://www.autohotkey.com/boards/viewtopic.php?t=60522) 
    (I could not find an original link on github for it specifically.) The code itself is not used in the project, but it was a tremendous help when creating it.
