extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export  var anim : String
@export var speed: float = 120.0
@export var corruption_damage: float = 20.0
@export var healty_damage: float = -5.0
@export var golden_damage: float = -20.0
var direction: Vector2 = Vector2.ZERO
var already_hit := false

func setup(anim: String, move_direction: Vector2, move_speed: float):
	animated_sprite_2d.play(anim)
	direction = move_direction.normalized()
	speed = move_speed

func _physics_process(delta: float) -> void:
	if already_hit:
		return

	velocity = direction * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("player"):
			hit_player()
			break


func hit_player() -> void:
	if already_hit:
		return
	Global.score_bug_hunter += 1
	already_hit = true

	if anim == "corrupt":
		Global.score_bug_hunter -= 1
		get_tree().call_group(
			"bug_hunter",
			"add_corruption",
			corruption_damage
		)
		
	if anim == "healty":
		get_tree().call_group(
			"bug_hunter",
			"add_corruption",
			healty_damage
		)
		
	if anim == "golden":
		get_tree().call_group(
			"bug_hunter",
			"add_corruption",
			golden_damage
		)

	queue_free()
