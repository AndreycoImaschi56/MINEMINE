extends Node2D

var level: int = 1
var current_level: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = get_node("levelroot")
	
	var uscita = current_level.get_node_or_null("uscita")
	if uscita:
		uscita.body_entered.connect(_on_uscita_body_entered)
		
func _on_uscita_body_entered(body: Node2D) -> void:
	
