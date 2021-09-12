extends KinematicBody2D

var velocity = Vector2.ZERO
var time = 0
var freq = 2
var amplitude = 10

func _physics_process(delta):
	time = fmod((delta + time),  PI)
	velocity.y = cos(time*freq)*amplitude
	move_and_slide(velocity)
