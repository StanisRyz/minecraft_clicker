class_name PrestigeConfig
extends RefCounted

const TALENT_COUNT: int = 6
const TALENT_BONUS_TYPES: Array = ["click_damage", "gold", "partner_dps", "autoclick_rate", "settlement_effect", "boss_damage"]


static func get_talent_count() -> int:
	return TALENT_COUNT


static func get_talent_bonus_type(index: int) -> String:
	if index < 0 or index >= TALENT_BONUS_TYPES.size():
		return ""
	return TALENT_BONUS_TYPES[index]


static func get_effect_type(index: int) -> String:
	return get_talent_bonus_type(index)


static func get_name_key(index: int) -> String:
	return "prestige.talent.%02d.name" % (index + 1)


static func get_purchase_gain_key(index: int) -> String:
	return "prestige.talent.%02d.purchase_gain" % (index + 1)


static func get_total_bonus_key(index: int) -> String:
	return "prestige.talent.%02d.total_bonus" % (index + 1)
