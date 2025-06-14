extends Node3D

signal finish_door_toggled(is_open: bool, door: Node3D)

@export var accepted_player_type: String
@onready var animation_player = $"../AnimationPlayer"

func _on_finish_hit_box_body_entered(body: Node3D) -> void:
	if not body.has_method("is_water_girl"):
		return
	
	var is_water_girl = body.is_water_girl()
	if (is_water_girl and accepted_player_type == "watergirl") or (not is_water_girl and accepted_player_type == "fireboy"):
		open_door()

func _on_finish_hit_box_body_exited(body: Node3D) -> void:
	if not body.has_method("is_water_girl"):
		return
	
	var is_water_girl = body.is_water_girl()
	if (is_water_girl and accepted_player_type == "watergirl") or (not is_water_girl and accepted_player_type == "fireboy"):
		close_door()

func open_door():
	animation_player.play("open")
	emit_signal("finish_door_toggled", true, self)

func close_door():
	animation_player.play("close")
	emit_signal("finish_door_toggled", false, self)
