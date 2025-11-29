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
func _ready() -> void:
	for i in PlayerManager.playerDevices.size():
		var spawnplr = player.instantiate()
		spawnplr.position = spawnPos+Vector3(2.0,0.0,0.0)*i
		spawnplr.input = DeviceInput.new(PlayerManager.playerDevices[i])
		get_parent().call_deferred("add_child",spawnplr)
		cams[i].player = spawnplr
		spawnplr.linkedUI = uis[i]
	for i in 4:
		screens[i].visible = i<PlayerManager.playerDevices.size()
	screenContainer.columns=ceil(PlayerManager.playerDevices.size()/2.0)
