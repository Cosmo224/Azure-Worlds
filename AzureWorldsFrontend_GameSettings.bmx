Function GameSettings()
	Local GsWindow:TGadget = CreateWindow("Game Settings...",GraphicsWidth()/5,GraphicsHeight()/5,400,400,Null) ' Window
	Local GsLabel:TGadget = CreateLabel("General:",4,16,80,24,GsWindow) ' General settings label
	Local GsWorldSizeLabel:TGadget = CreateLabel("World Size",4,48,60,24,GsWindow) ' World size label
	Local GsWorldSize:TGadget = CreateTextField(64,44,244,24,GsWindow) ' world size textbox
	Local GsStylingTrigger:TGadget = CreateLabel("Under Construction",4,80,244,24,GsWindow) ' Selection dropdown
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
					Case GsWorldSize
						AzWorldSizeX = Int GadgetText(GsWorldSize) ' set world size x to the text field text of GsWorldSize, and convert it to an int
						If AzWorldSizeX = 0 ' Error checking (say if they put "cccccc" as a size or something screwed up)
							App.WriteLog("User selected invalid world size.",Syslog) ' log it if it was invalid
							Notify("Size invalid.")
							AzWorldSizeX = 4000		
						Else ' user set a correct size
							If AzOffsetX > AzWorldSizeX ' if new world size is smaller than others
								AzOffsetX = AzWorldSizeX ' prevent being in invalid position
							EndIf
							'-destroy blocks now in invalid worldspace
						EndIf
						
				End Select			
		End Select
	Forever

End Function
