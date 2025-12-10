extends Node3D
@onready var raycast = $RayCast3D
var waitingToCast:=true
func _process(delta: float) -> void:
	if waitingToCast:
		raycast.force_raycast_update()
		if raycast.is_colliding():
			waitingToCast=false
			global_position=raycast.get_collision_point()
			#print(str(raycast.get_collision_point()))
			raycast.enabled=false
