extends Control

@onready var menu: Control = $"."
var OptionsMenu = "res://Scenes/OptionsMenu.tscn"
var GameEnvironment = "res://Scenes/water_world.tscn"

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(GameEnvironment)

func _on_options_pressed() -> void:
	queue_free()
	#get_tree().change_scene_to_file(OptionsMenu)
	
func _on_quit_pressed() -> void:
	get_tree().quit()
