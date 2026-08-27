class_name PartnerConfig
extends RefCounted

const PARTNER_COUNT: int = BalanceConfig.PARTNER_COUNT


static func get_partner_count() -> int:
	return PARTNER_COUNT


static func get_base_dps(index: int) -> int:
	if index < 0 or index >= BalanceConfig.PARTNER_DPS_VALUES.size():
		return 0
	return BalanceConfig.PARTNER_DPS_VALUES[index]


static func get_base_cost(index: int) -> int:
	if index < 0 or index >= BalanceConfig.PARTNER_BASE_COSTS.size():
		return 0
	return BalanceConfig.PARTNER_BASE_COSTS[index]


static func get_name_key(index: int) -> String:
	return "partner.%02d.name" % (index + 1)
