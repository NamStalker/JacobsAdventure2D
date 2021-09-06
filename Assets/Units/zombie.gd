extends KinematicBody2D

onready var _anim_player = $AnimationPlayer
onready var _anim_tree = $AnimationTree
onready var _anim_state = _anim_tree.get("parameters/playback")

var _lastDir = 0
var _max_speed = 50
var _acceleration = 300
var _friction = _acceleration * 3
var _velocity = Vector2.ZERO
var _input_vector = Vector2.ZERO
var _knockback = Vector2.ZERO

enum{
	MOVE,
	DASH,
	ATTACK
}

var _state = MOVE

func _ready():
	_anim_tree.active = true
	set_physics_process(true)

func _physics_process(delta):
	match _state:
		MOVE:
			move_state(delta)
	
func move_state(delta):
	var world = get_tree().current_scene
	var playerPath = world.find_node("Player").get_path()
	_input_vector.x = get_node(playerPath).get_position().x - position.x
	_input_vector.y = get_node(playerPath).get_position().y - position.y
	_input_vector = _input_vector.normalized()
	
	if _input_vector != Vector2.ZERO:
		_anim_tree.set("parameters/walking/blend_position", _input_vector)
		_anim_state.travel("walking")
		_velocity = _velocity.move_toward(_input_vector * _max_speed, _acceleration * delta)
		ApplyFriction(_input_vector, delta)
	else:
		ApplyFriction(_input_vector, delta)
		
	move()

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


func _on_hurtbox_area_entered(area):
	_knockback = area._knockback_vector * 300
	_velocity = _knockback
	move()
