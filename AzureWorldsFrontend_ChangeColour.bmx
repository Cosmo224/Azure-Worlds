
Function ChangeColour()
	Local CcRequester = RequestColor(255,255,255)
	Select CcRequester
		Case True
			AzCurrentColourR = RequestedRed()
			AzCurrentColourG = RequestedGreen()
			AzCurrentColourB = RequestedBlue()
		Case False
			Return
	End Select
End Function


