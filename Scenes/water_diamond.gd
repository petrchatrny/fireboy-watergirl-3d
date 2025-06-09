extends Node3D 

@export var type: String = "water"

@onready var area: Area3D = $Area3D

func _on_diamond_visibility_changed() -> void:
	if not visible:
		print("Diamond is now invisible, removing it...")
		call_deferred("remove_diamond")

# Funkce pro odstranění diamantu
func remove_diamond() -> void:
	if is_inside_tree():
		print("Removing diamond...")
		# Odstraníme všechny poduzly, které jsou součástí diamantu
		for child in get_children():
			if child is CollisionShape3D:
				child.disabled = true  # Deaktivujeme kolizní tvar
			elif child is Area3D:
				child.queue_free()  # Pokud je Area3D, odstraníme ji
		# Použijeme queue_free() pro odstranění celého diamantu
		queue_free()  # Zbaví se paměti a odstraní diamant z hierarchie scény
	else:
		print("Diamond is not part of the scene!")

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))  # Připojení signálu body_entered z Area3D

# Funkce pro zpracování kolize s postavou
func _on_body_entered(body: Node) -> void:
	print("Body entered: ", body.name)  # Debug - vubec to nejede doprdele
	if body is CharacterBody3D:
		print("Player entered area!")
		if body.is_watergirl and type == "water":
			print("Watergirl picks up blue diamond")
			# Deaktivuje kolizi diamantu na Area3D
			area.collision_layer = 0  # Deaktivuje kolizi (vrstva 0)
			visible = false  # Skryje diamant
			_on_diamond_visibility_changed()  # odstranění diamantu
		elif not body.is_watergirl and type == "fire":
			print("Fireboy picks up red diamond")
			# Deaktivuje kolizi diamantu na Area3D
			area.collision_layer = 0  # Deaktivuje kolizi (vrstva 0)
			visible = false  # Skryje diamant
			_on_diamond_visibility_changed()  # odstranění diamantu
		
