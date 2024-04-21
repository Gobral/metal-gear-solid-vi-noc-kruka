extends Node

export var aaa = 5

var input_map = null
var wasd_mem = [0, 0, 0, 0]
var input_buffer = []

func push_input(input):
	input_map = input
	input_buffer.append(input)

func fetch_input():
	input_map = null
	
func clear_buffer():
	input_buffer.clear()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


