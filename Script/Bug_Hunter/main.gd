extends Node2D

var corruption: float = 0.0
var max_corruption: float = 100.0

@onready var corruption_overlay: ColorRect = $CanvasLayer/CorruptionOverlay
@onready var timer: Timer = $Timer
@onready var label: Label = $Label
var time: float

func _ready() -> void:
	add_to_group("bug_hunter")

func _process(delta: float) -> void:
	if time < 300:
		time += delta

	label.text = str(int(max(300 - time, 0)))

func add_corruption(amount: float) -> void:
	corruption = clampf(
		corruption + amount,
		0.0,
		max_corruption
	)
	update_corruption()
	if corruption >= max_corruption:
		game_over()

func update_corruption() -> void:
	var darkness = (corruption / max_corruption) * 0.8
	var tween = create_tween()
	tween.tween_property(
		corruption_overlay,
		"color",
		Color(0, 0, 0, darkness),
		0.3
	)

func game_over() -> void:
	Global.bg_mini_game = preload("uid://0n42r7yaseu0")
	Global.current_scene_mini_game = "res://Scene/Bug_Hunter/main.tscn"
	Global.text_game_over = "[shake rate=20.0 level=5 connected=1]You Lose[/shake]"
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")

func _on_timer_timeout() -> void:
	Global.bg_mini_game = preload("uid://0n42r7yaseu0")
	Global.current_scene_mini_game = "res://Scene/Bug_Hunter/main.tscn"
	Global.text_game_over = "[wave amp=50.0 freq=5.0 connected=1]You Win[/wave]"
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")
