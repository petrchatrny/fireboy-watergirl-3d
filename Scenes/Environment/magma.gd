extends StaticBody3D

@export var type: String = "magma"  # Tento typ určuje, že jde o acid
@onready var area: Area3D = $Area3D  # Připojení k Area3D pro detekci vstupů

func _ready() -> void:
	# Pokud je to acid, připojí se signál
	area.connect("body_entered", Callable(self, "_on_body_entered"))

# Funkce pro zpracování kolize s postavou
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		print("Body entered: ", body.name)  # Ladicí výpis pro kontrolu
		if body.is_watergirl:
			print("Watergirl touched acid")
			body.die("Acid killed Watergirl!")  # Smrt pro Watergirl
		elif not body.is_watergirl:
			print("Fireboy touched acid")
			body.die("Acid killed Fireboy!")  # Smrt pro Fireboy
