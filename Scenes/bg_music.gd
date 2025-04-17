extends Node2D
var MainMenu = load("res://Scenes/MainMenu.tscn")
var OptionsMenu = load("res://Scenes/OptionsMenu.tscn")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(MainMenu.instantiate())

# Checks to see which node is removed from the tree
func _on_child_exiting_tree(node: Node) -> void:
	if node.has_method("_on_quit_pressed"):
		add_child.call_deferred(OptionsMenu.instantiate())
		
	elif node.has_method("_on_back_pressed"):
		add_child.call_deferred(MainMenu.instantiate())
		
