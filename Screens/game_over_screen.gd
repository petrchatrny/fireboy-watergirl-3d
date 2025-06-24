extends CenterContainer

func _ready() -> void:
	$CanvasLayer/VBoxContainer/Control/VBoxContainer/PlayAgainButton.grab_focus()

func restart_level():
	get_tree().reload_current_scene()

func open_level_select():
	get_tree().change_scene_to_file("res://Screens/main_screen.tscn")
