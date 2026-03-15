extends CharacterBody2D


const SPEED = 40.0
const KNOKBACK_FORCE: int = 50
const drop_chance: float = 0.5

var healt: int = 100
var target = null
var strenght: int = 10
var is_alive: bool = true
var target_in_range: bool = false
var health_pickup_scene = preload("res://scene/health_pickups.tscn")

@onready var hit: AudioStreamPlayer2D = $hit
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar: Node2D = $Healthbar
@onready var attack_timer: Timer = $AttackTimer
@onready var collision_shape_2d: CollisionShape2D = $hitbox/CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $sight/CollisionShape2D



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
	
	collision_shape_2d.set_deferred("disabled", true)
	collision_shape_2d_2.set_deferred("disabled", true)
	
	if randf() <= drop_chance:
		drop_item()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "player":
		target_in_range = true
		body.take_damage(strenght)
		attack_timer.start()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "player":
		target_in_range = false
		attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	if target and target_in_range:
		target.take_damage(strenght)

func drop_item():
	var drop = health_pickup_scene.instantiate()
	drop.position = position
	var levelroot = get_parent().get_parent()
	var items_node = levelroot.get_node("items")
	items_node.call_deferred("add_child", drop)
