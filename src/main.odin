package main

import "core:fmt"
import "core:io"
import rl "vendor:raylib"

import "renderer"
import "world"


main :: proc() {
	rl.InitWindow(800, 450, "raylib [core] example - basic window")
	rl.SetTargetFPS(60)

	player := world.Player {
		rl.Vector2{0, 0},
		rl.LoadTexture("./res/player_filled.png"),
		rl.LoadTexture("./res/player_outline.png"),
	}

	phasing := false


	camera := rl.Camera2D{rl.Vector2(0), rl.Vector2(0), 0.0, 5.0}
	for !rl.WindowShouldClose() {
		rl.SwapScreenBuffer()
		//Game Systems
		{
			if rl.IsKeyPressed(.R) {
				phasing = !phasing
			}

			//Move input
			if rl.IsKeyPressed(.D) {
				player.pos.x += 16
			}

			if rl.IsKeyPressed(.A) {
				player.pos.x -= 16
			}

			if rl.IsKeyPressed(.S) {
				player.pos.y += 16
			}

			if rl.IsKeyPressed(.W) {
				player.pos.y -= 16
			}

		}

		//Render
		{
			rl.BeginDrawing()
			camera.target = player.pos
			camera.offset = rl.Vector2{f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)}
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
