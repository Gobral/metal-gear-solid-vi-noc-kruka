extends RigidBody2D


export var JUMP_GOOD = float(240000)
export var WALK_SPEED = float(750)
export var WALK_FORCE = float(500000)
export var FLOOR_FRICTION = float(300)
export var AIR_RESISTANCE = float(45)
export var FLY_COOLDOWN = float(-1)
export var FLY_MODIFIER = float(0.25)
export var FLY_BRAKE = float(1)

var facing_left = false
var last_jump = 0.0
var player_interaction_sprite: Sprite

#var size_to_bottom = 1
	
func movement(mem, now):
	if mem > 0:
		if now > 0:
			return 1
		elif now < 0:
			return 0
		else:
			return 1
	else:
		if now > 0:
			return 1
		else:
			return 0

func is_on_floor():
	var space_state = get_world_2d().direct_space_state
	var cs2 = get_node("CollisionShape2D")
	# use global coordinates, not local to node
	var size_to_bottom = cs2.shape.extents.y
	var width = cs2.shape.extents.x * 0.9875
	var start = global_position + Vector2(-width, size_to_bottom)
	var finish = global_position + Vector2(+width, size_to_bottom)
	var result = space_state.intersect_ray(start, finish, [self])
	if "position" in result:
		return true
	return false

func _ready():
	player_interaction_sprite = get_child(4).get_child(0).get_child(0)

func can_jump():
	if is_on_floor():
		return true
	if FLY_COOLDOWN < 0:
		return false
	return FLY_COOLDOWN < last_jump

func _physics_process(delta):
	var body = get_node(".")
	var controller = get_node("controller")
	var input_buffer = controller.input_buffer
	var input_map = controller.input_map
	var wasd_mem = controller.wasd_mem
	var initial_vel = linear_velocity
	var jump = false
	
	var wasd_from_buffer = [0,0,0,0]
	var wasd_sum = 0
	for im in input_buffer:
		if "wasd" in im:
			var wasd = im["wasd"]
			for i in range(4):
				wasd_from_buffer[i] += wasd[i]
				if wasd_from_buffer[i] != 0:
					wasd_sum += 1
	
	if input_map:
		jump = ("jump" in input_map and input_map["jump"])
		if wasd_sum > 0:
			for i in range(4):
				wasd_mem[i] = movement(wasd_mem[i], wasd_from_buffer[i])
	
	input_map = null
	controller.clear_buffer()
	controller.fetch_input()
	
	var v = Vector2(0, 0)
	v.x = wasd_mem[3] - wasd_mem[1]
	v.y = wasd_mem[2] - wasd_mem[0]
	if !facing_left and v.x < 0:
		facing_left = true
	elif facing_left and v.x > 0:
		facing_left = false
	

	var vd = v.dot(v)
	if (vd > 1.0):
		v = v/vd
	v.y = 0.0
	var onfloor = is_on_floor()
	var speed_cap_modifier = 1.0
	var fly_modifier = FLY_MODIFIER
	if v.x * initial_vel.x >= 0:
		var from = 0.75
		var to = 1.0
		var vel = abs(initial_vel.x) /  WALK_SPEED
		vel = (vel - from) / (to - from)
		vel = 1-vel
		speed_cap_modifier = clamp(vel, 0, 1)
	else:
		fly_modifier = FLY_BRAKE
	if onfloor:
		fly_modifier = 1.0
	var walk_force = delta * v * WALK_FORCE * fly_modifier * speed_cap_modifier
	body.apply_central_impulse(walk_force)
	
	var af = -body.linear_velocity.x * 15.0
	af = mass * delta * clamp(af, -FLOOR_FRICTION, FLOOR_FRICTION)
	if onfloor:
		body.apply_central_impulse(Vector2(af, 0))
		
	var sprite = get_node("sprite")
	var leb = get_node("leb")

	# animationez 
	if wasd_mem[1] or wasd_mem[3]:
		sprite.play("walk")
		leb.play("walk")
	else:
		sprite.play("idle")
		leb.play("idle")
	
	sprite.flip_h = facing_left
	leb.flip_h = facing_left
	
	if jump and can_jump():
		apply_central_impulse(Vector2(0, -JUMP_GOOD))
		last_jump = 0
	last_jump += delta
	
	var resistance_force = -initial_vel * AIR_RESISTANCE * delta
	if mass < 1:
		resistance_force *= mass
	apply_central_impulse(resistance_force)
	
	
func _on_InteractionArena_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("PierogArea"):
		player_interaction_sprite.visible = true


func _on_InteractionArena_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("PierogArea"):
		player_interaction_sprite.visible = false
