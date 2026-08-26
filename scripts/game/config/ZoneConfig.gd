class_name ZoneConfig
extends RefCounted

const LEVELS_PER_ZONE: int = 5
const BOSS_LEVEL_INTERVAL: int = 5
const ZONE_COUNT: int = 10
const TOTAL_ZONE_LEVELS: int = LEVELS_PER_ZONE * ZONE_COUNT

# Player-facing zone/boss names live in localization (zone.NN.name, zone.NN.boss).
# ZONE_DATA holds only balance multipliers; enemy spawning uses EnemyPoolConfig.
const ZONE_DATA: Array = [
	{"hp_multiplier": 1.0, "reward_multiplier": 1.0},
	{"hp_multiplier": 1.4, "reward_multiplier": 1.3},
	{"hp_multiplier": 1.9, "reward_multiplier": 1.7},
	{"hp_multiplier": 2.5, "reward_multiplier": 2.2},
	{"hp_multiplier": 3.2, "reward_multiplier": 2.8},
	{"hp_multiplier": 3.6, "reward_multiplier": 3.1},
	{"hp_multiplier": 4.2, "reward_multiplier": 3.6},
	{"hp_multiplier": 5.1, "reward_multiplier": 4.3},
	{"hp_multiplier": 6.3, "reward_multiplier": 5.2},
	{"hp_multiplier": 7.7, "reward_multiplier": 6.2},
]


static func get_zone_count() -> int:
	assert(ZONE_DATA.size() == ZONE_COUNT, "ZONE_DATA must contain exactly ZONE_COUNT entries")
	return ZONE_COUNT


static func get_cycle_level_for_level(level: int) -> int:
	var safe_level: int = maxi(level, 1)
	return ((safe_level - 1) % TOTAL_ZONE_LEVELS) + 1


static func get_cycle_index_for_level(level: int) -> int:
	var cycle_level: int = get_cycle_level_for_level(level)
	@warning_ignore("integer_division")
	return (cycle_level - 1) / LEVELS_PER_ZONE


static func get_zone_index_for_level(level: int) -> int:
	return get_cycle_index_for_level(level)


static func get_zone_data_for_level(level: int) -> Dictionary:
	return ZONE_DATA[get_zone_index_for_level(level)]


static func get_zone_number_for_level(level: int) -> int:
	return get_zone_index_for_level(level) + 1


static func get_name_key(zone_index: int) -> String:
	return "zone.%02d.name" % (zone_index + 1)


static func get_boss_key(zone_index: int) -> String:
	return "zone.%02d.boss" % (zone_index + 1)


static func get_name_key_for_level(level: int) -> String:
	return get_name_key(get_zone_index_for_level(level))


static func get_zone_cycle_index_for_level(level: int) -> int:
	var safe_level: int = maxi(level, 1)
	@warning_ignore("integer_division")
	return int((safe_level - 1) / TOTAL_ZONE_LEVELS)


static func get_effective_hp_multiplier_for_level(level: int, cycle_hp_multiplier: float) -> float:
	var zone: Dictionary = get_zone_data_for_level(level)
	var cycle_index: int = get_zone_cycle_index_for_level(level)
	return float(zone.get("hp_multiplier", 1.0)) * pow(cycle_hp_multiplier, float(cycle_index))


static func get_effective_reward_multiplier_for_level(level: int, cycle_reward_multiplier: float) -> float:
	var zone: Dictionary = get_zone_data_for_level(level)
	var cycle_index: int = get_zone_cycle_index_for_level(level)
	return float(zone.get("reward_multiplier", 1.0)) * pow(cycle_reward_multiplier, float(cycle_index))
