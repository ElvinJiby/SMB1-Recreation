extends Node2D

@export var mute: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not mute:
		play_music()
		
func play_music():
	if not mute:
		$OverworldTheme.play()
		
func play_jump():
	if not mute:
		$Jump.play()
		
func play_doublejump():
	if not mute:
		$DoubleJump.play()

func play_starman_bling():
	if not mute:
		$StarmanPickup.play()

func play_invincibility():
	if not mute:
		$Invincibility.play()
		
func play_starman_warning():
	if not mute:
		$StarmanWarning.play()
		
func play_enemydie():
	if not mute:
		$EnemyDie.play()
		
func play_pipe():
	if not mute:
		$Pipe.play()

func stop_all():
	$Invincibility.stop()
	$OverworldTheme.stop()
	$Jump.stop()
	$EnemyDie.stop()
