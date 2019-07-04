Function GameSettings()
	Local GsWindow:TGadget = CreateWindow("Game Settings...",GraphicsWidth()/5,GraphicsHeight()/5,400,400,Null) ' Window
	Local GsLabel:TGadget = CreateLabel("Object Type: ",4,16,80,24,GsWindow) ' Object type label
	Local GsDropdown:TGadget = CreateComboBox(88,12,244,24,GsWindow) ' Selection dropdown
	Local GsOk:TGadget = CreateButton("OK",269,42,64,24,GsWindow) ' OK button

	SelectGadgetItem GsDropdown,0 ' so a blank item isn't selected
	Repeat
		Select WaitEvent()
			Case EVENT_WINDOWCLOSE ' Player wants to exit out
				Select EventSource()
					Case GsWindow ' GsWindow is the only gadget in this context that can generate this event, so we don't need to check for anything else
						FreeGadget GsWindow ' freeing Gswindow frees all its children
						Return ' return
				End Select 
			Case EVENT_GADGETACTION
				Select EventSource()			
					Case GsOk ' exit!
						FreeGadget GsWindow 'remove the Gswindow and all of its children
						Return ' return because we selected something.
				End Select			
		End Select
	Forever

End Function
