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
var trickState = false
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Crouch"):
		anim.play("Crouch",0.25,0.0)
		movespd = lerpf(movespd,crouchSpeed,delta*2.0)
	else:
		anim.play("Board",0.25,0.0)
		movespd = lerpf(movespd,mainSpeed,delta*2.0)
	if Input.is_action_just_released("Crouch") and is_on_floor():
		if rampArea.has_overlapping_areas():
			velocity.y=50.0
			trickState=true
		else:
			velocity.y=jumpHeight
	var animturn = 0.833+clampf(-rotation.y,-0.83,0.83)
	anim.seek(animturn)
	velocity.x=-sin(rotation.y)*movespd
	velocity.z=-cos(rotation.y)*movespd
	turnvel=move_toward(turnvel,(Input.get_action_strength("Right")-Input.get_action_strength("Left"))*turnspeed,delta*turnlerpspeed)
	rotation.y-=turnvel
	turnvel = lerpf(turnvel,0.0,delta*2.5)
	rotation.y=lerp_angle(rotation.y,0.0,delta*velocity.length()*0.1)
	if is_on_floor():
		if velocity.y<0.0:
			velocity.y=-0.0
		model.rotation.x = -get_floor_normal().z
		model.rotation.z = get_floor_normal().x
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
