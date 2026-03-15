extends Node2D

@onready var hud: CanvasLayer = $CanvasLayer

var level: int = 1
var current_level = null

func _ready() -> void:
	current_level = get_node("levelroot")
	_load_level(level)


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "player":
		level +=1
		call_deferred("_load_level", level)


func _load_level(level_number:int) -> void:
	if current_level:
		current_level.queue_free()
		
	var level_path = "res://scene/levels/level_%s.tscn" % level_number
	current_level = load(level_path).instantiate()
	add_child(current_level)
	current_level.name = "levelroot"
	_setup_level(current_level)
	
func _setup_level(level_root: Node) -> void:
	
	var player = level_root.get_node("player")
	player.died.connect(_on_player_died)
	
	var exit = level_root.get_node_or_null("uscita")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

func _on_player_died() -> void:
	await get_tree().create_timer(1.0).timeout
	await hud.fade (1.0)
	level = 1
	player_stats.reset()
	_load_level(level)
	await hud.fade (0.0)
