package main

import "core:fmt"
import "core:io"
import rl "vendor:raylib"

import "debug"
import "input"
import "renderer"
import "utils"
import "world"


main :: proc() {
	rl.InitWindow(640, 640, "raylib [core] example - basic window")
	flags := rl.ConfigFlags{.VSYNC_HINT}
	rl.SetConfigFlags(flags)
	rl.SetTargetFPS(60)

	//REMOVE THIS, USE PLAYER_UNIT INSTEAD
	world.init()
	defer world.clean_up()
	fmt.println(world.grid[0][1])
	phasing := false

	camera := rl.Camera2D{rl.Vector2(0), rl.Vector2(0), 0, utils.CAMERA_ZOOM}
	for !rl.WindowShouldClose() {
		rl.SwapScreenBuffer()
		//Game Systems
		{
			if rl.IsKeyPressed(.R) {
				phasing = !phasing
			}

			//NOTE: This is not part of the tactics thing but more for playing around with other ideas
			//			input.player_movement_input(&player, &camera)
			input.detect_hover()
			input.unit_click()
		}

		//Render
		{
			rl.BeginDrawing()
			rl.BeginMode2D(camera)
			rl.ClearBackground(rl.BLACK)
			//TODO: There's someting weird going on with the drawing of my player texture vertical and diagonal

			renderer.draw_battle_map()
			renderer.draw_grid()
			rl.EndMode2D()
			rl.EndDrawing()
		}
	}
}
