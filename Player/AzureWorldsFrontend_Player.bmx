' Azure Worlds Player
' �2019 Cosmo for avant-gard� eyes.
Import MaxGui.Drivers
Include "../Engine/AzureWorldsApp.bmx"
Global App:AzureWorlds = New AzureWorlds
Global InstanceMgr:InstanceManager = New InstanceManager ' initalize
Global PlayerMgr:Player = New Player ' yeah!!!
' todo: use App.GetConfiguration() to do this
App.Init(1288,960,0,0,"..\Engine\NonInstanceTextures\avantgarde.png",6000,"AZURE WORLDS Player",1024,768,4000,1500,"AZURE WORLDS Player","..\Engine\AvantGardeEyes.log",1,"..\Engine\Gfx")
App.GetAppArgs() ' handle App Arguments
PlayerMgr.InitPlayer()
Repeat 
	Select WaitEvent()
		Case EVENT_TIMERTICK
			InstanceMgr.Redraw()
			PlayerMgr.PlayerPhysics() ' physics aa
		Case EVENT_KEYREPEAT ' undocumented for now but i was able to get it documented in the next release of blitzmax ng by committing it myself
			PlayerMgr.MovePlayer() ' move the player
		Case EVENT_WINDOWCLOSE
			App.Close()
		
	End Select 
Forever