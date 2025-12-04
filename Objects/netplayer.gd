extends CharacterBody3D
@onready var model
@onready var anim
var uid:int
var player_init:Node

func setmodel(modelNum:int) -> void:
	model = PlayerManager.charModels[modelNum].instantiate()
	add_child(model)
	model.scale*=2
	model.position.y-=1
	model.position.z-=1
	anim=model.get_node("AnimationPlayer")
