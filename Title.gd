extends Node

var timer = 0

export(Gradient) var curve

func _process(delta):
	timer += delta
	if timer > 2:
		get_tree().change_scene("res://Main.tscn")
	$RichTextLabel.modulate = curve.interpolate(timer / 2.0)
