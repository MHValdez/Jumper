extends CharacterBody2D


const SPEED = 300.0
const FRICTION = 0.02
const DASH_VELOCITY = 3000.0
const JUMP_VELOCITY = -500.0
const DOUBLE_JUMP_VELOCITY = -500.0
const GRIP_TIME = 0.2
const CHARGE_TIME = 0.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dashing = false
var jumping = false
var has_double_jump = true
var direction = 0
var charge = Timer.new()
var grip = Timer.new()


func _physics_process(delta):
	# Timers for dash charge and wall grip
	for timer in [charge, grip]:
		add_child(timer)
		timer.one_shot = true
		timer.autostart = false
	
	charge.wait_time = CHARGE_TIME
	grip.wait_time = GRIP_TIME
	
	if is_on_floor():
		$AnimatedSprite2D.set_rotation(0)
		$AnimatedSprite2D.play("idle")
	
	if is_on_wall():
		direction = get_wall_normal()[0]
		$AnimatedSprite2D.set_rotation(direction * PI/2.0)
		
		# Can jump or dash
		if jumping:
			# Just landed
			grip.start()
			charge.paused = false
		
		jumping = false
		dashing = false
		has_double_jump = true
		
		if grip.get_time_left() > 0:
			# Grip wall after landing
			velocity.y = 0
			$AnimatedSprite2D.play("jump")
		else:
			# Slide dpwn at constant speed
			velocity.y = gravity * FRICTION
			$AnimatedSprite2D.play("idle")
	else:
		if dashing:
			# Continue dash
			velocity.x = direction * DASH_VELOCITY
		else:
			# Continue jump
			velocity.x = direction * SPEED
			velocity.y += gravity * delta
	
	if is_on_wall():
		direction = get_wall_normal()[0]
		$AnimatedSprite2D.set_rotation(direction * PI/2.0)
		
		if Input.is_action_just_pressed("jump"):
			# Begin dash charge
			charge.start()
		
		if Input.is_action_pressed("jump"):
			$AnimatedSprite2D.play("charge")
		
		if Input.is_action_just_released("jump"):
			# Jump away from wall
			charge.paused = true
	
			if charge.get_time_left() > 0.0:
				# Initiate regular jump away from wall
				velocity.x = direction * SPEED
				velocity.y = JUMP_VELOCITY
				jumping = true
			else:
				# Initate dash away from wall
				velocity.x = direction * DASH_VELOCITY
				dashing = true      
	else:
		if Input.is_action_just_pressed("jump"):
			if not dashing and has_double_jump:
				# Peform single double jump per regular jump
				has_double_jump = false
				velocity.x = direction * SPEED
				velocity.y = DOUBLE_JUMP_VELOCITY
		
		$AnimatedSprite2D.play("jump")

	move_and_slide()
