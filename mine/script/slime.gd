extends CharacterBody2D


const SPEED = 40.0
const KNOKBACK_FORCE: int = 50

var healt: int = 100
var target = null
var is_alive: bool = true

@onready var hit: AudioStreamPlayer2D = $hit
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar: Node2D = $Healthbar



func _physics_process(delta: float) -> void:
	if target and is_alive:
		_attack(delta)

	move_and_slide()


func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += delta * direction * SPEED
	animated_sprite.play("attack")


func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == ("player"):
		target = body


func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "player" and is_alive:
		target = null
		animated_sprite.play("idle")


func take_damage(damage: int, attacker_position: Vector2) -> void:
	healt -= damage
	healthbar.update_health(healt)
	if healt <= 0:
		die()
	else:
		hit.play()
		var knockback_direction = (position - attacker_position).normalized()
		var target_position = position + knockback_direction * KNOKBACK_FORCE
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", target_position, 0.5)

func die() -> void:
	is_alive = false
	animated_sprite.play("die")
	
	hit.pitch_scale = 0.7
	hit.play()
	
	$CollisionShape2D.set_deferred("disabled", true)
	$sight/CollisionShape2D.set_deferred("disabled", true)
