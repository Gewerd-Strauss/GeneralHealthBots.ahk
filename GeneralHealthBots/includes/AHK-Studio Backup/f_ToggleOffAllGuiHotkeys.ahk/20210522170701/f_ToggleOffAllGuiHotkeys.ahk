f_ToggleOffAllGuiHotkeys()
{
	VNF:=1.0.1.15
	Hotkey, ^S, lTriggerAdvancedSettingsGUI_StandUpBot,Off
	Hotkey, ^S, lTriggerAdvancedSettingsGUI_StayHydratedBot,Off
	Hotkey, Esc, GuiEscape_AboutStandUpBot,Off
	Hotkey, Esc, GuiEscape_AboutStayHydratedBot,Off
	Hotkey, Enter, GuiEscape_AboutStandUpBot, Off
	Hotkey, Enter, GuiEscape_AboutStayHydratedBot, Off
	
	Hotkey, Enter, SubmitChangedSettings_StayHydratedBot,Off
	Hotkey, Enter, SubmitChangedSettings_StandUpBot,Off
	
	Hotkey, Esc, GuiEscape_StayHydratedBot,Off
	Hotkey, Esc, GuiEscape_StandUpBot,Off
	Hotkey, Escape, GuiEscape_ConfirmQuestion_f_ConfirmQuestion,Off
	
	f_UnstickModKeys()
}
return

