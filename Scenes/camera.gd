extends Node3D

@export var target : Node3D 
@export var smooth_speed = 10.0
@onready var spring_arm = $SpringArm3D
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, 1.0, 0.5)
func _process(delta):
	if target:
		global_position = global_position.lerp(target.global_position, delta * smooth_speed)
		global_rotation.y = target.get_parent().global_rotation.y
