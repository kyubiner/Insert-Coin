extends Control

@onready var texture_button_4: TextureButton = $HBoxContainer/TextureButton4
@onready var texture_button_3: TextureButton = $HBoxContainer/TextureButton3
@onready var texture_button_2: TextureButton = $HBoxContainer/TextureButton2
@onready var texture_button: TextureButton = $HBoxContainer/TextureButton

func _on_github_breaker_pressed() -> void:
	LoadingSystem.load_scene("res://Scene/Github_Breaker/main.tscn")

func _on_core_shield_pressed() -> void:
	LoadingSystem.load_scene("res://Scene/360_Core_Shield/main.tscn")

func _on_bug_hunter_pressed() -> void:
	LoadingSystem.load_scene("res://Scene/Bug_Hunter/main.tscn")

func _on_commit_rush_pressed() -> void:
	LoadingSystem.load_scene("res://Scene/Commit_Rush/main.tscn")
