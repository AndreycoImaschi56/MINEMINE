extends CharacterBody2D

const SPEED = 100


func _physics_process(_delta: float) -> void:
	process_movement()
	move_and_slide()

func process_movement() -> void:
	
	var direction := Input.get_vector("left", "right", "up", "down")
	
	
	if direction != Vector2.ZERO:
		velocity = SPEED * direction
	else:
		velocity = Vector2.ZERO
		
