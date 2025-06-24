extends Control

var LevelButton := preload("res://Scenes/GUI/level_button.tscn")

const level_folder_path := "res://Levels/"

# Ručně spravovaný seznam levelů:
const LEVELS := [
	"level_1.tscn",
	"level_2.tscn",
	"level_3.tscn",
	"level_4.tscn",
]

@onready var grid_container = $Panel/VBoxContainer/MarginContainer2/GridContainer
@onready var back_button = $BackButton

func _ready() -> void:
	fill_levels()

func fill_levels() -> void:
	var buttons := []
	
	for level_path in LEVELS:
		var button := LevelButton.instantiate()
		
		# Vyčistí název tlačítka
		button.text = level_path.replace(".tscn", "").to_upper().replace("_", " ").replace("LEVEL", "").strip_edges()
		
		# Při stisknutí přepne na daný level
		button.pressed.connect(func():
			get_tree().change_scene_to_file(level_folder_path + level_path)
		)
		
		# Uložení do seznamu pro propojení
		buttons.append(button)
		
		# Přidá tlačítko do rozhraní
		grid_container.add_child(button)
	
	# Propojení focusu mezi tlačítky
	for i in buttons.size():
		var button = buttons[i]
		
		# Vlevo a vpravo
		if i > 0:
			button.focus_neighbor_left = buttons[i - 1].get_path()
		if i < buttons.size() - 1:
			button.focus_neighbor_right = buttons[i + 1].get_path()
		
		# dolu
		button.focus_neighbor_bottom = back_button.get_path()

	# První tlačítko si vezme focus
	if buttons.size() > 0:
		buttons[0].grab_focus()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/main_screen.tscn")
