package main

import "core:fmt"
import "core:io"
import rl "vendor:raylib"

import "input"
import "renderer"
import "world"


main :: proc() {
	rl.InitWindow(800, 450, "raylib [core] example - basic window")
	rl.SetTargetFPS(60)

	player := world.Player {
		rl.Vector2{0, 0},
		rl.LoadTexture("./res/player_filled.png"),
		rl.LoadTexture("./res/player_outline.png"),
		//		rl.LoadTexture("./res/player_filled_transparent.png"),
		//		rl.LoadTexture("./res/player_outline_transparent.png"),
	}

	phasing := false


	camera := rl.Camera2D{rl.Vector2(0), rl.Vector2(0), 0.0, 3.0}
	for !rl.WindowShouldClose() {
		rl.SwapScreenBuffer()
		//Game Systems
		{
			if rl.IsKeyPressed(.R) {
				phasing = !phasing
			}

			//NOTE: This is not part of the tactics thing but more for playing around with other ideas
			//			input.player_movement_input(&player, &camera)


		}

		//Render
		{
			rl.BeginDrawing()
			rl.BeginMode2D(camera)
			rl.ClearBackground(rl.BLACK)
			//TODO: There's someting weird going on with the drawing of my player texture vertical and diagonal

			if phasing {
				renderer.draw_outlined_plane(player)
			} else {
				renderer.draw_filled_plane(player)
			}
			rl.EndMode2D()
			rl.EndDrawing()
		}
	}
}
