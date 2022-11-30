extends StaticBody2D

var leci = false
var wspina = false
var aktywowany = false
var timer = 0
const time_for_spaduwing = 10
const do_usuniecia = 20

func _ready():
	pass # Replace with function body.
	
func _init():
	set_process(true)
	
func _process(delta):
	if aktywowany:
		timer += delta
		if !leci and timer > time_for_spaduwing:
			leci = true
			get_node("AnimatedSprite").play("spadu")
			get_node("CollisionShape2D").disabled = true
		elif leci and timer > do_usuniecia:
			get_parent().remove_child(self)
		
	
func startuj():
	aktywowany = true

