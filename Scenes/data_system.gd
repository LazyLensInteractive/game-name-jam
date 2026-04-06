extends Node
#this file holds all data that can be changed from what cards/power ups can do to player power, health, and a bunch of other things that need to be checked this will be a mess good luck debugging
var player_data = []
var level_data = []
var card_data = []
var stats = []
var enemy_data = []
var current_enemy_health_multi = 1
var current_player_dmg_multi = 1
var player_exp = 0
var player_money = 0
var player_strength = 0 
@onready var manager = get_tree().get_first_node_in_group("GuyManager")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in manager.how_many:
		var enemy_health = randf_range(1, 3) * current_enemy_health_multi
		enemy_data.append(enemy_health)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
