extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rich_text_label: RichTextLabel = $RichTextLabel

var scene: String = Global.current_scene_mini_game

func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file(scene)

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.

func _ready() -> void:
	sprite_2d.texture = Global.bg_mini_game
	rich_text_label.text = Global.text_game_over
	Global.score_360_core_shield = 0
	Global.score_github_breaker = 0
