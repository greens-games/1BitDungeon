package physics

import "../utils"
import "core:fmt"

//Check if any of 'a' is inside/coliding with 'b' for now we are assuming squares
collide :: proc(
	a_pos: utils.Vector2,
	a_size: utils.Vector2,
	b_pos: utils.Vector2,
	b_size: utils.Vector2,
) -> bool {
	//If any portion of a enters b we have a collitsion and return true
	a_corners := get_four_corners(a_pos, a_size)
	b_corners := get_four_corners(b_pos, b_size)

	for i in 0 ..< 4 {
		if within_bounds(a_corners[i], b_corners) {
			return true
		}
	}

	return false
}

@(private)
get_four_corners :: proc(pos: utils.Vector2, size: utils.Vector2) -> [4]utils.Vector2 {
	//
	top_left := pos
	top_right := utils.Vector2{pos.x + size.x, pos.y}
	bot_left := utils.Vector2{pos.x, pos.y + size.y}
	bot_right := utils.Vector2{pos.x + size.x, pos.y + size.y}
	corners := [4]utils.Vector2{top_left, top_right, bot_left, bot_right}
	return corners
}

@(private)
within_bounds :: proc(pos: utils.Vector2, bounds: [4]utils.Vector2) -> bool {
	if (pos.x >= bounds[0].x && pos.x <= bounds[1].x) &&
	   (pos.y >= bounds[0].y && pos.y <= bounds[2].y) {
		return true
	}
	return false
}
