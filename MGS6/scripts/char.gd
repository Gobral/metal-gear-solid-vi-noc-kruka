extends RigidBody2D


export var JUMP_GOOD = float(150000)
export var WALK_SPEED = float(20)
export var AIR_RESISTANCE = float(45)
export var FLY_COOLDOWN = -1

var facing_left = false
var last_jump = 0

	
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
	return true

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
	
	print("%s - %s" % [ get_node("..").get_path(), wasd_mem])
	
	var vd = v.dot(v)
	if (vd > 1.0):
		v = v/vd
	v.y = 0.0
	body.linear_velocity += v * WALK_SPEED
	
	var sprite = get_node("sprite")
	sprite.flip_h = facing_left
	
	if jump and can_jump():
		apply_central_impulse(Vector2(0, -JUMP_GOOD))
		last_jump = FLY_COOLDOWN
	last_jump -= delta
	
	var resistance_force = -initial_vel * AIR_RESISTANCE * delta
	if mass < 1:
		resistance_force *= mass
	apply_central_impulse(resistance_force)
	

