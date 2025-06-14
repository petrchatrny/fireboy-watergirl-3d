extends Node3D

var is_open : bool = false
@onready var animation = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D

func open():
	if not is_open:
		animation.play("open")
		audio_player.play()
		is_open = true

func close():
	if is_open:
		animation.play("close")
		is_open = false
