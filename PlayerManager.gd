extends Node
var playerDevices: Array
var playerIDs: Array
var playerChars = [0,0,0,0]
var charModels = [load("res://Models/jolt snowboard.glb"),load("res://Models/Characters/Blolt.tscn"),load("res://Models/Characters/Tammy.tscn"),load("res://Models/Re-Sapph Snowboard.glb"),load("res://Models/Characters/Pi.tscn"),load("res://Models/suzanne snowboard.glb"),load("res://Models/Characters/Penn Guiny.tscn")]
var charNames = ["Jolt","Blolt","Tammy","Sapphire","Pi","Suzanne","Penn Guiny"]
var playerCheckDists := [10000.0,10000.0,10000.0,10000.0]
var playerCheckpoints := [0,0,0,0]
var playerPlacements := [1,2,3,4]
var finishOrder := []
var playerUIDs:= []
var netplayerModels:=[]
var netplayerNames:=[]
var netplayerEmblems:=[]
var peer
var localEmblem := Image.new()
func _ready() -> void:
	fix_list_lengths()
	#var emb = Image.new()
	localEmblem.load("res://Textures/tempEmblem.png")
	#localEmblem = emb#.save_png_to_buffer()
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
func on_peer_connected(id:int) -> void:
	playerUIDs.append(id)
	netplayerModels.append(-1)
	netplayerNames.append("Unnamed Boarder")
	netplayerEmblems.append(localEmblem)
func on_peer_disconnected(id:int) -> void:
	netplayerModels.remove_at(playerUIDs.find(id))
	netplayerNames.remove_at(playerUIDs.find(id))
	netplayerEmblems.remove_at(playerUIDs.find(id))
	playerUIDs.remove_at(playerUIDs.find(id))
func fix_list_lengths():
	var noDevice:int
	if not playerDevices:
		noDevice=1
	if not playerPlacements.size() == playerDevices.size()+playerUIDs.size()+noDevice:
		playerPlacements.clear()
		playerCheckDists.clear()
		for i in playerDevices.size()+playerUIDs.size()+noDevice:
			playerPlacements.append(1)
			playerCheckDists.append(0)
func _process(delta: float) -> void:
	fix_list_lengths()
	var sortedCheckDists = playerCheckDists.duplicate()
	sortedCheckDists.sort()
	sortedCheckDists.reverse()
	for i in playerPlacements.size():
		playerPlacements[i] = sortedCheckDists.find(playerCheckDists[i])+1
	#print(playerCheckDists)
	#print(playerPlacements)
func logDist(plr:int,val:float):
	playerCheckDists[plr]=val
func someoneFinished():
	if finishOrder.size()>=playerDevices.size():
		await get_tree().create_timer(3.0).timeout
		finishOrder.clear()
		playerDevices.clear()
		get_tree().change_scene_to_file("res://UI/join_menu.tscn")
@rpc("any_peer", "call_remote", "reliable", 1)
func sync_player_info(pid:int, name:String,emblem):
	var player_index = PlayerManager.playerUIDs.find(pid)
	if not player_index==-1:
		#fix_list_lengths()
		if netplayerNames.size()<=player_index:
			netplayerNames.append("Unnamed Boarder")
		if name:
			netplayerNames[player_index]=name
		else:
			netplayerNames[player_index]="Unnamed Boarder"
		#var img = Image.new()
		#img.load_png_from_buffer(emblem)
		var img = Image.new()
		img.load_png_from_buffer(emblem)
		if netplayerEmblems.size()<=player_index:
			netplayerEmblems.append(Image.new())
			netplayerEmblems[player_index]=img
		#var netp = netplayerContainer.get_child(player_index)
		#netp.set_header()
#I was looking into mod support and while it's definitely possible to do,
#I think it's out of the scope of the Siege build
#note from future me: continuing this for another siege week so this may be a thing there
#focusing on polish and netplay first

#func _ready() -> void:
	#var modPath = OS.get_executable_path().get_base_dir() + "/modCharacters"
	#var modDir := DirAccess.open(modPath)
	#charModels.append(load(modload))
#func get_unclaimed_devices():
#	var devices = Input.get_connected_joypads()
#	return devices.filter(func(device): return !playerDevices.has(device))
