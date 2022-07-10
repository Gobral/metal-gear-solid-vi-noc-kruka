extends Node2D

onready var pierozi = get_node("pierozi")

func _ready():
	var cscript = load("res://scripts/pierogus.gd")
	for p in pierozi.get_children():
		p.set_script(cscript)
		p.startuj()

func _physics_process(delta):
	for p in pierozi.get_children():
		if p.leci: spaduwa(p.get_node("AnimatedSprite"))
		
func spaduwa(nodzik):
	nodzik.translate(Vector2(0,2))
