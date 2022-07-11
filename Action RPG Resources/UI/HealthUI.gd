extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFULL = $HeartUIFull
onready var heartUIEMPTY = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFULL != null:
		heartUIFULL.rect_size.x = hearts * 15


func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartUIEMPTY != null:
		heartUIEMPTY.rect_size.x = hearts * 15


func _ready():
	self.max_hearts = StatusJogador.max_health
	self.hearts = StatusJogador.health
	StatusJogador.connect("health_changed", self, "set_hearts")
	StatusJogador.connect("max_health_changed", self, "set_max_hearts")

