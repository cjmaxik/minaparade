extends Node2D

var sprites: Array = []
var chant: Array = []
var rickroll: bool = false

func _ready() -> void:
	$Rickroll.visible = rickroll
	$Balloon0.visible = false
	$Balloon3.visible = false

	for i in range(5):
		get_node("Minawan%s" % i).visible = false

	for i in range(sprites.size()):
		var minawan = get_node("Minawan%s" % i)
		minawan.texture = sprites[i]
		minawan.visible = true

		var shadow = get_node("MinawanShadow").duplicate()
		shadow.visible = true
		shadow.texture = sprites[i]
		shadow.position = Vector2(0, minawan.texture.get_size().y / 3)
		minawan.add_child(shadow)

		$Banner/Label.text = chant[0]

		if i == 0:
			$Balloon0.visible = true
			$Balloon0/Emote.texture = chant[1]
		elif i == 3:
			$Balloon3.visible = true
			$Balloon3/Emote.texture = chant[1]
		
	$GroupPlayer.play("moving")

func spawn_next_minawan() -> void:
	get_parent().spawn_next_minawan()
