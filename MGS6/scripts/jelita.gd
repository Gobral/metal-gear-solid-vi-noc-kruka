extends Node2D

onready var pierozi = get_node("pierozi")
onready var zubr = get_node("zubr")
onready var sowik = get_node("slowik")
onready var lina = get_node("Line2D")
var zubr_zwykly = load("res://scripts/char.gd")
var zubr_wspinaczkowy = load("res://scripts/wspinak.gd")
var hak_u_sowika = true
var wspinanie = false
var do_pierozka = Vector2(0, 0)

func _ready():
	var cscript = load("res://scripts/pierogus.gd")
	for p in pierozi.get_children():
		p.set_script(cscript)

func _physics_process(delta):
	var zubrowe_pierogi = zubr.get_colliding_bodies()
	var sowikowe_pierogi = sowik.get_colliding_bodies()
	
	for p in zubrowe_pierogi:
		if p.get_parent().get_name() == "pierozi": p.startuj()
		if not wspinanie: zubr.set_script(zubr_zwykly)
	
	for p in pierozi.get_children():
		if p.leci: spaduwa(p.get_node("AnimatedSprite"))

	lina.set_point_position(1, zubr.global_position)
		
	if hak_u_sowika:
		lina.set_point_position(0, sowik.global_position)
		for p in sowikowe_pierogi:
			if p.get_parent().get_name() == "pierozi": 
				hak_u_sowika = false
				wspinanie = true
				zubr.gravity_scale = 0
				zubr.set_script(zubr_wspinaczkowy)
				do_pierozka = p.get_node("AnimatedSprite").global_position
				lina.set_point_position(0, do_pierozka)
	elif wspinanie:
		zubr.global_position = zubr.global_position.move_toward(do_pierozka, 10)
		if do_pierozka.distance_to(zubr.global_position) < 1: 
			wspinanie = false
			zubr.gravity_scale = 16
		
	
		
func spaduwa(nodzik):
	nodzik.translate(Vector2(0,4))
