package test

import "../src/debug"
import "../src/pathfinding"
import "../src/utils"
import w "../src/world"
import "core:testing"

@(test)
equality_test :: proc(t: ^testing.T) {
	v1 := utils.Vector2{1, 1}
	v2 := utils.Vector2{1, 1}
	v3 := v1 + v2
	testing.expect(t, v1.xy == v2.xy, "They are not equal")
	testing.expect(t, v3.xy == {2, 2}, "They are not equal after adding")
}

@(test)
astar_test :: proc(t: ^testing.T) {
	w.init()
	defer w.clean_up()
	start := utils.Vector2{0, 0}
	goal := utils.Vector2{2, 0}
	pathfinding.a_star(start, goal, w.valid_cell)
}

@(test)
neighbours_test :: proc(t: ^testing.T) {
	w.init()
	defer w.clean_up()
	start := utils.Vector2{0, 0}
	goal := utils.Vector2{1, 0}
	parent := pathfinding.Node {
		pos = start,
	}
	nodes := pathfinding.get_all_neighbours(parent, w.valid_cell)
	defer delete(nodes)
	testing.expect(t, len(nodes) == 1)
}
