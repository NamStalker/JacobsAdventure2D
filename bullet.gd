extends KinematicBody2D
onready var _pew = $AudioStreamPlayer
var _velocity = Vector2.ZERO
var _input_vector = Vector2.ZERO
var _speed = 300
var _closest_x = 0
var _closest_y = 0
var _knockback_vector = Vector2.ZERO

func _ready():
	_pew.play()
	var world = get_tree().current_scene
	_input_vector = world.find_node("Player").find_node("AnimationTree").get("parameters/walking/blend_position")
	_input_vector = _input_vector.normalized()
	
func _physics_process(_delta):
	_velocity = move_and_slide(_input_vector * _speed)
	var trans = get_global_transform_with_canvas()
	if trans.origin.x < 0 || trans.origin.y < 0:
		queue_free()
	elif trans.origin.x > ProjectSettings.get_setting("display/window/size/width") || trans.origin.y > ProjectSettings.get_setting("display/window/size/height"):
		queue_free()


func _on_interact_range_area_entered(area):
	queue_free()
