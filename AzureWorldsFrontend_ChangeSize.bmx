
Function ChangeSize()
	Local CsWindow:TGadget = CreateWindow("ChangeSize",GraphicsWidth()/5,GraphicsHeight()/5,400,200,Null) ' Window
	Local CsXLabel:TGadget = CreateLabel("X: ",4,18,80,24,CsWindow)
	Local CsYLabel:TGadget = CreateLabel("Y: ",4,42,80,24,CsWindow)
	Local CsXSize:TGadget = CreateTextField(88,16,244,24,CsWindow) ' Object type label
	Local CsYSize:TGadget = CreateTextField(88,42,244,24,CsWindow)
	Local CsOk:TGadget = CreateButton("OK",269,72,64,24,CsWindow) ' OK button

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
						AzCurrentSizeX = Int TextFieldText(CsXSize) ' convert the text field text to an int and then set the x size to the int
					Case CsYSize
						AzCurrentSizeY = Int TextFieldText(CsYSize) ' convert the Text Field Text To an Int And Then set the x size To the Int
					Case CsOk ' exit!
						If AzCurrentSizeX = 0 Or AzCurrentSizeY = 0 ' if they were retarded and put in some stupid shit like sfadjsfkh
							AzCurrentSizeX = 32 ' reset to a dummy size
							AzCurrentSizeY = 32 
						EndIf
						FreeGadget CsWindow 'remove the CsWindow and all of its children
						Return ' return because we selected somethingf
				End Select			
		End Select
	Forever
End Function


