extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -600.0
var left = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
		
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("WaddleRight")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

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
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else: interactLabel.text = ""

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"print_text": print(cur_interaction.interact_value)
			"blue_gem": print("Added blue gem to inventory")
			"purple_gem": print("Added purple gem to inventory")
			"light_potion": print("Added light potion to inventory")
			"light_mushroom": print("Added light mushroom to inventory")
