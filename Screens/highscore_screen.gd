extends Control

const level_folder_path := "res://levels/"
const results_file_path := "user://game_results.json"

@onready var highscore_table = $PanelContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer
var score_row_scene = preload("res://Scenes/GUI/score_table_row.tscn")

func _ready() -> void:
	populate_highscore_table()
	
	$BackButton.grab_focus()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/main_screen.tscn")

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

func populate_highscore_table():
	var scores = load_best_scores()
	
	# smaže předchozí řádky, pokud nějaké jsou (ponecháme hlavičku)
	for i in range(1, highscore_table.get_child_count()):
		highscore_table.get_child(i).queue_free()

	# projde každý záznam ve slovníku
	for level_name in scores.keys():
		var data = scores[level_name]

		# inicializace ScoreTableRow scény
		var row_instance = score_row_scene.instantiate()
		var row = row_instance.get_child(0)

		# přepsání labelů v ScoreTableRow scéně
		row.get_node("1").text = str(data.get("level", "").capitalize().replace("_", " "))
		row.get_node("2").text = "%d/%d" % [data.get("diamonds_collected", 0), data.get("diamonds_total", 0)]
		row.get_node("3").text = "%ds" % int(data.get("seconds", 0))
		row.get_node("4").text = format_timestamp(data.get("timestamp", ""))

		# přidání řádku do tabulky
		highscore_table.add_child(row_instance)

func format_timestamp(ts: String) -> String:
	if ts == "":
		return "-"
	if "T" in ts:
		var parts = ts.split("T")
		var date = parts[0]
		var time = parts[1].substr(0,5) # jen HH:MM
		return "%s %s" % [date, time]
	return ts
