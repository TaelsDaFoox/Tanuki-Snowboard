extends Control


func _on_local_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/join_menu.tscn")


func _on_online_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/netplay_setup.tscn")
