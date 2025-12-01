extends TextureRect
func _process(delta: float) -> void:
	position.x -= delta*50
	position.y +=delta*25
	position.x = fmod(position.x+251.0,251.0)-251.0
	position.y = fmod(position.y+216.0, 216.0)-216.0
