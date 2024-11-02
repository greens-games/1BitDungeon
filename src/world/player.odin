package world

import rl "vendor:raylib"

Player :: struct {
	pos:            rl.Vector2,
	sprite_filled:  rl.Texture2D,
	sprite_outline: rl.Texture2D,
}
