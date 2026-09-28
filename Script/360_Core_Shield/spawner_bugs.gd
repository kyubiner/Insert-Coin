extends Node2D

@onready var timer: Timer = $"../Timer"
@onready var core: StaticBody2D = $"../Core"

const BUG =  preload("res://Scene/360_Core_Shield/bug.tscn")

func _ready() -> void:
	timer.start()
	randomize()

func _on_timer_timeout() -> void:
	var amount = 1
	if Global.score_360_core_shield >= 75:
		amount = 4
	elif Global.score_360_core_shield >= 50:
		amount = 3
	elif Global.score_360_core_shield >= 25:
		amount = 2
	else:
		amount = 1
	for i in amount:
		spawn_bugs(choose_bug())

func spawn_bugs(choose):
	var bug = BUG.instantiate()
	var screen_size = get_viewport_rect().size
	var margin = 100
	var side = randi() % 4
	var spawn_pos = Vector2()
	
	match side:
		0:
			spawn_pos = Vector2(randf() * screen_size.x, -margin)
		1:
			spawn_pos = Vector2(randf() * screen_size.x, screen_size.y + margin)
		2:
			spawn_pos = Vector2(-margin, randf() * screen_size.y)
		3:
			spawn_pos = Vector2(screen_size.x + margin, randf() * screen_size.y)
	
	bug.texture = bug.BUGS[choose].texture
	bug.speed = bug.BUGS[choose].speed
	bug.target = core
	bug.global_position = spawn_pos
	add_child(bug)

func choose_bug():
	var score = Global.score_360_core_shield
	var choose = []
	
	if score >= 75:
		choose = [1, 2, 3, 3, 3, 0]
	elif score >= 50:
		choose = [0, 1, 1, 2, 2, 3]
	elif score >= 25:
		choose = [0, 0, 1, 1, 2]
	else:
		choose = [0, 0, 0, 1]
	
	return choose.pick_random()
