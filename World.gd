extends Node2D

onready var stats = StatusJogador
onready var timer = $morte
onready var musica = $Musica
export(String, FILE, "*.tscn") var menu

func _ready():
	stats.connect("no_health", self, "morte")


func morte():
	musica.stop()
	timer.start(3)


func _on_morte_timeout():
	get_tree().change_scene(menu)
	stats.health = stats.max_health
