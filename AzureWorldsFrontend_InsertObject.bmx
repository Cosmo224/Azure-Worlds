
Function InsertObject()
	Local IoWindow:TGadget = CreateWindow("Insert Object",GraphicsWidth()/5,GraphicsHeight()/5,400,150,Null) ' Window
	Local IoLabel:TGadget = CreateLabel("Object Type: ",4,16,80,24,IoWindow) ' Object type label
	Local IoDropdown:TGadget = CreateComboBox(88,12,244,24,IoWindow) ' Selection dropdown
	Local IoOk:TGadget = CreateButton("OK",269,42,64,24,IoWindow) ' OK button
	For Local IoItems:String = EachIn AzInstanceIdList ' go thru the InstanceID list
		AddGadgetItem IoDropdown,IoItems ' add them all to the dropdown
	Next
	SelectGadgetItem IoDropdown,0 ' so a blank item isn't selected
	Repeat
		Select WaitEvent()
			Case EVENT_WINDOWCLOSE ' Player wants to exit out
				Select EventSource()
					Case IoWindow ' IoWindow is the only gadget in this context that can generate this event, so we don't need to check for anything else
						FreeGadget IoWindow ' freeing iowindow frees all its children
						Return ' return 
				End Select 
			Case EVENT_GADGETACTION
				Select EventSource()
					Case IoDropdown
						AzCurrentInstanceId = EventData()					
					Case IoOk ' exit!
						FreeGadget IoWindow 'remove the iowindow and all of its children
						Return ' return because we selected somethingf
				End Select			
		End Select
	Forever
End Function

