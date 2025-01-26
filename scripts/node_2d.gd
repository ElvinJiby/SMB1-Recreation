extends Node2D

@export var goomba_scene: PackedScene  # Reference to the Goomba scene

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		spawn_goomba(event.position)

func spawn_goomba(position: Vector2) -> void:
	if goomba_scene:
		var goomba_instance = goomba_scene.instantiate()
		goomba_instance.position = position
		add_child(goomba_instance)
