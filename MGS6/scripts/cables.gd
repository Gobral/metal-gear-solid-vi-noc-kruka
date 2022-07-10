extends Node2D


const win = preload("../win.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene


#
# od -1 do -5 miejsca podstawowe kabli
# 0  - 5 miejsca przy gniazdach

# to the outside sockets and to the inside pyta


var p = [ 1, 0, 3, 2, 4 ]

var zubr = {
	"name": "zubr",
	"outside": "left",
	"inside": "right",
	"cables": [ -1, -1, -1, -1, -1 ],
	"hand": -1,
	"picked": false
}

var slowik = {
	"name": "slowik",
	"outside": "right",
	"inside": "left",
	"cables": [ -1, -1, -1, -1, -1 ],
	"hand": -1,
	"picked": false
}

func compare_cable(hand, c):
	return hand == c or (hand < 0 and c < 0)

func hand_up(who):
	var h = who["hand"]
	if h < 0:
		if who["picked"]:
			return
		while true:
			h += 1
			if h == 0:
				return
			if who["cables"][-h-1] == -1:
				who["hand"] = h
				return
	else:
		if who["picked"]:
			while true:
				h+= 1
				if h > len(p):
					return
				elif h in who["cables"]:
					continue
				for i in len(who["cables"]):
					if compare_cable(who["hand"], who["cables"][i]):
						who["cables"][i] = h
						break
				who["hand"] = h
				return
		else:
			while true:
				h+= 1
				if h > len(p):
					return
				elif h in who["cables"]:
					who["hand"] = h
					return

func hand_down(who):
	var h = who["hand"]
	if h < 0:
		if who["picked"]:
			return
		while true:
			h -= 1
			if -h > len(p):
				return
			if who["cables"][-h-1] == -1:
				who["hand"] = h
				return
	else:
		if who["picked"]:
			while true:
				h-= 1
				if h < 0:
					return
				elif h in who["cables"]:
					continue
				for i in len(who["cables"]):
					if compare_cable(who["hand"], who["cables"][i]):
						who["cables"][i] = h
				who["hand"] = h
				return
		else:
			while true:
				h-= 1
				if h < 0:
					return
				elif h in who["cables"]:
					who["hand"] = h
					return
func hand_outside(who):
	var hand = who["hand"]
	if hand >= 0:
		return
	if who["picked"]:
		var freee = 1
		while true:
			if freee in who["cables"]:
				freee += 1
			else:
				break
		if who["cables"][-hand-1] == -1:
			who["cables"][-hand-1] = freee
		who["hand"] = freee
	else:
		var notfree = 0
		while true:
			if notfree in who["cables"]:
				break
			if notfree > len(who["cables"]):
				return
			notfree += 1
		who["hand"] = notfree
	
func hand_inside(who):
	var hand = who["hand"]
	if hand < 0:
		return
	if who["picked"]:
		var cable = 0
		for i in len(who["cables"]):
			if who["cables"][i] == hand:
				who["cables"][i] = -1
				cable = i+1
		who["hand"] = -cable
	else:
		var notfree = 1
		for i in len(who["cables"]):
			if who["cables"][i] == -1:
				notfree = i
				break
		who["hand"] = -notfree-1
	
func pick(who):
	var hand = who["hand"]
	var cables = who["cables"]
	for cable in cables:
		if compare_cable(hand, cable):
			who["picked"] = !who["picked"]
			return
		
func _ready():
	refresh_cahnges()

func is_diode_on():
	var z = -1
	var s = -1
	for i in len(zubr["cables"]):
		if zubr["cables"][i] == 0:
			z = i
	for i in len(slowik["cables"]):
		if slowik["cables"][i] == 0:
			s = i
	return z >= 0 and s >= 0 and s == p[z]

func _input(event):
	for who in [ zubr, slowik ]:
		
		if event.is_action_pressed("%s_up" % who["name"]):
			hand_up(who)
		elif event.is_action_pressed("%s_down" % who["name"]):
			hand_down(who)
		elif event.is_action_pressed("%s_%s" % [who["name"], who["outside"]]):
			hand_outside(who)
		elif event.is_action_pressed("%s_%s" % [who["name"], who["inside"]]):
			hand_inside(who)
		elif event.is_action_pressed("%s_activate" % who["name"]):
			pick(who)
			
	refresh_cahnges()
	
func refresh_cahnges():
	for who in [ zubr, slowik ]:
		var name = who["name"]
		var hand_sprite = get_node("hands/%s" % name)
		var hand = who["hand"]
		if hand > 0:
			hand_sprite.global_position = get_node("sockets/%s%s" % [name[0], hand]).default_position + Vector2(0, -30)
		elif hand < 0:
			hand_sprite.global_position = get_node("cables/%s%s" % [name[0], -hand]).default_position + Vector2(0, -30)
		else:
			hand_sprite.global_position = get_node("sockets/%stest" % name[0]).default_position + Vector2(0, -30)
		if who["picked"]:
			hand_sprite.scale = Vector2(2,2)
		else:
			hand_sprite.scale = Vector2(1,1)
			
		var cables = who["cables"]
		for ii in range(5):
			var i = ii+1
			var cable = get_node("cables/%s%s" % [name[0], i])
			if cables[ii] == -1:
				cable.global_position = cable.default_position
			elif cables[ii] == 0:
				cable.global_position = get_node("sockets/%stest" % name[0]).default_position + Vector2(0, -10)
			else:
				cable.global_position = get_node("sockets/%s%s" % [name[0], cables[ii]]).default_position + Vector2(0, -10)
		
		var all_good = true
		for i in range(5):
			var wirez = zubr["cables"][i]
			var wires = slowik["cables"][p[i]]
			if wirez == wires and wirez > 0:
				pass
			else:
				all_good = false
		if all_good:
			var w = win.instance()
			get_node("..").add_child(w)
			queue_free()
			
	var diode = get_node("diode")
	diode.texture = diode.texture_while_on if is_diode_on() else diode.texture_while_off



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
