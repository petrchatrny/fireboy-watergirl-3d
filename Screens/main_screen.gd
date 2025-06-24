extends CenterContainer

func _ready() -> void:
	$PanelContainer/VBoxContainer/HBoxContainer/Control/VBoxContainer/PlayButton.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/level_select_screen.tscn")


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/highscore_screen.tscn") 
