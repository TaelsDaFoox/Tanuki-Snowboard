extends Control
@onready var ipInput = $IpInput
@onready var portInput = $PortInput
@onready var consoleLabel = $ConsoleLabel
@onready var chatInput = $ChatInput
@onready var usernameInput = $UsernameInput
@onready var lobbyBtn = $lobby
@onready var musicCredit = $MusicCredit
func _ready() -> void:
	MenuMusic.play()
	multiplayer.peer_connected.connect(on_peer_connected)
	get_viewport().files_dropped.connect(on_files_dropped)
	PlayerManager.netplayersCssReady.clear()
	PlayerManager.netplayersRaceReady.clear()

func on_peer_connected(id:int) -> void:
	syncinfo()
	#consoleLabel.text = "id "+str(id)+" connected!"
	#if multiplayer.is_server():
		#PlayerManager.playerUIDs.append(id)
		#consoleLabel.text = str(PlayerManager.playerUIDs)

func _on_host_pressed() -> void:
	consoleLabel.text = "host!"
	PlayerManager.peer = ENetMultiplayerPeer.new()
	PlayerManager.peer.create_server(int(portInput.text), 32)
	multiplayer.multiplayer_peer = PlayerManager.peer

func _process(delta: float) -> void:
	musicCredit.text=MenuMusic.musicCredit
	if multiplayer.has_multiplayer_peer() and multiplayer.is_server() and PlayerManager.playerUIDs.size():
		lobbyBtn.visible=true
	else:
		lobbyBtn.visible=false
	var playerlist:Array
	var playerlistStr:="Connected Players:"
	for i in PlayerManager.playerUIDs.size():
		if PlayerManager.netplayerNames.size()>i:
			playerlistStr=playerlistStr+"\n"+PlayerManager.netplayerNames[i]
			#playerlist.append(PlayerManager.netplayerNames[i])
	consoleLabel.text = str(playerlistStr)
	#if multiplayer.is_server():
	#	consoleLabel.text = str(PlayerManager.playerUIDs)

func _on_join_pressed() -> void:
	consoleLabel.text = "peer!"
	PlayerManager.peer = ENetMultiplayerPeer.new()
	PlayerManager.peer.create_client(ipInput.text, int(portInput.text))
	multiplayer.multiplayer_peer = PlayerManager.peer

@rpc("any_peer", "call_remote", "reliable", 0)
func chat_message(msg:String):
	consoleLabel.text=msg
@rpc("any_peer", "call_remote", "reliable", 0)
func debug_emb(emb):
	print(str(emb))
	var img = Image.new()
	img.load_png_from_buffer(emb)
	var tex = ImageTexture.create_from_image(img)
	$TextureRect.texture = tex

func decode_data(string:String, allow_objects = false):
	return JSON.to_native(JSON.parse_string(string), allow_objects)

func _on_chat_send_pressed() -> void:
	chat_message.rpc(chatInput.text)
	#chat_message.rpc_id(1,chatInput.text)
	#get_tree().change_scene_to_file("res://UI/join_menu.tscn")


func _on_lobby_pressed() -> void:
	to_lobby.rpc()
@rpc("any_peer", "call_local", "reliable", 0)
func to_lobby():
	get_tree().change_scene_to_file("res://UI/join_menu.tscn")

func _on_emblem_upload_pressed() -> void:
	$FileDialog.popup()

func on_files_dropped(files):
	print(files)
	var path = files[0]
	var img = Image.new()
	img.load(path)
	await img
	img.resize(32,32,Image.INTERPOLATE_NEAREST)
	PlayerManager.localEmblem=img#.save_png_to_buffer()
	var tex = ImageTexture.create_from_image(img)
	$Emblem.texture = tex
	syncinfo()
func _on_file_dialog_file_selected(path: String) -> void:
	var img = Image.new()
	img.load(path)
	img.resize(32,32,Image.INTERPOLATE_NEAREST)
	PlayerManager.localEmblem=img#.save_pipng_to_buffer()
	var tex = ImageTexture.create_from_image(img)
	$Emblem.texture = tex
	#debug_emb.rpc(img.save_png_to_buffer())
	PlayerManager.sync_player_info.rpc(multiplayer.get_unique_id(),usernameInput.text,PlayerManager.localEmblem.save_png_to_buffer())
func syncinfo():
	PlayerManager.sync_player_info.rpc(multiplayer.get_unique_id(),usernameInput.text,PlayerManager.localEmblem.save_png_to_buffer())

func _on_username_text_changed() -> void:
	PlayerManager.sync_player_info.rpc(multiplayer.get_unique_id(),usernameInput.text,PlayerManager.localEmblem.save_png_to_buffer())


func _on_title_pressed() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	get_tree().change_scene_to_file("res://UI/title_screen.tscn")
