extends Node3D

@export var multimesh: MultiMeshInstance3D
@export var spawn_location: Node3D
@export var item_count: int = 1000

# Array of locational + value representations of the objects
var items: Array[GlobalData.PhysicalItem] = []

var exp_multi := 1
var money_multi := 1

var is_ready_to_hit = false

func _ready() -> void:
	generate_items(item_count)
	
	if multimesh.multimesh.instance_count < item_count:
		multimesh.multimesh.instance_count = item_count
	
	for i in range(items.size()):
		multimesh.multimesh.set_instance_transform(i, items[i].transform)
		if i % 500 == 0: await get_tree().process_frame

	is_ready_to_hit = true

	
func generate_items(count: int):
	for i in range(count):
		var random = randf()
		var item : GlobalData.Item
		if random < 2:
			item = GlobalData.Item.new(1, 5 * exp_multi, 1 * money_multi)
		else:
			item = GlobalData.Item.new(3, 15 * exp_multi, 5 * money_multi)
		# Generate the location of the item, package into "PhysicalItem" class
		var physical := GlobalData.PhysicalItem.new(item, generate_transform(item))
		items.append(physical)

func generate_transform(item: GlobalData.Item) -> Transform3D:
	var begin_pos = spawn_location.global_position + Vector3(randf_range(-10, 20), 0, randf_range(-10, 20))
	
	var t = Transform3D().translated(begin_pos)
	if item.health > 1:
		t = t.scaled(Vector3(2, 4, 2))
	else:
		t = t.scaled(Vector3(0.5, 0.5, 0.5))
	
	return t


func dmg_location(hit_area: Vector3, hit_radius: float):
	if not is_ready_to_hit: return #return if still loading idealy this will never be the case as the player shouldent be able to collect before the arrays are loaded but it happens cause its random spawning
	var radius_sq = hit_radius * hit_radius 
	for i in range(items.size()):
		var item := items[i]
		if item.transform.origin.y <= -500:
			continue
		if item.transform.origin.distance_squared_to(hit_area) < radius_sq:
			if GlobalData.player.strength >= item.item.health:
				GlobalData.player.add_item(item.item)
				CashNumbersBus.display_number(item.item.money, item.transform.origin)
				item.transform.origin = Vector3(0, -1000, 0) # Send to the shadow realm
				multimesh.multimesh.set_instance_transform(i, item.transform)
