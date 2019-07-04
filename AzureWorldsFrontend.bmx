' front-end for A Z U R E | W O R L D S
Import MaxGui.Drivers
Include "Engine/AzureWorldsApp.bmx"
Include "AzureWorldsFrontend_ChangeColour.bmx"
Include "AzureWorldsFrontend_InsertObject.bmx"
Include "AzureWorldsFrontend_ChangeSize.bmx"
Include "AzureWorldsFrontend_GameSettings.bmx"
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
		Case EVENT_KEYDOWN ' KeyDown
			Select EventData()
				Case KEY_W ' check for W for testing purposes
					TstInsrtBlk()
				
			End Select
		Case EVENT_MOUSEDOWN ' We want to insert something! :D
			If AzClickToInsert = 1
				InstanceMgr.InsertInstance(AzCurrentInstanceId,EventX(),EventY(),AzCurrentSizeX,AzCurrentSizeY,AzCurrentColourR,AzCurrentColourG,AzCurrentColourB,AzCurrentGridSize,AzCurrentStyling) ' Insert the block - 1 line of code!
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
				Case 304
					Notify("AZURE WORLDS~nVersion 1.0. ~n~nCreated by Connor Hyde. Portions of code: ~n© 2017-2019 Connor Hyde. ~n© 2019 avant-gardé eyes.")
			End Select 
	End Select 
Forever

Function TstInsrtBlk()
	Print("Inserting Instance")
	InstanceMgr.InsertInstance(0,Rnd(0,900),Rnd(0,700),Rnd(5,64),Rnd(5,64),Rnd(0,255),Rnd(0,255),Rnd(0,255),Rnd(1,32),0)
	
End Function

