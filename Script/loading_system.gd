extends Node

signal loading_progress(progress_amount: float)
signal scene_loaded

var loading_screen_scene: PackedScene = preload("uid://b8hcdg73cx168")
var scene_being_loaded: String
var progress: Array[float]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(false)

func load_scene(scene_to_load: String) -> void:
	get_tree().paused = true
	var new_loading_screen = loading_screen_scene.instantiate()
	
	loading_progress.connect(new_loading_screen.update_load_progress)
	scene_loaded.connect(new_loading_screen.loading_complete)
	
	get_tree().get_root().add_child(new_loading_screen)
	
	scene_being_loaded = scene_to_load
	ResourceLoader.load_threaded_request(scene_to_load, "", true)
	set_process(true)

func _process(_delta: float) -> void:
	var loading_state = ResourceLoader.load_threaded_get_status(scene_being_loaded, progress)
	
	match loading_state:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loading_progress.emit(progress[0]) 
		ResourceLoader.THREAD_LOAD_LOADED:
			scene_loaded.emit() 
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_being_loaded))
			get_tree().paused = false
			set_process(false)
