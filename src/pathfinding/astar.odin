package pathfinding


import "../utils"
import w "../world"
import "core:fmt"
import "core:math"
import "core:testing"

Successor :: struct {
	parent_id: i32,
	pos:       utils.Vector2,
	f:         i32,
	g:         i32,
	h:         i32,
}
Node :: struct {
	parent_index: i32,
	//Use row + col for pos
	pos:          utils.Vector2,
	f:            f32,
	g:            f32,
	h:            f32,
}


///AStar pathfinding to find the close to most optimal path
a_star :: proc(
	start: utils.Vector2,
	goal: utils.Vector2,
	valid_proc: proc(_: utils.Vector2, _: utils.Vector2, _: utils.Vector2) -> bool,
) -> [dynamic]utils.Vector2 {
	open_list := [dynamic]Node{}
	defer delete(open_list)

	close_list := [dynamic]Node{}
	defer delete(close_list)


	start_node := Node {
		parent_index = -1,
		pos          = start,
		f            = 0,
		g            = 1,
		h            = calc_h(goal, start),
	}

	append(&open_list, start_node)

	index := 0

	for len(open_list) > 0 {
		q := open_list[find_lowest_f(open_list)]
		unordered_remove(&open_list, find_lowest_f(open_list))
		append(&close_list, q)

		if q.pos.xy == goal.xy {
			break
		}

		successors := get_all_neighbours(q, valid_proc)
		defer delete(successors)

		successor_loop: for &successor in successors {
			//check if successor pos is in closed list
			for node in close_list {
				if successor.pos.xy == node.pos.xy {
					//we are in the close list so ignore this successor
					continue successor_loop //supposed to continue successor
				}
			}
			//calculate g,h,f for successor
			successor.g = q.g + calc_g(start, successor.pos)
			successor.h = calc_h(goal, successor.pos)
			successor.f = calc_f(successor.h, successor.g)
			//check if successor pos is in open list
			for &node in open_list {
				if successor.pos.xy == node.pos.xy {
					if successor.g < node.g && successor.f < node.f && successor.h < node.h {
						node.g = successor.g
						node.h = successor.h
						node.f = successor.f
						node.parent_index = successor.parent_index
						continue successor_loop //supposed to continue successor
					}
				}
			}
			successor.parent_index = i32(index)
			finalNode: Node = successor
			append(&open_list, finalNode)
		}

		index += 1
	}
	return back_track(close_list)
}


get_all_neighbours :: proc(
	parent: Node,
	valid_proc: proc(_: utils.Vector2, _: utils.Vector2, _: utils.Vector2) -> bool,
) -> [dynamic]Node {
	move1 := utils.Vector2{1, 0}
	move3 := utils.Vector2{0, 1}
	move5 := utils.Vector2{-1, 0}
	move7 := utils.Vector2{0, -1}
	moves := [4]utils.Vector2{move1, move3, move5, move7}
	nodes := make([dynamic]Node)

	for move in moves {
		new_pos := parent.pos + move
		_ = new_pos
		if valid_proc(parent.pos, new_pos, move) {
			node: Node = {
				pos = new_pos,
			}
			append(&nodes, node)
		}
	}
	return nodes
}


//O(n) always because we need to look at every node added
find_lowest_f :: proc(list: [dynamic]Node) -> int {
	smallest: f32 = 1000.0
	current_index := 0
	for value, i in list {
		if (value.f < smallest) {
			current_index = i
			smallest = value.f
		}
	}
	return current_index
}

calc_f :: proc(h: f32, g: f32) -> f32 {
	return h + g
}
calc_g :: proc(start_pos: utils.Vector2, move_pos: utils.Vector2) -> f32 {
	return 1.0
}
calc_h :: proc(goal_pos: utils.Vector2, move_pos: utils.Vector2) -> f32 {
	//Diagonal
	dx := math.abs(f32(move_pos.x) - f32(goal_pos.x))
	dy := math.abs(f32(move_pos.y) - f32(goal_pos.y))

	D :: 1
	D2 := math.sqrt_f32(2.0)

	h := D * (dx + dy) + (D2 - 2 * D) * math.min(dx, dy)
	//Euclidean
	//const h:f32 = @sqrt(2 * (move_pos.x - goal_pos.x) + 2 * (move_pos.y - goal_pos.y));

	return h
}


back_track :: proc(list: [dynamic]Node) -> [dynamic]utils.Vector2 {
	curr_node: Node = list[len(list) - 1]
	ret_list := [dynamic]utils.Vector2{} //I'll need to heap allocate this one

	i: u32 = 100

	for curr_node.parent_index >= 0 {
		append(&ret_list, curr_node.pos)
		curr_node = list[curr_node.parent_index]
	}
	return ret_list
}

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
	defer w.clean_up(w.world)
	start := utils.Vector2{0, 0}
	goal := utils.Vector2{2, 0}
	a_star(start, goal, w.valid_cell)
}

@(test)
neighbours_test :: proc(t: ^testing.T) {
	defer w.clean_up(w.world)
	start := utils.Vector2{0, 0}
	goal := utils.Vector2{1, 0}
	parent := Node {
		pos = start,
	}
	nodes := get_all_neighbours(parent, w.valid_cell)
	delete(nodes)
	testing.expect(t, len(nodes) == 1)
}
