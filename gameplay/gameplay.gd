extends Node2D

const SLIME_SCENE := preload("res://enemies/slime/slime.tscn")
const PINE_TREE_TEXTURE := preload("res://map/pine_tree.png")

@export var slimes_per_wave: Array[int] = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45]
@export var win_wave: int = 10
@export var tree_count: int = 70
@export var tree_spawn_radius: float = 1800.0
@export var slime_spawn_min_distance: float = 350.0
@export var slime_spawn_max_distance: float = 700.0

@onready var player: Player = %Player
@onready var enemies: Node2D = %Enemies
@onready var map: Node2D = %Map
@onready var wave_label: RichTextLabel = %LoopLabel
@onready var wave_progress_bar: ProgressBar = %LoopProgressBar
@onready var end_screen: Control = %EndScreen
@onready var end_label: Label = %EndLabel
@onready var play_again_button: Button = %PlayAgainButton

var current_wave := 0
var slimes_alive := 0
var slimes_in_wave := 0
var game_over := false
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	play_again_button.pressed.connect(_on_play_again_pressed)
	player.touched_by_enemy.connect(_trigger_lose)
	end_screen.hide()
	_spawn_trees()
	_start_wave(1)


func _process(_delta: float) -> void:
	if game_over:
		return
	_update_ui()


func _start_wave(wave: int) -> void:
	current_wave = wave
	var index := mini(wave - 1, slimes_per_wave.size() - 1)
	slimes_in_wave = slimes_per_wave[index]
	slimes_alive = 0

	player.hurtbox.monitoring = false
	for i in slimes_in_wave:
		_spawn_slime()
	player.hurtbox.monitoring = true

	_update_ui()


func _spawn_slime() -> void:
	var slime: BasicEnemy = SLIME_SCENE.instantiate()
	var spawn_pos := _random_spawn_position()
	slime.position = enemies.to_local(spawn_pos)
	enemies.add_child(slime)
	slime.died.connect(_on_slime_died)
	slimes_alive += 1


func _random_spawn_position() -> Vector2:
	for _attempt in 20:
		var angle := _rng.randf_range(0.0, TAU)
		var distance := _rng.randf_range(slime_spawn_min_distance, slime_spawn_max_distance)
		var pos := player.global_position + Vector2.from_angle(angle) * distance
		if pos.distance_to(player.global_position) >= slime_spawn_min_distance:
			return pos

	return player.global_position + Vector2(slime_spawn_max_distance, 0.0)


func _spawn_trees() -> void:
	for i in tree_count:
		var tree := Sprite2D.new()
		tree.texture = PINE_TREE_TEXTURE
		var angle := _rng.randf_range(0.0, TAU)
		var distance := _rng.randf_range(120.0, tree_spawn_radius)
		tree.position = Vector2.from_angle(angle) * distance
		map.add_child(tree)


func _on_slime_died() -> void:
	if game_over:
		return

	slimes_alive -= 1
	if slimes_alive <= 0:
		if current_wave >= win_wave:
			_trigger_win()
		else:
			_start_wave(current_wave + 1)


func _trigger_win() -> void:
	game_over = true
	end_label.text = "You Win!"
	end_screen.show()
	_set_gameplay_active(false)


func _trigger_lose() -> void:
	if game_over:
		return

	game_over = true
	end_label.text = "You Lose!"
	end_screen.show()
	_set_gameplay_active(false)


func _set_gameplay_active(active: bool) -> void:
	if active:
		player.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		player.process_mode = Node.PROCESS_MODE_DISABLED

	for child in enemies.get_children():
		child.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED


func _update_ui() -> void:
	wave_label.text = "[center]Wave %d — %d slimes left[/center]" % [current_wave, slimes_alive]
	if slimes_in_wave > 0:
		wave_progress_bar.value = (1.0 - float(slimes_alive) / slimes_in_wave) * 100.0
	else:
		wave_progress_bar.value = 100.0


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
