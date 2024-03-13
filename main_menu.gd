extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://level.tscn")

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()