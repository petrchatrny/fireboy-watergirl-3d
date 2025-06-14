extends "res://Levels/base_level.gd"

var door_opened = false

func _handle_button_toggled(is_pressed: bool) -> void:
	door_opened = is_pressed
	
	if(door_opened):
		$Scene/Controls/LockableDoor.open()
		$Scene/Controls/LockableDoor2.open()
		$Scene/Controls/LockableDoor3.open()
		$Scene/Controls/LockableDoor4.open()
	else:
		$Scene/Controls/LockableDoor.close()
		$Scene/Controls/LockableDoor2.close()
		$Scene/Controls/LockableDoor3.close()
		$Scene/Controls/LockableDoor4.close()
