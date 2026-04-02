extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("fire"):
		weapon_shoot()

	move_and_slide()
func weapon_shoot():
	var camera = get_viewport().get_camera_3d() 
	var mouse_location = get_viewport().get_mouse_position() #dont let the cat catch this little guy :p
	var raycast_start = camera.project_ray_origin(mouse_location)
	var raycast_end = raycast_start + camera.project_ray_normal(mouse_location) * 2000 #big ass ray make sure it collides with the floor in order to "shoot"
	var raycast_create = PhysicsRayQueryParameters3D.create(raycast_start, raycast_end) #calls the actual creation of the ray
	raycast_create.exclude = [self] #exclude the player body from making a raycast hit
	var hit = get_world_3d().direct_space_state.intersect_ray(raycast_create) #finds where the ray intersected in 3d space 
	if hit:
		var hit_location = hit.position
		get_tree().get_first_node_in_group("GuyManager").dmg_location(hit_location, 4.0) #go to the dmg_location function to read comment about this one and group discription 
func _on_timer_timeout() -> void:
	pass
	#weapon_shoot()#timer for default weapon to fire
	#$Timer.start()#idk if this is needed but here anyway
	
