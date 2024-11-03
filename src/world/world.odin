package world

import "../utils"
import "core:fmt"
import "core:testing"

World :: struct {
	grid: [32][32]Cell,
}

//static var here
//We initialize outside of procedure so this world file contains the same world all over
world := init()

init :: proc() -> ^World {
	world := new(World)

	for data, r in world.grid {
		for value, c in world.grid[r] {
			new_cell := new(Cell)
			new_cell.col_x = i32(c * utils.CELL_SIZE)
			new_cell.row_y = i32(r * utils.CELL_SIZE)
			new_cell.cell_type = .FREE
			//			fmt.println(rawptr(new_cell))
		}
	}
	world.grid[0][1].cell_type = .WALL
	return world
}

clean_up :: proc(world: ^World) {
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
	if (int(next_pos.y) > len(world.grid) - 1 || int(next_pos.x) > len(world.grid[0]) - 1) ||
	   (next_pos.x < 0 || next_pos.y < 0) {
		return false
	}

	//Check for non-walkable terrain
	if world.grid[int(next_pos.y)][int(next_pos.x)].cell_type == .WALL {
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

@(test)
init_test :: proc(t: ^testing.T) {
	world := init()
	defer clean_up(world)
	testing.expect(t, world.grid[0][1].cell_type == .WALL, "Didn't allocate properly?")
}
