f_DestroyGuis()
{
	VNI=1.0.0.6
	gui, GuiEscape_AboutStayHydratedBot: destroy, 
	gui, lEditSettings_StayHydratedBot: destroy,
	gui, Numpad6: destroy,
	gui, lRestoreActiveBackup_StayHydratedBot: destroy,
	gui, lSetCurrentDelay_StayHydratedBot: destroy,
	
	gui, lEditSettings_StandUpBot: destroy,
	gui, Numpad7: destroy,
	gui, lRestoreActiveBackup_StandUpBot: destroy,
	gui, lSetCurrentDelay_StandUpBot: destroy,
	
	gui, CQlRestoreActiveBackup_StayHydratedBot: destroy,
	gui, CQlRestoreActiveBackup_StandUpBot: destroy,
	gui, cQ: destroy
	
}
return