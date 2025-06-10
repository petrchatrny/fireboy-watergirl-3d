extends CharacterBody3D

@export var is_watergirl: bool = true  # true = Watergirl, false = Fireboy

# ovládání
@export var controller_id: int = -1  # -1 = klávesnice/myš, 0+ = gamepad ID
@export var use_mouse: bool = false  # ovládání kamery pomocí myši
var walk_left_action := ""
var walk_right_action := ""
var walk_forward_action := ""
var walk_back_action := ""
var jump_action := ""

# pohyb
@export var speed = 3.5
@export var jump_velocity = 5.5
var grounded = false
var is_jumping_now = false

# rotace kamery
var yaw = 0.0
var pitch = 0.0
var sensitivity = 0.003

# části těla
const WATERGIRL_MESH_PATH := "res://Scenes/watergirl_mesh.tscn"
const FIREBOY_MESH_PATH := "res://Scenes/fireboy_mesh.tscn"
var character_mesh: Node3D
@onready var step_cast = $StepCast

func _ready() -> void:
	# nastavení podle typu hráče
	var mesh_scene = null
	if is_watergirl:
		walk_forward_action = "wg_walk_forward"
		walk_back_action = "wg_walk_backward"
		walk_left_action = "wg_walk_left"
		walk_right_action = "wg_walk_right"
		jump_action = "wg_jump"
		mesh_scene = preload(WATERGIRL_MESH_PATH)
	else:
		walk_forward_action = "fb_walk_forward"
		walk_back_action = "fb_walk_backward"
		walk_left_action = "fb_walk_left"
		walk_right_action = "fb_walk_right"
		jump_action = "fb_jump"
		mesh_scene = preload(FIREBOY_MESH_PATH)
	
	# načtení textury postavy a přidání do stromu prvků
	character_mesh = mesh_scene.instantiate()
	add_child(character_mesh)
	
	# nastavení animačního stromu
	var animation_player = character_mesh.get_node("AnimationPlayer")
	$AnimationTree.anim_player = animation_player.get_path()
	$AnimationTree.active = true
	
	for body in get_children():
		if body is Area3D:
			body.connect("body_entered", Callable(self, "_on_body_entered"))

	# ignorování kolize kamery s vlastním tělem hráče
	$Head/SpringArm3D.add_excluded_object(get_rid())

# vyhodnocování fyziky v čase
func _physics_process(delta: float) -> void:
	# přidání gravitace
	if not is_grounded():
		velocity += get_gravity() * delta
	
	# skok
	if is_jumping() and is_grounded():
		velocity.y += jump_velocity
		is_jumping_now = true
	
	# chůze
	var input_direction = get_direction()
	var direction = Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3.UP, yaw)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# otočení postavy směrem, kterým jde
		var target_angle = atan2(direction.x, direction.z)
		character_mesh.rotation.y = target_angle
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
#	
	# animace pohybŮ
	$AnimationTree.set("parameters/conditions/idle",  input_direction == Vector2.ZERO and is_grounded())
	$AnimationTree.set("parameters/conditions/walking", input_direction != Vector2.ZERO and is_grounded())
	$AnimationTree.set("parameters/conditions/jumping", not is_grounded())
	
	move(delta)
	is_jumping_now = false

# zachytávání vstupů na periferiích
func _input(event: InputEvent) -> void:
	# reakce na pohyb myší
	if controller_id == -1 and event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
	
	# reakce na pohyb pravého joysticku 
	elif controller_id >= 0:
		yaw -= Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_X) * sensitivity * 10
		pitch -= Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_Y) * sensitivity * 10
	
	rotate_camera()

# zpracování kolizí
func _on_body_entered(body: Node) -> void:
	if body is Area3D:
		print("Body entered: ", body.name)  # Debug: Zobrazí jméno objektu
		if is_watergirl:
			# Pokud je to Watergirl a diamant je "water_diamond", znič diamant
			if body.type == "water":  # Připojeno přes custom property
				body.queue_free()
				print("Watergirl picked up the blue diamond!")
		else:
			# Pokud je to Fireboy a diamant je "fire_diamond", znič diamant
			if body.type == "fire":  # Připojeno přes custom property
				body.queue_free()
				print("Fireboy picked up the red diamond!")

# pohyb v čase
func move(delta: float):
	step_cast.global_position.x = global_position.x + velocity.x * delta
	step_cast.global_position.z = global_position.z + velocity.z * delta
	
	if is_grounded():
		step_cast.target_position.y = -1.0
	else:
		step_cast.target_position.y = -0.45
	
	# zrušit skákání při přiblížení ke stěně
	var query = PhysicsShapeQueryParameters3D.new()
	query.exclude = [self]
	query.shape = step_cast.shape
	query.transform = step_cast.global_transform
	
	var result = get_world_3d().direct_space_state.intersect_shape(query, 1)
	if !result:
		step_cast.force_shapecast_update()
	
	step_cast.force_shapecast_update()
	if step_cast.is_colliding() && velocity.y <= 0:
		global_position.y = step_cast.get_collision_point(0).y
		velocity.y = 0
		grounded = true
	else:
		grounded = false

	move_and_slide()

# otočení kamery kamery
func rotate_camera():
	pitch = clamp(pitch, deg_to_rad(-89.0), deg_to_rad(89.0))
	yaw = wrap(yaw, 0.0, deg_to_rad(360))
	$Head.global_rotation = Vector3(pitch, yaw, 0)

# na základě hodnot ze vstupních periferií sestaví směrový vektor pohybu
func get_direction() -> Vector2:
	if controller_id >= 0:
		var x = Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_X)
		var y = Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_Y)
		
		var deadzone = 0.2
		var direction = Vector2(x if abs(x) > deadzone else 0.0, y if abs(y) > deadzone else 0.0)
		
		return direction.normalized()
	else:
		return Input.get_vector(walk_left_action, walk_right_action, walk_forward_action, walk_back_action)

# na základě hodnot ze vstupních periferií vyhodnotí, jestli má hráč skákat
func is_jumping() -> bool:
	if controller_id >= 0:
		return Input.is_joy_button_pressed(controller_id, JOY_BUTTON_A)
	else:
		return jump_action != "" and Input.is_action_just_pressed(jump_action)

# true, pokud je hráč uzeměný (nepadá, neskáče, nelétá, stojí na pevné zemi)
func is_grounded() -> bool:
	return grounded || is_on_floor()
