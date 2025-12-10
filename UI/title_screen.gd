extends Control
@onready var musicCredit = $MusicCredit
func _ready() -> void:
	MenuMusic.play()
	PlayerManager.playerUIDs.clear()
	PlayerManager.netplayerNames.clear()
	PlayerManager.netplayerEmblems.clear()
	PlayerManager.netplayerModels.clear()
	PlayerManager.netplayersCssReady.clear()
	PlayerManager.netplayersRaceReady.clear()

func _on_local_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/join_menu.tscn")


func _on_online_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/netplay_setup.tscn")

func _process(delta: float) -> void:
	musicCredit.text=MenuMusic.musicCredit
