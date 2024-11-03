package input

import "../world"
import rl "vendor:raylib"

player_movement_input :: proc(player: ^world.Player, camera: ^rl.Camera2D) {

	//Move input
	if rl.IsKeyDown(.D) {
		player.pos.x += 100 * rl.GetFrameTime()
	}

	if rl.IsKeyDown(.A) {
		player.pos.x -= 100 * rl.GetFrameTime()
	}

	if rl.IsKeyDown(.S) {
		player.pos.y += 100 * rl.GetFrameTime()
	}

	if rl.IsKeyDown(.W) {
		player.pos.y -= 100 * rl.GetFrameTime()
	}

	camera.target = player.pos
	camera.offset = rl.Vector2{f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)}
}
