
f_ConvertRelativeWavPath_StayHydratedBot(sFullFilePathToAudioFile) ; A solution to .wav-files
{
	VNI=1.0.0.4
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