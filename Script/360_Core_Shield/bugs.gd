extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
const BUGS = [
	{
		'id' : 1,
		'texture' : preload("uid://c0fbypdifes5u"),
		'speed' : 50,
	},
	{
		'id' : 2,
		'texture' : preload("uid://cnfxigid3iur1"),
		'speed' : 100,
	},
	{
		'id' : 3,
		'texture' : preload("uid://qbwjkkrevdpd"),
		'speed' : 150,
	},
	{
		'id' : 4,
		'texture' : preload("uid://bdcg0sdos7jsc"),
		'speed' : 200,
	}
]

var texture
@export var speed: float
@onready var target: Node2D

func _ready() -> void:
	sprite_2d.texture = texture

func _physics_process(delta: float) -> void:
	if target:
		var direction = (target.position - global_position).normalized()
		var collision = move_and_collide(direction * speed * delta)
		look_at(target.position)
		if collision:
			var hit_collide = collision.get_collider()
			if hit_collide.name == "Shield":
				if hit_collide.has_method("grow_shield"):
					hit_collide.grow_shield(2.0)
					Global.score_360_core_shield += 1
				queue_free()
			if hit_collide.name == "Core":
				Global.bg_mini_game = preload("uid://0n42r7yaseu0")
				Global.current_scene_mini_game = "res://Scene/360_Core_Shield/main.tscn"
				Global.text_game_over = "[shake rate=20.0 level=5 connected=1]You Lose[/shake]"
				get_tree().change_scene_to_file("res://Scene/game_over.tscn")
