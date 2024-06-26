extends StaticBody2D

var leci = false
var wspina = false
var aktywowany = false
var timer = 0
const time_for_spaduwing = 10
const do_usuniecia = 20

var player_interaction_sprite: Sprite
var interaction_node: Node2D
var pokaz_hint = false
export var interaction_radius = 10

func _ready():
	player_interaction_sprite = get_child(2).get_child(0).get_child(0)
	
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
	elif pokaz_hint:
		przesun_interakcje()
		
	
func startuj():
	aktywowany = true
	
func przesun_interakcje():
	player_interaction_sprite.set_offset((interaction_node.get_global_position() - get_global_position()) * interaction_radius)

func interaction_sprite_show(area):
	interaction_node = area.get_parent()
	player_interaction_sprite.visible = true
	pokaz_hint = true

func interaction_sprite_hide():
	pokaz_hint = false
	player_interaction_sprite.visible = false
	player_interaction_sprite.set_offset(Vector2( 0, 0 ))
	
func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("SlowikArea"):
		interaction_sprite_show(area)		

func _on_Area2D_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("SlowikArea"):
		interaction_sprite_hide()
