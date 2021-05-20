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