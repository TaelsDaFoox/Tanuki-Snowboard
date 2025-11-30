extends SubViewport
@onready var model = $Model
@onready var anim = $Model/AnimationPlayer
func _ready() -> void:
	anim.play("CharSelect")
