extends Node

var active_region: Node3D
var player: CharacterBody3D
var wave: int = 1

func _ready() -> void:
	active_region = get_tree().get_first_node_in_group("GuyManager")
	player = get_tree().get_first_node_in_group("Player")
	print("[RM] active_region=", active_region)
	print("[RM] player=", player)
	if active_region == null:
		print("[RM] ERROR: GuyManager group empty")
		return
	if player == null:
		print("[RM] ERROR: Player group empty")
		return
	active_region.region_cleared.connect(_on_cleared)
	print("[RM] signal connected")

func _on_cleared() -> void:
	print("[RM] _on_cleared fired. wave was=", wave)
	wave += 1
	print("[RM] new wave=", wave)
	print("[RM] player pos before teleport=", player.global_position)
	player.global_position = active_region.spawn_location.global_position + Vector3(0, 1, 0)
	print("[RM] player pos after teleport=", player.global_position)
	active_region.replenish(wave, wave)
