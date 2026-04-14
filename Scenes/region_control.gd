extends Node

var player: CharacterBody3D
var regions: Array[Node] = []
var unlocked_up_to: int = 1

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	regions = get_tree().get_nodes_in_group("GuyManager")
	print("[RM] player=", player)
	print("[RM] regions found=", regions.size())
	for i in range(regions.size()):
		print("[RM] region ", i, " = ", regions[i].name, " visible=", regions[i].visible)
	for i in range(1, regions.size()):
		regions[i].visible = false
		print("[RM] hiding region ", i, " = ", regions[i].name)

func _process(_delta: float) -> void:
	var exp := GlobalData.player.exp
	for region_index in GlobalData.region_unlocks:
		if region_index <= unlocked_up_to: continue
		if exp >= GlobalData.region_unlocks[region_index]:
			print("[RM] exp=", exp, " threshold=", GlobalData.region_unlocks[region_index], " unlocking region ", region_index)
			_unlock_region(region_index)

func _unlock_region(index: int) -> void:
	unlocked_up_to = index
	print("[RM] _unlock_region index=", index, " regions.size()=", regions.size(), " array index=", index - 1)
	if index - 1 < regions.size():
		regions[index - 1].visible = true
		print("[RM] made visible: ", regions[index - 1].name)
	else:
		print("[RM] ERROR: index-1 out of bounds")
