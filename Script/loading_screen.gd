extends CanvasLayer

@onready var fade: Node2D = $Fade
@onready var progress_bar: ProgressBar = $Fade/ProgressBar

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func update_load_progress(progress: float) -> void:
	progress_bar.value = 100.0 * progress

func loading_complete() -> void:
	progress_bar.value = progress_bar.max_value
	var hide_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	hide_tween.tween_interval(0.2)
	hide_tween.tween_property(fade, "modulate:a", 0.0, 0.15)
	
	hide_tween.tween_callback(queue_free)
