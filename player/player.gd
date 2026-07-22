class_name Player
extends CharacterBody2D

#region movement variables
@export var speed := 460.0
@export var ground_friction_factor := 10.0
#endregion

func _physics_process(delta: float) -> void:
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering * ground_friction_factor * delta
	move_and_slide()
