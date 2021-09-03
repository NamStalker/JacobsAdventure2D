extends KinematicBody2D

onready var _sprite = $PlayerSprite
var _lastDir = 0
var _max_speed = 150
var _acceleration = 300
var _friction = _acceleration * 3
var _shiftMod = 1

var _velocity = Vector2.ZERO

func _ready():
	set_physics_process(true)
	
func _process(_delta):
	if Input.is_action_pressed("ui_down"):
		#_sprite.play("walk_down")
		_lastDir = 0
	elif Input.is_action_pressed("ui_up"):
		#_sprite.play("walk_up")
		_lastDir = 1
	elif Input.is_action_pressed("ui_right"):
		_sprite.set_flip_h(true)
		#_sprite.play("walk_side")
		_lastDir = 2
	elif Input.is_action_pressed("ui_left"):
		_sprite.set_flip_h(false)
		#_sprite.play("walk_side")
		_lastDir = 3
	#else:
		#if _lastDir == 0:
			#_sprite.play("idle")
		#elif _lastDir == 1:
			#_sprite.play("idle_up")
		#elif _lastDir == 2 || _lastDir == 3:
			#_sprite.play("idle_side")
			
	if Input.is_action_pressed("run"):
		_shiftMod = 2
		_sprite.speed_scale = 2
	elif Input.is_action_just_released("run"):
		_shiftMod = 1
		_sprite.speed_scale = 1

func _physics_process(delta):
	Movement(delta)
	
func Movement(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		_velocity = _velocity.move_toward(input_vector * _max_speed * _shiftMod, _acceleration * _shiftMod * delta)
		ApplyFriction(input_vector, delta)
	else:
		ApplyFriction(input_vector, delta)
		
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
