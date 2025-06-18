extends "res://Levels/base_level.gd"

func _on_red_pressure_plate_pressure_plate_toggled(is_pressed: bool) -> void:
	var doors = find_doors_by_name_prefix("RedDoor")
	set_doors_state(doors, is_pressed)

func _on_green_pressure_plate_pressure_plate_toggled(is_pressed: bool) -> void:
	var doors = find_doors_by_name_prefix("GreenDoor")
	set_doors_state(doors, is_pressed)

func _on_blue_pressure_plate_pressure_plate_toggled(is_pressed: bool) -> void:
	var doors = find_doors_by_name_prefix("BlueDoor")
	set_doors_state(doors, is_pressed)

func _on_white_pressure_plate_pressure_plate_toggled(is_pressed: bool) -> void:
	var doors = find_doors_by_name_prefix("WhiteDoor")
	set_doors_state(doors, is_pressed)

func set_doors_state(doors: Array, is_open: bool) -> void:
	for door in doors:
		if is_open:
			door.open()
		else:
			door.close()

func find_doors_by_name_prefix(prefix: String) -> Array:
	var parent = $Scene/Controls
	var matches := []
	for child in parent.get_children():
		if child.name.begins_with(prefix):
			matches.append(child)
	return matches

func _on_finish_pressure_plate_pressure_plate_toggled(is_pressed: bool) -> void:
	if is_pressed:
		$Scene/Controls/FireboyMainDoor.open()
	else:
		$Scene/Controls/FireboyMainDoor.close()
