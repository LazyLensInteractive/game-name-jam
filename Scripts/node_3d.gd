extends Node3D
#idk why i named these vars this just go off the path name im tired alr
@onready var lowest_level_multimesh: MultiMeshInstance3D = $"Region 1"
@onready var second_multimesh: MultiMeshInstance3D = $"Region 2"
@onready var small_items: Node3D = $"../Spawn Locations/Region 1 Spawn"
@onready var second_items: Node3D = $"../Spawn Locations/Region 2 Spawn"

var how_many = 5000
var how_many_second = 1000 
var locations = [] 
var locations_second = [] 
var start_index_first = 0
var start_index_second = 0
var is_ready_to_hit = false
var how_many_dead = 0
var times_hit = 0
#i rewrrote most of this today and delted the comments its mostly the same as last time just better as i read the docs for once uhh check github for an older version or wait till i add comments got more stuff to do
func _ready() -> void:
	start_index_first = GlobalData.object_health.size()
	GlobalData.object_data(how_many)
	for i in range(how_many):
		var global_i = start_index_first + i
		var begin_pos = small_items.global_position + Vector3(randf_range(-10, 20), 0, randf_range(-10, 20))
		var t = Transform3D().translated(begin_pos)
		if GlobalData.object_health[global_i] > 1:
			t = t.scaled(Vector3(2, 4, 2))
		else:
			t = t.scaled(Vector3(0.5, 0.5, 0.5))
		locations.append(t)
		lowest_level_multimesh.multimesh.set_instance_transform(i, t)
		if i % 500 == 0: await get_tree().process_frame
	start_index_second = GlobalData.object_health.size()
	GlobalData.object_data(how_many_second)
	for i in range(how_many_second):
		var global_i = start_index_second + i
		var begin_pos = second_items.global_position + Vector3(randf_range(-5, 5), 0, randf_range(-5, 5))
		var t = Transform3D().translated(begin_pos)
		if GlobalData.object_health[global_i] > 1:
			t = t.scaled(Vector3(2, 4, 2))
		else:
			t = t.scaled(Vector3(0.5, 0.5, 0.5))
		locations_second.append(t)
		second_multimesh.multimesh.set_instance_transform(i, t)
		if i % 500 == 0: await get_tree().process_frame #helps performace by loading in 500 entry chunks instead of all at once 
	is_ready_to_hit = true

func dmg_location(hit_area: Vector3, hit_radius: float):
	if not is_ready_to_hit: return #return if still loading idealy this will never be the case as the player shouldent be able to collect before the arrays are loaded but it happens cause its random spawning
	var radius_sq = hit_radius * hit_radius 
	for i in range(locations.size()):
		if locations[i].origin.y < -500: continue
		if locations[i].origin.distance_squared_to(hit_area) < radius_sq:
			var global_i = start_index_first + i
			if GlobalData.player_strength >= GlobalData.object_health[global_i]:
				locations[i].origin = Vector3(0, -1000, 0)
				lowest_level_multimesh.multimesh.set_instance_transform(i, locations[i])
				GlobalData.data_calc(global_i)
	for i in range(locations_second.size()):
		if locations_second[i].origin.y < -500: continue
		if locations_second[i].origin.distance_squared_to(hit_area) < radius_sq:
			var global_i = start_index_second + i
			if GlobalData.player_strength >= GlobalData.object_health[global_i]:
				locations_second[i].origin = Vector3(0, -1000, 0)
				second_multimesh.multimesh.set_instance_transform(i, locations_second[i])
				GlobalData.data_calc(global_i)
