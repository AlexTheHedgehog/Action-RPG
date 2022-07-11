extends Area2D

onready var stats = StatusJogador
onready var piscando = $AnimationPlayer
onready var som = $AudioStreamPlayer

func _ready():
	piscando.play("piscando")

func _on_heartItem_body_entered(_body):
	som.play()
	if stats.health < stats.max_health:
		stats.health += 1


func _on_AudioStreamPlayer_finished():
	queue_free()
