class_name Pot extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_box: Area2D = $HitBox
@onready var animations: AnimatedSprite2D = $Sprite2D

var is_exploding: bool = false

func _ready() -> void:
	hit_box.monitoring = false


func _on_pickup_item_c_thrown() -> void:
	collision_shape.disabled = true
	hit_box.monitoring = true


func _on_pickup_item_c_put_down() -> void:
	collision_shape.disabled = false
	hit_box.monitoring = false


func _on_hit_box_hit_occured() -> void:
	if is_exploding: return
	is_exploding = true
	
	z_index = 100
	
	animations.play("explode")
	
	await animations.animation_finished
	queue_free()
