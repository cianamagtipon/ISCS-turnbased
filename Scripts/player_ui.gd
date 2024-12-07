extends VBoxContainer

@export var buttons: Array
@export var enemy_buttons: Array

var selected_action: CombatAction
var selected_enemy: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/BattleScene").character_begin_turn.connect(on_character_begin_turn)
	get_node("/root/BattleScene").character_end_turn.connect(on_character_end_turn)

func on_character_begin_turn(character):
	visible = character.is_player
	
	if visible:
		_display_combat_actions(character.combat_actions)

func on_character_end_turn(character):
	visible = false

func _display_combat_actions(combat_actions):
	for i in len(buttons):
		var button = get_node(buttons[i])
		if i < len(combat_actions):
			button.visible = true
			button.text = combat_actions[i].display_name
			button.combat_action = combat_actions[i]
		else:
			button.visible = false
	
	var enemies = $"..".enemies

	for j in len(enemy_buttons):
		var enemy_button = get_node(enemy_buttons[j])
		if j < enemies.size():
			enemy_button.visible = true
			enemy_button.text = enemies[j].name
			enemy_button.enemy_target = enemies[j]
		else:
			enemy_button.visible = false

func on_action_button_pressed(action):
	selected_action = action

func on_enemy_button_pressed(enemy):
	selected_enemy = enemy
	if selected_action:
		selected_enemy.cast_combat_action(selected_action)
