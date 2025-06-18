extends StaticBody3D

signal pressure_plate_toggled(is_pressed: bool)

@export var button_color: Color = Color(0.3, 0.1, 0.2)
@onready var animation = $AnimationPlayer
var is_pressed : bool = false

func _ready() -> void:
	var button = $Area3D/Button
	
	var material = button.get_surface_override_material(0)
	if material == null:
		material = StandardMaterial3D.new()
		button.set_surface_override_material(0, material)

	if material is StandardMaterial3D:
		material.albedo_color = button_color

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if not is_pressed:
		is_pressed = true
		animation.play("press_down")
		emit_signal("pressure_plate_toggled", true)

func _on_area_3d_body_exited(_body: Node3D) -> void:
	if is_pressed:
		is_pressed = false
		animation.play("press_up")
		emit_signal("pressure_plate_toggled", false)
