extends Node2D

onready var _timer = $Timer

var spawn_counter = 0
var spawn_amount = 1
var spawn_delay = 3
var rng:RandomNumberGenerator


func _ready():
	randomize()
	_timer.start()

func _on_Timer_timeout():
	var zombie = load("res://Assets/Units/zombie.tscn")
	for _num in range(spawn_amount):
		var iZomb = zombie.instance()
		var world = get_tree().current_scene
		world.find_node("enemies").add_child(iZomb)
		# coin flip wether it spawns in top/bottom or left/right sides
		if randi() % 2 == 0:
			iZomb.global_position.x = randi() % ProjectSettings.get_setting("display/window/size/width")
			# coin flip top or bottom
			if randi() % 2 == 0:
				iZomb.global_position.y = -64
			else:
				iZomb.global_position.y = ProjectSettings.get_setting("display/window/size/height") + 96
		else:
			iZomb.global_position.y = randi() % ProjectSettings.get_setting("display/window/size/height")
			# coin flip left or right
			if randi() % 2 == 0:
				iZomb.global_position.x = -64
			else:
				iZomb.global_position.x = ProjectSettings.get_setting("display/window/size/width") + 96
	spawn_counter += 1
	if(spawn_counter % 5):
		spawn_amount += 1
	if(spawn_counter % 10 && spawn_delay > 1):
		spawn_delay -= .2
	var world = get_tree().current_scene
	var player = world.find_node("Player")
	if player.visible == false:
		queue_free()
	_timer.start(spawn_delay)
