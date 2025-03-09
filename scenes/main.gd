extends Node

@export var obstacle: PackedScene
@export var coin: PackedScene

var spawned_object_pos_x: int = 1700
var dynamic_objects_speed: int = 700
var damage_over_time: int  = 3
var health_per_pickup: int  = 4
var health: float = 100.0

var score: float
var last_obstacle_pos: String

func _process(delta: float) -> void:
	#scroll dynamic objects
	for dynamic_object in get_tree().get_nodes_in_group("DynamicObject"):
		dynamic_object.position.x -= dynamic_objects_speed * delta
	
	if health > 0:
		health -= damage_over_time * delta
		$UI/HealthBar.value = health
	else:
		game_over()		
	score += delta
	
	var formatted_score: String = str(score)
	var decimal_index = formatted_score.find(".")
	formatted_score = formatted_score.left(decimal_index + 3)
	$UI/ScoreLabel.text = formatted_score


func _on_spawner_timer_timeout() -> void:
	var random: int = randi() % 2
	var obstacle_instance: Area2D = obstacle.instantiate()
	add_child(obstacle_instance)
	obstacle_instance.position.x = spawned_object_pos_x
	if random == 0:
		obstacle_instance.position.y = 200
		last_obstacle_pos = "up"
	if random == 1:
		obstacle_instance.position.y = 800
		obstacle_instance.scale.y *= -1
		last_obstacle_pos = "down"
	obstacle_instance.body_entered.connect(_on_obstacle_collided)



func _on_coin_spawner_timer_timeout() -> void:
	var random_position: int = randi() % 3
	var coin_instance: Area2D = coin.instantiate()
	
	if last_obstacle_pos == "up" and random_position == 0:
		return
	if last_obstacle_pos == "down" and random_position == 2:
		return
		
	add_child(coin_instance)
	coin_instance.position.x = spawned_object_pos_x
	coin_instance.position.y = 280 + random_position * 200
	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))
	
		
func _on_coin_collided(body: Node2D, coin_instance: Area2D) -> void:
	if body.is_in_group("Player"):
		health += health_per_pickup
		coin_instance.get_node("AnimationPlayer").play("Pickup")
		$Player/CoinCollected.play()
		if health > 100:
			health = 100
			
			
func _on_obstacle_collided(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_over()
	
		
func game_over() -> void:
	$Player/GameOver.play()
	$GameOver.show()
	get_tree().paused = true
		
	
