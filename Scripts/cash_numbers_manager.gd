extends Node3D

@export var label_template: PackedScene
var pool: Array[Label3D] = []
var pool_size = 50

func _ready():
	# Connect squashed signal (we display number when that is activated)
	CashNumbersBus.object_squashed.connect(_on_squashed)
	# Pre-fill the pool
	for i in pool_size:
		var label = label_template.instantiate()
		label.hide()
		add_child(label)
		pool.append(label)

func _on_squashed(value: int, location: Vector3):
	var label = _get_from_pool()
	if label:
		label.text = str(value)
		label.global_position = location
		animate_label(label)

func _get_from_pool() -> Label3D:
	for label in pool:
		if not label.visible: return label
	return null # Or expand the pool

func animate_label(label : Label3D):
	label.show()
	label.modulate.a = 1.0
	
	var tween = create_tween().set_parallel(true)
	# Float upward
	tween.tween_property(label, "global_position:y", label.global_position.y + 2.0, 0.5)
	# Fade out
	tween.tween_property(label, "modulate:a", 0.0, 0.5).set_delay(0.2)
	
	await tween.finished
	label.hide()
