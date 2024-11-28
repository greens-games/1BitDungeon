package main

import "core:fmt"
import "core:io"
import "core:mem"
import rl "vendor:raylib"

import "debug"
import "input"
import "renderer"
import "systems"
import "utils"
import "world"


main :: proc() {

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}
	rl.InitWindow(640, 640, "raylib [core] example - basic window")
	flags := rl.ConfigFlags{.VSYNC_HINT}
	rl.SetConfigFlags(flags)
	rl.SetTargetFPS(60)
	damage_cell_texture := rl.LoadTexture("./res/attack_cell.png")

	//REMOVE THIS, USE PLAYER_UNIT INSTEAD
	world.init()
	defer world.clean_up()
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
			input.detect_key_press()
			input.move_cell_click()
			input.unit_click()
			systems.move_unit()
		}

		//Render
		{
			rl.BeginDrawing()
			rl.BeginMode2D(camera)
			rl.ClearBackground(rl.BLACK)
			//TODO: There's someting weird going on with the drawing of my player texture vertical and diagonal

			renderer.draw_battle_map()
			renderer.draw_battle_map_overlay(damage_cell_texture)
			renderer.draw_grid()
			rl.EndMode2D()
			rl.EndDrawing()
		}
	}
}
