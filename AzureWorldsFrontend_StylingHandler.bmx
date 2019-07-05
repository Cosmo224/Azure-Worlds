Function StylingHandler()
	If MenuChecked(AzWindowToolsMenuStyleButton)
		UncheckMenu(AzWindowToolsMenuStyleButton)
		AzCurrentStyling = 1
		Return 
	Else
		CheckMenu(AzWindowToolsMenuStyleButton)
		AzCurrentStyling = 0
		Return
	EndIf
	
End Function