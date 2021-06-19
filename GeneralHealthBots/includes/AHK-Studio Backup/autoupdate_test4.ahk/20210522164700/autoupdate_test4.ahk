#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
;#Persistent
;#Warn All ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;DetectHiddenWindows, On
;SetKeyDelay -1
SetBatchLines -1
SetTitleMatchMode, 2
ntfy:=Notify()
;;_____________________________________________________________________________________
;{#[General Information for file management]
ScriptName=MISSING 
VN=2.1.20.4                                                                    
LE=20 MÃ¤rz 2021 17:51:52                                                       
AU=Gewerd Strauss
;}______________________________________________________________________________________
;{#[File Overview]
Menu, Tray, Icon, C:\WINDOWS\system32\imageres.dll,101 ;Set custom Script icon
menu, Tray, Add, About, Label_AboutFile
;}______________________________________________________________________________________

;;;; TODO SEE LINES 194/195 (comment  from 21.05.2021 23:03:01)
vsdb:=true
; remember to remove this line and the 
;{#[Autorun Section]
; "https://raw.githubusercontent.com///main/"
/*
	Date: 19 Mai 2021 16:14:37: 
		1. stri0p all letters and spaces around the vn 
		2. compare both vn's, either without the build-num, or with it. 
		3. if mismatch,assume new file and ask user if he wants to update.  
		4. if user says no,	continue the script as normal. 
		5. if user says yes:  
		5.1 open github repo and	ask user to download the zip.  
		5.2 create a gui with a dropfile-ui to drop the zip onto.  once droppd onto the gui, the zip is extracted to a sisterfolder to
		the current scriptfolder, named scriptfolder_update all files within
		scriptfolder/user are copied to scriptfolder_update/user, then delete
		scriptfolder and rename scriptfolder_update to scriptfoldere
	
	For the ini-file, read back the user's existing ini-file and read the new 
		versions ini-file. Then, copy over all values from the old array to the new 
	array, without overwriting the newly added values from the new array.
*/
Numpad0::
vUserName:="Gewerd-Strauss"
vProjectName:="GeneralHealthBots.ahk"
vFileName:="StayHydratedBot%20settingsGUI_16.05.2021.ahk"	; added testing stuff so I don't have to use this 
FolderStructIncludesRelativeToMainScript:="GeneralHealthBots/includes/"
FolderStructIniFileRelativeToMainScript:="GeneralHealthBots/StayHydratedBot settingsGUI_16.05.2021.ini"
LocalValues:=[]
GitPageURLComponents:=[]
LocalValues:=[AU,VN,FolderStructIncludesRelativeToMainScript]
;FolderStructIncludesRelativeToMainScript â† needs to be packaged into another array, probably localvalues

GitPageURLComponents:=[vUserName,VProjectName,vFileName,FolderStructIniFileRelativeToMainScript]
f_UpdateRoutine(GitPageURLComponents,LocalValues,,1,1)
;f_CheckForUpdates(VN,vUserName,vProjectName,vFileName,VersionNumberDefMainScript:="VN=")


;}______________________________________________________________________________________
;{#[Hotkeys Section]



;}______________________________________________________________________________________
;{#[Label Section]



RemoveToolTip: 
Tooltip,
return
Label_AboutFile:
MsgBox,, File Overview, Name: %ScriptName%`nAuthor: %AU%`nVersionNumber: %VN%`nLast Edit: %LE%`n`nScript Location: %A_ScriptDir%
return
;}______________________________________________________________________________________
;{#[Functions Section]



;}_____________________________________________________________________________________
;{#[Include Section]


f_UpdateRoutine(GitPageURLComponents,LocalValues,VersionNumberDefSubScripts:="VNI=",VersionNumberDefMainScript:="VN=",vNumberOfBackups:=0,IniObjFlag:=-1)
{
	; facilitates all subfunctions for 
	; m(GitPageURLComponents,"`n",LocalValues)
	; add input verification: 
	; does gitpage connect successfully, 
	; does gitpage4 contain a valid path on the harddrive
	; 
	
	
	/*
		Date: 22 Mai 2021 10:57:45: an alternative way would be to use the ini-file
		only for fetching file-urls, then check for missing files. all other files are
		compared on a line-by-line basis to check if they match everywhere. you could
		make this a "cutting edge"-feature (possibly search another git branch for this?
		) and ask the user if they want to use experimental versions. Much more prone to
		error,  but in theory possible.
	*/
	vFileCountToUpdate:=0
	ReturnPackage:=f_CheckForUpdates(GitPageURLComponents,LocalValues,VersionNumberDefMainScript)
	vFileCountToUpdate:=ReturnPackage[2].Count()
	if ReturnPackage[1]!=0
		vFileCountToUpdate++
		;tooltip, updating 	; insert f_PerformUpdate here
	if vFileCountToUpdate!=0 			; MainFile's VN doesn't match â†’ update (insert assume-all function? Not necessary, as each file with unique name is also loggged by vn.)
		if f_Confirm_Question("Do you want to update?`nNew Version is "GitPageURLComponents[1],LocalValues[1],LocalValues[2])
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
	; Get online include version Numbers (VNs) from the online ini.file â† this is important to go over the ini-file as we need to make 
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
		; 2.1 YES: compare the vn's of that key between both arrays and check if unequal â†’ download
		; 2.2 NO:  key of an online-fn doesn't exist in the offline-fn, hence the function doesn't exist either. â†’ download to file
		
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
		3. Check if ReturnPackage[1]=1 â† download MainScript
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
				CurrFile:=FileOpen(v,"w") ; backup is handled already, so I don't have to worry about it. Or I do a better backup, and do it here just for the files that are updated. 101
				CurrFile.Write(FileText[k])
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

f_Confirm_Question(Question,AU,VN)
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
	gui, cQ: add, button, xm+20 ym+50 w30 gConfirmQuestion_f_ConfirmQuestion, &Yes
	gui, cQ: add, button, xm+170 ym+50 w30 gDenyQuestion_f_ConfirmQuestion, &No
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
	
	GuiEscape_ConfirmQuestion_f_ConfirmQuestion:
	gui, cQ: destroy
	return answer:=-1
	
	ConfirmQuestion_f_ConfirmQuestion:
	gui, cQ: submit
	gui, cQ: destroy
	return answer:=true
	
	DenyQuestion_f_ConfirmQuestion:
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


















; f_SelectFolderToUnpackFrom()
; {
; 		; global 
; 	; create new temp folder here, do the move move shit and perform the rest, cf. notes at top of script.
; 	; 1 get the parent folder of the script
; 	; 2 create a new, temporary folder named 
; 	;startfolder:=A_ScriptFullPath's parent folder
; 	Path = %A_ScriptFullPath%
; 	Parent := SubStr(Path, 1, InStr(SubStr(Path,1,-1), "\", 0, 0)-1)
; 	Parent := SubStr(Parent,1, InStr(SubStr(Parent,1,-1),"\",0,0)-1)
; 	Parent := SubStr(Parent,1, InStr(SubStr(Parent,1,-1),"\",0,0)-1)
; 	Parent := SubStr(Parent,1, InStr(SubStr(Parent,1,-1),"\",0,0)-1)
; 	;msgbox % parent "`n" Path
; 	f_InformOfNextSteps("Please Select the downloaded, already unzipped folder of the new ReadLine.`nThe files will be transferred to the location of this folders directory, and the current settings will be integrated into the new settings.",780,715)
; 	;FileSelectFolder, sFolderOfNewVersion,%parent%,,Please Select the downloaded, already unzipped folder of the new ReadLine.`nThe files will be transferred to the location of this folders directory, and the current settings will be integrated into the new settings.
; 	FileSelectFolder, sFolderOfNewVersion,,,
	
; 	SetTimer, RemoveToolTip, -400
; 	return sFolderOfNewVersion
; 	; for some god damn reason, GuiDropFiles doesn't work at all.
; 	;FileSelectFolder, sFolderOfNewVersion,%parent%
; 	/*
; 		if 2=1
; 		{
; 			MsgBox, gui created
; 			gui_control_options := "xm w220 " . cForeground . " -E0x200"    ; remove border around edit field
; 			gui, CFD: new
; 			Gui, CFD: Margin, 16, 16
; 			Gui, CFD: +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
; 			cBackground := "c" . "1d1f21"
; 			cCurrentLine := "c" . "282a2e"
; 			cSelection := "c" . "373b41"
; 			cForeground := "c" . "c5c8c6"
; 			cComment := "c" . "969896"
; 			cRed := "c" . "cc6666"
; 			cOrange := "c" . "de935f"
; 			cYellow := "c" . "f0c674"
; 			cGreen := "c" . "b5bd68"
; 			cAqua := "c" . "8abeb7"
; 			cBlue := "c" . "81a2be"
; 			cPurple := "c" . "b294bb"
; 			Gui, CFD: Color, 1d1f21, 373b41, 
; 			Gui, CFD: Font, s11 cWhite, Segoe UI 
; 			gui, CFD: add, text,xm ym, Please download the newest ReadLine by pressing "Code", then selecting "Download ZIP".`nSave the zip in %A_ScriptDir%.`nafterwards, drag the file onto the  `n`n%A_ScriptFullPath%
; 		; Gui, CFD: add, Edit, %gui_control_options% -VScroll 
; 			Gui, CFD: Font, s7 cWhite, Verdana
; 			Gui, CFD: Add, Text,x25, ReadLine: %VN%	Author: %AU% 
; 			gui, CFD: show,, FileDropGUI
; 		}
		
; 		return
		
		
; 		GuiEscape:
; 		gui, destroy
; 		return
		
; 		GuiDropFiles:
; 		MsgBox, Files dropped, performing actions now
; 		return
; 	*/
; }








; ; https://www.autohotkey.com/boards/viewtopic.php?t=43898 select multiple files/folders
; FileSelectSpecific(P_OwnerNum,P_Path,P_SelectFileOrFolder="folder",P_Prompt="Please Select the downloaded, already unzipped folder of the new ReadLine.`",P_ComplementText="",P_Multi="",P_DefaultView="Icon",P_FilterOK="",P_FilterNO="",P_Restrict=1,P_LVHeight="220",P_LVWidth="350") {
; 	global
	
; 	;*****************************
; 	; MAKE SURE PREVIOUS OWNER IS RE-ENABLED AND EXISTING FS DESTROYED
; 	;*****************************
; 	if glb_FSOwnerNum
; 		try, Gui,%glb_FSOwnerNum%:-Disabled
; 	try Gui,FileSelectSpecific:Destroy
; 	;*****************************
; 	; CONTEXT MENU
; 	;*****************************
; 	try
; 		Menu, FSContextMenu, Add, SELECT, FSSelect
; 	Menu, FSContextMenu, Add, Create Folder, FSCreateFolder
; 	Menu, FSContextMenu, Add, Open Folder in Explorer, FSDisplayFolder
; 	Menu, FSContextMenu, Default, 1&
	
; 	;*****************************
; 	; GLOBAL VARS
; 	;*****************************
; 	glb_FSTitle=%A_ScriptName% - File Select Dialog
	
; 	glb_FSInit:=1
; 	glb_FSFolder:=P_Path
; 	glb_FSCurrent:=glb_FSFolder
; 	glb_FSFilterOK:=P_FilterOK
; 	glb_FSFilterNO:=P_FilterNO
; 	glb_FSRestrict:=P_Restrict
	
; 	glb_FSType:=P_SelectFileOrFolder
; 	glb_FSReturn:=""
; 	glb_FSOwnerNum:=P_OwnerNum
	
	
; 	if (P_SelectFileOrFolder="File" or P_SelectFileOrFolder="All")
; 		LoopType:="FD"
; 	else if (P_SelectFileOrFolder="Folder")
; 		LoopType:="D"
	
; 	glb_FSLoopType:=LoopType
	
; 	if P_Multi
; 		glb_FSNoMulti:=""
; 	else
; 		glb_FSNoMulti:="-Multi"
	
; 	; Check if the last character of the folder name is a backslash, which happens for root
; 	; directories such as C:\. If it is, remove it to prevent a double-backslash later on.
; 	StringRight, LastChar, glb_FSFolder, 1
; 	if LastChar = \
; 		StringTrimRight, glb_FSFolder, glb_FSFolder, 1  ; Remove the trailing backslash.
; 	glb_FSCurrent:=glb_FSFolder
	
; 	;*****************************
; 	; GUI CREATION
; 	;*****************************
; 	Gui, FileSelectSpecific:Default
; 	Gui, FileSelectSpecific: New
; 	Gui +HwndFSHwnd
; 	Gui +Resize +MinSize330x280
	
; 	;SET AND DISABLE OWNER
; 	if (glb_FSOwnerNum) {
; 		Gui +Owner%glb_FSOwnerNum%
; 		Gui, %glb_FSOwnerNum%:+Disabled
; 	}
	
; 	Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
	
; 	; Create some buttons:
; 	Gui, Add, Button, xm w20 gFSSwitchView, % Chr(0x02630)
; 	Gui, Font, Bold
; 	Gui, Add, Button, x+5 yp gFSRefresh, % Chr(0x21BB)
; 	Gui, Add, Button, x+5 w30 gFSPrevious, % Chr(0x2190)
; 	; Gui, Font
; 	; Gui, Font, Bold
; 	Gui, Add, Button, x+5 yp gFSSelect, % "SELECT"
; 	Gui, Font
; 	Gui, Add, Edit, xm y+8 w%P_LVWidth% vFSNavBarv, % glb_FSCurrent
; 	Gui, Add, Text, xm y+8 w%P_LVWidth% vFSPromptv, % P_Prompt
	
	
; 	; Create the ListView and its columns:
; 	ListViewPos:= " w" P_LVWidth
; 	ListViewPos:= " h" P_LVHeight
	
; 	Gui, Add, ListView, xm y+10 %ListViewPos% vFSListView gFSListViewHandler %glb_FSNoMulti%, Name|In Folder|Size (KB)|Type
; 	LV_ModifyCol(3, "Integer")  ; For sorting, indicate that the Size column is an integer.
	
; 	if (P_DefaultView="Icon") {
; 		GuiControl, +Icon, FSListView    ; Switch to icon view.
; 		Glb_FSIconView:=1
; 	} else {
; 		GuiControl, +Report, FSListView  ; Switch back to details view.
; 		Glb_FSIconView:=0
; 	}
	
; 	Gui, Font, s10
; 	if P_ComplementText
; 		Gui, Add, Text, xm y+8 w%P_LVWidth% vFSComplementv, % P_ComplementText
	
; 	Gui, Font, Italic s9
; 	if !glb_FSNoMulti
; 		Gui, Add, Text, xm y+5 w%P_LVWidth% vFSMultiIndicv, % "Hold Ctrl or Shift for Multi-Selection"
	
; 	Gui, Font
	
; 	;*****************************
; 	; ICONS CREATION
; 	;*****************************
; 	; Calculate buffer size required for SHFILEINFO structure.
; 	FSIconArray:={}
	
; 	FSImageListID1 := IL_Create(10)
; 	FSImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.
; 	; Attach the ImageLists to the ListView so that it can later display the icons:
; 	LV_SetImageList(FSImageListID1)
; 	LV_SetImageList(FSImageListID2)
	
; 	; Gather a list of file names from the selected folder and append them to the ListView:
; 	;*****************************
; 	; SEARCH FILES AND SHOW GUI
; 	;*****************************
; 	GuiControl, -Redraw, FSListView  ; Improve performance by disabling redrawing during load.
	
; 	FSAddLoopFiles()
; 	FSRedrawCol()
	
; 	GuiControl, +Redraw, FSListView  ; Re-enable redrawing (it was disabled above).
	
; 	Gui, Show,,% glb_FSTitle
; 	glb_FSInit:=0
	
; 	return FSHwnd
; }

; FileSelectSpecificAdjust(P_Path="") {
; 	global
; 	if !P_Path
; 		P_Path:=glb_FSCurrent
; 	Gui FileSelectSpecific: Default
; 	GuiControl, -Redraw, FSListView
; 	LV_Delete()
; 	FSAddLoopFiles()
; 	GuiControl,,FSNavBarv, % glb_FSCurrent
; 	FSRedrawCol()
; 	GuiControl, +Redraw, FSListView
; }

; FSAddLoopFiles() {
; 	global
; 	Gui FileSelectSpecific: Default
	
; 	FSsfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
; 	VarSetCapacity(FSsfi, FSsfi_size,0)
	
; 	if !glb_FSCurrent {
; 		DriveGet, FSDriveList, list
; 		FSDriveLabels:={}
		
; 		Loop, parse, FSDriveList 
; 		{
; 			DriveGet, FSDriveLabel, Label, %A_Loopfield%:
; 			FSDriveLabels[A_Index]:=FSDriveLabel
			
; 			IconNumber:=FSSetIcon(A_Loopfield ":","",FSIconArray,FSImageListID1,FSImageListID2)
			
; 			LV_Add("Icon" . IconNumber, A_Loopfield ": " FSDriveLabels[A_Index], "", "", "")
; 		}
; 		return
; 	}
	
; 	Loop, Files, %glb_FSCurrent%\*, %glb_FSLoopType%
; 	{
; 		if A_LoopFileAttrib contains H,S  ; Skip any file that is either H (Hidden), or S (System). Note: No spaces in "H,S".
; 			continue  ; Skip this file and move on to the next one.
		
; 		; FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.
		
; 		If glb_FSfilterOK
; 			If A_LoopFileExt not in ,%glb_FSfilterOK%
; 				continue
		
; 		If glb_FSFilterNO
; 			If A_LoopFileExt in %glb_FSFilterNO%
; 				continue
		
; 		IconNumber:=FSSetIcon(A_LoopFileFullPath,A_LoopFileExt,FSIconArray,FSImageListID1,FSImageListID2)
		
; 		; Create the new row in the ListView and assign it the icon number determined above:
; 		LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, A_LoopFileExt)
; 	}
; }

; FSSetIcon(P_Filepath,P_FileExt,ByRef P_IconArray,ByRef P_Imagelist1,ByRef P_ImageList2) {
; 	global
	
; 	if P_FileExt in EXE,ICO,ANI,CUR
; 	{
; 		ExtID := P_FileExt  ; Special ID as a placeholder.
; 		IconNumber = 0  ; Flag it as not found so that these types can each have a unique icon.
; 	}
; 	else  ; Some other extension/file-type, so calculate its unique ID.
; 	{
; 		;TTRICK: if no ext it can be drive or directory or a file without ext. In this case we create a fake ext so they won't use the same icons and icons can be re-used
; 		if !P_FileExt
; 		{
			
; 			if Regexmatch(P_Filepath, ":$")
; 				P_FileExt:="DRIVE"
; 			else if InStr(FileExist(P_Filepath), "D")
; 				P_FileExt:="DIR"
; 			else if FileExist(P_Filepath)
; 				P_FileExt:="NOEXT"
; 		}
; 		ExtID = 0  ; Initialize to handle extensions that are shorter than others.
; 		Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
; 		{
; 			StringMid, ExtChar, P_FileExt, A_Index, 1
; 			if not ExtChar  ; No more characters.
; 				break
; 			; Derive a Unique ID by assigning a different bit position to each character:
; 			ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
; 		}
; 		; Check if this file extension already has an icon in the ImageLists. If it does,
; 		; several calls can be avoided and loading performance is greatly improved,
; 		; especially for a folder containing hundreds of files:
; 		IconNumber := P_IconArray[ExtID]
; 	}
; 	;can debug icons here
; 	; msgbox IconNumber %IconNumber% P_Filepath %P_Filepath% P_FileExt %P_FileExt%
; 	if not IconNumber  ; There is not yet any icon for this extension, so load it.
; 	{
; 		; Get the high-quality small-icon associated with this file extension:
; 		if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "str", P_Filepath, "uint", 0, "ptr", &FSsfi, "uint", FSsfi_size, "uint", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
; 			IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
; 		else ; Icon successfully loaded.
; 		{
; 			; Extract the hIcon member from the structure:
; 			hIcon := NumGet(FSsfi, 0)
; 			; Add the HICON directly to the small-icon and large-icon lists.
; 			; Below uses +1 to convert the returned index from zero-based to one-based:
; 			IconNumber := DllCall("ImageList_ReplaceIcon", "ptr", P_Imagelist1, "int", -1, "ptr", hIcon) + 1
; 			DllCall("ImageList_ReplaceIcon", "ptr", P_ImageList2, "int", -1, "ptr", hIcon)
; 			; Now that it's been copied into the ImageLists, the original should be destroyed:
; 			DllCall("DestroyIcon", "ptr", hIcon)
; 			; Cache the icon to save memory and improve loading performance:
; 			P_IconArray[ExtID] := IconNumber
; 		}
; 	}
; 	return IconNumber
; }


; ;*****************************
; ;FS GUI LABELS
; ;*****************************
; FSCreateFolder:
; Gui FileSelectSpecific: Default
; InputBox, FolderName, , % "Enter Folder Name",,,120
; if (ErrorLevel or !FolderName)
; 	return
; FileCreateDir, % glb_FSCurrent "/" FolderName
; FileSelectSpecificAdjust(glb_FSCurrent)
; return

; FSDisplayFolder:
; Gui FileSelectSpecific: Default
; FSOpenFolderInExplorer(glb_FSCurrent)
; return

; FSSwitchView:
; Gui FileSelectSpecific: Default
; GuiControl, -Redraw, FSListView
; if not Glb_FSIconView
; 	GuiControl, +Icon, FSListView    ; Switch to icon view.
; else
; 	GuiControl, +Report, FSListView  ; Switch back to details view.
; Glb_FSIconView := not Glb_FSIconView             ; Invert in preparation for next time.
; FSRedrawCol()
; GuiControl, +Redraw, FSListView
; return

; FSRedrawCol() {
; 	global
; 	Gui FileSelectSpecific: Default
; 	LV_ModifyCol()  ; Auto-size each column to fit its contents.
; 	LV_ModifyCol(2,0)  ; Hide FileDir Col
; 	LV_ModifyCol(3, 60) ; Make the Size column at little wider to reveal its header.
; 	LV_ModifyCol(4, "AutoHdr") ; Make the Size column at little wider to reveal its header.
; }

; FSListViewHandler:
; if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
; {
; 	LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
; 	LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
; 		; LV_GetText(FileExt, A_EventInfo, 4)  ; Get the text of the fourth field.
; 	FilePath:=FileDir "\" FileName
	
; 	if !glb_FSCurrent
; 	{
; 		loop, parse, FileName, :
; 			if (A_Index=1) {
; 				FilePath := A_Loopfield ":"
; 				break
; 			}
; 	}
	
; 	if InStr(FileExist(FilePath), "D") {
; 		glb_FSCurrent:=FilePath
; 		FileSelectSpecificAdjust(glb_FSCurrent)
; 		return
; 	}
	
; 	else if (FileExist(FilePath) and (glb_FSType="File" or glb_FSType="All")) {
; 		if glb_FSNoMulti
; 			glb_FSReturn:=FilePath
; 		else
; 			glb_FSReturn:=FileDir "`n" FileName
		
; 		if (glb_FSOwnerNum)
; 			Gui, %glb_FSOwnerNum%:-Disabled
; 		Gui,FileSelectSpecific:Destroy
; 		return
; 	}
; }
; return

; FSPrevious:
; Gui FileSelectSpecific: Default
; if !glb_FSCurrent
; 	return
; if (glb_FSCurrent=glb_FSFolder and glb_FSRestrict) {
; 	tooltip You can not navigate above the folder `n%glb_FSFolder%
; 	SetTimer, RemoveToolTip2, -3000
; 	return
; }
; if !InStr(FileExist(FSGetParentDir(glb_FSCurrent)), "D")
; 	glb_FSCurrent:=""
; else
; 	glb_FSCurrent:=FSGetParentDir(glb_FSCurrent)

; FileSelectSpecificAdjust(glb_FSCurrent)
; return

; FSRefresh:
; Gui FileSelectSpecific: Default
; FileSelectSpecificAdjust(glb_FSCurrent)
; return

; FSSelect:
; Gui FileSelectSpecific: Default
; RowNumber = 0
; RowOkayed = 0 
; if !LV_GetNext(RowNumber) {
; 	msgbox Please select an element first
; 	return
; }

; Loop
; {
; 	RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
; 		; msgbox RowNumber %RowNumber%
; 	if not RowNumber  ; The above returned zero, so there are no more selected rows.
; 		break
; 	LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
; 	LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
; 	FilePath:=FileDir "\" FileName
	
; 	if !glb_FSCurrent
; 	{
; 		loop, parse, FileName, :
; 			if (A_Index=1) {
; 				FilePath := A_Loopfield ":"
; 				FileName := A_Loopfield ":"
; 				break
; 			}
; 	}
	
; 	if !FileExist(FilePath)
; 		continue
	
; 	if (InStr(FileExist(FilePath), "D") and glb_FSType="File")
; 		continue
	
; 	if (!InStr(FileExist(FilePath), "D") and glb_FSType="Folder")
; 		continue
	
; 	RowOkayed++
	
; 	glb_FSMultiReturn.= "`n" FileName
	
; }

; if (RowOkayed=0) {
; 	msgbox sorry wrong selection
; 	return
; }

; if (RowOkayed=1 and glb_FSNoMulti)
; 	glb_FSReturn:=FilePath
; else
; 	glb_FSReturn:=FileDir . glb_FSMultiReturn

; if (glb_FSOwnerNum)
; 	Gui, %glb_FSOwnerNum%:-Disabled

; Gui,FileSelectSpecific:Destroy
; return

; ;Context-sensitive hotkey to detect Enter on FS navigation bar
; #If (FSHwnd and WinActive("ahk_id " FSHwnd))
; Enter::
; GuiControlGet, OutputVar, FileSelectSpecific:FocusV
; ; msgbox OutputVar %OutputVar%
; if (OutputVar="FSNavBarv")
; 	Gosub, FSNavBar
; Return
; #If

; ;Enter on FS navigation bar
; FSNavBar:
; Gui, FileSelectSpecific:Default
; GuiControlGet, FSNavBarv
; StringRight, LastChar, FSNavBarv, 1
; if LastChar = \
; 	StringTrimRight, FSNavBarv, FSNavBarv, 1  ; Remove the trailing backslash.
; if !InStr(FileExist(FSNavBarv), "D")
; 	return

; if (glb_FSRestrict and !Instr(FSNavBarv,glb_FSFolder)) {
; 	tooltip You can not navigate above the folder `n%glb_FSFolder%
; 	SetTimer, RemoveToolTip2, -3000
; 	return
; }
; GuiControl,,FSNavBarv,% FSNavBarv

; glb_FSCurrent:=FSNavBarv
; FileSelectSpecificAdjust()
; return

; RemoveToolTip2:
; tooltip
; return

; ;*****************************
; ;FS GUI SPECIAL LABELS
; ;*****************************
; FileSelectSpecificGuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
; Gui FileSelectSpecific: Default
; if A_GuiControl <> FSListView  ; This check is optional. It displays the menu only for clicks inside the ListView.
; 	return
; Menu, FSContextMenu, Show
; return

; FileSelectSpecificGuiClose:
; if glb_FSOwnerNum
; 	try, Gui,%glb_FSOwnerNum%:-Disabled
; Gui,Destroy
; return

; FileSelectSpecificGuiSize:  ; Readjust the controls in response to the user's resizing of the window.
; if A_EventInfo = 1  ; The window has been minimized.  No action needed.
; 	return
; 	;Do not trigger during init
; if glb_FSInit
; 	return

; GuiControl, -Redraw, FSListView

; GuiControlGet, FSComplementv
; GuiControlGet, FSMultiIndicv

; 	; Otherwise, the window has been resized or maximized. Resize the controls.

; GuiControlGet, FSListViewPos, Pos, FSListView

; GuiControl, MoveDraw, FSPromptv, % " W" . (A_GuiWidth-20)
; GuiControl, MoveDraw, FSNavBarv, % " W" . (A_GuiWidth-20)

; FSListGap=

; if (FSComplementv) {
; 	GuiControl, MoveDraw, FSComplementv, % "y" FSListViewPosY + FSListViewPosH + 10 " W" . (A_GuiWidth-20)
; 	FSListGap+=10
; }

; GuiControlGet, FSComplementPos, Pos, FSComplementv

; if (FSMultiIndicv) {
; 	GuiControl, MoveDraw, FSMultiIndicv, % "y" A_GuiHeight-20 " W" . (A_GuiWidth-20)
; 	FSListGap+=5
; }

; GuiControlGet, FSMultiIndicPos, Pos, FSMultiIndicv

; 	;Trick : Round() so that empty vars = 0
; FSListGap:=Round(FSComplementPosH) + Round(FSMultiIndicPosH) + 15

; GuiControl, MoveDraw, FSListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - FSListViewPosY - Round(FSListGap))

; 	;Set timer to recreate listview if icon view
; if (Glb_FSIconView)
; 	SetTimer, FileSelectSpecificAdjust, -200

; GuiControl, +Redraw, FSListView  ; Re-enable redrawing (it was disabled above).

; return
; ;*****************************


; ;*****************************
; ;SMALL FS FUNCTIONS
; ;*****************************
; FSGetParentDir(Path) {
; 	return SubStr(Path, 1, InStr(SubStr(Path,1,-1), "\", 0, 0)-1)
; }

; FSOpenFolderInExplorer(P_Folder) {
; 	global
; 	if !InStr(FileExist(P_Folder), "D")
; 		return 0
; 	Run % P_Folder
; }

; ;}_____________________________________________________________________________________
; #IfWinActive, FileDropGUI
; Enter:: 
; MsgBox, hi
; gui, CFD: submit
; gui, CFD: destroy
; return
; Esc::
; gui, CFD: Destroy
; return



