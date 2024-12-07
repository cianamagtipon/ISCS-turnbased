extends Node2D

@export var enemies: Array[Node]

@export var player_char: Node
@export var enemy_char: Node

@export var next_turn_delay: float = 1.0

var cur_char: Character

var characters: Array[Node] = []  # List of all characters (player + enemies)
var cur_index: int = 0            # Current index in the turn order

var game_over : bool = false

signal character_begin_turn(character)
signal character_end_turn(character)

# Called when the node enters the scene tree for the first time.
func _ready():
	characters.append(player_char)
	characters += enemies
	await get_tree().create_timer(0.5).timeout
	begin_next_turn()

func begin_next_turn():
	cur_index = (cur_index + 1) % characters.size()
	cur_char = characters[cur_index]
	
	emit_signal("character_begin_turn", cur_char)

func end_current_turn():
	emit_signal("character_end_turn", cur_char)
	
	await get_tree().create_timer(next_turn_delay).timeout
	
	if !game_over:
		begin_next_turn()

func character_died(character):
	game_over = true
	
	if character.is_player == true:
		print("Game Over")
	else:
		print("You Win!")
