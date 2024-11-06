package world

import "../entities"
import "../utils"
import "core:fmt"
import "core:testing"
import rl "vendor:raylib"


//static var here
//We initialize outside of procedure so this world file contains the same world all over
rows :: int(40 / utils.CAMERA_ZOOM)
cols :: int(40 / utils.CAMERA_ZOOM)
grid := [rows][cols]Cell{} //could probably be a matrix
player_units: [3]entities.Player_Unit //We should know max player unit size so don't need dynamic
selected_unit: entities.Player_Unit

init :: proc() {
	for data, r in grid {
		for value, c in grid[r] {
			grid[r][c].col_x = i32(c * utils.CELL_SIZE)
			grid[r][c].row_y = i32(r * utils.CELL_SIZE)
			grid[r][c].cell_type = .FREE
		}
	}
	grid[0][1].cell_type = .WALL

	//Set players based on map data
	grid[1][1].cell_type = .PLAYER_UNIT
	grid[1][1].occupier_index = 0
	player_units[0] = entities.Player_Unit {
		pos_x          = 1,
		pos_y          = 1,
		move_range     = 3,
		dmg            = 5,
		sprite_filled  = rl.LoadTexture("./res/player_filled.png"),
		sprite_outline = rl.LoadTexture("./res/player_outline.png"),
	}
}

clean_up :: proc() {
	free_all() //THIS WORKS BUT IS ONLY IDEAL IF THIS IS THE LAST THING WE ARE CLEANING UP

	/* This results in alot of bad frees
	for data, r in world.grid {
		for &value, c in world.grid[r] {
			fmt.println("Freeing address: ", rawptr(&value))
			free(&world.grid[r][c])
		}
	}
	free(world)
	*/
}

valid_cell :: proc(
	curr_pos: utils.Vector2,
	next_pos: utils.Vector2,
	movement: utils.Vector2,
) -> bool {
	if (int(next_pos.y) > len(grid) - 1 || int(next_pos.x) > len(grid[0]) - 1) ||
	   (next_pos.x < 0 || next_pos.y < 0) {
		return false
	}

	//Check for non-walkable terrain
	if grid[int(next_pos.y)][int(next_pos.x)].cell_type == .WALL {
		return false
	}

	//Diagonal movement check for adjacent terrain
	/*
	if movement.y != 0 && movement.x != 0 {
		if world.grid[int(curr_pos.y + movement.y)][int(curr_pos.x)].cell_type == .WALL &&
		   world.grid[int(curr_pos.y)][int(curr_pos.x + movement.x)].cell_type == .WALL {
			return false
		}
	}
	*/
	return true
}
