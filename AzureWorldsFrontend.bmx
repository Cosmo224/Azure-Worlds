' front-end for A Z U R E | W O R L D S
Import MaxGui.Drivers
Include "Engine/AzureWorldsApp.bmx"
Include "AzureWorldsFrontend_ChangeColour.bmx"
Include "AzureWorldsFrontend_InsertObject.bmx"
Include "AzureWorldsFrontend_ChangeSize.bmx"
Include "AzureWorldsFrontend_GameSettings.bmx"
Include "AzureWorldsFrontend_StylingHandler.bmx"
Global App:AzureWorlds = New AzureWorlds ' instantiate the app
Global InstanceMgr:InstanceManager = New InstanceManager ' instantiate the instance manager
'TODO: Get from Config file
App.Init(1288,960,0,0,"Engine/NonInstanceTextures/avantgarde.png",7500) ' we don't need the last parameter

Repeat
	Select WaitEvent()
		Case EVENT_WINDOWCLOSE ' application wants to close...
			Select EventSource() ' select the source
				Case AzWindow
					FreeGadget AzWindow
					End ' exit  
			End Select
		Case EVENT_TIMERTICK ' Idle

			InstanceMgr.Redraw()
			App.AzCheckTreeViewSelection(AzWindowExplorer)

		Case EVENT_KEYREPEAT ' Undocumented feature
			Select EventData()
				Case KEY_LEFT ' Scroll left
					If AzOffsetX > 0 ' if AzOffsetX is more than 0 (cus yeah)
						AzOffsetX = AzOffsetX - AzSpeedX ' reduce the offsetx by the speed
					EndIf
				Case KEY_RIGHT ' Scroll right
					If AzOffsetX < AzWorldSizeX ' if x offset less than worldsize
						AzOffsetX = AzOffsetX + AzSpeedX ' ditto
					EndIf 
			End Select		
		Case EVENT_MOUSEDOWN ' We want to insert something! :D
			If AzClickToInsert = 1
				InstanceMgr.InsertInstance(AzCurrentInstanceId,EventX() + AzOffsetX,EventY(),AzCurrentSizeX,AzCurrentSizeY,AzCurrentColourR,AzCurrentColourG,AzCurrentColourB,AzCurrentGridSize,AzCurrentStyling) ' Insert the block - 1 line of code!
			EndIf
		Case EVENT_MENUACTION
			Select EventData()
				Case 102
					GameSettings()
				Case 202
					InsertObject()
				Case 203
					ChangeColour()
				Case 204
					ChangeSize()
				Case 206
					StylingHandler()
				Case 304
					Notify("AZURE WORLDS~nVersion 1.0. ~n~nCreated by Connor Hyde. Portions of code: ~n© 2017-2019 Connor Hyde. ~n© 2019 avant-gardé eyes.")
			End Select 
		Case EVENT_GADGETACTION
			Select EventSource() ' what triggered it?
				Case AzWindowColourBtn ' recolour button
					ChangeColour(True)
				Case AzWindowDelBtn
					InstanceMgr.DeleteInstance() ' no we don't need any params.
				Case AzWindowSizeBtn
					ChangeSize(True) ' we want to resize the currently selected brick
			End Select
		
	End Select 
Forever


