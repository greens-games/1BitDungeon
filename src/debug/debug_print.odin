package debug

import "../entities"
import "core:fmt"

print_battle_map :: proc(grid: [10][10]entities.Cell) {
	fmt.printf("    ")
	for col, c in grid[0] {
		fmt.printf("%v ", c)
	}
	fmt.println()
	for row, r in grid {
		fmt.print(r, ": ")
		for cell, c in row {
			switch cell.cell_type {
			case entities.Cell_Type.WALL:
				fmt.print("W ")
			case entities.Cell_Type.FREE:
				fmt.print("F ")
			case entities.Cell_Type.PLAYER_UNIT:
				fmt.print("P ")
			case entities.Cell_Type.ENEMY_UNIT:
				fmt.print("E ")
			case entities.Cell_Type.MOVE_CELL:
				fmt.print("M ")
			case entities.Cell_Type.DAMAGE_CELL:
				fmt.print("D ")
			}
		}
		fmt.println()
		fmt.println()
	}
}


print_battle_map_overlay :: proc(grid: [10][10]entities.Cell) {
	for row in grid {
		for cell in row {
			switch cell.cell_type {
			case entities.Cell_Type.WALL:
				fmt.print("W")
			case entities.Cell_Type.FREE:
				fmt.print("F")
			case entities.Cell_Type.PLAYER_UNIT:
				fmt.print("P")
			case entities.Cell_Type.ENEMY_UNIT:
				fmt.print("E")
			case entities.Cell_Type.MOVE_CELL:
				fmt.print("M")
			case entities.Cell_Type.DAMAGE_CELL:
				fmt.print("D ")
			}
		}
		fmt.println()
	}
}
