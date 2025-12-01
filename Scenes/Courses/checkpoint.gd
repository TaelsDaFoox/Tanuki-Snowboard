extends Area3D
@export var checkpointNum: int
func _on_body_entered(body: Node3D) -> void:
	body.hitCheckpoint(checkpointNum)
