package world

import "../components"
import rl "vendor:raylib"

Player :: struct {
	pos:            rl.Vector2,
	move_path:      components.Path,
	sprite_filled:  rl.Texture2D,
	sprite_outline: rl.Texture2D,
}
