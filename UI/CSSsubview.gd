extends SubViewport
@onready var model = $Model
@onready var anim = $Model/AnimationPlayer
@export var playerNum: int
@onready var spawnpos = $spawnPos
var prevchar = -1
func _ready() -> void:
	anim.play("CharSelect")
func _process(delta: float) -> void:
	if not prevchar == PlayerManager.playerChars[playerNum] and PlayerManager.playerChars[playerNum]<=PlayerManager.charModels.size()-1:
		prevchar = PlayerManager.playerChars[playerNum]
		if model:
			model.queue_free()
		model = PlayerManager.charModels[PlayerManager.playerChars[playerNum]].instantiate()
		model.rotation.y=PI
		anim = model.get_node("AnimationPlayer")
		anim.play("CharSelect")
		model.visible=false
		if PlayerManager.playerChars[playerNum]==3:
			model.scale*=1.5
		else:
			model.scale*=2
		call_deferred("add_child",model)
		await get_tree().create_timer(1.0/30.0).timeout
		model.global_position = spawnpos.global_position
		model.visible=true
		
		
