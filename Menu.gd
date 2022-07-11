extends Control

export(String, FILE, "*.tscn") var fase1
onready var som = $AudioStreamPlayer

func _on_Button_button_down():
	som.play()


func _on_Button2_button_down():
	som.play()


func _on_Button_button_up():
	get_tree().change_scene(fase1)


func _on_Button2_button_up():
	get_tree().quit()

