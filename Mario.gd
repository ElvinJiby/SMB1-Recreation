extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var WALK_SPEED: float = 300
@export var RUN_SPEED: float = 700
@export var ACCELERATION: float = 800
@export var DECELERATION: float = 1600
@export var INVINCIBLE_RUN_SPEED: float = 900
@export var INVINCIBLE_ACCELERATION: float = 900

@export var NORMAL_JUMP_VELOCITY: float = -1300
@export var RUN_JUMP_VELOCITY: float = -1500
@export var JUMP_CUTOFF: float = 0.5
@export var DOUBLE_JUMP_VELOCITY: float = -1000

var can_double_jump: bool = true
var is_invincible: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var isRunning: bool = Input.is_action_pressed("Run")
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		AudioController.play_jump()
		if abs(velocity.x) > 600:
			velocity.y = RUN_JUMP_VELOCITY
		else:
			velocity.y = NORMAL_JUMP_VELOCITY
	if Input.is_action_just_pressed("Jump") and not is_on_floor() and can_double_jump:
		velocity.y = DOUBLE_JUMP_VELOCITY
		AudioController.play_doublejump()
		can_double_jump = false
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y *= JUMP_CUTOFF
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("Left", "Right")
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
	
	var target_speed: float = 0.0
	if direction != 0:
		if isRunning:
			if is_invincible:
				target_speed = direction * INVINCIBLE_RUN_SPEED
			else:
				target_speed = direction * RUN_SPEED
		else:
			target_speed = direction * WALK_SPEED

	# Accelerate towards the target speed.
	if target_speed != 0:
		if is_invincible:
			velocity.x = move_toward(velocity.x, target_speed, INVINCIBLE_ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, target_speed, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	
	# Animation State Handling
	if velocity.x == 0 and is_on_floor(): # if idle
		if anim.animation != "idle":
			anim.play("idle")
	elif velocity.x != 0 and is_on_floor(): # walking/running
		if anim.animation != "walk":
			anim.play("walk")
		if isRunning:
			anim.speed_scale = RUN_SPEED / WALK_SPEED
		else:
			anim.speed_scale = 1.0
	elif velocity.y != 0 and not is_on_floor(): # in the air
		if anim.animation != "jump":
			anim.play("jump")
	
	if Input.is_action_just_pressed("Respawn"):
		position.x = 698
		position.y = 830
		velocity = Vector2()
		
	if Input.is_action_just_pressed("Invincible"):
		if not is_invincible:
			is_invincible = true
			set_collision_layer_value(1, false)
			anim.material = preload("res://StarmanShader.tres")
			AudioController.stop_all()
			AudioController.play_invincibility()
			
			await get_tree().create_timer(11.0).timeout
			
			set_collision_layer_value(1, true)
			anim.material = null
			AudioController.stop_all()
			AudioController.play_music()
			is_invincible = false
		
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_invincible:
		if body is CharacterBody2D:
			print("collision with goomba")
			var goomba = body as CharacterBody2D
			goomba.die()