# GeneralHealthBots.ahk
Small script for setting independent reminders to drink and switch from a sitting to a standing working position and back. Originally only intended to be a locally run analogue of the [Stay_Hydrated_Bot](https://www.twitch.tv/stay_hydrated_bot/about) on twitch. 
However, as I am myself suffering from a bad posture as a result of way too much time hunched over in front of a pc, this script will double as a reminder to regularly stand up and sit down again as well. Both bots can be used completely independent of each other.

## Overview
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_Submenu_Overview.jpeg?raw=true)


# Help
Go to this documentation or report a bug directly on GitHub. 


## StayHydratedBot


## Settings
![alt text](https://github.com/Gewerd-Strauss/GeneralHealthBots.ahk/blob/main/Github%20Help%20Pictures/SHB_Submenu_Settings_ActiveBackup.jpeg?raw=true)

1. First ordered list item
2. Another item
⋅⋅* Unordered sub-list. 
1. Actual numbers don't matter, just that it's a number
⋅⋅1. Ordered sub-list
4. And another item.

   You can have properly indented paragraphs within list items. Notice the blank line above, and the leading spaces (at least one, but we'll use three here to also align the raw Markdown).

⋅⋅⋅To have a line break without a paragraph, you will need to use two trailing spaces.⋅⋅
⋅⋅⋅Note that thi
   
____
1. Insert (full) File Path of Audiofile
   
   Mp3- and WAV-files are possible, although wav-files may not work depending on path length. If the full path to the .wav-file is greater than 127 characters, the bot's cannot use that file. However, that is checked for the path, so the user is notified if that is the case. In that case, either move the audiofile and possibly script to a different location to ensure a shorter pathlength or choose a different file. 

2. Set default reminder time in minutes
   
   This is the time between each reminder, given in minutes.

3. Set default notification time in milliseconds
   
   This is the time each notification remains visible on screen, given in milliseconds. 1 Secondequals 1000 milliseconds.



## Set Timer
Set the respective time inbetween reminders, in minutes. This time will not be reused after restarting the bot again. For that, look at


## Pause
Deactivate the notification and sound played whenever the timer goes off. Note that the timer itself continues running, however it will not execute any code when it triggers.




## HUD & Sound
Toggle wether or not a HUD or Sound is used to notify the user when the timer goes off.
Note that pausing the bot has the same effect as unchecking both "HUD" and "Sound" for the respective bot. 
Functionally this also just prohibits the respective aspect from triggering, the timer itself doesn't stop.
