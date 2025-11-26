extends Camera3D
@export var player: CharacterBody3D
@export var followspd = 2.0
var camOffset: Vector3
func _ready() -> void:
	if player:
		camOffset = position-player.position
func _physics_process(delta: float) -> void:
	if player:
		position = position.lerp(player.position+camOffset,delta*followspd)
