extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var on_lata = false

var input_map = null
#var walk_vector = Vector2(0, 0)
var wasd_mem = [0, 0, 0, 0]

func push_input(input):
	input_map = input

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var body = get_node("..")
	if input_map:
		if "jump" in input_map and input_map["jump"]:
			body.linear_velocity.y -= 100
		if "wasd" in input_map:
			var wasd = input_map["wasd"]
			for i in range(4):
				wasd_mem[i] = wasd[i] + wasd_mem[i]
	input_map = null
	
	var v = Vector2(0, 0)
	v.x = wasd_mem[3] - wasd_mem[1]
	v.y = wasd_mem[2] - wasd_mem[0]
	
	var vd = v.dot(v)
	if (vd > 1.0):
		v = v/vd
	v.y = 0.0
	body.linear_velocity += v * 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
