extends Node2D


onready var _animSprite = $AnimatedSprite


func _ready():
	_animSprite.frame = 0
	_animSprite.play("shrapnel")
	
func _on_AnimatedSprite_animation_finished():
	queue_free()
