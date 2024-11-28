package input

import "../world"
import "core:fmt"
import rl "vendor:raylib"

detect_key_press :: proc() {
	if rl.IsKeyPressed(.Q) {
		world.clear_overlay()
		world.assign_attack_cells()
	}
}
