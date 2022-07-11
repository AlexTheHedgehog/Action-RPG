extends KinematicBody2D

var motion  = Vector2.ZERO
var knockback = Vector2.ZERO
onready var status = $status
onready var playerDetection = $PlayerDetection
onready var sprite = $Morcego
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var piscando = $piscando

const EnemyDeathEffect = preload("res://Action RPG Resources/Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	piscando.play("stop")


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			motion = motion.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander()
		CHASE:
			var player = playerDetection.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		motion += softCollision.get_push_vector() * delta * 400
	motion = move_and_slide(motion)

func update_wander():
	state = pick_new_state([IDLE, WANDER])
	wanderController.set_wander_timer(rand_range(1, 3))


func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	motion = motion.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = motion.x < 0


func seek_player():
	if playerDetection.can_see_player():
		state = CHASE


func pick_new_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 120
	status.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_status_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	piscando.play("start")


func _on_Hurtbox_invincibility_ended():
	piscando.play("stop")
