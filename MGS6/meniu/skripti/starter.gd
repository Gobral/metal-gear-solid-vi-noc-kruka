extends TextureButton

onready var player = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AudioStreamPlayer")
func _ready():
	pass
	
func _pressed():
	var next_level_res = load("res://intro.tscn")
	var next_level = next_level_res.instance()
