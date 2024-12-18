package renderer

import "../debug"
import "../entities"
import "../utils"
import "../world"
import "core:fmt"
import rl "vendor:raylib"


draw_player_unit_texture :: proc(unit: entities.Player_Unit) {
	srcRec := rl.Rectangle{0, 0, 16, 16}
	desRec := rl.Rectangle {
		f32(unit.pos_x * utils.CELL_SIZE),
		f32(unit.pos_y * utils.CELL_SIZE),
		16,
		16,
	}
	rl.DrawTexturePro(unit.sprite_filled, srcRec, desRec, rl.Vector2{0, 0}, 0.0, rl.WHITE)
}

draw_enemy_unit_texture :: proc(unit: entities.Enemy_Unit) {
	srcRec := rl.Rectangle{0, 0, 16, 16}
	desRec := rl.Rectangle {
		f32(unit.pos_x * utils.CELL_SIZE),
		f32(unit.pos_y * utils.CELL_SIZE),
		16,
		16,
	}
	rl.DrawTexturePro(unit.sprite_outline, srcRec, desRec, rl.Vector2{0, 0}, 0.0, rl.WHITE)
}

draw_grid :: proc() {
	grid_cols := rl.GetScreenWidth() / utils.CELL_SIZE
	grid_rows := rl.GetScreenHeight() / utils.CELL_SIZE
	for r in 0 ..< grid_rows {
		for c in 0 ..< grid_cols {

			rec := rl.Rectangle {
				f32(c * utils.CELL_SIZE),
				f32(r * utils.CELL_SIZE),
				utils.CELL_SIZE,
				utils.CELL_SIZE,
			}
			rl.DrawRectangleLinesEx(rec, 0.15, rl.WHITE)
		}
	}
}

//Draw the battle map based on the world's Grid
//TODO: These battle map stuffs suck we should just have a few render buffers taht we iterate through that contains the pos and what to render (i.e texture, color, etc...) 
draw_battle_map :: proc() {
	for row, r in world.grid {
		for cell, c in row {
			#partial switch cell.cell_type {
			case .WALL:
				{
					rl.DrawRectangle(
						i32(c * utils.CELL_SIZE),
						i32(r * utils.CELL_SIZE),
						utils.CELL_SIZE,
						utils.CELL_SIZE,
						rl.WHITE,
					)
				}
			case .PLAYER_UNIT:
				{
					draw_player_unit_texture(world.player_units[cell.occupier_index])
				}

			case .ENEMY_UNIT:
				{
					draw_enemy_unit_texture(world.enemy_units[cell.occupier_index])
				}
			}
		}
	}
}


//Draw the battle map based on the world's Grid
//TODO: get rid of all this texture shenanigans
draw_battle_map_overlay :: proc(texture: rl.Texture2D) {
	for row, r in world.grid_overlay {
		for cell, c in row {
			#partial switch cell.cell_type {
			case .MOVE_CELL:
				{
					draw_move_cell(r, c)
				}

			case .DAMAGE_CELL:
				{
					draw_damage_cell(r, c, texture)
				}
			}
		}
	}
}

@(private)
draw_move_cell :: proc(r, c: int) {
	rec := rl.Rectangle {
		f32(c * utils.CELL_SIZE),
		f32(r * utils.CELL_SIZE),
		utils.CELL_SIZE,
		utils.CELL_SIZE,
	}
	rl.DrawRectangleLinesEx(rec, 1.0, rl.WHITE)
}

draw_damage_cell :: proc(r, c: int, damage_cell_texture: rl.Texture2D) {
	srcRec := rl.Rectangle{0, 0, 16, 16}
	desRec := rl.Rectangle{f32(c * utils.CELL_SIZE), f32(r * utils.CELL_SIZE), 16, 16}
	rl.DrawTexturePro(damage_cell_texture, srcRec, desRec, rl.Vector2{0, 0}, 0.0, rl.WHITE)
}

/*

@(private)
draw_four_move_corners :: proc(r, c: i16, unit: entities.Player_Unit) {

	rec := rl.Rectangle {
		f32((unit.pos_x + r) * utils.CELL_SIZE),
		f32((unit.pos_y + c) * utils.CELL_SIZE),
		utils.CELL_SIZE,
		utils.CELL_SIZE,
	}

	rec2 := rl.Rectangle {
		f32((unit.pos_x + -r) * utils.CELL_SIZE),
		f32((unit.pos_y + c) * utils.CELL_SIZE),
		utils.CELL_SIZE,
		utils.CELL_SIZE,
	}

	rec3 := rl.Rectangle {
		f32((unit.pos_x + -r) * utils.CELL_SIZE),
		f32((unit.pos_y + -c) * utils.CELL_SIZE),
		utils.CELL_SIZE,
		utils.CELL_SIZE,
	}


	rec4 := rl.Rectangle {
		f32((unit.pos_x + r) * utils.CELL_SIZE),
		f32((unit.pos_y + -c) * utils.CELL_SIZE),
		utils.CELL_SIZE,
		utils.CELL_SIZE,
	}
	rl.DrawRectangleLinesEx(rec, 1.0, rl.WHITE)
	rl.DrawRectangleLinesEx(rec2, 1.0, rl.WHITE)
	rl.DrawRectangleLinesEx(rec3, 1.0, rl.WHITE)
	rl.DrawRectangleLinesEx(rec4, 1.0, rl.WHITE)
}
*/
