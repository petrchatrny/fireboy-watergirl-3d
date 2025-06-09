extends Node

@onready var watergirl = $Watergirl
@onready var fireboy = $Fireboy

func _ready():
	var joypads = Input.get_connected_joypads()
	
	if joypads.size() >= 2:
		# dva ovladače - oba hráči na gamepadech
		watergirl.controller_id = joypads[0]
		watergirl.use_mouse = false
		
		fireboy.controller_id = joypads[1]
		fireboy.use_mouse = false
	elif joypads.size() == 1:
		# jeden ovladač - holka hraje na ovladači a kluk přes klávesnici a myši
		watergirl.controller_id = joypads[0]
		watergirl.use_mouse = false
		
		fireboy.controller_id = -1
		fireboy.use_mouse = true
	else:
		# žádný ovladač → oba hráči na klávesnici, jeden i pomocí myši
		watergirl.controller_id = -1
		watergirl.use_mouse = false
		
		fireboy.controller_id = -1
		fireboy.use_mouse = true
