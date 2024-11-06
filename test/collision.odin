package test

import "../src/physics"
import "../src/utils"
import "core:testing"

@(test)
test_collide :: proc(t: ^testing.T) {
	a := utils.Vector2{0, 0}
	b := utils.Vector2{16, 16}
	size := utils.Vector2{utils.CELL_SIZE, utils.CELL_SIZE}
	ok := physics.collide(a, size, b, size)
	testing.expect(t, ok)

}
