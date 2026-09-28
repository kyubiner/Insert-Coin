extends Control

@onready var github_breaker: TextureButton = $TextureButton2
@onready var core_shield: TextureButton = $TextureButton

func _on_github_breaker_pressed() -> void:
	LoadingSystem.load_scene("res://Scene/360_Core_Shield/main.tscn")

func _on_core_shield_pressed() -> void:
	LoadingSystem.load_scene("res://Scene/Github_Breaker/main.tscn")
