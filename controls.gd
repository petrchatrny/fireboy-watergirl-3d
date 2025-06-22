extends Control

var LevelButton := preload("res://Scenes/GUI/level_button.tscn")

const level_folder_path := "res://levels/"
const results_file_path := "user://game_results.json"

@onready var best_score_list = $Panel/VBoxContainer/TextureRect/VBoxContainer  # Zajišťujeme, že máme správnou cestu

# Preload font pro nastavení písma
var font := preload("res://Assets/HUD/trajanpro-bold.otf")  # Nahraď cestu k fontu podle toho, který používáš

func _ready() -> void:
	display_best_scores()

func display_best_scores():
	for child in best_score_list.get_children():
		child.queue_free()

	var header := Label.new()
	header.text = "Best level results: "
	header.set("custom_fonts/font", font)
	header.modulate = Color(0, 0, 0)  
	header.set("theme/font_size", 40)

	best_score_list.add_child(header)

	var results = load_best_scores()

	if results.is_empty():
		var label := Label.new()
		label.text = "Žádné uložené výsledky."
		label.add_font_override("font", font) 
		label.set("custom_fonts/font", font)  
		label.modulate = Color(0, 0, 0)
		label.set("theme/font_size", 30)
		best_score_list.add_child(label)
		return

	var level_names := results.keys()
	level_names.sort()

	for level in level_names:
		var result = results[level]
		if typeof(result) != TYPE_DICTIONARY:
			continue

		var label := Label.new()
		label.text = "%s – %d/%d diamantů – %ds" % [
			level.capitalize(),
			result.get("diamonds_collected", 0),
			result.get("diamonds_total", 0),
			result.get("seconds", 0)
		]
		label.set("custom_fonts/font", font) 
		label.modulate = Color(0, 0, 0) 
		label.set("theme/font_size", 30)
		best_score_list.add_child(label)

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


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_screen.tscn")
