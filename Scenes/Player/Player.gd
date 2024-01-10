class_name Player
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer


@export var SPEED : float = 430
@export var JUMP_VELOCITY : float = -400
@export var ACCELERATION : float = 1_300
@export var MAX_DOUBLE_JUMPS : int = 1


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var airJumpCount : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var dialogue_begin = 0 #dialogue has not commenced
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
	
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0 && dialogue_begin == 0:
		dialogue_begin = 1
		actionables[0].action()
	elif actionables.size() <= 0:
		dialogue_begin = 0 #run this when outside of dialogue
		
		#DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
		#return
		
	
	gravity_handle(delta)
	
	if is_on_floor():
		airJumpCount = 0
	
	# Handle jump.
	var jumpPress = Input.is_action_just_pressed("ui_accept")
	jump_handle(jumpPress)
	# inputs jump for buffered amount of time
	if jump_buffer_timer.time_left > 0:
		jump_handle(true)
	
	var inputDir = Input.get_axis("ui_left", "ui_right")
	movement_handle(delta, inputDir)
	friction_handle(delta, inputDir)
	
	# For coyote timer
	var wasOnFloor = is_on_floor()
	
	move_and_slide()
	
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
			velocity.x = move_toward(velocity.x, 0, ACCELERATION/3 *delta)


# For when we add animations
#func update_animations(inputDir):
	#if inputDir:
		#if is_on_floor():
			#animated_sprite_2d.flip_h = (inputDir < 0)
		#animated_sprite_2d.play("run")
	#else:
		#animated_sprite_2d.play("idle")
	#
	#if velocity.y < 0:
		#animated_sprite_2d.play("jump")
	#elif velocity.y >0:
		#animated_sprite_2d.play("fall")


