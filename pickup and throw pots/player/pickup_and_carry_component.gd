class_name PickupAndCarryComponent extends Node2D

signal item_thrown


@onready var ray_cast: RayCast2D = $RayCast2D
@onready var rotations: Dictionary[String, int] = {
	"down": 0,
	"up": 180,
	"left": 90,
	"right": 270,
}

@onready var angle_to_direction: Dictionary[float, Vector2] = {
	0: Vector2(0, 1),
	90: Vector2(-1, 0),
	180: Vector2(0, -1),
	270: Vector2(1, 0),
}

@onready var parent: Node2D = get_parent()
@onready var item_container: Node2D = $ItemContainer


var item_in_hand: Node2D = null


func _ready() -> void:
	update_rotation()
	
	
func _process(delta: float) -> void:
	update_rotation()


func update_rotation() -> void:
	if !parent || !parent.get("last_anim_direction"): return
	
	ray_cast.rotation_degrees = rotations[parent.last_anim_direction]


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var collider = ray_cast.get_collider()
		
		if item_in_hand: throw_item_in_hand()
		elif collider && collider is PickupItemC: pickup(collider)
		
		
func pickup(item: PickupItemC) -> void:
	var pickup_ready = true
	
	if parent.has_method("try_pickup_item"):
		pickup_ready = await parent.try_pickup_item(item)
	
	if !pickup_ready: return
	
	item.pickup(item_container)
	item_in_hand = item
	
	
func throw_item_in_hand() -> void:
	item_in_hand.throw(angle_to_direction[ray_cast.rotation_degrees], parent.global_position.y)
	item_in_hand = null
	
	item_thrown.emit()
