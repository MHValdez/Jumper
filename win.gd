extends Node2D

const QUIT_TIME = 2
var quit_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Damage.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	add_child(quit_timer)
	quit_timer.one_shot = true
	quit_timer.autostart = false
	quit_timer.wait_time = QUIT_TIME
	
	if Input.is_action_just_pressed("jump"):
		quit_timer.set_paused(false)
		quit_timer.start()
		
	if Input.is_action_just_released("jump"):
		quit_timer.set_paused(true)
		
		if get_tree().current_scene.name != "level":
			get_tree().change_scene_to_file("res://level.tscn")
	
	if quit_timer.get_time_left() == 0.0:
		get_tree().quit()
