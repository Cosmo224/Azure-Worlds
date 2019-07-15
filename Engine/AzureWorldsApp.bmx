' AZURE WORLDS YES

' Globals
Global Syslog:TStream
Global Beta:Int
Global Version:Int=1
Global AzCurrentColourR:Int=255 ' Current colour - R
Global AzCurrentColourG:Int=255 ' Current colour - G
Global AzCurrentColourB:Int=255 ' Current colour - B
Global AzCurrentGridSize:Int=30 ' Current grid size
Global AzCurrentInstanceId:Int=0 ' Current Instance ID
Global AzCurrentUniqueId:Int=0 ' Current Unique ID - integrate? 
Global AzCurrentSizeX:Int=30 ' Current size - X
Global AzCurrentSizeY:Int=30 ' Current size - Y
Global AzDebugDisplay:Int=1 ' Display debug information
Global AzOffsetX:Int=0 ' Offset X for scrolling
Global AzOffsetY:Int=0 ' Offset Y for scrolling
Global AzSpeedX:Int=20 ' Scrollspeed X
Global AzSpeedY:Int=20 ' Scrollspeed Y (this and Scrollspeed X vars placeholder values)
Global AzClickToInsert:Int=1 ' click-to-insert (are blocks insertable)
Global AzCurrentStyling:Int=0 ' Current styling
Global AzGlobalTimer:TTimer ' Timer for running the game
Global AzGfxList:TList ' list of strings holding the path to every GFX in the Gfx/ foider
Global AzGfxManager:InstanceGFX = New InstanceGFX ' GFX Manager
Global AzInstanceList:TList
Global AzInstanceIdList:TList ' hack
Global AzWorldSizeX:Int ' World size X - integrate?
Global AzWorldSizeY:Int
Global AzWindowExplorerList:TList ' you can do this
Global AzWindow:TGadget
Global AzWindowMenu:TGadget
Global AzWindowCanvas:TGadget  
Global AzWindowFileMenu:TGadget
Global AzWindowGameMenu:TGadget
Global AzWindowToolsMenu:TGadget
Global AzWindowToolsMenuStyleButton:TGadget ' this button only because we need to handle it
Global AzWindowHelpMenu:TGadget 
Global AzWindowExplorer:TGadget
Global AzWindowExplorerRoot:TGadget
Global AzWindowToolStrip:TGadget
Global AzWindowCtiBtn:TGadget
Global AzWindowDelBtn:TGadget
Global AzWindowSizeBtn:TGadget
Global AzWindowColourBtn:TGadget
Global AzWindowEffectBtn:TGadget
Global AzWindowPropBtn:TGadget
Type AzureWorlds

	Method Init(x=1228,y=928,d=0,h=0,introImg:String="NonInstanceTextures\avantgarde.png",displayTime:Int=6000,appTtl:String="avant-gardé eyes presents Azure Worlds",canvasSzX=1024,canvasSzY=768,worldSzX=4000,worldSzY=1500,gameName:String="AZURE WORLDS") ' placeholder values
		AppTitle = appTtl
		' preparation for loading from config
		canvasSzX = x - x/5
		canvasSzY = y - y/4
		SeedRnd MilliSecs() ' seed the random number generator
		Syslog = Self.OpenLog("Engine\AvantGardeEyes.log")
		WriteLog("avant-gardé eyes engine - playing frontend " + gameName,Syslog)
		WriteLog("© 2019 avant-gardé eyes",Syslog)
		WriteLog("Initalizing...",Syslog) ' log init
		WriteLog("Debug display: " + AzDebugDisplay,Syslog)
		WriteLog("Window size X: " + x,Syslog)
		WriteLog("Window size Y: " + y,Syslog)
		WriteLog("Graphics size X " + canvasSzX,Syslog)
		WriteLog("Graphics size Y " + canvasSzY,Syslog)
		WriteLog("Default world size X " + worldSzX,Syslog)
		WriteLog("Default world size Y " + worldSzY,Syslog)
		WriteLog("Intro image: " + introImg,Syslog)
		WriteLog("Intro display time: " + displayTime,Syslog)
		WriteLog("Title: " + appTtl,Syslog)
		AzGfxList = New TList ' initalize the gfx list
		WriteLog("Initalized AzGfxList.",Syslog)
		AzWorldSizeX = worldSzX
		AzWorldSizeY = worldSzY
		AzInstanceList = New TList ' New instance list
		WriteLog("Initalized AzInstanceList.",Syslog)
		AzInstanceIdList = New TList ' New Instance Id list - external display only
		WriteLog("Initalized AzInstanceIdList.",Syslog)
		AzWindowExplorerList = New TList
		WriteLog("Initalized AzWindowExplorerList.",Syslog)
		AzGlobalTimer = CreateTimer(60) ' initalize the timer
		WriteLog("Created timer...",Syslog)
		WriteLog("Initalising intro graphics",Syslog)
		Graphics x,y,d,h
		Local introImage:TImage = LoadImage(introImg) ' load the intro image
		If introImage = Null ' Null = failed to load
			WriteLog("Failure to load: Couldn't load intro image.",Syslog)
			HandleError(1,"Error loading intro image",1,0)
		EndIf
		WriteLog("Displayed images.",Syslog)
		DrawImage introImage,0,0
		Flip
		Delay displayTime
		WriteLog("Intro done. Ending graphics...",Syslog)
		EndGraphics ' end the graphics as we use MaxGUI
		WriteLog("Destroying image..",Syslog)
		introImage = Null ' destroy the image
		InitAzGui(AppTtl,x,y,canvasSzX,canvasSzY) ' initalize GUI
		WriteLog("Initalising GFX Manager...",Syslog)
		AzGfxManager.LoadInstanceGFX()
		AzToolVisibility(1,0,0,0,0,0) ' set tool visibility to 1,0,0,0,0,0 as we dont need the rest
		AzInitInstanceIdList(AzInstanceIdList) ' initalize the instanceid list
		WriteLog("Init done.",Syslog)
		Return True ' return true
	End Method
	
	Method OpenLog:TStream(logUrl:String)
		Local logStr:TStream = OpenStream(logUrl) ' open the log
		Return logStr
	End Method
	
	Method WriteLog(logText:String,logStream:TStream)
		If AzDebugDisplay = 1
			WriteLine(logStream,"[" + CurrentDate() + " " + CurrentTime() + "] " + logText)
			Return True
		EndIf 
	End Method
	
	Method HandleError(errorId:Int,errorText:String,errorSeverity:Int,confirmation:Int) ' error handling. returns errorResult if errorSeverity=0 and confirmation=1.
		WriteLog(errorText,Syslog) ' write the error to the log
		Select errorSeverity ' 0 = error, 1 = crash
			Case 0
				Select confirmation ' ok or ok/cancel
					Case 0
						Notify("Error: ~n~n " + errorText + "~n~n Error Code: " + errorId)
					Case 1
						Local errorResult = Confirm("Error: ~n~n " + errorText + "Continue? ~n~n Error Code: " + errorId)
						Return errorResult ' return the errorresult
				End Select
			Case 1
				RuntimeError("Critical Error: ~n~n " + errorText + "~n~n Error Code: " + errorId + " Please contact support. ")
			Default
		End Select

	End Method
	
	Method InitAzGui:Int(AppTtl:String,x,y,canvasSzX,canvasSzY) ' initalize the Az MaxGUI
		WriteLog("UI initalising...",Syslog)
		AzWindow=CreateWindow(AppTtl,DesktopWidth()/5,DesktopHeight()/5,x,y,Null) ' main window
		AzWindowCanvas = CreateCanvas(0,0,canvasSzX,canvasSzY,AzWindow) ' canvas - this holds the graphics
		SetGraphics CanvasGraphics(AzWindowCanvas) ' redirect the graphics context to the canvas so we can draw stuff
		AzWindowMenu = WindowMenu(AzWindow) ' window menu
		' cut down on unnecessary variables here for most menus
		AzWindowFileMenu = CreateMenu("File",0,AzWindowMenu) ' File menu
		AzWindowGameMenu = CreateMenu("Game",100,AzWindowMenu) ' Game menu
		AzWindowToolsMenu = CreateMenu("Tools",200,AzWindowMenu) ' Tools menu
		AzWindowHelpMenu = CreateMenu("Help",300,AzWindowMenu) ' Help menu
		' FILE MENU SUBMENUS
		CreateMenu("New Game",1,AzWindowFileMenu) ' new game submenu
		CreateMenu("Open Game",2,AzWindowFileMenu) ' open game submenu
		CreateMenu("Save Game",3,AzWindowFileMenu) ' save game submenu
		CreateMenu("Save Game As",4,AzWindowFileMenu) ' save game as submenu
		CreateMenu("Upload",5,AzWindowFileMenu) ' upload menu
		CreateMenu("",6,AzWindowFileMenu) ' blank dummy menu for divider
		CreateMenu("Exit",7,AzWindowFileMenu) ' exit menu
		
		' GAME MENU SUBMENUS
		
		CreateMenu("Play",101,AzWindowGameMenu) ' player
		CreateMenu("Settings...",102,AzWindowGameMenu) ' Settings menu
		
		' TOOLS MENU SUBMENUS
		
		If AzDebugDisplay > 1
			CreateMenu("Debug",201,AzWindowToolsMenu) ' Debug menu
		EndIf
		CreateMenu("Insert Object",202,AzWindowToolsMenu) ' Insert object menu
		CreateMenu("Colour",203,AzWindowToolsMenu) ' Colour menu
		CreateMenu("Size",204,AzWindowToolsMenu) ' Size menu
		AzWindowToolsMenuStyleButton = CreateMenu("Style",206,AzWindowToolsMenu) ' Style menu - we need to handle this
		CreateMenu("",207,AzWindowToolsMenu) ' Dummy menu for divider
		CreateMenu("Check for Updates",208,AzWindowToolsMenu) ' Check for Updates
		
		CheckMenu AzWindowToolsMenuStyleButton ' so it doesn't act weirdly
		' HELP MENU SUBMENUS
		
		CreateMenu("Online Help",301,AzWindowHelpMenu) ' Online help menu
		CreateMenu("Visit Azure Worlds",302,AzWindowHelpMenu) ' Visit Azure Worlds menu 
		CreateMenu("",303,AzWindowHelpMenu) ' dummy
		CreateMenu("About",304,AzWindowHelpMenu) ' About Menu
		
		UpdateWindowMenu AzWindow ' update the window menu
		
		' Explorer
		AzWindowExplorer = CreateTreeView(canvasSzX + 4,28,GadgetWidth(AzWindow) - canvasSzX - 30,GadgetHeight(AzWindow) - 125,AzWindow) ' Explorer - where the bricks are!
		AzWindowExplorerRoot = TreeViewRoot(AzWindowExplorer) ' Root handle for adding shit
		CreateLabel("Explorer: ",canvasSzX + 4,0,96,24,AzWindow) ' create the label 
		AzWindowToolStrip = CreateLabel("Brick Tools: ",4,canvasSzY + 4,96,24,AzWindow) ' Tool strip label
		
		' TOOLSTRIP for BLOCKS
		AzWindowCtiBtn = CreateButton("Click-to-Insert: On",GadgetWidth(AzWindow)/8,GadgetHeight(AzWindow) - GadgetHeight(AzWindow)/4.65,96,32,AzWindow) ' Click-to-Insert toggle
		AzWindowDelBtn = CreateButton("Delete",GadgetWidth(AzWindow)/4.499,GadgetHeight(AzWindow) - GadgetHeight(AzWindow)/4.65,96,32,AzWindow) ' Delete button
		AzWindowSizeBtn = CreateButton("Resize",GadgetWidth(AzWindow)/3.141,GadgetHeight(AzWindow) - GadgetHeight(AzWindow)/4.65,96,32,AzWindow) ' Size button
		AzWindowColourBtn = CreateButton("Colour",GadgetWidth(AzWindow)/2.4,GadgetHeight(AzWindow) - GadgetHeight(AzWindow)/4.65,96,32,AzWindow) ' Colour button
		AzWindowEffectBtn = CreateButton("Effect",GadgetWidth(AzWindow)/1.954,GadgetHeight(AzWindow) - GadgetHeight(AzWindow)/4.65,96,32,AzWindow) ' Effects and Style button
		AzWindowPropBtn = CreateButton("Properties",GadgetWidth(AzWindow)/1.648,GadgetHeight(AzWindow) - GadgetHeight(AzWindow)/4.65,96,32,AzWindow) ' Properties button
	End Method

	Method AzToolVisibility(one,two,three,four,five,six)
		If one=1 ' click to insert
			ShowGadget AzWindowCtiBtn
		Else
			HideGadget AzWindowCtiBtn
		EndIf
		
		If two=1
			ShowGadget AzWindowDelBtn
		Else
		 	HideGadget AzWindowDelBtn
		EndIf
		
		If three=1
			ShowGadget AzWindowSizeBtn
		Else
			HideGadget AzWindowSizeBtn
		EndIf
		
		If four=1
			ShowGadget AzWindowColourBtn	
		Else
			HideGadget AzWindowColourBtn
		EndIf
		
		If five=1
			ShowGadget AzWindowEffectBtn
		Else
			HideGadget AzWindowEffectBtn	
		EndIf
		
		If six=1
			ShowGadget AzWindowPropBtn
		Else
			HideGadget AzWindowPropBtn
		EndIf
	End Method
	
	Method AzInitInstanceIdList:TList(AzList:TList)
		WriteLog("Registering Instance IDs...",Syslog)
		Local Az0:String = "Block"
		Local Az1:String = "CircleBlock"
		AzList.AddLast(Az0)
		WriteLog("Registered ID 0 with name " + Az0,Syslog)	
		AzList.AddLast(Az1)
		WriteLog("Registered ID 1 with name " + Az1,Syslog)		
		Return AzList 
	End Method
	
	Method AzRegisterTreeView(instanceId,uniqueId)
		Local AzT:TGadget = AddTreeViewNode(instanceId + " (ID: " + uniqueId + ")",AzWindowExplorerRoot) ' add the tree view node to the root of the explorer
		AzWindowExplorerList.AddLast(AzT)
	End Method

	Method AzUnregisterTreeView(uniqueId)
		FreeGadget SelectedTreeViewNode(AzWindowExplorer) ' remove the treeview gadget
		SelectTreeViewNode(AzWindowExplorer) 'deselect	
	End Method
	
	Method AzCheckTreeViewSelection(treeView:TGadget)
		If SelectedTreeViewNode(treeView) <> Null
			AzToolVisibility(1,1,1,1,1,1) 	'all tools visible	
		Else
			AzToolVisibility(1,0,0,0,0,0) ' all except click to insert tool invisible
		EndIf
	End Method
End Type

' Azure Worlds Instance Manager
' © 2019 Cosmo
Type InstanceManager Extends AzureWorlds
	Field posX ' X position of the brick
	Field posY ' Y position of the brick
	Field sizeX ' X size of the brick
	Field sizeY ' Y size of the brick
	Field colourR ' Colour RGB red of the brick
	Field colourG ' Colour RGB green of the brick
	Field colourB ' Colour RGB blue of the brick
	Field instanceId ' instance ID of the brick
	Field instanceIdDescription:String ' instance ID description of the brick
	Field uniqueId ' unique ID of the brick
	Field gridSize ' grid size of the brick
	Field styling ' styling of the brick
	Field fx=Null ' BrickFX(tm)
	Field scoreBonus ' score given
	Field timeBonus ' time given
	Field bonusBonus ' bonus given
	Field winGiven ' Win given
	Field physEnabled ' Super-Shit" Physics Engine Enabled
	
	Method InsertInstance:InstanceManager(instanceId,posX,posY,sizeX,sizeY,colourR,colourG,colourB,gridSize,styling)
		If AzClickToInsert = 1 ' if click-to-insert is on (lazy btw)
			Local insMan:InstanceManager = New InstanceManager
			insMan.instanceId = AzCurrentInstanceId
			insMan.posX = RoundPos(posX,gridSize) ' round x to the grid size
			insMan.posY = RoundPos(posY,gridSize) ' round y to the grid size
			insMan.sizeX = sizeX
			insMan.sizeY = sizeY
			insMan.colourR = colourR
			insMan.colourG = colourG
			insMan.colourB = colourB
			insMan.gridSize = gridSize
			insMan.styling = styling
			AzCurrentUniqueId = AzCurrentUniqueId + 1
			insMan.uniqueId = AzCurrentUniqueId 
			insMan.instanceIdDescription = insMan.DetermineInstanceParameters(instanceId) ' description of the InstanceID 
			AzInstanceList.AddLast(insMan) ' add this to the list of instances
			AzRegisterTreeView(insMan.instanceId,insMan.uniqueId)
		
		Return insMan ' return insMan
		EndIf
	End Method
	
	Method DeleteInstance() ' delete instance 
		Local index=GetCurrentlySelectedInstance() ' 2019-07-14 - convert to using GetCurrentlySelectedInstance for efficiency and speed
	
		For Local i:InstanceManager = EachIn AzInstanceList
			If index = i.uniqueId ' if the ID we want to delete is actually the ID
				WriteLog("Deleting instance with ID " + i.uniqueId,Syslog)
				AzInstanceList.Remove(i) ' remove it from the list, thus making it inaccessible
				i=Null ' remove the actual object
				AzUnregisterTreeView(uniqueId) ' remove the treeview node signifying the object
				For Local i:InstanceManager = EachIn AzInstanceList ' yes, we have to do this
					If i.uniqueId > uniqueId
					i.uniqueId = i.uniqueId - 1 ' decrement all uniqueIds by 1
				EndIf ' this unfucks the treeview
			Next

			EndIf 
			
		Next
	End Method
	
	Method RecolourInstance(uniqueId:Int=Null) ' merge functions?
		If uniqueId = Null ' if we want to resize currently selected instance instead of arbitrary instance
			uniqueId = GetCurrentlySelectedInstance() ' get the currently selected instance
		EndIf 
		
		For InstanceMgr = EachIn AzInstanceList ' loop through every instance...
			Print(instanceMgr.uniqueId)
			If InstanceMgr.uniqueId = uniqueId ' if this is the ID we want...
				WriteLog("Recolouring instance currently with colour " + instanceMgr.colourR + "," + instanceMgr.colourG + "," + instanceMgr.colourR + " to " + RequestedRed() + "," + RequestedGreen() + "," + RequestedBlue(),Syslog)	 
				instanceMgr.colourR = RequestedRed() ' reuse the current variables for brevity, recolour the block (red)
				instanceMgr.colourG = RequestedGreen() ' reuse the current variables for brevity, recolour the block (green)
				instanceMgr.colourB = RequestedBlue() ' reuse the current variables for brevity, recolour the block (blue)
			EndIf
		Next

	
	End Method
	
	Method ResizeInstance(uniqueId:Int=Null) ' resize instance
		 ' hack
		If uniqueId = Null ' if we want to resize currently selected instance instead of arbitrary instance
			uniqueId = GetCurrentlySelectedInstance() ' get the currently selected instance

		EndIf 
		For InstanceMgr = EachIn AzInstanceList ' loop through every instance...
			Print(instanceMgr.uniqueId)
			If InstanceMgr.uniqueId = uniqueId ' if this is the ID we want...
				WriteLog("Resizing instance currently with size " + instanceMgr.sizeX + "," + instanceMgr.sizeY + " to " + AzCurrentSizeX + "," + AzCurrentSizeY,Syslog)	 
				instanceMgr.sizeX = AzCurrentSizeX ' reuse the current variables for brevity, resize the block in the x-direction
				instanceMgr.sizeY = AzCurrentSizeY ' reuse the current variables for brevity, resize the block in the y-direction
			EndIf
		Next

	End Method
	
	
	Method GetCurrentlySelectedInstance() ' gets the index of the currently selected instance.
		Local index=0 ' index of the part in question to delete
		For Local n:TGadget = EachIn AzWindowExplorerList ' go thru everything
			index=index+1 ' increment index
			If n = SelectedTreeViewNode(AzWindowExplorer) 'ok
				Return index ' exit the loop so we don't have to call another function
			EndIf 
		Next

	End Method
	
	Method DetermineInstanceParameters:String(instanceId:String) ' this determines the parameters of a brick by their Instance IDs
		Select instanceId
			Case 0
				instanceIdDescription = "Brick"
			Case 1
				instanceIdDescription = "CircleBrick"
			Default
				HandleError(5,"Attempted to create description for undefined Instance ID",1,0)
		End Select
		Return instanceIdDescription
	End Method 
		
	Method SetClickToInsert() ' sets the click to insert feature status - on or off 
		Select AzClickToInsert ' click-to-insert select
			Case 0 ' is it off?
				AzClickToInsert = 1 ' is azclicktoinsert off? then turn it on!
				SetGadgetText AzWindowCtiBtn,"Click-to-Insert: On" ' change text to match
				Return
			Case 1
				AzClickToInsert = 0 ' is azclicktoinsert on? then turn it off!
				SetGadgetText AzWindowCtiBtn,"Click-to-Insert: Off"
				Return 
		End Select
	End Method
	
	Method RoundPos(x#,m#)
		If m < 0.0
			 m = -m
		EndIf 	
		' Fake Sgn as for some reason BMX-NG 0.99+ doesn't support it
		Local s#
		If x < 0.0 s=-1
		If x = 0 s=0
		If x > 0.0 s=1
		If x < 0.0
			x = -x
		EndIf 
		Local diff# = x Mod m ' modulus the x
		If diff < .5 * m 
			Return (x-diff)*s
		Else
			Return (m+x-diff)*s
		EndIf  
	End Method 
	
	Method Redraw()

	Cls
	For InstanceMgr = EachIn AzInstanceList
		SetColor InstanceMgr.colourR,InstanceMgr.colourG,InstanceMgr.colourB ' R/G/B
			Select InstanceMgr.instanceId ' what type of block should we add>
				Case 0
					DrawRect InstanceMgr.posX - AzOffsetX,InstanceMgr.posY,InstanceMgr.sizeX,InstanceMgr.sizeY ' draw square [type 0]
				Case 1
					DrawOval InstanceMgr.posX - AzOffsetX,InstanceMgr.posY,InstanceMgr.sizeX,InstanceMgr.sizeY ' draw circle [type 1] - note we subtract the offset x from the actual x position for scrolling
				Default
					App.HandleError(3,"Attempted to insert nonexistent brick type.",1,0)
			End Select
		
			Select InstanceMgr.styling
				Case 0
					SetColor InstanceMgr.colourR-32,InstanceMgr.colourG-32,InstanceMgr.colourB-32 ' test styling
					DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/2.5 - AzOffsetX, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/2.5,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' add offset to 
					DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/1.225 - AzOffsetX, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/2.5,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
					DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/2.5 - AzOffsetX, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/1.225,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
					DrawRect InstanceMgr.posX + InstanceMgr.sizeX - InstanceMgr.sizeX/1.225 - AzOffsetX, InstanceMgr.posY + InstanceMgr.sizeY - InstanceMgr.sizeY/1.225,InstanceMgr.sizeX/4, InstanceMgr.sizeY/4 ' styletest
				Case 1
				
				Default
					App.HandleError(4,"Attemped to insert brick with nonexistent style ID.",2,0)
			End Select ' todo: add var 
			' draw the GFX

			Select InstanceMgr.fx
				Case Null ' if we didn't select an effect...
				Default
					For Local InstanceGFX:InstanceGFX = EachIn AzGfxList ' loop through every effect...
						If InstanceGFX.GfxId = InstanceMgr.fx ' if the GfxId is equal to the fx that we want...
							DrawImage InstanceGFX.gfxImage, InstanceMgr.posX - AzOffsetX, InstanceMgr.posY ' draw the effect 
						EndIf
					Next
			End Select
		SetColor 255,255,255 ' restore colour
	Next
	If AzDebugDisplay = 1 ' if debug display is on
		SetColor 255,255,255
		DrawText "DEBUG",0,0
		DrawText "---",0,15 ' debug mode
		DrawText "Offset X: " + AzOffsetX,0,30
		DrawText "Offset Y: " + AzOffsetY,0,45		
	EndIf 

	Flip 

	
	End Method


End Type

'Azure Worlds Instance GFX Manager (technically there should be two types but who cares)
Type InstanceGFX Extends InstanceManager
	Field gfxId:Int ' gfx ID
	Field gfxName:String ' gfx name
	Field gfxImage:TImage ' gfx image - we don't even need to store the url!
	Method LoadInstanceGFX() ' load GFX
		Local gfxFolder:Byte Ptr = ReadDir("Engine\Gfx\") ' read every file in the Gfx\ folder - todo: use variable...
		
		If gfxFolder=0
			HandleError(7,"Failed to read Gfx folder",1,0) ' throw an error and crash
		EndIf
		Local currentGfx:String ' current file to load
		Local gfxIndex:Int=1 ' gfx Id to insert (YES, ONE-BASED BECAUSE APPARENTLY NULL AND ZERO ARE THE SAME GOD DAMN THING, 0=no effect)
		Repeat
			currentGfx = NextFile(gfxFolder) ' loop through every file in the folder
			If ExtractExt(currentGfx) = "png" ' load all PNG files ONLY
				Local gfxInstance:InstanceGFX = New InstanceGFX ' create the gfx
				
				WriteLog("Loading GFX @ Engine\Gfx\" + currentGfx + " with ID " + gfxIndex,Syslog) ' log the gfx loading
				gfxInstance.gfxId = gfxIndex
				gfxInstance.gfxName = setupGfxNames(gfxIndex) ' setup the gfx name with the gfx index 
				gfxInstance.gfxImage = LoadImage("Engine\Gfx\" + currentGfx) ' load the gfx
				AzGfxList.AddLast(gfxInstance) ' add the gfx to the list
				gfxIndex = gfxIndex + 1 ' increment 1 to gfxIndex
			EndIf 
		Until currentGfx = "" ' stupid legacy Blitz3D style APIs...I want to use EachIn!
	End Method

	Method setupGfxNames:String(gfxId) ' setup the gfx names - this will be called with gfxIndex
			Local gfxName:String 'the name of the gfx
			Select gfxId
				Case 1 ' gfxId 0
					gfxName = "Test Graphical FX"
				Case 2
					gfxName = "Test Graphical FX II"
			End Select
			
			Return gfxName ' return the gfxName
	End Method 
End Type


