extends StaticBody2D

var leci = false
var wspina = false


func _ready():
	pass # Replace with function body.
	
func startuj():
	leci = true
	get_node("AnimatedSprite").play("spadanie")
	get_node("CollisionShape2D").disabled = true
