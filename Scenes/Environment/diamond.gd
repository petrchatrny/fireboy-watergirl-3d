extends Node3D

@export var allowed_for_water_girl: bool = false

signal diamond_collected()

@onready var audio_player = $AudioStreamPlayer3D
@onready var mesh = $group1022280760
@onready var collision_area = $Area3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	# kontrola, jestli do diamantu vrazil hráč
	if not body.has_method("is_water_girl"):
		return

	var is_water_girl = body.is_water_girl()
	if is_water_girl == allowed_for_water_girl:
		# odeslat signál, že byl diamant posbírán
		emit_signal("diamond_collected")
		
		# schovat texturu diamantu
		mesh.visible = false
		
		# vypnout kolizi
		collision_area.set_deferred("monitorable", false)
		
		# vydat zvuk sebrání
		audio_player.play()

		# odstranit diamant ze scény - počkáme, až se zvuk dohraje a pak odstraníme node ze scény, jinak by uzel zmizel hned a zvuk by nedohrál
		audio_player.finished.connect(queue_free)
