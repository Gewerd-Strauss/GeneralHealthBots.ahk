f_ConvertRelativePath(RelativePath)
{
	VNI=1.0.0.3
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
