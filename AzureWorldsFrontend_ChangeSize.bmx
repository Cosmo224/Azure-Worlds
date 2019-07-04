
Function ChangeSize()
	Local CsWindow:TGadget = CreateWindow("ChangeSize",GraphicsWidth()/5,GraphicsHeight()/5,400,150,Null) ' Window
	Local CsXSize:TGadget = CreateTextField(54,16,244,24,CsWindow) ' Object type label
	Local CsYSize:TGadget = CreateTextField(54,36,244,24,CsWindow)

	Local CsOk:TGadget = CreateButton("OK",269,42,64,24,CsWindow) ' OK button
	For Local CsItems:String = EachIn AzInstanceIdList ' go thru the InstanceID list
		'AddGadgetItem CsDropdown,CsItems ' add them all to the dropdown
	Next

	Repeat
		Select WaitEvent()
			Case EVENT_WINDOWCLOSE ' Player wants to exit out
				Select EventSource()
					Case CsWindow ' CsWindow is the only gadget in this context that can generate this event, so we don't need to check for anything else
						FreeGadget CsWindow ' freeing Cswindow frees all its children
						Return ' return 
				End Select 
			Case EVENT_GADGETACTION
				Select EventSource()
					Case CsXSize
						AzCurrentSizeX = Int TextFieldText(CsXSize)
					Case CsYSize
						AzCurrentSizeY = Int TextFieldText(CsYSize)
					Case CsOk ' exit!
						If AzCurrentSizeX = 0 Or AzCurrentSizeY = 0
						
						EndIf
						FreeGadget CsWindow 'remove the CsWindow and all of its children
						Return ' return because we selected somethingf
				End Select			
		End Select
	Forever
End Function


