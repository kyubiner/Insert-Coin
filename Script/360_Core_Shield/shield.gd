extends CharacterBody2D

@onready var line_2d: Line2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

const MAX_ANGLE = 360
const ROTATION_SPEED = 5.0

var current_angle = 90
var outer_radius = 120
var inner_radius = 100

func _ready() -> void:
	update_shield_shape()

func _process(delta: float) -> void:
	var rotate: float
	if Input.is_action_pressed("ui_right"):
		rotate -= 1
	elif Input.is_action_pressed("ui_left"):
		rotate += 1
	rotation += rotate * delta * ROTATION_SPEED

func grow_shield(plus_degree):
	if current_angle < MAX_ANGLE:
		current_angle += plus_degree
		
		if current_angle >= MAX_ANGLE:
			current_angle = MAX_ANGLE
			win_game()
		
		update_shield_shape()

func update_shield_shape():
	var collision_points = PackedVector2Array()
	var line_points = PackedVector2Array()
	var segments = max(10, int(current_angle / 3.0))
	var start_angle = deg_to_rad(-current_angle / 2.0)
	var end_angle = deg_to_rad(current_angle / 2.0)
	var midle_radius = (outer_radius + inner_radius) / 2.0
	
	for i in range(segments + 1):
		var t = i / float(segments)
		var angle = lerp(start_angle, end_angle, t)
		
		line_points.append(Vector2(cos(angle), sin(angle)) * midle_radius)
		collision_points.append(Vector2(cos(angle), sin(angle))  * outer_radius)
	
	for i in range(segments, -1, -1):
		var t = i / float(segments)
		var angle = lerp(start_angle, end_angle, t)
		collision_points.append(Vector2(cos(angle), sin(angle)) * inner_radius)
	
	line_2d.points = line_points
	collision_polygon_2d.polygon = collision_points

func win_game():
	Global.bg_mini_game = preload("uid://0n42r7yaseu0")
	Global.current_scene_mini_game = "res://Scene/360_Core_Shield/main.tscn"
	Global.text_game_over = "[wave amp=50.0 freq=5.0 connected=1]You Win[/wave]"
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")
