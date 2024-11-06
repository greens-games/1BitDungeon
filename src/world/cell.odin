package world

Cell :: struct {
	occupier_index: i32,
	col_x:          i32,
	row_y:          i32,
	cell_type:      Cell_Type,
}

Cell_Type :: enum {
	FREE,
	WALL,
	PLAYER_UNIT,
	ENEMY_UNIT,
}
