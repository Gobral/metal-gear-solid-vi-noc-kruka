extends Node2D



the_zubr = {
	"hp" = 100.0,
	"name" = "zubr",
}

the_slowik = {
	"hp" = 100.0
	"name" = "slowik",
}



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	for who in [ the_zubr, the_slowik ]:
		if event.is_action_pressed("%s_up" % who["name"]):
			pass
		elif event.is_action_pressed("%s_down" % who["name"]):
			pass
		elif event.is_action_pressed("%s_right" % who["name"]]):
			pass
		elif event.is_action_pressed("%s_left" % who["name"]]):
			pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





