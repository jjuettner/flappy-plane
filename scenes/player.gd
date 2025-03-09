extends RigidBody2D

var impulse_force: int = 1500

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		apply_central_impulse(Vector2(0,-1) * impulse_force)
	$Particles.position = Vector2(position.x - 50, position.y-15)
