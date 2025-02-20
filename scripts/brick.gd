extends StaticBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_area: Area2D = $HitArea

var original_position: Vector2

func _ready() -> void:
	original_position = global_position

func _on_hit_area_area_entered(area: Area2D) -> void:
	hit_area.set_collision_layer_value(1, false)

	var b_tween = get_tree().create_tween()
	b_tween.tween_property(self, "global_position", global_position + Vector2(0,-30), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	b_tween.tween_property(self, "global_position", original_position, 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await b_tween.finished
