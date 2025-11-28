extends Node
@export var spawnPos:Vector3 = Vector3(0,1.5,0)
@onready var cam = $"../SubViewport/Camera3D"
var player = load("res://Objects/player.tscn")
@onready var ui = $"../SubViewport/RaceUI"
@onready var screen1 = $"../GridContainer/SplitscreenRect1"
func _ready() -> void:
	for i in PlayerManager.playerDevices:
		var spawnplr = player.instantiate()
		spawnplr.position = spawnPos
		spawnplr.input = DeviceInput.new(i)
		get_parent().call_deferred("add_child",spawnplr)
		cam.player = spawnplr
		spawnplr.linkedUI = ui
