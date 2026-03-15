extends CanvasLayer

const heart_size: int = 20
const heart_full = preload("res://assets/images/enemies/Heart.png")
const heart_half = preload("res://assets/images/enemies/Heart 0.5.png")
const heart_empty = preload("res://assets/images/enemies/Heart 0.png")

var player

@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var hearts_container: HBoxContainer = $hearts


func fade(to_alpha: float) -> void:
	var tween:= create_tween()
	tween.tween_property(fade_overlay, "modulate:a", to_alpha, 1.5 )
	await tween.finished

func update_health(new_health: int) -> void:
	var hearts = hearts_container.get_children()
	var max_hearts = len(hearts)
	var full = int (new_health / heart_size)
	var half = 1 if (new_health % heart_size) > 0 else 0
	var empty = max_hearts - (full + half)
	
	for i in full:
		hearts [i].texture = heart_full
	
	if half:
		hearts [full].texture = heart_half
	
	for i in empty:
		hearts [len(hearts) - 1 - i].texture = heart_empty

func set_player(p) -> void:
	player = p
	if player:
		player.health_changed.connect(update_health)
		update_health(player.health)
