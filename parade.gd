extends Node2D

var minawan_group = preload("res://minawan_group.tscn")
var all_minawan: Array = []
var last_group: Array = [
	load("res://minasonas/CJwan.png"),
	load("res://minasonas/Kaliwan.png"),
	load("res://minasonas/jenwan.png"),
	load("res://minasonas/Jokerwan.png"),
]

var chants: Array = [
	["Man I love Cerber", load("res://emotes/MILC.png")],
	["MOGU MOGU", load("res://emotes/party.webp")],
	["Man I love Slugber", load("res://emotes/MILS.webp")],
	["Lore video\npremiere NOW!", load("res://emotes/YAY.webp")],
	["Man I love Orber", load("res://emotes/MILO.png")],
	["WAN WAN WAN WAN", load("res://emotes/WANWAN.png")],
	["Man I love Ember", load("res://emotes/MILE.webp")],
	["AWOOOOOOOOOO", load("res://emotes/awoo.png")],
	["PRAISE THE ORBER", load("res://emotes/flushed.webp")],
	["PEETZA!", load("res://emotes/Munch.webp")],
	["WHERE IS CERBER", load("res://emotes/WHERE.png")],
	["Pay your taxes!", load("res://emotes/Pet.webp")],
	["THEY ARE\nCHOCOLATE", load("res://emotes/Smug.webp")],
	["Stay away\nnoise monster", load("res://emotes/Angy.webp")],
	["MINAWAN, ASSEMBLE", load("res://emotes/LETSGO.webp")],
	["Ara Ara~", load("res://emotes/Blushed.webp")],
	["SPOIL THE DAWG!", load("res://emotes/puddle.webp")],
]
var current_chant: int = 0

func _init() -> void:
	var path = "res://minasonas/"
	for fname in DirAccess.get_files_at(path):
		var import_name: String = fname.trim_suffix(".import")
		if fname.ends_with(".import") and ResourceLoader.exists(path + import_name):
			print_debug("Found %s" % import_name)
			if fname.begins_with("CJwan") or fname.begins_with("jenwan") or fname.begins_with("Kaliwan") or fname.begins_with("Jokerwan"):
				print_debug("--- Skipping %s" % import_name)
				continue
			else:
				var minawan = load(path + import_name)
				all_minawan.append(minawan)

func _process(_delta: float) -> void:
	if not OS.has_feature("web"):
		if Input.is_action_just_pressed("ui_accept"):
			Engine.time_scale = 5.0 if Engine.time_scale == 1.0 else 1.0

		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _ready() -> void:
	$Control2.modulate.a = 0
	$Control2/Label.modulate.a = 0
	$Control2/Live.modulate.a = 0

	randomize()
	all_minawan.shuffle()
	all_minawan = _chunk(all_minawan, 5)
	all_minawan.append(last_group)

func spawn_next_minawan() -> void:
	if all_minawan.size() == 0:
		_closing_parade()
		return

	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout

	var instance = minawan_group.instantiate()
	instance.sprites = all_minawan.pop_front()
	instance.position.y += randf_range(-90, 69)
	
	instance.chant = chants[current_chant]
	current_chant = (current_chant + 1) % chants.size()
	
	if all_minawan.size() == 0:
		instance.rickroll = true
	add_child(instance)
	
	print_debug("%s chunks, %s chants left" % [all_minawan.size(), chants.size() - current_chant])

func _chunk(array: Array, chunkSize: int) -> Array:
	array = array.duplicate()
	var chunks = []
	var i = 0
	while i < array.size():
		chunks.append(array.slice(i, i + chunkSize))
		i += chunkSize

	return chunks

func _on_button_pressed() -> void:
	$BGM.play()

	%CenterContainer.queue_free()
	%GooberHere.queue_free()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	await get_tree().create_timer(0.5).timeout

	var tween = get_tree().create_tween()
	tween.tween_property($Control/ColorRect, "modulate:a", 0, 9.5)
	await tween.finished

	$Control.queue_free()
	spawn_next_minawan()

func _closing_parade() -> void:
	print_debug("Closing parade")
	await get_tree().create_timer(4.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($Control2, "modulate:a", 1.0, 10.0)
	await tween.finished

	tween = get_tree().create_tween()
	tween.parallel().tween_property($Control2/Label, "modulate:a", 1.0, 5.0)
	tween.parallel().tween_property($Control2/Live, "modulate:a", 1.0, 5.0)
