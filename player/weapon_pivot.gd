extends Node2D


func _physics_process(delta: float) -> void:
	var direction_to_mouse = global_position.direction_to(get_global_mouse_position())
	rotation = direction_to_mouse.angle()
