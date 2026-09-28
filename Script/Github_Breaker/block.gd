extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var hp
var next
var is_destroyed

func hit():
	if is_destroyed:
		return
	
	set_hp(next)

func death():
	set_binary()
	is_destroyed = true
	collision_shape_2d.set_deferred("disabled", true)

func set_hp(level: int):
	match  level:
		0:
			hp =  5
			next = 1
			sprite_2d.modulate = Color("#11161d")
		1:
			hp = 4
			next = 2
			sprite_2d.modulate = Color("#082516")
		2:
			hp = 3
			next = 3
			sprite_2d.modulate = Color("#133e22")
		3:
			hp = 2
			next = 4
			sprite_2d.modulate = Color("#1d582d")
		4:
			hp = 1
			next = 5
			sprite_2d.modulate = Color("#31723d")
			Global.score_github_breaker += 1
		5:
			death()

func set_binary():
	var label = Label.new()
	label.text = str(randi() % 2)
	label.add_theme_color_override("font color", Color("#31723d"))
	label.global_position = self.global_position
	get_tree().current_scene.add_child(label)
	
	var tween = get_tree().create_tween()
	var random_x = randf_range(-30, 30)
	tween.tween_property(label, "position", label.position + Vector2(random_x, -60), 0.5).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label,  "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
