f_DestroyGuis()
{
	VNI=1.0.0.6
	Gui, GuiEscape_AboutStayHydratedBot: destroy, 
	Gui, lEditSettings_StayHydratedBot: destroy,
	Gui, Numpad6: destroy,
	Gui, lRestoreActiveBackup_StayHydratedBot: destroy,
	Gui, lSetCurrentDelay_StayHydratedBot: destroy,
	
	Gui, lEditSettings_StandUpBot: destroy,
	Gui, Numpad7: destroy,
	Gui, lRestoreActiveBackup_StandUpBot: destroy,
	Gui, lSetCurrentDelay_StandUpBot: destroy,
	
	Gui, CQlRestoreActiveBackup_StayHydratedBot: destroy,
	Gui, CQlRestoreActiveBackup_StandUpBot: destroy,
	Gui, cQ: destroy
}
return