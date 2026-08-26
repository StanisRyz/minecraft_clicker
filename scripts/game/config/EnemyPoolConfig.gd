class_name EnemyPoolConfig
extends RefCounted

const NORMAL_ENEMIES: Array[Dictionary] = [
	{"name_key": "enemy.common.enemy_01.name", "slot": "enemy_01"},
	{"name_key": "enemy.common.enemy_02.name", "slot": "enemy_02"},
	{"name_key": "enemy.common.enemy_03.name", "slot": "enemy_03"},
	{"name_key": "enemy.common.enemy_04.name", "slot": "enemy_04"},
	{"name_key": "enemy.common.enemy_05.name", "slot": "enemy_05"},
	{"name_key": "enemy.common.enemy_06.name", "slot": "enemy_06"},
	{"name_key": "enemy.common.enemy_07.name", "slot": "enemy_07"},
	{"name_key": "enemy.common.enemy_08.name", "slot": "enemy_08"},
	{"name_key": "enemy.common.enemy_09.name", "slot": "enemy_09"},
	{"name_key": "enemy.common.enemy_10.name", "slot": "enemy_10"},
	{"name_key": "enemy.common.enemy_11.name", "slot": "enemy_11"},
	{"name_key": "enemy.common.enemy_12.name", "slot": "enemy_12"},
	{"name_key": "enemy.common.enemy_13.name", "slot": "enemy_13"},
	{"name_key": "enemy.common.enemy_14.name", "slot": "enemy_14"},
	{"name_key": "enemy.common.enemy_15.name", "slot": "enemy_15"},
]

static func get_random_normal_candidate(rng: RandomNumberGenerator) -> Dictionary:
	if NORMAL_ENEMIES.is_empty():
		return {
			"name_key": "",
			"slot": "enemy_01",
		}
	return NORMAL_ENEMIES[rng.randi_range(0, NORMAL_ENEMIES.size() - 1)]
