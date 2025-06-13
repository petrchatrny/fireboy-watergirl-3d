extends Node

var passed_seconds_count : int = 0
var total_diamonds_count: int = 0
var collected_diamonds_count: int = 0
var is_game_over: bool = false
var is_winner: bool = false

@onready var watergirl = $SplitScreen/LeftScreen/SubViewport/Watergirl
@onready var fireboy = $SplitScreen/RightScreen/SubViewport/Fireboy

func _on_ready() -> void:
	# na základě připojených zařízení k PC vyhodnotí ovládání hry
	setup_peripherals()
	
	# připojení signálů z diamantů
	connect_diamond_signals()
	
	# uložení výchozího počtu diamantů do proměnné
	total_diamonds_count = get_total_diamonds_count()
	
	# nastavení správného výchozího skóre
	update_score()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Předpoklad: pravý hráč má myš, jinak přesměruj na levý
		$SplitScreen/RightScreen/SubViewport.input(event)

func _on_timer_timeout() -> void:
	# aktualizace proměnné
	passed_seconds_count += 1
	
	# vizuální vykreslení změny času
	var minutes = int(passed_seconds_count / 60)
	var seconds = int(passed_seconds_count % 60)
	$HUD/TimerRect/TimeLabel.text = "%02d:%02d" % [minutes, seconds]

func _on_diamond_collected():
	collected_diamonds_count += 1
	update_score()

# ------------------------------------------------------------------------------

# na základě připojených zařízení k PC vyhodnotí ovládání hry
func setup_peripherals(): 
	# přepnutí myši do "InGame" režimu
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$SplitScreen/LeftScreen.focus_mode = Control.FocusMode.FOCUS_NONE
	$SplitScreen/RightScreen.focus_mode = Control.FocusMode.FOCUS_ALL
	$SplitScreen/RightScreen.grab_focus()
	
	var joypads = Input.get_connected_joypads()
	
	# dva ovladače - oba hráči na gamepadech
	if joypads.size() >= 2:
		watergirl.controller_id = joypads[0]
		watergirl.use_mouse = false
		
		fireboy.controller_id = joypads[1]
		fireboy.use_mouse = false
	# jeden ovladač - holka hraje na ovladači a kluk přes klávesnici a myši
	elif joypads.size() == 1:
		watergirl.controller_id = joypads[0]
		watergirl.use_mouse = false
		
		fireboy.controller_id = -1
		fireboy.use_mouse = true
	# žádný ovladač - oba hráči na klávesnici, jeden i pomocí myši
	else:
		watergirl.controller_id = -1
		watergirl.use_mouse = false
		
		fireboy.controller_id = -1
		fireboy.use_mouse = true

# připojí signály z diamantů, aby je level mohl přijímat
func connect_diamond_signals():
	var diamond_container = $Scene/Diamonds
	for diamond in diamond_container.get_children():
		if diamond.has_signal("diamond_collected"):
			diamond.connect("diamond_collected", Callable(self, "_on_diamond_collected"))
		else:
			print("⚠️ Uzel ", diamond.name, " nemá signál 'collected'")

# aktualizuje text skóre v HUD
func update_score() -> void:
	var text = str(collected_diamonds_count) + "/" + str(total_diamonds_count)
	$HUD/ScoreRect/Control/DiamondCountLabel.text = text

# získá počet diamantů
func get_total_diamonds_count() -> int:
	var diamond_container = $Scene/Diamonds
	return diamond_container.get_child_count()
