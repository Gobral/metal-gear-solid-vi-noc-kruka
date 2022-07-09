extends RigidBody2D


export var JUMP_GOOD = float(150000)
export var WALK_SPEED = float(25)
export var AIR_RESISTANCE = float(45)
export var FLY_COOLDOWN = float(-1)

var facing_left = false
var last_jump = 0.0
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

func can_jump():
	if is_on_floor():
		return true
	if FLY_COOLDOWN < 0:
		return false
	return FLY_COOLDOWN < last_jump

func _physics_process(delta):
	var body = get_node(".")
	var controller = get_node("controller")
	var input_map = controller.input_map
	var wasd_mem = controller.wasd_mem
	controller.fetch_input()
	var initial_vel = linear_velocity
	var jump = false
	if input_map:
		jump = ("jump" in input_map and input_map["jump"])
		if "wasd" in input_map:
			var wasd = input_map["wasd"]
			for i in range(4):
				wasd_mem[i] = movement(wasd_mem[i], wasd[i])
	input_map = null
	
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
	var no_fly_modifier = 1.0
	var onfloor = is_on_floor()
	if FLY_COOLDOWN < 0.0 and !onfloor:
		no_fly_modifier = 1.0/6.0
	body.linear_velocity += v * WALK_SPEED * no_fly_modifier
	
	var max_additional_friction = 600.0
	var af = -body.linear_velocity.x * 15.0
	af = mass * delta * clamp(af, -max_additional_friction, max_additional_friction)
	if onfloor:
		body.apply_central_impulse(Vector2(af, 0))
		
	
	var sprite = get_node("sprite")
	sprite.flip_h = facing_left
	
	if jump and can_jump():
		apply_central_impulse(Vector2(0, -JUMP_GOOD))
		last_jump = 0
	last_jump += delta
	
	var resistance_force = -initial_vel * AIR_RESISTANCE * delta
	if mass < 1:
		resistance_force *= mass
	apply_central_impulse(resistance_force)
	
