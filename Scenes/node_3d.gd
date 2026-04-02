extends Node3D
# this script controls multi mesh gpu instancing for mass hoards of goobers uhh first time i have done this may be a bit sloppy but hope its working right 
#(pro tip: 1k+ instances of navigation agents is not very performant found this out today)
@onready var multmeh: MultiMeshInstance3D = $MultiMeshInstance3D 
var how_many = 5000
var locations = [] #this holds all positions is it a good way to do this? (genuine question idk)
var speed = 4 # i think this is m/s i honestly dont know lmao
var how_many_dead = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(how_many):
		var begin_pos = Vector3(randf_range(-80, 80), 0, randf_range(-80, 80)) #the position for the aray to start at random ranges to be well... random positions
		var t = Transform3D() #transform var is internal so t is used here cause yeah it works just think of it that way 
		t = t.translated(begin_pos)
		locations.append(t) #appends our positions of the count from var how_many to the array of locations (in theory.... game theory)
		multmeh.multimesh.set_instance_transform(i, t) #sets the mesh to draw instances at the transform positions of the array
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if not player: #even though there is only every one item in the player group and we are only checking the first one.... just to make sure... can never be too sure... 
		return
	
	for i in range(how_many):
		var current_locations = locations[i] #grab all location data we just made
		var current_positions = current_locations.origin #get position of each location in our array 
		var direction = (player.global_position - current_positions).normalized() #find where the player is
		current_positions += direction * speed * delta #change all positions based on delta and speed var
		current_locations.origin = current_positions #new orgion of locations becomes the position
		locations[i] = current_locations #write new locations to array
		multmeh.multimesh.set_instance_transform(i, current_locations)#redraw multimesh
func dmg_location(hit_area: Vector3, hit_radius: float):#2 required calls here hit area will be the location of a raycast hit and hit radius can be changed based on how close the raycast had to be to call a enemy dead also kills within this range as a kinda splash dmg
	for i in range(how_many):
		if locations[i].origin.y < -500:#just a check to make sure the enemy isint already dead
			continue
		var distance = locations[i].origin.distance_to(hit_area)
		if distance < hit_radius: #if within range moves the guy 1000m down and calls it dead (kinda just out of view but removing them from the array is too much work)
			locations[i].origin = Vector3(0, -1000, 0)
			multmeh.multimesh.set_instance_transform(i, locations[i])#redraws the mesh with new deaths if some happened
			how_many_dead += 1 #how many have died unused for now but will be used in shop for some cards 
			print(how_many_dead) #debug text
