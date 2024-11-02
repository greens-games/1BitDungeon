package world

import "../utils"
import "core:fmt"
import "core:testing"

World :: struct {
	grid: [2][2]Cell,
}


init :: proc() -> ^World {
	world := new(World)

	for data, r in world.grid {
		for value, c in world.grid[r] {
			new_cell := new(Cell)
			new_cell.col_x = i32(c * utils.CELL_SIZE)
			new_cell.row_y = i32(r * utils.CELL_SIZE)
			new_cell.cell_type = .FREE
			fmt.println(rawptr(new_cell))
		}
	}
	world.grid[0][1].cell_type = .WALL
	return world
}

clean_up :: proc(world: ^World) {
	//	free_all() //THIS WORKS BUT IS ONLY IDEAL IF THIS IS THE LAST THING WE ARE CLEANING UP

	for data, r in world.grid {
		for &value, c in world.grid[r] {
			fmt.println("Freeing address: ", rawptr(&value))
			free(&world.grid[r][c])
		}
	}
	free(world)
}

@(test)
init_test :: proc(t: ^testing.T) {
	world := init()
	defer clean_up(world)
	testing.expect(t, world.grid[0][1].cell_type == .WALL, "Didn't allocate properly?")
}
