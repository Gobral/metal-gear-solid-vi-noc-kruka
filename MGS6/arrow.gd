extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Texture) var aa
export(Texture) var aaa

var numer = 0
var time_to_disappear = -1

# Called when the node enters the scene tree for the first time.
func _process(delta):
	get_node("Sprite").texture = aa if time_to_disappear < 0.0 else aaa

func _physics_process(delta):
	if time_to_disappear >= 0.0:
		time_to_disappear -= delta
		if time_to_disappear < 0.0:
			get_node("..").progress += 1
			self.queue_free()
	else:
		global_position.y += 2.4
	
func destroy(trace):
	if !trace:
		self.queue_free()
		get_node("..").progress += 1
	time_to_disappear = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
