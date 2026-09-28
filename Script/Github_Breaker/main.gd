extends Node2D

@onready var Blocks = preload("res://Scene/Github_Breaker/block.tscn")
@onready var http_request: HTTPRequest = $HTTPRequest

var username = "kyubiner"
var api_url = "https://github-contributions-api.jogruber.de/v4/" + username + "?y=2026"
var dragging = false
var drag_position = Vector2i()

func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	get_window().size = Vector2i(768, 432)
	get_window().transparent = true
	get_window().transparent_bg = true
	
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(api_url)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_position = DisplayServer.mouse_get_position() - DisplayServer.window_get_position()
		else:
			dragging = false
	if event is InputEventMouseMotion and dragging:
		DisplayServer.window_set_position(DisplayServer.mouse_get_position() - drag_position)

func _on_request_completed(result, response_code, header, body):
	if response_code == 200:
		var json = JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		
		if error == OK:
			var data = json.get_data()
			_generate_grid_from_github(data)

func _generate_grid_from_github(data):
	var contributions = data["contributions"]
	var current_month_contributions = []
	
	var date_dict = Time.get_datetime_dict_from_system()
	var target_year = date_dict.year
	var  target_month = date_dict.month
	for daily_data in contributions:
		var date_str = daily_data["date"]
		var parts = date_str.split("-")
		if parts.size() == 3:
			var data_year = int(parts[0])
			var data_month = int(parts[1])
			if data_year == target_year and data_month == target_month:
				current_month_contributions.append(daily_data)
	
	var day_index = 0
	var start_x = 85
	var start_y = 30
	var margin = 60
	
	for col in range(11):
		for row in range(3):
			if day_index >= current_month_contributions.size():
				break
			var daily_data = current_month_contributions[day_index]
			var level_contribution =  int(daily_data["level"])
			var newBlock = Blocks.instantiate()
			add_child(newBlock)
			newBlock.position = Vector2(start_x + (margin * col), start_y + (margin * row))
			if newBlock.has_method("set_hp"):
				newBlock.set_hp(level_contribution)
			day_index += 1

func _on_death_zone_body_entered(body: Node2D) -> void:
	Global.bg_mini_game = preload("uid://i2on6k57m4k1")
	Global.current_scene_mini_game = "res://Scene/Github_Breaker/main.tscn"
	Global.text_game_over = "[shake rate=20.0 level=5 connected=1]You Lose[/shake]"
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")

func _process(delta: float) -> void:
	if Global.score_github_breaker == Time.get_datetime_dict_from_system().month:
		Global.bg_mini_game = preload("uid://i2on6k57m4k1")
		Global.current_scene_mini_game = "res://Scene/Github_Breaker/main.tscn"
		Global.text_game_over = "[wave amp=50.0 freq=5.0 connected=1]You Win[/wave]"
		get_tree().change_scene_to_file("res://Scene/game_over.tscn")
