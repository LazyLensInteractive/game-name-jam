extends CharacterBody3D
var player_health = 500
var camera_sensitivty = 0.001 #self explanitory lower number slower 
const BASE_SPEED_MULTIPLIER = 5
var base_speed: float = 0.0
const JUMP_VELOCITY = 4.5
@onready var label: Label = $"../../ui/Label"
@export var camera : Node3D #not a camera node but trust we dont want the camera directly bound to the player so we do some other stuff check out the camera script for more info 
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #your mouse is mine wahhhh 
	_update_base_speed()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * camera_sensitivty) #rotate the player body so w continues moving forward based on the camera
func _physics_process(delta: float) -> void:
	var current_speed = base_speed
	if Input.is_action_pressed("ui_accept"):
		current_speed *= 2.0
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var forward = camera.global_basis.z
	var right = camera.global_basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	var direction = (forward * input_dir.y + right * input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	if Input.is_action_just_pressed("fire"):
		pass #weapon_shoot()
	var location = self.global_position
	if location != null:
		for region in get_tree().get_nodes_in_group("GuyManager"):
			region.dmg_location(location, 1.5)
	RenderingServer.global_shader_parameter_set("player_pos", global_position) #update the shader for the current player position
	if label != null:
		label.text = "mhhh cash:" + str(GlobalData.player.money)
	if label == null:
		print("im broken")
		
#camera stuff
	
	move_and_slide()
func weapon_shoot():
	var camera = get_viewport().get_camera_3d() 
	var mouse_location = get_viewport().get_mouse_position() #dont let the cat catch this little guy :p
	var raycast_start = camera.project_ray_origin(mouse_location)
	var raycast_end = raycast_start + camera.project_ray_normal(mouse_location) * 2000 #big ass ray make sure it collides with the floor in order to "shoot"
	var raycast_create = PhysicsRayQueryParameters3D.create(raycast_start, raycast_end) #calls the actual creation of the ray
	raycast_create.exclude = [self.get_rid()] #exclude the player body from making a raycast hit (idk what .get_rid() does but self was being wierd)
	var hit = get_world_3d().direct_space_state.intersect_ray(raycast_create) #finds where the ray intersected in 3d space 
	if hit:
		var hit_location = hit.position
		get_tree().get_first_node_in_group("GuyManager").dmg_location(hit_location, 4.0) #go to the dmg_location function to read comment about this one and group discription 
	
func _on_timer_timeout() -> void:
	pass
	#weapon_shoot()#timer fodsr default weapon to fire
	#$Timer.start()#idk ifaw this is needed but here anyway
func awawdwwwwwwwwwwwwwsadhit():
	if player_health > 0:
		player_health -= 1
	if player_health <= 0:
		print("dead")
	print(player_health)
func _update_base_speed() -> void:
	var level = GlobalData.player_upgrades["speed"]
	base_speed = float(level) * BASE_SPEED_MULTIPLIER
	if base_speed == 0:
		base_speed = 0.5
