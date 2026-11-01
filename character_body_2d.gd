extends CharacterBody2D

@export var speed: float = 250.0

func _physics_process(_delta):
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)
	velocity = direction * speed
	move_and_slide()
	var screen_size = get_viewport_rect().size
	global_position.x = clampf(global_position.x, 20.0, screen_size.x - 20.0)
	global_position.y = clampf(global_position.y, 20.0, screen_size.y - 20.0)
