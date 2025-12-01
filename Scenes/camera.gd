extends Camera3D
@export var player: CharacterBody3D
@export var followspd = 10.0
var camOffset: Vector3 = Vector3(0.0,3.0,1.0)
func _ready() -> void:
	if player:
		pass
		#camOffset = position-player.position
		#print(camOffset)
func _physics_process(delta: float) -> void:
	if player and not player.finished:
		position = position.lerp(player.position+camOffset.rotated(Vector3.UP,player.rotation.y),delta*followspd)
		#var rotBuffer = rotation
		#look_at(player.position,Vector3.UP)
		#rotation = Vector3(rotBuffer.x,rotation.y,rotBuffer.z)
		rotation.y = lerp_angle(rotation.y,player.slopeDir,delta)
