extends Node
@onready var consoleLabel = $"../ConsoleLabel"
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Crouch"):
		print("some input, somewhere")
		if event is InputEventKey:
			if not PlayerManager.playerDevices.has(-1):
				PlayerManager.playerDevices.append(-1)
			else:
				print("kb already added!!")
		else:
			if not PlayerManager.playerDevices.has(event.device):
				PlayerManager.playerDevices.append(event.device)
				print("append gamepad " + str(event.device))
			else:
				print("device already added!!")
func _process(delta: float) -> void:
	consoleLabel.text = "devices: \n"+str(PlayerManager.playerDevices)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Courses/Course1.tscn")
