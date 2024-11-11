package input

import "../debug"
import "../entities"
import "../utils"
import "../world"
import "core:fmt"
import rl "vendor:raylib"

detect_hover :: proc() {

	hovered_cell := get_mouse_cell()

	#partial switch hovered_cell.cell_type {
	case entities.Cell_Type.PLAYER_UNIT:
		//show move range
		// How do we know which player unit we are hovering?
		unit := world.player_units[hovered_cell.occupier_index]
	}
}

unit_click :: proc() {
	if rl.IsMouseButtonPressed(.LEFT) {

		chosen_cell := get_mouse_cell()

		#partial switch chosen_cell.cell_type {
		case entities.Cell_Type.PLAYER_UNIT:
			//show move range
			// How do we know which player unit we are hovering?
			unit := world.player_units[chosen_cell.occupier_index]
			world.selected_unit = unit
			world.assign_move_cells()
		}
	}
}

@(private)
get_mouse_cell :: proc() -> entities.Cell {

	mouse_grid_pos :=
		rl.GetMousePosition().xy /
		rl.Vector2{utils.CELL_SIZE * utils.CAMERA_ZOOM, utils.CELL_SIZE * utils.CAMERA_ZOOM}

	return world.grid[i32(mouse_grid_pos.y)][i32(mouse_grid_pos.x)]
}
