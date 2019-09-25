Function BrickProperties()
	Local BpWindow:TGadget = CreateWindow("Brick Properties",GraphicsWidth()/5,GraphicsHeight()/5,400,400,Null) ' Window
	Local BpLabel:TGadget = CreateLabel("General:",4,16,80,24,BpWindow) ' General settings label
	Local BpScoreBonusLabel:TGadget = CreateLabel("Score Bonus on Hit:",4,48,115,24,BpWindow) ' World size label
	Local BpScoreBonus:TGadget = CreateTextField(119,44,244,24,BpWindow) ' world size textbox
	Local BpTimeBonusLabel:TGadget = CreateLabel("Time Bonus on Hit:",4,80,115,24,BpWindow) ' time bonus
	Local BpTimeBonus:TGadget = CreateTextField(119,76,244,24,BpWindow)
	Local BpBonusBonusLabel:TGadget = CreateLabel("Bonus on Hit:",4,112,115,24,BpWindow) ' bonus bonus
	Local BpBonusBonus:TGadget = CreateTextField(119,108,60,24,BpWindow)
	Local BpPhysEnabled:TGadget = CreateButton("Physics Enabled",119,144,60,24,BpWindow,BUTTON_CHECKBOX) ' is physics enabled?
	Local BpStylingTrigger:TGadget = CreateLabel("Under Construction",4,180,244,24,BpWindow) ' Selection dropdown
	Local BpOk:TGadget = CreateButton("OK",269,290,64,24,BpWindow) ' OK button
	Repeat
		Select WaitEvent()
			Case EVENT_WINDOWCLOSE ' Player wants to exit out
				Select EventSource()
					Case BpWindow ' BpWindow is the only gadget in this context that can generate this event, so we don't need to check for anything else
						FreeGadget BpWindow ' freeing Bpwindow frees all its children
						Return ' return
				End Select 
			Case EVENT_GADGETACTION
				Select EventSource()			
					Case BpOk ' exit!
						Local uniqueId:Int = InstanceMgr.GetCurrentlySelectedInstance() ' this function returns the index and thus uniqueId of the currently selected instance.
						For InstanceMgr = EachIn AzInstanceList ' loop through every single
							If InstanceMgr.uniqueId = uniqueId ' is it the currently selected Unique Id?
								' temp variables for checking purposes
								Local tempScoreBonus = Int GadgetText(BpScoreBonus) ' set the score bonus
								Local tempTimeBonus = Int GadgetText(BpTimeBonus) ' set the time bonus
								Local tempBonusBonus = Int GadgetText(BpBonusBonus) ' set the bonus bonus
								If tempScoreBonus <> 0
									InstanceMgr.scoreBonus = tempScoreBonus ' set score bonus to temp var
								ElseIf tempTimeBonus <> 0
									InstanceMgr.timeBonus = tempTimeBonus ' set time bonus to temp var
								ElseIf tempBonusBonus <> 0 
									InstanceMgr.bonusBonus = tempBonusBonus ' set bonus bonus to temp var
								EndIf	
								If ButtonState(BpPhysEnabled) = True
									InstanceMgr.physEnabled = 1 ' turn it on
								Else
									InstanceMgr.physEnabled = 0 ' turn it off
								EndIf
								' is it checked?
							EndIf
						Next
						
						FreeGadget BpWindow 'remove the Bpwindow and all of its children
						Return ' return because we selected something.
					
				End Select			
		End Select
	Forever

End Function
