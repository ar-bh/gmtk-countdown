class_name Player
extends CharacterBody2D

#region movement variables
@export var speed := 460.0
@export var ground_friction_factor := 10.0
#endregion

var frame_history: Array = []
var is_shooting: bool = false

func _physics_process(delta: float) -> void:
	#region movement
	var move_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering * ground_friction_factor * delta
	move_and_slide()
	#endregion
	
	is_shooting = Input.is_action_just_pressed("shoot")
	
	var frame_data = {
		"position": global_position,
		"rotation": global_rotation,
		"shot": is_shooting
	}
	frame_history.append(frame_data)
	
func reset_frame_history() -> void:
	frame_history = []
	
