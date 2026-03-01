extends CharacterBody2D

const SPEED = 100

var last_direction: Vector2 = Vector2.RIGHT

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	
	process_movement()
	process_animation()
	move_and_slide()

func process_movement() -> void:
	
	var direction := Input.get_vector("left", "right", "up", "down")
	
	
	if direction != Vector2.ZERO:
		velocity = SPEED * direction
		last_direction = direction
	else:
		velocity = Vector2.ZERO

func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)



func play_animation (prefix: String, dir : Vector2) -> void:
	if dir.x != 0:
		sprite.flip_h = dir.x < 0 
		sprite.play(prefix + "_right")
	elif dir.y < 0:
		sprite.play (prefix + "_up")
	elif dir.y > 0:
		sprite.play (prefix + "_down")
