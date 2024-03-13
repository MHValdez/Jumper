extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_door_player_entered(body):
	if body == $Player:
		get_tree().change_scene_to_file("res://game_over.tscn")


func _on_spikes_body_entered(body):
	if body == $Player:
		get_tree().change_scene_to_file("res://game_over.tscn")
