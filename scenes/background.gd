extends Node2D

var speed: int = 700

func _process(_delta: float) -> void:
	if position.x <= -1600:
		position.x = 0
