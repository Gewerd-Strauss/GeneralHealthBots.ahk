m(x*){
	VNI=1.0.0.13
	static List:={BTN:{OC:1,ARI:2,YNC:3,YN:4,RC:5,CTC:6},ico:{X:16,"?":32,"!":48,I:64}},Msg:=[]
	static Title
	List.Title:="AutoHotkey",List.Def:=0,List.Time:=0,Value:=0,TXT:="",Bottom:=0
	WinGetTitle,Title,A
	for a,b in x{
		Obj:=StrSplit(b,":"),(Obj.1="Bottom"?(Bottom:=1):""),(VV:=List[Obj.1,Obj.2])?(Value+=VV):(List[Obj.1]!="")?(List[Obj.1]:=Obj.2):TXT.=(IsObject(b)?Obj2String(b,,Bottom):b) "`n"
	}
	Msg:={option:Value+262144+(List.Def?(List.Def-1)*256:0),Title:List.Title,Time:List.Time,TXT:TXT}
	Sleep,120
	/*
		SetTimer,Move,-1
	*/
	MsgBox,% Msg.option,% Msg.Title,% Msg.TXT,% Msg.Time
	/*
		SetTimer,ActivateAfterm,-150
	*/
	for a,b in {OK:Value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
			return b
	return
	Move:
	TT:=List.Title " ahk_class #32770 ahk_exe AutoHotkey.exe"
	WinGetPos,x,y,w,h,%TT%
	WinMove,%TT%,,2000,% Round((A_ScreenHeight-h)/2)
	/*
		ToolTip,% A_ScriptFullPath
		USE THIS TO SAVE LAST POSITIONS FOR MSGBOX'S
	*/
	return
	/*
		ActivateAfterm:
		if(InStr(Title,"Omni-Search")||!Title){
			Loop,20
			{
				WinGetActiveTitle,ATitle
				if(InStr(ATitle,"AHK Studio"))
					Break
				Sleep,50
			}
		}else{
			WinActivate,%Title%
		}
		return
	*/
}

Obj2String(Obj,FullPath:=1,BottomBlank:=0){
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b))
				Obj2String(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " b "`n"
				else if(b!="")
					String.=FullPath "." a " = " b "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}
