extends StaticBody3D

signal pressure_plate_toggled(is_pressed: bool)

var is_pressed : bool = false
@onready var animation = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not is_pressed:
		is_pressed = true
		animation.play("press_down")
		emit_signal("pressure_plate_toggled", true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if is_pressed:
		is_pressed = false
		animation.play("press_up")
		emit_signal("pressure_plate_toggled", false)
