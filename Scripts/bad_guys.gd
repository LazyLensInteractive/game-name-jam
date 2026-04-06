extends Node
var bad_guys = load("res://Scenes/goober.tscn")

var can_spawn = true
var spawn_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_count >= 5:
		can_spawn = false
	if can_spawn:
		var instance = bad_guys.instantiate()
		add_child(instance)
		spawn_count += 1
	
	
	
