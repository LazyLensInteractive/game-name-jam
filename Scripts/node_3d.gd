extends Node3D

@export var multimesh: MultiMeshInstance3D
@export var spawn_location: Node3D
@export var item_count: int = 1000
@export var exp_multi: int = 1
@export var money_multi: int = 1

var items: Array[GlobalData.PhysicalItem] = []
var is_ready_to_hit := false

func _ready() -> void:
	await _build()

func _build() -> void:
	is_ready_to_hit = false
	items.clear()
	_generate(item_count)
	if multimesh.multimesh.instance_count < item_count:
		multimesh.multimesh.instance_count = item_count
	for i in range(items.size()):
		multimesh.multimesh.set_instance_transform(i, items[i].transform)
		if i % 500 == 0: await get_tree().process_frame
	is_ready_to_hit = true

func _generate(count: int) -> void:
	for i in range(count):
		var item: GlobalData.Item
		if randf() < 0.7:
			item = GlobalData.Item.new(1, 5 * exp_multi, 1 * money_multi)
		else:
			item = GlobalData.Item.new(3, 15 * exp_multi, 5 * money_multi)
		items.append(GlobalData.PhysicalItem.new(item, _make_transform(item)))

func _make_transform(item: GlobalData.Item) -> Transform3D:
	var pos := spawn_location.global_position + Vector3(
		randf_range(-10, 20), 0, randf_range(-10, 20)
	)
	var t := Transform3D().translated(pos)
	t = t.scaled(Vector3(2, 4, 2) if item.health > 1 else Vector3(0.5, 0.5, 0.5))
	return t

func dmg_location(hit_area: Vector3, hit_radius: float) -> void:
	if not is_ready_to_hit: return
	var radius_sq := hit_radius * hit_radius
	for i in range(items.size()):
		var item := items[i]
		if item.transform.origin.y <= -500: continue
		if item.transform.origin.distance_squared_to(hit_area) < radius_sq:
			if GlobalData.player.strength >= item.item.health:
				item.transform.origin = Vector3(0, -1000, 0)
				multimesh.multimesh.set_instance_transform(i, item.transform)
				GlobalData.player.add_item(item.item)
			else:
				print("Need strength ", item.item.health, " have ", GlobalData.player.strength)
