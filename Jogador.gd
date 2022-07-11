extends KinematicBody2D

const DANO_SOM = preload("res://Action RPG Resources/Music and Sounds/DANO_SOM.tscn")
export var MOMENTUM := 500
export var MAX_SPEED := 80
export var FRICTION := 500
export var ROLL_SPEED := 1.5

enum {
	MOVER,
	ROLAR,
	ATACAR
}

var motion := Vector2.ZERO
var state = MOVER
var direction = "baixo"
var roll_vector = Vector2.LEFT
var stats = StatusJogador
onready var ATAQUE_SOM = $ATAQUE_SOM
onready var ROLAR_SOM = $ROLAR_SOM
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var piscando = $piscando

func _ready():
	randomize()
	piscando.play("stop")
	stats.connect("no_health", self, "queue_free")
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		MOVER:
			move_state(delta)
		ROLAR:
			roll_state()
		ATACAR:
			attack_state()

func move_state(delta):
	var input_vector := Vector2.ZERO
	$HitboxPivot/SwordHitbox/CollisionShape2D.set_disabled(true)
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if Input.is_action_pressed("ui_right"):
			direction = "direita"
			$HitboxPivot.set_rotation_degrees(0)
			$AnimatedSprite.play("direita")
		elif Input.is_action_pressed("ui_left"):
			direction = "esquerda"
			$HitboxPivot.set_rotation_degrees(180)
			$AnimatedSprite.play("esquerda")
		elif Input.is_action_pressed("ui_up"):
			direction = "cima"
			$HitboxPivot.set_rotation_degrees(270)
			$AnimatedSprite.play("cima")
		elif Input.is_action_pressed("ui_down"):
			direction = "baixo"
			$HitboxPivot.set_rotation_degrees(90)
			$AnimatedSprite.play("baixo")
		motion = motion.move_toward(input_vector * MAX_SPEED, MOMENTUM * delta)
		if Input.is_action_just_pressed("Rolar"):
			ROLAR_SOM.play()
			state = ROLAR
	else:
		if direction == "direita":
			$AnimatedSprite.play("idleDireita")
		elif direction == "esquerda":
			$AnimatedSprite.play("idleEsquerda")
		elif direction == "cima":
			$AnimatedSprite.play("idleCima")
		elif direction == "baixo":
			$AnimatedSprite.play("idleBaixo")
		motion = motion.move_toward(Vector2.ZERO, FRICTION * delta)
	
	mover()
	
	roll_vector = input_vector
	swordHitbox.knockback_vector = input_vector
	if Input.is_action_just_pressed("Atacar"):
		ATAQUE_SOM.play()
		state = ATACAR


func attack_state():
	$HitboxPivot/SwordHitbox/CollisionShape2D.set_disabled(false)
	if direction == "direita":
		$AnimatedSprite.play("ataqDireita")
	elif direction == "esquerda":
		$AnimatedSprite.play("ataqEsquerda")
	elif direction == "cima":
		$AnimatedSprite.play("ataqCima")
	elif direction == "baixo":
		$AnimatedSprite.play("ataqBaixo")
	if $AnimatedSprite.get_frame() == 4:
		state = MOVER


func roll_state():
	motion = roll_vector * MAX_SPEED * ROLL_SPEED
	mover()
	if direction == "direita":
		$AnimatedSprite.play("rollDireita")
	elif direction == "esquerda":
		$AnimatedSprite.play("rollEsquerda")
	elif direction == "cima":
		$AnimatedSprite.play("rollCima")
	elif direction == "baixo":
		$AnimatedSprite.play("rollBaixo")
	if $AnimatedSprite.get_frame() == 4:
		state = MOVER


func mover():
	motion = move_and_slide(motion)


func _on_Hurtbox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var dano = DANO_SOM.instance()
	get_tree().current_scene.add_child(dano)


func _on_Hurtbox_invincibility_started():
	piscando.play("start")


func _on_Hurtbox_invincibility_ended():
	piscando.play("stop")
