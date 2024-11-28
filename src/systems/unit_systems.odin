package systems

import "../world"

import "core:fmt"

move_unit :: proc() {
	if world.unit_moving {

		next_pos, ok := pop_safe(&world.selected_unit.move_path.path)
		if ok {
			world.selected_unit.pos_y = i16(next_pos.y)
			world.selected_unit.pos_x = i16(next_pos.x)
		}
		if !ok {
			start := world.selected_unit.move_path.start_pos
			target := world.selected_unit.move_path.target_pos
			world.grid[int(start.y)][int(start.x)].cell_type = .FREE
			world.grid[int(start.y)][int(start.x)].occupier_index = -1
			world.grid[int(target.y)][int(target.x)].cell_type = .PLAYER_UNIT
			world.grid[int(target.y)][int(target.x)].occupier_index = i32(world.selected_unit.id)
			world.unit_moving = false
		}
	}
	//move to next step in path
}

attack_unit :: proc() {

}
