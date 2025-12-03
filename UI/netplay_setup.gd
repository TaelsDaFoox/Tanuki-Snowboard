extends Control
@onready var ipInput = $IpInput
@onready var portInput = $PortInput
@onready var consoleLabel = $ConsoleLabel
@onready var chatInput = $ChatInput
func _ready() -> void:
	multiplayer.peer_connected.connect(on_peer_connected)

func on_peer_connected(id:int) -> void:
	consoleLabel.text = "id "+str(id)+" connected!"
	if multiplayer.is_server():
		PlayerManager.playerIDs.append(id)
		consoleLabel.text = str(PlayerManager.playerIDs)

func _on_host_pressed() -> void:
	consoleLabel.text = "host!"
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(portInput.text), 32)
	multiplayer.multiplayer_peer = peer


func _on_join_pressed() -> void:
	consoleLabel.text = "peer!"
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ipInput.text, int(portInput.text))
	multiplayer.multiplayer_peer = peer

@rpc("any_peer", "call_remote", "reliable", 0)
func chat_message(msg:String):
	consoleLabel.text=msg

func _on_chat_send_pressed() -> void:
	chat_message.rpc_id(1,chatInput.text)
	#get_tree().change_scene_to_file("res://UI/join_menu.tscn")
