extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func destroy_to_shrapnel():
		var shrapnel = load("res://Assets/Props/pot_shrapnel.tscn")
		var iShrap = shrapnel.instance()
		var world = get_tree().current_scene
		world.add_child_below_node(world.find_node("YSort"), iShrap)
		iShrap.global_position = global_position
		
		queue_free()

func _on_interact_range_area_entered(_area):
	destroy_to_shrapnel()
