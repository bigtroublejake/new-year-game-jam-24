class_name Player
extends CharacterBody2D



@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var dialogue_timeout_timer = $DialogueTimeoutTimer
@onready var gpu_particles_2d = $GPUParticles2D

@onready var actionable_finder: Area2D = $ActionableFinder

var SPEED = 430.0
var JUMP_VELOCITY = -400.0
var ACCELERATION = 3_300.0
var MAX_DOUBLE_JUMPS = 1
var PARTICLE_POS : Vector2


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var airJumpCount : int
var has_weapon = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PARTICLE_POS = abs(gpu_particles_2d.position)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#_dialogue_handle()
	
	gravity_handle(delta)
	if is_on_floor():
		airJumpCount = 0
	
	var attackPress = Input.is_action_just_pressed("player_attack")
	_attack(attackPress)
	
	# Handle jump.
	var jumpPress = Input.is_action_just_pressed("ui_accept")
	jump_handle(jumpPress)
	# inputs jump for buffered amount of time
	if jump_buffer_timer.time_left > 0:
		jump_handle(true)
	
	var inputDir = Input.get_axis("ui_left", "ui_right")
	if _dialogue_handle() == false:
		movement_handle(delta, inputDir)
	else:
		velocity.x = move_toward(velocity.x, 0, 1_000 * delta)
	
	friction_handle(delta, inputDir)
	
	# For coyote timer
	var wasOnFloor = is_on_floor()
	
	move_and_slide()
	update_animations(inputDir)
	
	# Also for coyote timer
	var jusLeftLedge = wasOnFloor and not is_on_floor() and velocity.y >= 0
	if jusLeftLedge:
		coyote_jump_timer.start()




func gravity_handle(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func jump_handle(jumpPress):
	if jumpPress:
		if is_on_floor() or coyote_jump_timer.time_left > 0.0:
			velocity.y = JUMP_VELOCITY
			# resets jump buffer timer
			jump_buffer_timer.stop()
		elif airJumpCount < MAX_DOUBLE_JUMPS:
			velocity.y = JUMP_VELOCITY
			airJumpCount += 1
		elif airJumpCount >= MAX_DOUBLE_JUMPS and !is_on_floor():
			#starts jump buffer timer
			if jump_buffer_timer.time_left == 0:
				jump_buffer_timer.start()


func movement_handle(delta, inputDir):
	if inputDir:
		velocity.x = move_toward(velocity.x, inputDir*SPEED, ACCELERATION*delta)


func friction_handle(delta, inputDir):
	if inputDir == 0:
		if not is_on_floor():
			#air friction
			velocity.x = move_toward(velocity.x, 0, ACCELERATION/15 *delta)
		else:
			#floor friction
			velocity.x = move_toward(velocity.x, 0, ACCELERATION/2 *delta)


func _dialogue_handle():
	var dialogue_begin = 0 #dialogue has not commenced
	var actionables = actionable_finder.get_overlapping_areas()
	if Input.is_action_just_pressed("interact"):
		if actionables.size() > 0 and dialogue_begin == 0 and dialogue_timeout_timer.time_left == 0:
			dialogue_begin = 1
			actionables[0].dialogue()
			dialogue_timeout_timer.start()
		elif actionables.size() <= 0:
			dialogue_begin = 0 #run this when outside of dialogue
			
			#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
			#return
	#var is_balloon out = 
	if $"..".has_node("ExampleBalloon") == true:
		return true
	else:
		return false


func _take_damage():
	print("dead")


#For power up effect
func _power_up():
		SPEED = SPEED*2
		$power_timer.start()


func _on_power_timer_timeout():
	SPEED = SPEED/2


func _weapon_pickup():
	has_weapon = true



func _attack(attackPress):
	if has_weapon == true:
		if attackPress == true and attack_finish == true:
			print("attack")
			animated_sprite_2d.play("attack")
			gpu_particles_2d.emitting = false
			gpu_particles_2d.emitting = true
			attack_finish = false

# For when we add animations
var attack_finish : bool = true
func update_animations(inputDir):
	if inputDir and attack_finish == true:
		if is_on_floor():
			animated_sprite_2d.flip_h = (inputDir > 0)
		animated_sprite_2d.play("run")
	elif attack_finish == true:
		animated_sprite_2d.play("idle")
	
	if inputDir:
		gpu_particles_2d.position.x = PARTICLE_POS.x * inputDir
	
	#if velocity.y < 0:
		#animated_sprite_2d.play("jump")
	#elif velocity.y >0:
		#animated_sprite_2d.play("fall")


func _on_animated_sprite_2d_animation_looped():
	if attack_finish == false:
		print("anim looped")
		attack_finish = true
		animated_sprite_2d.play("idle")
