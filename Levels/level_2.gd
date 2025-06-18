extends "res://Levels/base_level.gd"

var door_opened = false

func _handle_button_toggled(is_pressed: bool) -> void:
	door_opened = is_pressed
	
	if(door_opened):
		$Scene/LockableDoorWall2.open()
	else:
		$Scene/LockableDoorWall2.close()


func _on_pressure_toggled(is_pressed: bool) -> void:
	if is_pressed:
		$Scene/Controls/LockableDoorWall.open()
	else:
		$Scene/Controls/LockableDoorWall.close()
