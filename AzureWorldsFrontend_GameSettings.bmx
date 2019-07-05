Function GameSettings()
	Local GsWindow:TGadget = CreateWindow("Game Settings...",GraphicsWidth()/5,GraphicsHeight()/5,400,400,Null) ' Window
	Local GsLabel:TGadget = CreateLabel("General:",4,16,80,24,GsWindow) ' Object type label
	Local GsStylingTrigger:TGadget = CreateLabel("Under Construction",4,40,244,24,GsWindow) ' Selection dropdown
	Local GsOk:TGadget = CreateButton("OK",269,290,64,24,GsWindow) ' OK button

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
