extends Node3D
@onready var sprite = $MeepleSpr
var yv:=1.0
var randomTime:float
func _ready() -> void:
	randomTime=randf_range(0.5,1.4)
	match randi_range(0,5):
		0:
			sprite.texture=load("res://Textures/meeple/meeple-merc.png")
		1:
			sprite.texture=load("res://Textures/meeple/meeple-red.png")
		2:
			sprite.texture=load("res://Textures/meeple/meeple-orange.png")
		3:
			sprite.texture=load("res://Textures/meeple/meeple-green.png")
		4:
			sprite.texture=load("res://Textures/meeple/meeple-blue.png")
		5:
			sprite.texture=load("res://Textures/meeple/meeple-purple.png")
func _physics_process(delta: float) -> void:
	yv-=delta*150.0
	sprite.position.y+=yv*delta
	if sprite.position.y<=0.0:
		sprite.position.y=0.0
		yv=40.0*randomTime
