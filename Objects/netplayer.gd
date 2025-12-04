extends CharacterBody3D
@onready var model
@onready var anim
var uid:int
var player_init:Node
var modelSet = false
func _ready() -> void:
	set_header()
func set_model(modelNum:int) -> void:
	if not modelSet:
		modelSet = true
		model = PlayerManager.charModels[modelNum].instantiate()
		add_child(model)
		model.scale*=2
		model.position.y-=1
		model.position.z-=1
		anim=model.get_node("AnimationPlayer")

func set_header():
	var player_index = PlayerManager.playerUIDs.find(uid)
	$SubViewport/HBoxContainer/Username.text = PlayerManager.netplayerNames[player_index]
