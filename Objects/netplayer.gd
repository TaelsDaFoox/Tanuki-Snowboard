extends CharacterBody3D
@onready var model
@onready var anim
var uid:int
var player_init:Node
var modelSet = false
var placementEndings := ["th","st","nd","rd","th","th","th","th","th","th",]
@onready var username =$SubViewport/HBoxContainer/Username
@onready var icon =$SubViewport/HBoxContainer/PlayerIcon
func _ready() -> void:
	set_header()
func _process(delta: float) -> void:
	var player_index = PlayerManager.playerUIDs.find(uid)
	if not PlayerManager.playerUIDs.has(uid):
		return
	
	var placement = PlayerManager.playerPlacements[player_index+1]
	#print("index "+str(player_index+1)+" is "+str(PlayerManager.playerPlacements[player_index+1]))
	#var placement = PlayerManager.playerPlacements.find(player_index+2)
	
	var placementstr = str(placement)+placementEndings[fmod(placement,10)]
	#if player_index>=PlayerManager.netplayerNames.size()-1:
	username.text = PlayerManager.netplayerNames[player_index]+" ("+placementstr+")"
func set_model(modelNum:int) -> void:
	if not modelSet:
		modelSet = true
		model = PlayerManager.charModels[modelNum].instantiate()
		add_child(model)
		model.scale*=2
		model.position.y-=1
		model.position.z-=1
		anim=model.get_node("AnimationPlayer")

func set_header():
	var player_index = PlayerManager.playerUIDs.find(uid)
	username.text = PlayerManager.netplayerNames[player_index]
	#var img = Image.new()
	#img.load_png_from_buffer(PlayerManager.netplayerEmblems[player_index])
	var img = PlayerManager.netplayerEmblems[player_index]
	var tex = ImageTexture.create_from_image(img)
	icon.texture=tex
	print(img)
