extends Node3D
@onready var multmeh: MultiMeshInstance3D = $MultiMeshInstance3D 
var how_many = 5000
var locations = [] #this holds all positions is it a good way to do this? (genuine question idk)
var speed = 2 # i think this is m/s i honestly dont know lmao
var how_many_dead = 0
var times_hit = 0

func _ready() -> void:
	# Tell GlobalData to prepare the health/exp arrays for our 5000 objects
	GlobalData.object_data(how_many)
	
	for i in range(how_many):
		var begin_pos = Vector3(randf_range(-80, 80), 0, randf_range(-80, 80))
		var t = Transform3D() 
		t = t.translated(begin_pos)
		if GlobalData.object_health[i] > 1:
			t = t.scaled(Vector3(2, 4, 2)) # Big Building
		else:
			t = t.scaled(Vector3(0.5, 0.5, 0.5)) # Small Goober
		locations.append(t)
		multmeh.multimesh.set_instance_transform(i, t)
func _physics_process(delta: float) -> void:
	pass

func dmg_location(hit_area: Vector3, hit_radius: float): #2 required calls here hit area will be the location of a raycast hit and hit radius can be changed based on how close the raycast had to be to call a enemy dead
	for i in range(how_many):
		if locations[i].origin.y < -500: #just a check to make sure the enemy isint already dead
			continue
			
		var distance = locations[i].origin.distance_to(hit_area)
		
		if distance < hit_radius:
			if GlobalData.player_strength >= GlobalData.object_health[i]:
				GlobalData.player_exp += GlobalData.object_exp[i]
				GlobalData.player_money += GlobalData.object_money[i]
				
				# Move the guy 1000m down and calls it dead
				locations[i].origin = Vector3(0, -1000, 0)
				multmeh.multimesh.set_instance_transform(i, locations[i]) #redraws the mesh with new deaths if some happened
				how_many_dead += 1 #how many have died unused for now but will be used in shop for some cards 
				GlobalData.data_calc(i)
				#print(how_many_dead) #debug text


#outdated function its still here just in case its useful i dont think it will be though 
func player_dmg(detect_area: Vector3, radius: float): #basicly a copy of above for enemy to player detection too lazy to make something better 
	for i in range(how_many):
		if locations[i].origin.y < -500:
			continue
		var distance = locations[i].origin.distance_to(detect_area)
		if distance < radius:
			locations[i].origin = Vector3(0, -1000, 0)
			multmeh.multimesh.set_instance_transform(i, locations[i])
			times_hit += 1
			var p = get_tree().get_first_node_in_group("Player")
			if p:
				p.player_hit()
