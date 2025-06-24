extends CenterContainer

@onready var play_again_button = $CanvasLayer/MarginContainer2/VBoxContainer/Control/VBoxContainer/PlayAgainButton

func _ready():
	play_again_button.grab_focus()

func restart_level():
	get_tree().reload_current_scene()

func open_level_select():
	get_tree().change_scene_to_file("res://Screens/main_screen.tscn")
