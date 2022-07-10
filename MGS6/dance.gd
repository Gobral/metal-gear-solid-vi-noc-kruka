extends Node2D

export(Array) var arrow_textures

const arrow_template = preload("arrow.tscn")

var hp = 100.0

var progress = 0

func spawn_strzalka(ktora):
	var arrow = arrow_template.instance()
	add_child(arrow)
	arrow.aa = arrow_textures[ktora]
	arrow.aaa = arrow_textures[ktora+4]
	arrow.numer = ktora
	arrow.global_position.x = 360 + ktora * 110

func destroy_arrow(ktora):
	var space_state = get_world_2d().direct_space_state
	var cs2 = get_node("destroy/CollisionShape2D")
	var aaa = Physics2DShapeQueryParameters.new()
	aaa.set_shape(cs2.shape)
	aaa.transform = cs2.get_global_transform()
	#aaa.exclude = [ get_node("destroy") ]
	var result = space_state.intersect_shape(aaa)
	var hit = false
	for a in result:
		if a.collider.numer == ktora:
			a.collider.destroy(true)
			hp = min(hp + 10.0, 100.0)
			hit = true
			break
	if !hit:
		hp -= 15.0
			
	#if "position" in result:
	#	return true
	#return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
		if event.is_action_pressed("slowik_up"):
			destroy_arrow(2)
		elif event.is_action_pressed("slowik_down"):
			destroy_arrow(1)
		elif event.is_action_pressed("zubr_right"):
			destroy_arrow(3)
		elif event.is_action_pressed("zubr_left"):
			destroy_arrow(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if randf() < 0.01:
		spawn_strzalka(int(clamp(randf()*4, 0, 3)))
	var space_state = get_world_2d().direct_space_state
	var cs2 = get_node("skucha/CollisionShape2D")
	var aaa = Physics2DShapeQueryParameters.new()
	aaa.set_shape(cs2.shape)
	aaa.transform = cs2.get_global_transform()
	#aaa.exclude = [ get_node("destroy") ]
	var result = space_state.intersect_shape(aaa)
	for a in result:
		if a.collider.numer >= 0:
			a.collider.destroy(false)
			hp -= 10.0
			
	get_node("hp").scale.y = clamp(hp, 0.0, 100.0) * 0.02
	
	if hp < 0.0:
		queue_free()
	
	if progress >= 75:
		queue_free()
	



