extends Node3D 

@export var type: String = "fire"  # This type identifies the diamond as a "fire" diamond
@onready var area: Area3D = $Area3D

func _on_diamond_visibility_changed() -> void:
	if not visible:
		print("Diamond is now invisible, removing it...")
		call_deferred("remove_diamond")

# Function to remove the diamond from the scene
func remove_diamond() -> void:
	if is_inside_tree():
		print("Removing diamond...")
		# Remove the area and disable its collision shape
		for child in get_children():
			if child is CollisionShape3D:
				child.disabled = true  # Disable the collision shape
			elif child is Area3D:
				child.queue_free()  # Remove the Area3D from the scene
		# Call queue_free to remove the entire diamond node
		queue_free()  # Remove it from memory and scene
	else:
		print("Diamond is not part of the scene!")

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))  # Connect the signal to detect when a player enters the area

# Function to handle when the player enters the area
func _on_body_entered(body: Node) -> void:
	print("Body entered: ", body.name)  # Debugging output
	if body is CharacterBody3D:
		print("Player entered area!")
		if not body.is_watergirl and type == "fire":  # If the player is Fireboy and the diamond is a fire diamond
			print("Fireboy picks up red diamond")
			area.collision_layer = 0  # Disable collision
			visible = false  # Hide the diamond
			_on_diamond_visibility_changed()  # Call the function to remove the diamond
			body.add_score(1)  # Add score to the Fireboy
