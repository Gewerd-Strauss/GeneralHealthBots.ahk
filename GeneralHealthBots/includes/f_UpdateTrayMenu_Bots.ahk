f_UpdateTrayMenu_Bots(vAllowedTogglesCount)
{
	static Callnum
	static Count
	Count:=vAllowedTogglesCount-Callnum
	Countold:=Count+1
	if (vAllowedTogglesCount>0) &&  ((Callnum=0)|| !Callnum)
		menu, StandUpBot, Rename, Toggle Position - , Toggle Position - %vAllowedTogglesCount%
 	if (vAllowedTogglesCount>0) && Callnum
	{
		if Count>0 and (Count=vAllowedTogglesCount)
			menu, StandUpBot, Rename, Toggle Position - %Countold%, Toggle Position - %Count%
		else
		{
			menu, StandUpBot, Rename, Toggle Position - %Countold%, All (%vAllowedTogglesCount%) uses expended
			menu, StandUpBot, Disable, All (%vAllowedTogglesCount%) uses expended
		}
	}
	Callnum++
	if (Count>0 and (Count=vAllowedTogglesCount)) ; I am not even sure if this conditional makes any sense to me anymore. There may be an edge-case which I forgot since coding this, but eh, it works now.
		return 0
	Else
	{
		if (Count=0)
			return 0 ; returns 0 if all uses are expended
		else
			return 1 ; returns still allowed to change stuff
	}
}
