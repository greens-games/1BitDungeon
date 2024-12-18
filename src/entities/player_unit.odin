package entities

import "../components"
import rl "vendor:raylib"


Player_Unit :: struct {
	id:             int,
	pos_x:          i16,
	pos_y:          i16,
	move_range:     i16,
	dmg:            i16,
	sprite_filled:  rl.Texture2D,
	sprite_outline: rl.Texture2D,
	move_path:      components.Path,
	weapon:         components.Weapon,
	//Class
	//Item
}
