package test

import "../src/world"
import "core:testing"

@(test)
init_test :: proc(t: ^testing.T) {
	world.init()
	defer world.clean_up()
	testing.expect(t, world.grid[0][1].cell_type == .WALL, "Didn't allocate properly?")
}
