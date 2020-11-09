extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var LIMIT = 100
var current_text = ''
var cursor_line = 0
var cursor_column = 0
var dark = true
var card = preload("res://card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_ua_vids()
	MemoirEdit = $VBoxContainer/HSplitContainer4/NinePatchRect/TextEdit
	
func load_ua_vids():
	var f = File.new()
	if f.file_exists(OS.get_executable_path()+"/ShorterUA.txt"):
		f.open(OS.get_executable_path()+"/ShorterUA.txt", File.READ)
	else:
		f.open("res://ShorterUA.txt",File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		line += " "
		$VBoxContainer/HSplitContainer/OptionButton.add_item(line)
		index += 1
	$VBoxContainer/HSplitContainer/OptionButton.select($VBoxContainer/HSplitContainer/OptionButton.get_item_count()-1)
	f.close()
	return
var MemoirEdit

func _on_LineEdit_text_changed(new_text):
	$VBoxContainer/HSplitContainer2/LineEdit.text = new_text.to_upper()
	$VBoxContainer/HSplitContainer2/LineEdit.caret_position = new_text.length()
func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().set_input_as_handled()
		MemoirEdit.insert_text_at_cursor("")

func _on_TextEdit_text_changed():
	var new_text : String = MemoirEdit.text
	if new_text.length() > LIMIT:
		MemoirEdit.text = current_text
		# when replacing the text, the cursor will get moved to the beginning of the
		# text, so move it back to where it was 
		MemoirEdit.cursor_set_line(cursor_line)
		MemoirEdit.cursor_set_column(cursor_column)

	current_text = MemoirEdit.text
	# save current position of cursor for when we have reached the limit
	cursor_line = MemoirEdit.cursor_get_line()
	cursor_column = MemoirEdit.cursor_get_column()

func _process(delta):
	if (dark):
		$VBoxContainer/HSplitContainer5/Button.text = "THEME: UNUS"
	else:
		$VBoxContainer/HSplitContainer5/Button.text = "THEME: ANNUS"

func _on_Button_pressed():
	dark = !dark
	



func Proceed():
	var instance = card.instance()
	if $VBoxContainer/HSplitContainer2/LineEdit.text!="":
		instance.username = $VBoxContainer/HSplitContainer2/LineEdit.text
	var epOpt = $VBoxContainer/HSplitContainer/OptionButton
	if str(epOpt.items[epOpt.selected])!="[Object:null]":
		instance.episode = str(epOpt.get_item_text(epOpt.selected))
	instance.dark = dark
	if MemoirEdit.text != "":
		instance.memoir = MemoirEdit.text
	add_child(instance)
	instance.takeScreenshot()
	yield(instance,"finishedShot")
	instance.queue_free()

