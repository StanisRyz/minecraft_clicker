extends SceneTree

# Run with: godot --headless --script res://scripts/tools/ValidateEnemyAssets.gd

const STATES: Array[String] = ["healthy.png", "hit.png", "wounded.png", "defeated.png"]

const NORMAL_ENEMY_FOLDER: String = "common"
const NORMAL_ENEMY_COUNT: int = 15

const BOSS_ZONE_COUNT: int = ZoneConfig.ZONE_COUNT

func _init() -> void:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	var slots_checked: int = 0
	var pngs_checked: int = 0

	# --- Canonical non-boss slots ---
	for i in range(1, NORMAL_ENEMY_COUNT + 1):
		var slot: String = "enemy_%02d" % i
		_check_slot("assets/images/enemies/%s/%s" % [NORMAL_ENEMY_FOLDER, slot], errors, warnings)
		slots_checked += 1
		pngs_checked += STATES.size()
	# --- Boss slots (one per gameplay zone) ---
	for zone_num in range(1, BOSS_ZONE_COUNT + 1):
		var zone_folder: String = "zone_%02d" % zone_num
		_check_slot("assets/images/enemies/%s/boss_01" % zone_folder, errors, warnings)
		slots_checked += 1
		pngs_checked += STATES.size()

	_check_runtime_asset_resolution(errors)
	_check_no_obsolete_asset_folders(errors)

	# --- Print report ---
	print("")
	print("=== Enemy Asset Validation Report ===")
	print("")

	if errors.is_empty() and warnings.is_empty():
		print("All required enemy PNG assets are present.")
		print("")

	if not errors.is_empty():
		print("ERRORS (%d):" % errors.size())
		for e: String in errors:
			print("  [ERROR] " + e)
		print("")

	if not warnings.is_empty():
		print("WARNINGS (%d):" % warnings.size())
		for w: String in warnings:
			print("  [WARN]  " + w)
		print("")

	print("--- Summary ---")
	var expected_slots: int = NORMAL_ENEMY_COUNT + BOSS_ZONE_COUNT
	var expected_pngs: int = expected_slots * STATES.size()
	print("Slots checked:      %d / %d" % [slots_checked, expected_slots])
	print("PNG files checked:  %d / %d" % [pngs_checked, expected_pngs])
	print("Errors:             %d" % errors.size())
	print("Warnings:           %d" % warnings.size())
	print("")

	if errors.is_empty():
		print("RESULT: PASS")
		quit(0)
	else:
		print("RESULT: FAIL")
		quit(1)


func _check_slot(rel_path: String, errors: Array[String], warnings: Array[String]) -> void:
	for state: String in STATES:
		var png_path: String  = "res://%s/%s" % [rel_path, state]
		var import_path: String = png_path + ".import"
		if not FileAccess.file_exists(png_path):
			errors.append("Missing PNG: %s/%s" % [rel_path, state])
		elif not FileAccess.file_exists(import_path):
			warnings.append("Missing .import: %s/%s.import" % [rel_path, state])


func _check_no_obsolete_asset_folders(errors: Array[String]) -> void:
	var enemy_root := DirAccess.open("res://assets/images/enemies")
	if enemy_root == null:
		errors.append("Cannot open enemy asset root")
		return
	enemy_root.list_dir_begin()
	var name: String = enemy_root.get_next()
	while name != "":
		if enemy_root.current_is_dir():
			if name == "elite":
				errors.append("Obsolete elite asset folder: assets/images/enemies/elite")
			elif name.begins_with("zone_"):
				var zone_number_text: String = name.trim_prefix("zone_")
				if zone_number_text.is_valid_int() and int(zone_number_text) > BOSS_ZONE_COUNT:
					errors.append("Obsolete enemy zone folder: assets/images/enemies/" + name)
		name = enemy_root.get_next()
	enemy_root.list_dir_end()


func _check_runtime_asset_resolution(errors: Array[String]) -> void:
	for i in range(1, NORMAL_ENEMY_COUNT + 1):
		var normal_slot: String = "enemy_%02d" % i
		for state: String in STATES:
			var state_name: String = state.get_basename()
			if EnemyAssetCatalog.load_normal_enemy_texture(normal_slot, state_name) == null:
				errors.append("Runtime normal texture unavailable: %s/%s" % [normal_slot, state])
	for zone_index in range(BOSS_ZONE_COUNT):
		for state: String in STATES:
			var state_name: String = state.get_basename()
			if EnemyAssetCatalog.load_boss_enemy_texture(zone_index, "boss_01", state_name) == null:
				errors.append("Runtime boss texture unavailable: zone_%02d/%s" % [zone_index + 1, state])
