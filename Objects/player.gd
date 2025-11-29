extends CharacterBody3D
@export var turnspeed = 2.0
@export var turnlerpspeed = 0.2
var movespd = 0.0
var turnvel = 0.0
@export var jumpHeight = 15.0
@export var mainSpeed = 50.0
@export var crouchSpeed = 30.0
@onready var anim = $Model/AnimationPlayer
@export var maxturnspd = 2.0
@export var gravity := 1.0
@export var trickGravity :=0.8
@onready var model = $Model
@onready var collider = $CollisionShape3D
@onready var rampArea = $RampArea
@onready var noSlopeArea = $NoSlopeAngle
@export var linkedUI: Control
@export var trickBoost = 80.0
var trickFailWait = 0.0
var slopeDir := 0.0
var extraBoost = 0.0
var trickState = false
var input
#var playerNum = 0
func _ready() -> void:
	#input = DeviceInput.new(-1)
	if linkedUI:
		linkedUI.linkedPlayer=self
	anim.play("Board",0.25,0.0)
func _physics_process(delta: float) -> void:
	if linkedUI and linkedUI.QTEactive:
		linkedUI.QTEinput(input)
	trickFailWait = move_toward(trickFailWait,0.0,delta)
	if is_on_floor():
		if not (get_floor_normal().y==1.0 or noSlopeArea.has_overlapping_areas()):
			slopeDir=-(Vector2(get_floor_normal().x,get_floor_normal().z).angle())-(PI/2)
		if linkedUI and linkedUI.QTEactive and not trickFailWait:
			linkedUI.cancelQTE()
			trickState=false
		if input.is_action_pressed("Crouch"):
			anim.play("Crouch",0.25,0.0)
			movespd = lerpf(movespd,crouchSpeed,delta*2.0)
		else:
			anim.play("Board",0.25,0.0)
			movespd = lerpf(movespd,mainSpeed+extraBoost,delta*2.0)
	else:
		movespd = lerpf(movespd,mainSpeed+extraBoost,delta*2.0)
	if input.is_action_just_released("Crouch") and is_on_floor():
		anim.play("Board",0.25,0.0)
		if rampArea.has_overlapping_areas():
			velocity.y=50.0
			trickState=true
			if linkedUI:
				linkedUI.QTEstart()
				trickFailWait=0.5
		else:
			velocity.y=jumpHeight
			print("no trick")
	if anim.current_animation=="Board" or anim.current_animation=="Crouch":
		var animturn = 0.833+clampf(-rotation.y,-0.83,0.83)
		anim.seek(animturn)
	velocity.x=-sin(rotation.y)*movespd
	velocity.z=-cos(rotation.y)*movespd
	turnvel=move_toward(turnvel,(input.get_action_strength("Right")-input.get_action_strength("Left"))*turnspeed,delta*(turnlerpspeed+(extraBoost/300.0)))
	rotation.y-=turnvel
	turnvel = lerpf(turnvel,0.0,delta*2.5)
	rotation.y=lerp_angle(rotation.y,slopeDir,delta*velocity.length()*0.1)
	if is_on_floor():
		if velocity.y<0.0:
			velocity.y=-0.0
		#model.rotation.x = -get_floor_normal().z
		#model.rotation.z = get_floor_normal().x
		var slopeAng = Vector3.UP-get_floor_normal()
		model.global_rotation.x = slopeAng.z
		model.global_rotation.z = slopeAng.x
		trickState=false
	else:
		if trickState:
			velocity.y-=gravity
		else:
			velocity.y-=trickGravity
		model.rotation.x=lerp_angle(rotation.x,0.0,delta*10)
		model.rotation.z=lerp_angle(rotation.z,0.0,delta*10)
	collider.global_rotation=Vector3.ZERO
	move_and_slide()
	extraBoost=move_toward(extraBoost,0.0,delta*20)
	#print(trickFailWait)

func tricked():
	anim.play("Trick",0.1,1.5)
	velocity.y=10.0
	print("trick1!!")
	extraBoost+=trickBoost
	movespd = mainSpeed+extraBoost*1.5
