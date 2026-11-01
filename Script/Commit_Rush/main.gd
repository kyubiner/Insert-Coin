extends Node2D

@export var win_target: float = 100.0     
@export var click_power: float = 5.0        
@export var decay_rate: float = 4.0          
@export var time_limit: float = 2.0          

var current_progress: float = 0.0
var required_key: String = ""
var is_active: bool = false

var available_keys: Array[String] = [
	"ui_left", 
	"ui_right", 
	"ui_accept", 
	"ui_up", 
	"ui_down"
]

@onready var timer: Timer = $QTETimer
@onready var label: Label = $LabelQTE
@onready var progress_bar: ProgressBar = $QTEProgressBar
@onready var timer_label: Label = $TimerLabel 

func _ready() -> void:
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
		
	progress_bar.min_value = 0
	progress_bar.max_value = win_target
	start_qte()

func start_qte() -> void:
	current_progress = 0.0
	progress_bar.value = current_progress
	is_active = true
	
	next_button_target()

func next_button_target() -> void:
	required_key = available_keys.pick_random()
	
	timer.start(time_limit)
	update_label_text()

func update_label_text() -> void:
	match required_key:
		"ui_left":
			label.text = "Push Button Left! (<-)"
		"ui_right":
			label.text = "Push Button Right! (->)"
		"ui_accept":
			label.text = "Push Enter / Space"
		"ui_up":
			label.text = "Push Button Up! (^)"
		"ui_down":
			label.text = "Push Button Down! (v)"

func _process(delta: float) -> void:
	if not is_active:
		return
	
	if timer_label and not timer.is_stopped():
		timer_label.text = "Timer: " + str(snapped(timer.time_left, 0.1)) + "s"
	
	if current_progress > 0:
		current_progress -= decay_rate * delta
		current_progress = clamp(current_progress, 0.0, win_target)
		progress_bar.value = current_progress

func _input(event: InputEvent) -> void:
	if not is_active:
		return
	
	if event.is_action_pressed(required_key):
		current_progress += click_power
		current_progress = clamp(current_progress, 0.0, win_target)
		progress_bar.value = current_progress
		
		if current_progress >= win_target:
			qte_win()
		else:
			next_button_target()
			
	elif is_any_qte_key_pressed(event):
		current_progress -= click_power

func is_any_qte_key_pressed(event: InputEvent) -> bool:
	for action in available_keys:
		if event.is_action_pressed(action):
			return true
	return false

func qte_win() -> void:
	Global.bg_mini_game = preload("uid://i2on6k57m4k1")
	Global.current_scene_mini_game = "res://Scene/Commit_Rush/main.tscn"
	Global.text_game_over = "[wave amp=50.0 freq=5.0 connected=1]You Win[/wave]"
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")

func qte_lose() -> void:
	Global.bg_mini_game = preload("uid://i2on6k57m4k1")
	Global.current_scene_mini_game = "res://Scene/Bug_Hunter/main.tscn"
	Global.text_game_over = "[shake rate=20.0 level=5 connected=1]You Lose[/shake]"
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")

func _on_timer_timeout() -> void:
	qte_lose()
