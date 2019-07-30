
Function ChangeColour(recolourCurrentlySelectedBrick:Int=False)
	Local CcRequester = RequestColor(255,255,255)
	Select CcRequester
		Case True
			' if we want to recolour the currently selected block
			If recolourCurrentlySelectedBrick:Int=True
				InstanceMgr.RecolourInstance()
				Return
			EndIf
			AzCurrentColourR = RequestedRed()
			AzCurrentColourG = RequestedGreen()
			AzCurrentColourB = RequestedBlue()
		Case False
			Return
	End Select
End Function


