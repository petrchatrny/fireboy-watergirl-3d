extends Node

var total_time_seconds : int = 0 

@onready var watergirl = $SplitScreen/LeftScreen/SubViewport/Watergirl
@onready var fireboy = $SplitScreen/RightScreen/SubViewport/Fireboy

func _ready():
	setup_peripherals()
	
	# přepnutí myši do "InGame" režimu
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$SplitScreen/LeftScreen.focus_mode = Control.FocusMode.FOCUS_NONE
	$SplitScreen/RightScreen.focus_mode = Control.FocusMode.FOCUS_ALL
	$SplitScreen/RightScreen.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Předpoklad: pravý hráč má myš, jinak přesměruj na levý
		$SplitScreen/RightScreen/SubViewport.input(event)

func _on_timer_timeout() -> void:
	# aktualizace proměnné
	total_time_seconds += 1
	
	# vizuální vykreslení změny času
	var minutes = int(total_time_seconds / 60)
	var seconds = int(total_time_seconds % 60)
	$HUD/TimerRect/TimeLabel.text = "%02d:%02d" % [minutes, seconds]

# ======================================================================================

# na základě připojených zařízení k PC vyhodnotí ovládání hry
func setup_peripherals(): 
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
