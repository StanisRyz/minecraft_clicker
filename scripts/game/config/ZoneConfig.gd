class_name ZoneConfig
extends RefCounted

const LEVELS_PER_ZONE: int = 5
const BOSS_LEVEL_INTERVAL: int = 5
const ZONE_COUNT: int = 10
const TOTAL_ZONE_LEVELS: int = LEVELS_PER_ZONE * ZONE_COUNT

# enemies and elite_enemy are legacy display/content notes.
# Non-boss enemy runtime selection now uses EnemyPoolConfig; these fields are no longer used for enemy spawning.
const ZONE_DATA: Array = [
	{
		"name": "Training Grounds",
		"level_start": 1,
		"level_end": 5,
		"enemies": ["Rogue Ninja", "Novice Bandit", "Training Outcast"],
		"elite_enemy": "Elite Rogue Ninja",
		"boss": "Training Master",
		"hp_multiplier": 1.0,
		"reward_multiplier": 1.0,
		"enemy_asset_zone": 1,
	},
	{
		"name": "Forest Path",
		"level_start": 6,
		"level_end": 10,
		"enemies": ["Forest Bandit", "Wild Scout", "Hidden Archer"],
		"elite_enemy": "Elite Forest Bandit",
		"boss": "Forest Guardian",
		"hp_multiplier": 1.4,
		"reward_multiplier": 1.3,
		"enemy_asset_zone": 1,
	},
	{
		"name": "Stone Valley",
		"level_start": 11,
		"level_end": 15,
		"enemies": ["Stone Warrior", "Valley Raider", "Rock Sentinel"],
		"elite_enemy": "Elite Stone Warrior",
		"boss": "Valley Warlord",
		"hp_multiplier": 1.9,
		"reward_multiplier": 1.7,
		"enemy_asset_zone": 3,
	},
	{
		"name": "Shadow Camp",
		"level_start": 16,
		"level_end": 20,
		"enemies": ["Shadow Fighter", "Camp Assassin", "Dark Scout"],
		"elite_enemy": "Elite Shadow Fighter",
		"boss": "Shadow Commander",
		"hp_multiplier": 2.5,
		"reward_multiplier": 2.2,
		"enemy_asset_zone": 3,
	},
	{
		"name": "Burning Outpost",
		"level_start": 21,
		"level_end": 25,
		"enemies": ["Ash Raider", "Flame Scout", "Cinder Guard"],
		"elite_enemy": "Elite Ash Raider",
		"boss": "Burning Outpost Chief",
		"hp_multiplier": 3.2,
		"reward_multiplier": 2.8,
		"enemy_asset_zone": 5,
	},
	{
		"name": "Scorched Outpost",
		"level_start": 26,
		"level_end": 30,
		"enemies": ["Scorched Raider", "Outpost Scout", "Ash Guard"],
		"elite_enemy": "Elite Scorched Raider",
		"boss": "Scorched Outpost Captain",
		"hp_multiplier": 3.6,
		"reward_multiplier": 3.1,
		"enemy_asset_zone": 5,
	},
	{
		"name": "Old Training Grounds",
		"level_start": 31,
		"level_end": 35,
		"enemies": ["Rogue Ninja", "Novice Bandit", "Training Outcast"],
		"elite_enemy": "Elite Rogue Ninja",
		"boss": "Old Grounds Champion",
		"hp_multiplier": 4.2,
		"reward_multiplier": 3.6,
		"enemy_asset_zone": 1,
	},
	{
		"name": "Mist River",
		"level_start": 36,
		"level_end": 40,
		"enemies": ["Mist Rogue", "River Ambusher", "Fog Archer"],
		"elite_enemy": "Elite Mist Rogue",
		"boss": "Mist River Lord",
		"hp_multiplier": 5.1,
		"reward_multiplier": 4.3,
		"enemy_asset_zone": 8,
	},
	{
		"name": "Flooded Shrine",
		"level_start": 41,
		"level_end": 45,
		"enemies": ["Mist Rogue", "River Ambusher", "Fog Archer"],
		"elite_enemy": "Elite Mist Rogue",
		"boss": "Flooded Shrine Keeper",
		"hp_multiplier": 6.3,
		"reward_multiplier": 5.2,
		"enemy_asset_zone": 8,
	},
	{
		"name": "Thunder Ridge",
		"level_start": 46,
		"level_end": 50,
		"enemies": ["Thunder Bandit", "Storm Scout", "Ridge Spearman"],
		"elite_enemy": "Elite Thunder Bandit",
		"boss": "Thunder Ridge General",
		"hp_multiplier": 7.7,
		"reward_multiplier": 6.2,
		"enemy_asset_zone": 10,
	},
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


static func get_enemy_asset_zone_number_for_level(level: int) -> int:
	var zone: Dictionary = get_zone_data_for_level(level)
	if zone.has("enemy_asset_zone"):
		return clampi(int(zone.enemy_asset_zone), 1, ZONE_COUNT)
	return get_zone_number_for_level(level)


static func get_enemy_asset_zone_index_for_level(level: int) -> int:
	return get_enemy_asset_zone_number_for_level(level) - 1


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
