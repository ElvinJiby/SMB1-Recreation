extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $DeathTimer
@onready var kill_area: Area2D = $Area2D


var SPEED: float = 300.0
var direction: int = -1	# 1 for right, -1 for left
var isDead: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not isDead:
		anim.play("walk")
		velocity.x = direction * SPEED
		
		if is_on_wall():
			direction *= -1
			velocity.x = direction * SPEED
		
		anim.flip_h = direction < 0

		move_and_slide()
	
	if Input.is_action_just_pressed("KillGoomba"):
		die()

func die():
	velocity = Vector2()
	isDead = true
	anim.play("die")
	AudioController.play_enemydie()
	set_collision_layer_value(1,false)
	kill_area.monitoring = false
	death_timer.start(1)
	print(get_global_mouse_position())

func _on_death_timer_timeout():
	queue_free()
	
func _on_kill_area_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Mario":
		var mario = body as CharacterBody2D
		if not isDead:
			die()
			if Input.is_action_pressed("Jump"):
				mario.velocity.y = -1000
			else:
				mario.velocity.y = -700
		print("Mario hit the goomba")
