class_name EnemyAssetCatalog

const ENEMY_IMAGE_ROOT: String = "res://assets/images/enemies/"
const NORMAL_ENEMY_FOLDER: String = "common"
const ELITE_ENEMY_FOLDER: String = "elite"
const STATE_HEALTHY: String = "healthy"
const STATE_HIT: String = "hit"
const STATE_WOUNDED: String = "wounded"
const STATE_DEFEATED: String = "defeated"
const ENEMY_STATES: Array[String] = ["healthy", "hit", "wounded", "defeated"]


static func get_boss_zone_folder(zone_index: int) -> String:
	return "zone_%02d" % (zone_index + 1)


static func get_normal_enemy_state_path(enemy_slot: String, state: String) -> String:
	return _get_state_path(NORMAL_ENEMY_FOLDER, enemy_slot, state)


static func get_elite_enemy_state_path(enemy_slot: String, state: String) -> String:
	return _get_state_path(ELITE_ENEMY_FOLDER, enemy_slot, state)


static func get_boss_enemy_state_path(zone_index: int, enemy_slot: String, state: String) -> String:
	return _get_state_path(get_boss_zone_folder(zone_index), enemy_slot, state)


static func load_normal_enemy_texture(enemy_slot: String, state: String) -> Texture2D:
	return _load_texture(get_normal_enemy_state_path(enemy_slot, state))


static func load_elite_enemy_texture(enemy_slot: String, state: String) -> Texture2D:
	return _load_texture(get_elite_enemy_state_path(enemy_slot, state))


static func load_boss_enemy_texture(zone_index: int, enemy_slot: String, state: String) -> Texture2D:
	return _load_texture(get_boss_enemy_state_path(zone_index, enemy_slot, state))


static func _get_state_path(root_folder: String, enemy_slot: String, state: String) -> String:
	return ENEMY_IMAGE_ROOT + root_folder + "/" + enemy_slot + "/" + state + ".png"


static func _load_texture(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	return ResourceLoader.load(path) as Texture2D


static func enemy_slot_for_normal_enemy(enemy_index: int) -> String:
	return "enemy_%02d" % (enemy_index + 1)


static func enemy_slot_for_elite() -> String:
	return "elite_01"


static func enemy_slot_for_boss() -> String:
	return "boss_01"
