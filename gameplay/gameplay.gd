extends Node2D

#region node variables
@onready var player: Player = %Player

@onready var loop_timer: Timer = %LoopTimer
@onready var loop_label: RichTextLabel = %LoopLabel
@onready var loop_progress_bar: ProgressBar = %LoopProgressBar
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loop_timer.timeout.connect(_on_loop_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loop_label.text = "[center]Time until next wave/clone: " + str(int(ceil(loop_timer.time_left))) + "s[/center]"
	loop_progress_bar.value = (loop_timer.time_left / loop_timer.wait_time) * 100.0

func _on_loop_timer_timeout() -> void:
	player.reset_frame_history()
