package debug

import "../world"
import "core:fmt"

print_battle_map :: proc() {

	for row in world.grid {
		for cell in row {
			switch cell.cell_type {
			case .WALL:
				fmt.print("W")
			case .FREE:
				fmt.print("F")
			case .PLAYER_UNIT:
				fmt.print("P")
			case .ENEMY_UNIT:
				fmt.print("E")
			}
		}
		fmt.println()
	}
}
