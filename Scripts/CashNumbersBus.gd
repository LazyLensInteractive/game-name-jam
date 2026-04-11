extends Node

# Sends signal to cash_number_manager to display number
signal object_squashed(value: int, location: Vector3)

# Wrapper function
func display_number(value: int, location: Vector3):
	object_squashed.emit(value, location)
