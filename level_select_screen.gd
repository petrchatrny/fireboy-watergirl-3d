extends CenterContainer
const level_folder_path:= "res://levels/"
@onready var v_box_container = $ScrollContainer/MarginContainer/VBoxContainer

func _ready() -> void:
	fill_levels()
	
	if v_box_container.get_child_count() > 0:
		v_box_container.get_child(0).grab_focus
		

func fill_levels() -> void:
	var level_paths = DirAccess.get_files_at(level_folder_path)
	for level_path in level_paths:
		if level_path.contains(".tscn") and !level_path.contains("base_"):
			var button:=Button.new()
			
			button.text = level_path.replace(".tscn", "").to_upper().replace("_", " ")
			v_box_container.add_child(button)
			
			button.pressed.connect(func():
				get_tree().change_scene_to_file(level_folder_path + level_path)
			)
