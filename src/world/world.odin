package world

import "../components"
import "../debug"
import "../entities"
import "../utils"
import "core:fmt"
import "core:testing"
import rl "vendor:raylib"


//static var here
//We initialize outside of procedure so this world file contains the same world all over
rows :: int(40 / utils.CAMERA_ZOOM)
cols :: int(40 / utils.CAMERA_ZOOM)
grid := [rows][cols]entities.Cell{} //could probably be a matrix
grid_overlay := [rows][cols]entities.Cell{} //could probably be a matrix
showing_overlay := false
should_clear_overlay := false
player_units: [3]entities.Player_Unit
enemy_units: [8]entities.Enemy_Unit
selected_unit: ^entities.Player_Unit
unit_moving := false

init :: proc() {
	for data, r in grid {
		for value, c in grid[r] {
			grid[r][c].col_x = i32(c * utils.CELL_SIZE)
			grid[r][c].row_y = i32(r * utils.CELL_SIZE)
			grid[r][c].cell_type = entities.Cell_Type.FREE

			grid_overlay[r][c].col_x = i32(c * utils.CELL_SIZE)
			grid_overlay[r][c].row_y = i32(r * utils.CELL_SIZE)
			grid_overlay[r][c].cell_type = entities.Cell_Type.FREE
		}
	}
	grid[3][5].cell_type = entities.Cell_Type.WALL

	//Set players based on map data
	grid[4][5].cell_type = entities.Cell_Type.PLAYER_UNIT
	grid[6][5].cell_type = entities.Cell_Type.ENEMY_UNIT
	grid[4][5].occupier_index = 0
	grid[6][5].occupier_index = 0
	//Why do we need to allocate here?
	player_unit_weapon := components.Weapon {
		damage      = 5,
		min_range   = 2,
		max_range   = 2,
		weapon_type = .AXE,
	}
	unit := entities.Player_Unit {
		id             = 0,
		pos_x          = 5,
		pos_y          = 4,
		move_range     = 3,
		dmg            = 5,
		sprite_filled  = rl.LoadTexture("./res/player_filled.png"),
		sprite_outline = rl.LoadTexture("./res/player_outline.png"),
		weapon         = player_unit_weapon,
	}

	//TODO: Move enemy stuff to battle.odin
	enemy_unit := entities.Enemy_Unit {
		pos_x          = 5,
		pos_y          = 6,
		move_range     = 3,
		dmg            = 5,
		sprite_filled  = rl.LoadTexture("./res/player_filled.png"),
		sprite_outline = rl.LoadTexture("./res/player_outline.png"),
	}
	player_units[0] = unit
	enemy_units[0] = enemy_unit
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

//Assign the move cells based on the selected unit, if there's no selected unit reset the move cells
assign_move_cells :: proc() {
	for r in 0 ..= selected_unit.move_range {
		for c in 0 ..= selected_unit.move_range {
			if r + c <= selected_unit.move_range {
				if r == 0 && c == 0 {
					continue
				}
				set_corner_move(r, c, selected_unit^, .MOVE_CELL, false)
			}
		}
	}
	showing_overlay = true
}

assign_attack_cells :: proc() {
	for r in 0 ..= selected_unit.weapon.max_range {
		for c in 0 ..= selected_unit.weapon.max_range {
			fmt.printfln("trying to target (%v, %v)", r, c)
			if r + c <= selected_unit.weapon.max_range {
				if r == 0 && c == 0 {
					continue
				}
				if r + c < selected_unit.weapon.min_range {
					continue
				}
				set_corner_move(i16(r), i16(c), selected_unit^, .DAMAGE_CELL, true)
			}
		}
	}
	showing_overlay = true
}

clear_overlay :: proc() {
	for data, r in grid_overlay {
		for value, c in grid_overlay[r] {
			grid_overlay[r][c].cell_type = entities.Cell_Type.FREE
		}
	}
	showing_overlay = false
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
	cell_type := grid[int(next_pos.y)][int(next_pos.x)].cell_type
	if cell_type == .WALL || cell_type == .ENEMY_UNIT {
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

valid_cell_1param :: proc(next_pos: utils.Vector2, target_enemies: bool) -> bool {
	if (int(next_pos.y) > len(grid) - 1 || int(next_pos.x) > len(grid[0]) - 1) ||
	   (next_pos.x < 0 || next_pos.y < 0) {
		return false
	}
	//Check for non-walkable terrain

	cell_type := grid[int(next_pos.y)][int(next_pos.x)].cell_type
	if cell_type == .WALL || (!target_enemies && cell_type == .ENEMY_UNIT) {
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

@(private)
set_corner_move :: proc(
	r, c: i16,
	unit: entities.Player_Unit,
	cell_type: entities.Cell_Type,
	target_enemies: bool,
) {
	if valid_cell_1param(utils.Vector2{f32(unit.pos_x + c), f32(unit.pos_y + r)}, target_enemies) {
		grid_overlay[(unit.pos_y + r)][(unit.pos_x + c)].cell_type = cell_type
	}
	if valid_cell_1param(utils.Vector2{f32(unit.pos_x + c), f32(unit.pos_y - r)}, target_enemies) {
		grid_overlay[(unit.pos_y - r)][(unit.pos_x + c)].cell_type = cell_type
	}
	if valid_cell_1param(utils.Vector2{f32(unit.pos_x - c), f32(unit.pos_y - r)}, target_enemies) {
		grid_overlay[(unit.pos_y - r)][(unit.pos_x - c)].cell_type = cell_type
	}
	if valid_cell_1param(utils.Vector2{f32(unit.pos_x - c), f32(unit.pos_y + r)}, target_enemies) {
		grid_overlay[(unit.pos_y + r)][(unit.pos_x - c)].cell_type = cell_type
	}
}
