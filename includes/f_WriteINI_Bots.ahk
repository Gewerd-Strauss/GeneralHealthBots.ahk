f_WriteINI_Bots(ByRef Array2D, INI_File)  ; write 2D-array to INI-file 
{	
	VNI=1.0.0.12
	;m(Array2D["Original Settings StayHydratedBot"])
	if !FileExist("GeneralHealthBots") ; check for StayHydratedBot directory
	{
		MsgBox, "Creating ""GeneralHealthBots"-directory at Location`n"%A_ScriptDir%", containing an ini-file named "%INI_File%.ini"
		FileCreateDir, GeneralHealthBots
	}
	if IsObject(Array2D)	
	{
		OrigWorkDir:=A_WorkingDir
		SetWorkingDir, GeneralHealthBots
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
