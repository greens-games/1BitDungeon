package world

Cell :: struct {
	col_x:     i32,
	row_y:     i32,
	cell_type: Cell_Type,
}

Cell_Type :: enum {
	FREE,
	WALL,
}
