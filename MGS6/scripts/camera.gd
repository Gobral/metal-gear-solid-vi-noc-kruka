extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var the_zubr
var the_slowik


# Called when the node enters the scene tree for the first time.
func _ready():
	the_zubr = get_node("../zubr")
	the_slowik = get_node("../slowik")
	pass # Replace with function body.

func _input(event):
	for aa in [ [ the_zubr, "zubr" ], [ the_slowik, "slowik" ] ]:
		var c = aa[0]
		var name = aa[1]
		if not c:
			continue
		var input = {}
		var wasd = [0, 0, 0, 0]
		var i = 0
		for dir in [ "up", "left", "down", "right" ]:
			var action = "%s_%s" % [name, dir]
			if event.is_action_pressed(action):
				wasd[i] += 1
			if event.is_action_released(action):
				wasd[i] -= 1
			i += 1			
		input["wasd"] = wasd
		if event.is_action_pressed("%s_jump" % name):
			input["jump"] = true
		c.get_node("controller").push_input(input)
		

func pass_controls():
	
	pass

func set_camera_position():
	var t = Vector2(0, 0)
	var num = 0
	for c in [ the_zubr, the_slowik ]:
		if c:
			num += 1
			t += c.get_global_position()
	if num > 0:
		t /= num
	set_global_position(t)
	

func _process(_delta):
	pass_controls()
	set_camera_position()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
