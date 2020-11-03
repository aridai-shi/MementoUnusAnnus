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
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
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
	img.save_png(OS.get_user_data_dir()+"/"+username+"Memoir.png")
	var newImage = img.save_png_to_buffer()
	
	var urlString = "/v0/b/unus-annus-memoir-database.appspot.com/o?uploadType=media&name="+username.replace(" ","")+"Memoir"
	print (urlString)
	_make_image_request(urlString,newImage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _make_image_request(url, data_to_send):
	# Add 'Content-Type' header:
	var headers = ["Content-Type: image/png"]
	var reqClient = HTTPClient.new()
	reqClient.connect_to_host("www.firebasestorage.googleapis.com",-1,true)
	while(reqClient.get_status() == HTTPClient.STATUS_CONNECTING or reqClient.get_status() == HTTPClient.STATUS_RESOLVING):
		reqClient.poll()
		print("Connecting...")
		OS.delay_msec(300)
	if reqClient.get_status()==HTTPClient.STATUS_SSL_HANDSHAKE_ERROR:
		print("Handshake error. Bonk aridai over it. Restarting")
		_make_image_request(url,data_to_send)
		return
	var result = reqClient.request_raw(HTTPClient.METHOD_POST,url,headers,data_to_send)
	if result!=0:
		print("Error Code: " + str(result) + " Restarting...")
		_make_image_request(url,data_to_send)
	emit_signal("finishedShot")
