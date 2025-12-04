extends Node
@onready var cam = $"../SubViewport/Camera3D"
@onready var cams = [$"../SubViewport/Camera3D",$"../SubViewport2/Camera3D",$"../SubViewport3/Camera3D",$"../SubViewport4/Camera3D"]
@onready var uis = [$"../SubViewport/RaceUI",$"../SubViewport2/RaceUI",$"../SubViewport3/RaceUI",$"../SubViewport4/RaceUI"]
@onready var screens = [$"../GridContainer/SplitscreenRect1",$"../GridContainer/SplitscreenRect2",$"../GridContainer/SplitscreenRect3",$"../GridContainer/SplitscreenRect4"]
var player = load("res://Objects/player.tscn")
@onready var ui = $"../SubViewport/RaceUI"
@onready var screen1 = $"../GridContainer/SplitscreenRect1"
@onready var screenContainer = $"../GridContainer"
@onready var music = $"../Music"
@onready var spawnPos= $"../SpawnPos"
var netplayer = load("res://Objects/netplayer.tscn")
@export var netplayerContainer: Node
#var charModels = [load("res://Models/Characters/Jolt.tscn"),load("res://Models/Characters/Blolt.tscn")]
var songs = [load("res://Audio/Music/Blizzard Peaks (Act1 & 2 Mix).mp3"),load("res://Audio/Music/ICECAP3.mp3"),load("res://Audio/Music/stuck.mp3"),load("res://Audio/Music/Sonic The Hedgehog 3 - IceCap Zone (Dumpster Fired).mp3"),load("res://Audio/Music/Get Edgy - Sonic Rush [OST].mp3")]
func _ready() -> void:
	music.stream = songs[randi_range(0,songs.size()-1)]
	music.play()
	#mpSpawner.set_spawn_function(func spawnfunc(plr): return plr)
	#await get_tree().create_timer(5.0).timeout
	for i in PlayerManager.playerDevices.size():
		var spawnplr = player.instantiate()
		spawnplr.playerNum = i
		spawnplr.position = spawnPos.global_position+Vector3(2.0,0.0,0.0)*i
		spawnplr.input = DeviceInput.new(PlayerManager.playerDevices[i])
		spawnplr.checkpoints = $"../Checkpoints"
		spawnplr.player_init=self
		get_parent().call_deferred("add_child",spawnplr)
		#playerNodes.append(spawnplr)
		
		#mpSpawner.call_deferred("spawn",spawnplr)
		
		#var spawnmdl = charModels[PlayerManager.playerChars[i]].instantiate()
		#spawnplr.call_deferred("add_child",spawnmdl)
		#spawnplr.model = spawnmdl
		#spawnplr.anim = spawnmdl.get_node("AnimationPlayer")
		#spawnplr.get_node("ModelTemp").call_deferred("queue_free")
		
		cams[i].player = spawnplr
		spawnplr.linkedUI = uis[i]
	for i in 4:
		screens[i].visible = i<PlayerManager.playerDevices.size()
	screenContainer.columns=ceil(PlayerManager.playerDevices.size()/2.0)
	if PlayerManager.playerDevices.size()==2:
		$"../SubViewport".size.x=1152*2
		$"../SubViewport2".size.x=1152*2
	#setup netplayers
	if PlayerManager.peer and PlayerManager.playerUIDs:
		for i in PlayerManager.playerUIDs:
			var spawnplr = netplayer.instantiate()
			#spawnplr.playerNum = i
			spawnplr.position = spawnPos.global_position
			#spawnplr.input = DeviceInput.new(PlayerManager.playerDevices[i])
			#spawnplr.checkpoints = $"../Checkpoints"
			spawnplr.uid = i
			spawnplr.player_init=self
			netplayerContainer.call_deferred("add_child",spawnplr)
@rpc("any_peer", "call_remote", "unreliable_ordered", 0)
func sync_player(pid:int,pos:Vector3,rot:Vector3,vel:Vector3,anim:String,animTime:float,mdl:int,checkdist:float):
	var player_index = PlayerManager.playerUIDs.find(pid)
	var netp = netplayerContainer.get_child(player_index)
	netp.global_position = pos
	netp.global_rotation = rot
	netp.velocity=vel
	netp.set_model(mdl)
	PlayerManager.playerCheckDists[PlayerManager.playerUIDs.find(pid)+1]=checkdist
	if netp.anim:
		netp.anim.play(anim,0.1,0.0)
		netp.anim.seek(animTime)
func _process(delta: float) -> void:
	for i in netplayerContainer.get_children():
		pass
