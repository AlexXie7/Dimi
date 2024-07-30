extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -620.0
var left = false
var idle = true
var crouched = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var inventory = []
var litLamps = 0

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InteractLabel"

func _ready():
	update_interactions()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("move_left"):
		left = true
	if Input.is_action_just_pressed("move_right"):
		left = false
	if Input.is_action_just_pressed("drop"):
		crouched = true
		$AnimatedSprite2D.play("Hide")
	if Input.is_action_just_released("drop"):
		crouched = false
		
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		crouched = false
		velocity.x = direction * SPEED
		if left:
			$AnimatedSprite2D.play("WaddleLeft")
		else:
			$AnimatedSprite2D.play("WaddleRight")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if crouched == false:
			if left:
				$AnimatedSprite2D.play("idleLeft")
			else:
				$AnimatedSprite2D.play("idleRight")

	move_and_slide()

#####################
# Interaction Methods
#####################

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions and all_interactions[0].interactable:
		interactLabel.text = all_interactions[0].interact_label
		$"Interaction Components/InteractionArea/ToolTip".show()
	else:
		interactLabel.text = ""
		$"Interaction Components/InteractionArea/ToolTip".hide()

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"print_text": print(cur_interaction.interact_value)
			"pickup": 
				print("Added " + cur_interaction.interact_value + " to inventory")
				if(cur_interaction.interactable):
					if(!inventory.has(cur_interaction.interact_value)):
						inventory.append(cur_interaction.interact_value)
						cur_interaction.interactable = false
						cur_interaction.hideSparkle()
						update_interactions()
				print(inventory)
			"createPotion":
				print("Making potion")
				var hasAllItems = true
				
				for item in ["blue_gem", "purple_gem", "page1", "light_mushroom"]:
					if item not in inventory:
						hasAllItems = false
				
				if hasAllItems:
					get_tree().change_scene_to_file("res://Scenes/Level2.tscn")
				else:
					cur_interaction.interact_label = "Need More Ingredients"
					update_interactions()
			"pickupPage":
				print("Picking up page")
				inventory.append(cur_interaction.interact_value)
			"lightLamp":
				litLamps += 1
				cur_interaction.lightLamp()
				cur_interaction.interactable = false
				cur_interaction.hideSparkle()
				update_interactions()
				if litLamps == 4:
					get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
				


func _on_reset_box_body_entered(body):
	global_position = Vector2(440, 1180)
