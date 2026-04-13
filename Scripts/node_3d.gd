extends Node3D

signal region_cleared

@export var multimesh: MultiMeshInstance3D
@export var spawn_location: Node3D
@export var item_count: int = 1000
@export var clear_threshold: float = 0.8

var items: Array[GlobalData.PhysicalItem] = []
var exp_multi := 1
var money_multi := 1
var is_ready_to_hit := false
var items_remaining := 0
var cleared_emitted := false

func _ready() -> void:
	await _build_region(item_count)

func _build_region(count: int) -> void:
	is_ready_to_hit = false
	items.clear()
	cleared_emitted = false
	generate_items(count)

	if multimesh.multimesh.instance_count < count:
		multimesh.multimesh.instance_count = count

	for i in range(items.size()):
		multimesh.multimesh.set_instance_transform(i, items[i].transform)
		if i % 500 == 0: await get_tree().process_frame

	items_remaining = count
	is_ready_to_hit = true

func replenish(scale_exp: int, scale_money: int) -> void:
	exp_multi = scale_exp
	money_multi = scale_money
	await _build_region(item_count)

func generate_items(count: int) -> void:
	for i in range(count):
		var random := randf()
		var item: GlobalData.Item
		if random < 0.7:
			item = GlobalData.Item.new(1, 5 * exp_multi, 1 * money_multi)
		else:
			item = GlobalData.Item.new(3, 15 * exp_multi, 5 * money_multi)
		var physical := GlobalData.PhysicalItem.new(item, generate_transform(item))
		items.append(physical)

func generate_transform(item: GlobalData.Item) -> Transform3D:
	var pos := spawn_location.global_position + Vector3(
		randf_range(-10, 20), 0, randf_range(-10, 20)
	)
	var t := Transform3D().translated(pos)
	if item.health > 1:
		t = t.scaled(Vector3(2, 4, 2))
	else:
		t = t.scaled(Vector3(0.5, 0.5, 0.5))
	return t

func dmg_location(hit_area: Vector3, hit_radius: float) -> void:
	if not is_ready_to_hit: return
	var radius_sq := hit_radius * hit_radius
	for i in range(items.size()):
		var item := items[i]
		if item.transform.origin.y <= -500:
			continue
		if item.transform.origin.distance_squared_to(hit_area) < radius_sq:
			if GlobalData.player.strength >= item.item.health:
				item.transform.origin = Vector3(0, -1000, 0)
				multimesh.multimesh.set_instance_transform(i, item.transform)
				GlobalData.player.add_item(item.item)
				items_remaining -= 1
				if not cleared_emitted:
					var crushed := item_count - items_remaining
					if float(crushed) / float(item_count) >= clear_threshold:
						cleared_emitted = true
						region_cleared.emit()
			else:
				print("Strength too low. Need: ", item.item.health, " Have: ", GlobalData.player.strength)
