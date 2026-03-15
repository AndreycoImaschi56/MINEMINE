extends Area2D

const health_effect: int = 20

@onready var collect: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	body.heal(health_effect)
	
	collision_shape_2d.set_deferred("disabled", true)
	visible = false
	collect.play()
	await collect.finished
	queue_free()
