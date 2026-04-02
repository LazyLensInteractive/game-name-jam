extends CharacterBody3D
var speed = 70
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var target_pos: Vector3
var has_target: bool
var monster_move = true
func _ready() -> void:
	has_target = true
	

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	target_pos = player.position
	if has_target:
		nav.target_position = target_pos
		var next_path := nav.get_next_path_position()
		var direction := global_position.direction_to(next_path)
		nav.set_velocity(direction * speed)
		
		#if nav.is_navigation_finished():
			#has_target = false
			#velocity = Vector3.ZERO
			
		var rotation_speed = 4
		var target_rotation := direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
		if abs(target_rotation - rotation.y) > deg_to_rad(60):
			rotation_speed = 20
		rotation.y = move_toward(rotation.y, target_rotation, delta * rotation_speed)
		
	


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	if monster_move == true:
		move_and_slide()
