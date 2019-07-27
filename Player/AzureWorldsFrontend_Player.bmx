' Azure Worlds Player
' ©2019 Cosmo for avant-gardé eyes.
Import MaxGui.Drivers
Include "../Engine/AzureWorldsApp.bmx"
Global App:AzureWorlds = New AzureWorlds
Global InstanceMgr:InstanceManager = New InstanceManager ' initalize
' todo: use App.GetConfiguration() to do this
App.Init(1288,960,0,0,"..\Engine\NonInstanceTextures\avantgarde.png",6000,"AZURE WORLDS Player",1024,768,4000,1500,"AZURE WORLDS Player","..\Engine\AvantGardeEyes.log",1,"..\Engine\Gfx")

Repeat 
	Select WaitEvent()
		Case EVENT_WINDOWCLOSE
			App.Close()
		
	End Select 
Forever