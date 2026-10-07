# PHASELINE — working title

An atmospheric, single-player signal-routing puzzle game about sending a neutrino message through a planet.

## Browser prototype

Open `index.html` in a modern desktop browser. Click relay tiles to rotate them, then press **Send pulse**. The pulse follows the arrows; route it to the receiver while avoiding the dampening field. `R` resets the board. There are three sequential field tests. This is a concept prototype, not a release build.

## Godot project

Open `godot/project.godot` with Godot 4.7.2 stable and run the main scene. The native prototype contains the same three puzzles, keyboard controls, move counts, level progression, and a local save for unlocked progress. It has been code-reviewed here but not launched or exported because the Godot executable is unavailable in this workspace.

## Tests

Run `npm test` with Node.js 22 or newer. The tests execute the browser game logic in a lightweight DOM mock and verify that each puzzle starts unsolved, reaches the receiver through its intended relay rotations, and advances to the next level. GitHub Actions also imports the Godot project and runs `godot/tests/AutomatedPlaytest.gd`, which plays all three puzzles through the actual scene and checks campaign completion.

## First-release target

- 30 handcrafted puzzles across three chapters
- A compact narrative about restoring a lost deep-space signal
- Keyboard and mouse support, remappable controls, color-safe symbols, reduced motion
- Windows first, with Steam Deck support evaluated during QA
- Premium, offline single-player; no accounts, ads, or microtransactions

## Development plan

See `STEAM_RELEASE_PLAN.md` for the staged roadmap and release gates.
