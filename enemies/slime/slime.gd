class_name BasicEnemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hitbox: CollisionShape2D = %HitBox

var player = null

@export var speed := 100.0

func _ready() -> void:
	animation_player.play("walk")

	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		
		move_and_slide()


func play_walk():
	animation_player.play("walk")


func play_hurt():
	animation_player.play("hurt")
	animation_player.queue("walk")
