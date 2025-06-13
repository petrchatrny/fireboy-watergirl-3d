extends Node3D

@export var allowed_for_water_girl: bool = false

signal diamond_collected()

func _on_area_3d_body_entered(body: Node3D) -> void:
	# kontrola, jestli do diamantu vrazil hráč
	if not body.has_method("is_water_girl"):
		return

	var is_water_girl = body.is_water_girl()
	if is_water_girl == allowed_for_water_girl:
		# odeslat signál, že byl diamant posbírán
		emit_signal("diamond_collected")

		# odstranit diamant ze scény
		queue_free()
