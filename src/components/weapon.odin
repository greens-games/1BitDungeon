package components

Weapon_Type :: enum {
	SWORD,
	MACE,
	STAFF,
	AXE,
	WAND,
}

Weapon :: struct {
	damage:      int,
	min_range:   int,
	max_range:   int,
	weapon_type: Weapon_Type,
}
