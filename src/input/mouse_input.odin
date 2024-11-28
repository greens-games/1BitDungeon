package input

import "../debug"
import "../entities"
import "../pathfinding"
import "../utils"
import "../world"
import "core:fmt"
import "core:math"
import rl "vendor:raylib"

curr_cell: entities.Cell

detect_hover :: proc() {

	hovered_cell := get_mouse_cell(world.grid)
	curr_cell = hovered_cell

	#partial switch hovered_cell.cell_type {
	case entities.Cell_Type.PLAYER_UNIT:
		//show move range
		// How do we know which player unit we are hovering?
		unit := world.player_units[hovered_cell.occupier_index]
	}
}

//TODO: ALL THIS CLICK STUFF NEEDS TO BE CLEANED UP TO BE A PROPER EVETN SYSTEM/SCHEDULER
//Move cell stuff MUST COME AFTER unit_click
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
			unit := &world.player_units[chosen_cell.occupier_index]
			world.selected_unit = unit
			world.assign_move_cells()
		}
	}
}

move_cell_click :: proc() {
	//TODO: create a mouse event and schedule it
	// Other systems can grab the scheduled event and use it
	if rl.IsMouseButtonPressed(.LEFT) {
		chosen_cell := get_mouse_cell(world.grid_overlay)
		#partial switch chosen_cell.cell_type {
		case entities.Cell_Type.MOVE_CELL:
			//show move range
			if (f32(chosen_cell.col_x) / utils.CELL_SIZE !=
					   world.selected_unit.move_path.target_pos.x ||
				   f32(chosen_cell.row_y) / utils.CELL_SIZE !=
					   world.selected_unit.move_path.target_pos.y) {
				world.selected_unit.move_path.target_pos.x =
					f32(chosen_cell.col_x) / utils.CELL_SIZE
				world.selected_unit.move_path.target_pos.y =
					f32(chosen_cell.row_y) / utils.CELL_SIZE
				world.selected_unit.move_path.start_pos = {
					f32(world.selected_unit.pos_x),
					f32(world.selected_unit.pos_y),
				}
				world.selected_unit.move_path.path = pathfinding.a_star(
					utils.Vector2{f32(world.selected_unit.pos_x), f32(world.selected_unit.pos_y)},
					world.selected_unit.move_path.target_pos,
					world.valid_cell,
				)
				world.unit_moving = true
				fmt.printfln("%v", world.selected_unit.move_path.path)
			}
		case .DAMAGE_CELL:

		}
		if world.showing_overlay {
			world.should_clear_overlay = true
			world.clear_overlay()
		}
	}
}

@(private)
get_mouse_cell :: proc(grid: [10][10]entities.Cell) -> entities.Cell {
	mouse_grid_pos :=
		rl.GetMousePosition().xy /
		rl.Vector2{utils.CELL_SIZE * utils.CAMERA_ZOOM, utils.CELL_SIZE * utils.CAMERA_ZOOM}
	return(
		grid[clamp(i32(mouse_grid_pos.y), 0, i32(40 / utils.CAMERA_ZOOM) - 1)][clamp(i32(mouse_grid_pos.x), 0, i32(40 / utils.CAMERA_ZOOM) - 1)] \
	)
}
