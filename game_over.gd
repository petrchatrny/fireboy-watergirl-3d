extends CenterContainer

@onready var play_again_button = $CanvasLayer/MarginContainer2/VBoxContainer/Button
@onready var select_level_button = $CanvasLayer/MarginContainer2/VBoxContainer/Button2

func _ready():
	play_again_button.pressed.connect(restart_level)
	select_level_button.pressed.connect(open_level_select)

func restart_level():
	get_tree().reload_current_scene()

func open_level_select():
	get_tree().change_scene_to_file("res://level_select_screen.tscn")
