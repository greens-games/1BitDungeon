package renderer

import "../world"
import rl "vendor:raylib"

draw_filled_plane :: proc(player: world.Player) {

	rl.DrawRectangle(0, 0, 16, 16, rl.WHITE)

	srcRec := rl.Rectangle{0, 0, 16, 16}
	desRec := rl.Rectangle{player.pos.x, player.pos.y, 16, 16}
	rl.DrawTexturePro(player.sprite_filled, srcRec, desRec, rl.Vector2{0, 0}, 0.0, rl.WHITE)
}

draw_outlined_plane :: proc(player: world.Player) {

	rl.DrawRectangle(10, 10, 16, 16, rl.WHITE)

	srcRec := rl.Rectangle{0, 0, 16, 16}
	desRec := rl.Rectangle{player.pos.x, player.pos.y, 16, 16}
	rl.DrawTexturePro(player.sprite_outline, srcRec, desRec, rl.Vector2{0, 0}, 0.0, rl.WHITE)
}
