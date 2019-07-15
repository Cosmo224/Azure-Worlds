
Function ObjectEffect()
	Local OeWindow:TGadget = CreateWindow("Object Effect",GraphicsWidth()/5,GraphicsHeight()/5,400,150,Null) ' Window
	Local OeLabel:TGadget = CreateLabel("Effect: ",4,16,80,24,OeWindow) ' Object type label
	Local OeDropdown:TGadget = CreateComboBox(88,12,244,24,OeWindow) ' Selection dropdown
	Local OeOk:TGadget = CreateButton("OK",269,42,64,24,OeWindow) ' OK button
	Local uniqueId ' for later in the function use
	For Local OeItems:InstanceGFX = EachIn AzGfxList ' go thru the InstanceID list
		AddGadgetItem OeDropdown,OeItems.gfxName ' add them all to the dropdown
	Next
	SelectGadgetItem OeDropdown,0 ' so a blank item isn't selected
	Repeat
		Select WaitEvent()
			Case EVENT_WINDOWCLOSE ' Player wants to exit out
				Select EventSource()
					Case OeWindow ' OeWindow is the only gadget in this context that can generate this event, so we don't need to check for anything else
						FreeGadget OeWindow ' freeing Oewindow frees all its children
						Return ' return 
				End Select 
			Case EVENT_GADGETACTION
				Select EventSource()
					Case OeDropdown
						uniqueId = InstanceMgr.GetCurrentlySelectedInstance() ' get the currently selected instance id
						Local gfxId = EventData() ' get the event data to change the brick fx to
						For InstanceMgr:InstanceManager = EachIn AzInstanceList ' loop through every instance
							If InstanceMgr.uniqueId = uniqueId ' if we get the current unique id
								InstanceMgr.fx = EventData() + 1 ' as 0=no effect
								
							EndIf
						Next				
					Case OeOk ' exit!
						'error checking (did we not trigger the event?)						
						For InstanceMgr:InstanceManager = EachIn AzInstanceList ' loop through every instance...
							If instanceMgr.uniqueId = uniqueId ' is unique id equivalent to the one we want to change
								If instanceMgr.fx = Null ' if fx = 0 
									instanceMgr.fx = 1 ' fx = 1
									Exit ' efficiency								
								EndIf
							EndIf
						Next 	
						FreeGadget OeWindow 'remove the window and all of its children
						
						Return ' return because we selected something
				End Select			
		End Select
	Forever
End Function

