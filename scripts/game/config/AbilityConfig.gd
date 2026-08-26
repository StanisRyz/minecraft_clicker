class_name AbilityConfig
extends RefCounted

const ABILITY_IDS: Array = ["autoclick", "gold_bonus", "focus_burst", "rally"]

const SKILL_DEFINITIONS: Array = [
	{"id": "autoclick_rank_1", "owner_type": "ability", "ability_id": "autoclick", "skill_level": 1, "unlock_character_level": 15, "bonus_type": "autoclick_rank", "bonus_value": 1.0},
	{"id": "autoclick_rank_2", "owner_type": "ability", "ability_id": "autoclick", "skill_level": 2, "unlock_character_level": 30, "bonus_type": "autoclick_rank", "bonus_value": 1.0},
	{"id": "autoclick_rank_3", "owner_type": "ability", "ability_id": "autoclick", "skill_level": 3, "unlock_character_level": 60, "bonus_type": "autoclick_rank", "bonus_value": 1.0},
	{"id": "autoclick_rank_4", "owner_type": "ability", "ability_id": "autoclick", "skill_level": 4, "unlock_character_level": 100, "bonus_type": "autoclick_rank", "bonus_value": 1.0},
	{"id": "autoclick_rank_5", "owner_type": "ability", "ability_id": "autoclick", "skill_level": 5, "unlock_character_level": 150, "bonus_type": "autoclick_rank", "bonus_value": 1.0},
	{"id": "gold_bonus_rank_1", "owner_type": "ability", "ability_id": "gold_bonus", "skill_level": 1, "unlock_character_level": 30, "bonus_type": "gold_bonus_rank", "bonus_value": 1.0},
	{"id": "gold_bonus_rank_2", "owner_type": "ability", "ability_id": "gold_bonus", "skill_level": 2, "unlock_character_level": 60, "bonus_type": "gold_bonus_rank", "bonus_value": 1.0},
	{"id": "gold_bonus_rank_3", "owner_type": "ability", "ability_id": "gold_bonus", "skill_level": 3, "unlock_character_level": 100, "bonus_type": "gold_bonus_rank", "bonus_value": 1.0},
	{"id": "gold_bonus_rank_4", "owner_type": "ability", "ability_id": "gold_bonus", "skill_level": 4, "unlock_character_level": 150, "bonus_type": "gold_bonus_rank", "bonus_value": 1.0},
	{"id": "gold_bonus_rank_5", "owner_type": "ability", "ability_id": "gold_bonus", "skill_level": 5, "unlock_character_level": 250, "bonus_type": "gold_bonus_rank", "bonus_value": 1.0},
	{"id": "focus_burst_rank_1", "owner_type": "ability", "ability_id": "focus_burst", "skill_level": 1, "unlock_character_level": 60, "bonus_type": "focus_burst_rank", "bonus_value": 1.0},
	{"id": "focus_burst_rank_2", "owner_type": "ability", "ability_id": "focus_burst", "skill_level": 2, "unlock_character_level": 100, "bonus_type": "focus_burst_rank", "bonus_value": 1.0},
	{"id": "focus_burst_rank_3", "owner_type": "ability", "ability_id": "focus_burst", "skill_level": 3, "unlock_character_level": 150, "bonus_type": "focus_burst_rank", "bonus_value": 1.0},
	{"id": "focus_burst_rank_4", "owner_type": "ability", "ability_id": "focus_burst", "skill_level": 4, "unlock_character_level": 250, "bonus_type": "focus_burst_rank", "bonus_value": 1.0},
	{"id": "focus_burst_rank_5", "owner_type": "ability", "ability_id": "focus_burst", "skill_level": 5, "unlock_character_level": 500, "bonus_type": "focus_burst_rank", "bonus_value": 1.0},
	{"id": "rally_rank_1", "owner_type": "ability", "ability_id": "rally", "skill_level": 1, "unlock_character_level": 80, "bonus_type": "rally_rank", "bonus_value": 1.0},
	{"id": "rally_rank_2", "owner_type": "ability", "ability_id": "rally", "skill_level": 2, "unlock_character_level": 125, "bonus_type": "rally_rank", "bonus_value": 1.0},
	{"id": "rally_rank_3", "owner_type": "ability", "ability_id": "rally", "skill_level": 3, "unlock_character_level": 200, "bonus_type": "rally_rank", "bonus_value": 1.0},
	{"id": "rally_rank_4", "owner_type": "ability", "ability_id": "rally", "skill_level": 4, "unlock_character_level": 350, "bonus_type": "rally_rank", "bonus_value": 1.0},
	{"id": "rally_rank_5", "owner_type": "ability", "ability_id": "rally", "skill_level": 5, "unlock_character_level": 500, "bonus_type": "rally_rank", "bonus_value": 1.0},
]


static func get_ability_ids() -> Array:
	return ABILITY_IDS


static func get_ability_skill_definitions() -> Array:
	return SKILL_DEFINITIONS


static func get_ability_skill_by_id(skill_id: String) -> Dictionary:
	for skill: Dictionary in SKILL_DEFINITIONS:
		if String(skill.get("id", "")) == skill_id:
			return skill
	return {}


static func get_unlock_level(ability_id: String) -> int:
	match ability_id:
		"autoclick": return BalanceConfig.AUTOCLICK_UNLOCK_LEVEL
		"gold_bonus": return BalanceConfig.GOLD_BONUS_UNLOCK_LEVEL
		"focus_burst": return BalanceConfig.FOCUS_BURST_UNLOCK_LEVEL
		"rally": return BalanceConfig.RALLY_UNLOCK_LEVEL
	return 0


static func get_purchase_cost(ability_id: String) -> int:
	match ability_id:
		"autoclick": return BalanceConfig.AUTOCLICK_PURCHASE_COST
		"gold_bonus": return BalanceConfig.GOLD_BONUS_PURCHASE_COST
		"focus_burst": return BalanceConfig.FOCUS_BURST_PURCHASE_COST
		"rally": return BalanceConfig.RALLY_PURCHASE_COST
	return 0


static func get_effect_key(ability_id: String) -> String:
	return "ability.%s.effect" % ability_id


static func get_effect_next_key(ability_id: String) -> String:
	return "ability.%s.effect_next" % ability_id


static func get_duration_key(ability_id: String) -> String:
	return "ability.%s.duration" % ability_id
