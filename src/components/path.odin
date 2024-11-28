package components

import "../utils"

Path :: struct {
	//printing dynamic array kinda sucks
	//could make max size of path max possible size for grid 
	path:       [dynamic]utils.Vector2,
	target_pos: utils.Vector2,
	start_pos:  utils.Vector2,
}
