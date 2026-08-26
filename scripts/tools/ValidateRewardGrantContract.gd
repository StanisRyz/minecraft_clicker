## Headless regression checks for rewarded-ad and paid-purchase grant helpers.
## Run with: godot --headless --script res://scripts/tools/ValidateRewardGrantContract.gd
extends SceneTree

const ClickerStateClass = preload("res://scripts/game/ClickerState.gd")
const ShopConfigClass = preload("res://scripts/game/config/ShopConfig.gd")
const GemPurchaseConfigClass = preload("res://scripts/game/config/GemPurchaseConfig.gd")
const BalanceConfigClass = preload("res://scripts/game/BalanceConfig.gd")


func _init() -> void:
	var errors: Array[String] = []
	var state: ClickerState = ClickerStateClass.new()

	var shop_before: int = state.gems
	var shop_result: Dictionary = state.grant_shop_rewarded_gems()
	var shop_product: Dictionary = ShopConfigClass.get_by_id("rewarded_gems_ad")
	_expect(shop_result.get("upgraded", false), "shop rewarded gems result succeeds", errors)
	_expect(state.gems - shop_before == int(shop_product.get("reward_gems", 0)), "shop rewarded gems adds configured amount", errors)

	var banner_before: int = state.gems
	var banner_result: Dictionary = state.grant_rewarded_ad_bonus("gems_5")
	_expect(banner_result.get("upgraded", false), "banner gems result succeeds", errors)
	_expect(state.gems - banner_before == BalanceConfigClass.REWARDED_AD_GEMS_REWARD, "banner gems adds configured amount", errors)
	_expect(state.grant_rewarded_ad_bonus("all_damage_x2").get("upgraded", false), "banner damage result succeeds", errors)
	_expect(state.get_rewarded_ad_all_damage_multiplier() == BalanceConfigClass.REWARDED_AD_DAMAGE_MULTIPLIER, "banner damage uses configured multiplier", errors)
	_expect(state.grant_rewarded_ad_bonus("gold_x4").get("upgraded", false), "banner gold result succeeds", errors)
	_expect(state.get_rewarded_ad_gold_multiplier() == BalanceConfigClass.REWARDED_AD_GOLD_MULTIPLIER, "banner gold uses configured multiplier", errors)
	_expect(state.grant_rewarded_ad_bonus("unknown").get("upgraded", true) == false, "unknown banner reward fails safely", errors)

	for product: Dictionary in GemPurchaseConfigClass.get_all():
		var before: int = state.gems
		var result: Dictionary = state.grant_paid_gem_purchase(String(product.get("id", "")))
		_expect(result.get("upgraded", false), "paid product %s succeeds" % product.get("id", ""), errors)
		_expect(state.gems - before == int(product.get("amount_gems", 0)), "paid product %s grants configured amount" % product.get("id", ""), errors)

	var unknown_before: int = state.gems
	_expect(state.grant_paid_gem_purchase("unknown").get("upgraded", true) == false, "unknown paid product fails safely", errors)
	_expect(state.gems == unknown_before, "unknown paid product grants nothing", errors)
	state.mark_purchase_processed("token-1")
	_expect(state.is_purchase_processed("token-1"), "processed purchase token is recorded", errors)
	_expect(not state.is_purchase_processed(""), "empty purchase token is invalid", errors)
	state.mark_purchase_processed("token-1")
	_expect(state.processed_purchase_ids.size() == 1, "duplicate purchase token is not recorded twice", errors)
	for index in range(ClickerStateClass.MAX_PROCESSED_PURCHASE_IDS + 1):
		state.mark_purchase_processed("cap-token-%d" % index)
	_expect(state.processed_purchase_ids.size() == ClickerStateClass.MAX_PROCESSED_PURCHASE_IDS, "processed purchase token list stays capped", errors)

	if errors.is_empty():
		print("ValidateRewardGrantContract: OK")
		quit(0)
	for error: String in errors:
		print("ERROR: " + error)
	quit(1)


func _expect(condition: bool, message: String, errors: Array[String]) -> void:
	if not condition:
		errors.append(message)
