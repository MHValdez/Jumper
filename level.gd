extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
