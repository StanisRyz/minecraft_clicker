class_name AdPlacementConfig
extends RefCounted

const AD_PLACEMENTS: Array[Dictionary] = [
	{
		"id": "rewarded_shop_gems",
		"type": "rewarded",
	},
	{
		"id": "rewarded_bonus_banner",
		"type": "rewarded",
	},
	{
		"id": "rewarded_offline_gold_x3",
		"type": "rewarded",
	},
	{
		"id": "fullscreen_auto_interstitial",
		"type": "fullscreen",
	},
]


static func get_by_id(placement_id: String) -> Dictionary:
	for placement: Dictionary in AD_PLACEMENTS:
		if String(placement.get("id", "")) == placement_id:
			return placement
	return {}


static func exists(placement_id: String) -> bool:
	return not get_by_id(placement_id).is_empty()
