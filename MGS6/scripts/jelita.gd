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
var wskok_na_pieroga = Vector2(0, 0)
var pierogus_shape = null

func _ready():
	var cscript = load("res://scripts/pierogus.gd")
		

func _physics_process(_delta):
	var zubrowe_pierogi = zubr.get_colliding_bodies()
	var sowikowe_pierogi = sowik.get_child(4).get_overlapping_areas()
	
	for p in pierozi.get_children():
		if p.leci: spaduwa(p.get_node("AnimatedSprite"))

	lina.set_point_position(1, zubr.global_position)
		
	if hak_u_sowika and Input.is_action_just_pressed("slowik_activate"):
		lina.set_point_position(0, sowik.global_position)
		for sp in sowikowe_pierogi:
			var p = sp.get_parent()
			print(p.get_parent())
			if p.get_parent().get_name() == "pierozi": 
				hak_u_sowika = false
				wspinanie = true
				zubr.gravity_scale = 0
				zubr.set_script(zubr_wspinaczkowy)
				var tempp = p.get_node("AnimatedSprite").global_position
				do_pierozka = Vector2(tempp.x, tempp.y - 220)
				lina.set_point_position(0, tempp)
				wskok_na_pieroga = tempp
				pierogus_shape = p
				
	elif wspinanie:
		zubr.global_position = zubr.global_position.move_toward(do_pierozka, 10)
		if do_pierozka.distance_to(zubr.global_position) < 1: 
			wspinanie = false
			zubr.gravity_scale = 16
			zubr.get_node("CollisionShape2D").disabled = false 
	
	else:
		for p in zubrowe_pierogi:
			if p.get_parent().get_name() == "pierozi": p.startuj()
			if not wspinanie: zubr.set_script(zubr_zwykly)
		lina.set_point_position(0, zubr.global_position)
		
	
		
func spaduwa(nodzik):
	nodzik.translate(Vector2(0,4))
