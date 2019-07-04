' front-end for A Z U R E | W O R L D S
Import MaxGui.Drivers
Include "Engine/AzureWorldsApp.bmx"
Include "AzureWorldsFrontend_ChangeColour.bmx"
Include "AzureWorldsFrontend_InsertObject.bmx"
Include "AzureWorldsFrontend_ChangeSize.bmx"
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
			Redraw()
			
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

Function Redraw()
	Cls
	For InstanceMgr = EachIn AzInstanceList
		SetColor InstanceMgr.colourR,InstanceMgr.colourG,InstanceMgr.colourB ' R/G/B
		Select InstanceMgr.instanceId ' what type of block should we add>
			Case 0
				DrawRect InstanceMgr.posX,InstanceMgr.posY,InstanceMgr.sizeX,InstanceMgr.sizeY ' draw square [type 0]
			Case 1
				DrawOval InstanceMgr.posX,InstanceMgr.posY,InstanceMgr.sizeX,InstanceMgr.sizeY ' draw square [type 0]
			Default
				App.HandleError(3,"Attempted to insert nonexistent brick type.",1,0)
		End Select
		
		Select InstanceMgr.styling
			Case 0
				SetColor InstanceMgr.colourR-32,InstanceMgr.colourG-32,InstanceMgr.colourB-32 ' test styling
				DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/2.5, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/2.5,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
				DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/1.225, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/2.5,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
				DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/2.5, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/1.225,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
				DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/1.225, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/1.225,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
			Case 1
				
			Default
				App.HandleError(4,"Attemped to insert brick with nonexistent style ID.",2,0)
		End Select 
	
		SetColor 255,255,255 ' restore colour
	Next
	Flip 
	
	
End Function

