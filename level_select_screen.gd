extends CenterContainer

const level_folder_path:= "res://levels/"
const results_file_path := "user://game_results.json"

@onready var v_box_container = $ScrollContainer/MarginContainer/VBoxContainer
@onready var best_score_button = $CanvasLayer/MarginContainer2/BestScore
@onready var best_score_popup = $CanvasLayer/MarginContainer3/PopupPanel
@onready var best_score_list = $CanvasLayer/MarginContainer3/PopupPanel/VBoxContainer

func _ready() -> void:
	fill_levels()

	if v_box_container.get_child_count() > 0:
		v_box_container.get_child(0).grab_focus()

	best_score_button.pressed.connect(show_best_scores)

func fill_levels() -> void:
	var level_paths = DirAccess.get_files_at(level_folder_path)
	for level_path in level_paths:
		if level_path.ends_with(".tscn") and not level_path.contains("base_"):
			var button := Button.new()
			button.text = level_path.replace(".tscn", "").to_upper().replace("_", " ")
			v_box_container.add_child(button)
			button.pressed.connect(func():
				get_tree().change_scene_to_file(level_folder_path + level_path)
			)

func show_best_scores():
	# Vymazání starých dětí
	for child in best_score_list.get_children():
		child.queue_free()

	var results := load_best_scores()

	if results.is_empty():
		var label := Label.new()
		label.text = "Žádné uložené výsledky."
		best_score_list.add_child(label)
		return

	var level_names := results.keys()
	level_names.sort()

	for level in level_names:
		var result = results[level]
		if typeof(result) != TYPE_DICTIONARY:
			continue

		var label := Label.new()
		label.text = "%s\t– %d/%d diamantů – %ds" % [
			level.capitalize(),
			result.get("diamonds_collected", 0),
			result.get("diamonds_total", 0),
			result.get("seconds", 0)
		]
		best_score_list.add_child(label)

	best_score_popup.popup_centered()

func load_best_scores() -> Dictionary:
	if not FileAccess.file_exists(results_file_path):
		return {}

	var file = FileAccess.open(results_file_path, FileAccess.READ)
	if not file:
		return {}

	var text = file.get_as_text()
	file.close()

	if text == "":
		return {}

	var json = JSON.new()
	if json.parse(text) == OK and typeof(json.data) == TYPE_DICTIONARY:
		return json.data
	else:
		return {}
