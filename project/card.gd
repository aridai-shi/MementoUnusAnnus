extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var username = "THE VIEWER"
var episode = "ACCEPTING THE TRUTH"
var memoir = "I accepted the Truth"
var dark = false
signal finishedShot
func _ready():
	if dark:
		$NinePatchRect.modulate = Color("#303030")
		$Details.add_color_override("font_color",Color("#E5E5E5"))
		$Logo.add_color_override("font_color",Color("#E5E5E5"))
		$Memento.add_color_override("font_color",Color("#E5E5E5"))
		$Question.add_color_override("font_color",Color("#E5E5E5"))
	else:
		$NinePatchRect.modulate = Color("#E5E5E5")
		$Details.add_color_override("font_color",Color("#303030"))
		$Logo.add_color_override("font_color",Color("#303030"))
		$Memento.add_color_override("font_color",Color("#303030"))
		$Question.add_color_override("font_color",Color("#303030"))
	$Memento.text = memoir
	$Details.text = "NAME: " + username + "\nFAV. VIDEO: " + episode
# Called when the node enters the scene tree for the first time.
func takeScreenshot():
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("Memoirs")
	var old_clear_mode = get_viewport().get_clear_mode()
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Let two frames pass to make sure the screen was captured.
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_data()
	# restore the previous value, as some part wont redraw after...
	img.flip_y()
	get_viewport().set_clear_mode(old_clear_mode)
#	img.save_png(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)+"/"+username+"Memoir.png")
	img.save_png("user://Memoirs/"+username+"Memoir.png")
	OS.shell_open("user://Memoirs/")
	emit_signal("finishedShot")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
