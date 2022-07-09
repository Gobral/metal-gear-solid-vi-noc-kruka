extends Node

export var aaa = 5

var input_map = null
var wasd_mem = [0, 0, 0, 0]


func push_input(input):
	input_map = input

func fetch_input():
	input_map = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
