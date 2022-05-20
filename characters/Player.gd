extends KinematicBody2D

signal laser_shoot
signal player_died

const SPEED := 600

var player_explosion_scene = load("res://objects/ParticlesPlayerExplosion.tscn")

func _ready() -> void:
	var camera = get_parent().get_node("MainCamera")
	self.connect("laser_shoot", camera, "_on_player_laser_shoot")
	
	var game = get_parent()
	self.connect("player_died", game, "_on_Player_player_died")

func _physics_process(delta: float) -> void:
	var velocity := Vector2()
	
	if (Input.is_action_pressed("ui_left") || Input.is_action_pressed("left")):
		velocity.x = -SPEED
	if (Input.is_action_pressed("ui_right") || Input.is_action_pressed("right")):
		velocity.x = SPEED
#	if (Input.is_action_pressed("ui_up")):
#		velocity.y = -SPEED
#	if (Input.is_action_pressed("ui_down")):
#		velocity.y = SPEED
	
	move_and_collide(velocity * delta)

func explode():
	var explosion = player_explosion_scene.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.emitting = true
	
	emit_signal("player_died")
	
	queue_free()

func _unhandled_key_input(event: InputEventKey) -> void:
	if (event.is_action_pressed("shoot")):
		$LaserWeapon.shoot()
		emit_signal("laser_shoot")


func _on_Hitbox_body_entered(body):
	if (!self.is_queued_for_deletion() && body.is_in_group("asteroids")):
		explode()
