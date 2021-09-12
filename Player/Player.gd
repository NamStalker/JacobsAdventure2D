extends KinematicBody2D

onready var _anim_player = $AnimationPlayer
onready var _anim_tree = $AnimationTree
onready var _anim_state = _anim_tree.get("parameters/playback")

onready var _weapon = $Position2D/Area2D

var _lastDir = 0
var _max_speed = 150
var _dash_speed = 250
var _acceleration = 300
var _friction = _acceleration * 3
var _velocity = Vector2.ZERO
var _input_vector = Vector2.ZERO

enum{
	MOVE,
	DASH,
	ATTACK,
	PASS
}

var _state = MOVE

func _ready():
	_anim_tree.active = true
	set_physics_process(true)

func _physics_process(delta):
	match _state:
		MOVE:
			move_state(delta)
		DASH:
			dash_state(delta)
		ATTACK:
			attack_state(delta)
		PASS:
			pass
	
func move_state(delta):
	_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_input_vector = _input_vector.normalized()
	
	if _input_vector != Vector2.ZERO:
		_anim_tree.set("parameters/attack/blend_position", _input_vector)
		_anim_tree.set("parameters/walking/blend_position", _input_vector)
		_anim_tree.set("parameters/dash/blend_position", _input_vector)
		_anim_state.travel("walking")
		_weapon._knockback_vector = _input_vector
		_velocity = _velocity.move_toward(_input_vector * _max_speed, _acceleration * delta)
		ApplyFriction(_input_vector, delta)
	else:
		ApplyFriction(_input_vector, delta)
		
	move()
	
	if Input.is_action_just_pressed("run"):
		_state = DASH
	
	if Input.is_action_pressed("ui_interact"):
		_state = ATTACK

func move():
	_velocity = move_and_slide(_velocity)

func ApplyFriction(input_vector, delta):
	# apply friction when not moving, 
	# and when moving against current velocity.
	if input_vector == Vector2.ZERO:
		_velocity = _velocity.move_toward(Vector2.ZERO, _friction * delta)
	elif _velocity.x > 0 && input_vector.x < 0 || _velocity.x < 0 && input_vector.x > 0:
		_velocity.x = _velocity.move_toward(Vector2.ZERO, _friction * delta).x
	elif _velocity.y > 0 && input_vector.y < 0 || _velocity.y < 0 && input_vector.y > 0:
		_velocity.y = _velocity.move_toward(Vector2.ZERO, _friction * delta).y

func attack_state(_delta):
	#_velocity = Vector2.ZERO
	var bullet = load("res://Assets/Props/bullet.tscn")
	var iBull = bullet.instance()
	var world = get_tree().current_scene
	world.find_node("projectiles").add_child(iBull)
	iBull.global_position = global_position
	_state = MOVE

func attack_animation_finished():
	_state = MOVE
	
func dash_state(_delta):
	_velocity = _input_vector * _dash_speed
	_anim_state.travel("dash")
	move()

func dash_animation_finished():
	_state = MOVE
