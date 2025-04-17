extends Control



func _on_volume_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	queue_free()
	#get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
