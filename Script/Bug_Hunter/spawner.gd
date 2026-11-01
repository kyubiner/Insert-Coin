extends Node2D

@export var virus_scene: PackedScene
@onready var virus_timer: Timer = $"../VirusTimer"
@onready var path_virus_2d: PathFollow2D = $"../Path2D/PathVirus2D"
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	virus_timer.start()

func _on_timer_timeout() -> void:
	var amount = 1
	if Global.score_bug_hunter >= 75:
		amount = 16
	elif Global.score_bug_hunter >= 50:
		amount = 8
	elif Global.score_bug_hunter >= 25:
		amount = 4
	else:
		amount = 2
	for i in amount:
		spawn_virus(choose_virus())

func spawn_virus(choose: String) -> void:
	var virus = virus_scene.instantiate()
	path_virus_2d.progress_ratio = randf()
	var spawn_position = path_virus_2d.global_position
	var direction = path_virus_2d.global_rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	var movement_direction = Vector2.RIGHT.rotated(direction)
	var movement_speed = randf_range(150.0, 250.0)
	
	virus.anim = choose
	
	add_child(virus)
	virus.global_position = spawn_position
	virus.rotation = direction
	
	virus.setup(
		choose,
		movement_direction,
		movement_speed
	)

func choose_virus() -> String:
	var score = Global.score_bug_hunter
	var choose: Array[String] = []

	if score >= 75:
		choose = [
			"healty",
			"corrupt",
			"corrupt",
			"corrupt",
			"golden"
		]

	elif score >= 50:
		choose = [
			"healty",
			"corrupt",
			"healty",
			"corrupt",
			"golden"
		]

	elif score >= 25:
		choose = [
			"healty",
			"healty",
			"corrupt"
		]

	else:
		choose = [
			"healty",
			"healty",
			"corrupt",
			"healty"
		]
	return choose.pick_random()
