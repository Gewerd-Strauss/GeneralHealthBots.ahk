f_OnExit_StayHydratedBot() ; not finished: needs new setting
{ ; will be removed in a future release most likely. Or left in for others to activate, if they whish to do so.
	VNI=1.0.0.9
	Notify().AddWindow("Bye Bye.",{Title:GeneralHealthBot,TitleColor:"0xFFFFFF",Time:vNotificationTimeInMilliSeconds_StayHydratedBot,Color:"0xFFFFFF",Background:"0x000000",TitleSize:10,Size:10,ShowDelay:0,Radius:15, Flash:1000,FlashColor:0x5555})
	sleep, 2000
	ExitApp
}

