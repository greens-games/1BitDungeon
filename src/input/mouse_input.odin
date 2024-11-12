package input

import "../debug"
import "../entities"
import "../utils"
import "../world"
import "core:fmt"
import rl "vendor:raylib"

detect_hover :: proc() {

	hovered_cell := get_mouse_cell(world.grid)

	#partial switch hovered_cell.cell_type {
	case entities.Cell_Type.PLAYER_UNIT:
		//show move range
		// How do we know which player unit we are hovering?
		unit := world.player_units[hovered_cell.occupier_index]
	}
}

unit_click :: proc() {
	if rl.IsMouseButtonPressed(.LEFT) {
		/* if !world.overlay_clear {
			world.clear_overlay()
		} */
		chosen_cell := get_mouse_cell(world.grid)
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

move_cell_click :: proc() {
	if rl.IsMouseButtonPressed(.LEFT) {
		chosen_cell := get_mouse_cell(world.grid_overlay)
		#partial switch chosen_cell.cell_type {
		case entities.Cell_Type.MOVE_CELL:
			//show move range
			// How do we know which player unit we are hovering?
			fmt.println("MOVING TO CELL AT POSITION", chosen_cell.col_x, chosen_cell.row_y)
		//Move unit using Astar
		}
	}
}

@(private)
get_mouse_cell :: proc(grid: [10][10]entities.Cell) -> entities.Cell {
	mouse_grid_pos :=
		rl.GetMousePosition().xy /
		rl.Vector2{utils.CELL_SIZE * utils.CAMERA_ZOOM, utils.CELL_SIZE * utils.CAMERA_ZOOM}
	return grid[i32(mouse_grid_pos.y)][i32(mouse_grid_pos.x)]
}
