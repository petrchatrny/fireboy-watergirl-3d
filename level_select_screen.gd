extends Control

var LevelButton := preload("res://Scenes/GUI/level_button.tscn")

const level_folder_path := "res://levels/"

# Ručně spravovaný seznam levelů:
const LEVELS := [
	"level_1.tscn",
	"level_2.tscn",
	"level_3.tscn",
	"level_4.tscn",
]

@onready var grid_container = $Panel/VBoxContainer/MarginContainer2/GridContainer

func _ready() -> void:
	fill_levels()

func fill_levels() -> void:
	for level_path in LEVELS:
		var button := LevelButton.instantiate()
		
		# Vyčistí název tlačítka
		button.text = level_path.replace(".tscn", "").to_upper().replace("_", " ").replace("LEVEL", "").strip_edges()
		
		# Při stisknutí přepne na daný level
		button.pressed.connect(func():
			get_tree().change_scene_to_file(level_folder_path + level_path)
		)
		
		# Přidá tlačítko do rozhraní
		grid_container.add_child(button)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_screen.tscn")
