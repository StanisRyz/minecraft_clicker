class_name PartnerSkillConfig
extends RefCounted

const SKILL_DEFINITIONS: Array = [
	# Partner 1 (index 0)
	{"id": "p0_s1", "partner_index": 0, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p0_s2", "partner_index": 0, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p0_s3", "partner_index": 0, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p0_s4", "partner_index": 0, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p0_s5", "partner_index": 0, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 2 (index 1)
	{"id": "p1_s1", "partner_index": 1, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p1_s2", "partner_index": 1, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p1_s3", "partner_index": 1, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p1_s4", "partner_index": 1, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p1_s5", "partner_index": 1, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 3 (index 2)
	{"id": "p2_s1", "partner_index": 2, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p2_s2", "partner_index": 2, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p2_s3", "partner_index": 2, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p2_s4", "partner_index": 2, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p2_s5", "partner_index": 2, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 4 (index 3)
	{"id": "p3_s1", "partner_index": 3, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p3_s2", "partner_index": 3, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p3_s3", "partner_index": 3, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p3_s4", "partner_index": 3, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p3_s5", "partner_index": 3, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 5 (index 4)
	{"id": "p4_s1", "partner_index": 4, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p4_s2", "partner_index": 4, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p4_s3", "partner_index": 4, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p4_s4", "partner_index": 4, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p4_s5", "partner_index": 4, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 6 (index 5)
	{"id": "p5_s1", "partner_index": 5, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p5_s2", "partner_index": 5, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p5_s3", "partner_index": 5, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p5_s4", "partner_index": 5, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p5_s5", "partner_index": 5, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 7 (index 6)
	{"id": "p6_s1", "partner_index": 6, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p6_s2", "partner_index": 6, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p6_s3", "partner_index": 6, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p6_s4", "partner_index": 6, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p6_s5", "partner_index": 6, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 8 (index 7)
	{"id": "p7_s1", "partner_index": 7, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p7_s2", "partner_index": 7, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p7_s3", "partner_index": 7, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p7_s4", "partner_index": 7, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p7_s5", "partner_index": 7, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 9 (index 8)
	{"id": "p8_s1", "partner_index": 8, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p8_s2", "partner_index": 8, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p8_s3", "partner_index": 8, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p8_s4", "partner_index": 8, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p8_s5", "partner_index": 8, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 10 (index 9)
	{"id": "p9_s1", "partner_index": 9, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p9_s2", "partner_index": 9, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p9_s3", "partner_index": 9, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p9_s4", "partner_index": 9, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p9_s5", "partner_index": 9, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 11 (index 10)
	{"id": "p10_s1", "partner_index": 10, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p10_s2", "partner_index": 10, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p10_s3", "partner_index": 10, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p10_s4", "partner_index": 10, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p10_s5", "partner_index": 10, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 12 (index 11)
	{"id": "p11_s1", "partner_index": 11, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p11_s2", "partner_index": 11, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p11_s3", "partner_index": 11, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p11_s4", "partner_index": 11, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p11_s5", "partner_index": 11, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 13 (index 12)
	{"id": "p12_s1", "partner_index": 12, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p12_s2", "partner_index": 12, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p12_s3", "partner_index": 12, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p12_s4", "partner_index": 12, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p12_s5", "partner_index": 12, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 14 (index 13)
	{"id": "p13_s1", "partner_index": 13, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p13_s2", "partner_index": 13, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p13_s3", "partner_index": 13, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p13_s4", "partner_index": 13, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p13_s5", "partner_index": 13, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 15 (index 14)
	{"id": "p14_s1", "partner_index": 14, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p14_s2", "partner_index": 14, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p14_s3", "partner_index": 14, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p14_s4", "partner_index": 14, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p14_s5", "partner_index": 14, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 16 (index 15)
	{"id": "p15_s1", "partner_index": 15, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p15_s2", "partner_index": 15, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p15_s3", "partner_index": 15, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p15_s4", "partner_index": 15, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p15_s5", "partner_index": 15, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 17 (index 16)
	{"id": "p16_s1", "partner_index": 16, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p16_s2", "partner_index": 16, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p16_s3", "partner_index": 16, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p16_s4", "partner_index": 16, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p16_s5", "partner_index": 16, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	# Partner 18 (index 17)
	{"id": "p17_s1", "partner_index": 17, "skill_level": 1, "unlock_count": 10, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p17_s2", "partner_index": 17, "skill_level": 2, "unlock_count": 25, "bonus_type": "click_damage_from_partner_dps", "bonus_value": 0.007},
	{"id": "p17_s3", "partner_index": 17, "skill_level": 3, "unlock_count": 50, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p17_s4", "partner_index": 17, "skill_level": 4, "unlock_count": 100, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
	{"id": "p17_s5", "partner_index": 17, "skill_level": 5, "unlock_count": 250, "bonus_type": "own_partner_dps", "bonus_value": 1.0},
]


static func get_all() -> Array:
	return SKILL_DEFINITIONS


static func get_by_id(skill_id: String) -> Dictionary:
	for skill: Dictionary in SKILL_DEFINITIONS:
		if String(skill.get("id", "")) == skill_id:
			return skill
	return {}


static func get_for_partner(partner_index: int) -> Array:
	var result: Array = []
	for skill: Dictionary in SKILL_DEFINITIONS:
		if int(skill.get("partner_index", -1)) == partner_index:
			result.append(skill)
	return result
