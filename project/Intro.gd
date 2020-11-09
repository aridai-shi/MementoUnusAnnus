extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var introString = "IF YOU FIND THE LIST OF EPISODES IS OUTDATED, DOWNLOAD THE LATEST ShorterUA.txt \n[i] [url=https://raw.githubusercontent.com/aridai-shi/MementoUnusAnnus/main/project/ShorterUA.txt]BY CLICKING HERE AND RIGHT-CLICK/'Save As' IN THE GAME'S FOLDER[/url][/i] \n OR UPDATE  IT MANUALLY! \n ALSO SHARE THE MEMOIRS WITH #MementoUnusAnnus AND LINK TO THE GITHUB PAGE SO MORE PEOPLE CAN SEE THIS.\n \n"
	var randStrings =[
		"MEMENTO MORI.",
		"IT WAS FUN WHILE IT LASTED.",
		"HAVE FUN REMINISCING.",
		"THANK YOU, MARK AND ETHAN."
	]
	randomize()
	$Label.bbcode_text="[center]"+introString+randStrings[randi()%randStrings.size()]+"\n PRESS SPACE TO START.[/center]"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Node2D.tscn")


func _on_Label_meta_clicked(meta):
	OS.shell_open(meta)
