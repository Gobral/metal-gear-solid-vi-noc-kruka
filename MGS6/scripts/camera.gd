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
	

func _process(delta):
	pass_controls()
	set_camera_position()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
