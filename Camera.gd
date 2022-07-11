extends Camera2D

onready var topLeft = $Limits/topLeft
onready var bottomRight = $Limits/bottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_bottom = bottomRight.position.x

