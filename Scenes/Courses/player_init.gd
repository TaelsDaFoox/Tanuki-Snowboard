extends Node
@export var spawnPos:Vector3 = Vector3(0,1.5,0)
@onready var cam = $"../SubViewport/Camera3D"
@onready var cams = [$"../SubViewport/Camera3D",$"../SubViewport2/Camera3D",$"../SubViewport3/Camera3D",$"../SubViewport4/Camera3D"]
@onready var uis = [$"../SubViewport/RaceUI",$"../SubViewport2/RaceUI",$"../SubViewport3/RaceUI",$"../SubViewport4/RaceUI"]
@onready var screens = [$"../GridContainer/SplitscreenRect1",$"../GridContainer/SplitscreenRect2",$"../GridContainer/SplitscreenRect3",$"../GridContainer/SplitscreenRect4"]
var player = load("res://Objects/player.tscn")
@onready var ui = $"../SubViewport/RaceUI"
@onready var screen1 = $"../GridContainer/SplitscreenRect1"
@onready var screenContainer = $"../GridContainer"
@onready var music = $"../Music"
#var charModels = [load("res://Models/Characters/Jolt.tscn"),load("res://Models/Characters/Blolt.tscn")]
var songs = [load("res://Audio/Music/Blizzard Peaks (Act1 & 2 Mix).mp3"),load("res://Audio/Music/ICECAP3.mp3"),load("res://Audio/Music/stuck.mp3"),load("res://Audio/Music/Sonic The Hedgehog 3 - IceCap Zone (Dumpster Fired).mp3"),load("res://Audio/Music/Get Edgy - Sonic Rush [OST].mp3")]
func _ready() -> void:
	music.stream = songs[randi_range(0,songs.size()-1)]
	music.play()
	for i in PlayerManager.playerDevices.size():
		var spawnplr = player.instantiate()
		spawnplr.playerNum = i
		spawnplr.position = spawnPos+Vector3(2.0,0.0,0.0)*i
		spawnplr.input = DeviceInput.new(PlayerManager.playerDevices[i])
		get_parent().call_deferred("add_child",spawnplr)
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
