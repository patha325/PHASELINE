# PHASELINE — working title

An atmospheric, single-player signal-routing puzzle game about sending a neutrino message through a planet.

## Browser prototype

Open `index.html` in a modern desktop browser. Click relay tiles to rotate them, then press **Send pulse**. The pulse follows the arrows; route it to the receiver while avoiding the dampening field. `R` resets the board. There are three sequential field tests. This is a concept prototype, not a release build.

## Godot project

Open `godot/project.godot` with Godot 4.7.2 stable and run the main scene. The native prototype contains the same three puzzles, keyboard controls, move counts, level progression, and a local save for unlocked progress. GitHub Actions exports Windows and Linux builds; it launches the Linux release export headlessly as a packaged-build smoke test.

## Tests

Run `npm test` with Node.js 22 or newer. The tests execute the browser game logic in a lightweight DOM mock and verify that each puzzle starts unsolved, reaches the receiver through its intended relay rotations, and advances to the next level. GitHub Actions imports the Godot project and runs `godot/tests/AutomatedPlaytest.gd`. The Godot test searches each actual board for a valid relay route, plays the lowest-click route through the scene, verifies campaign progression, and checks randomized relay misplays and reset behavior. CI exports Windows, Linux, and universal macOS release builds, launches the Linux export headlessly, runs the macOS app headlessly on a macOS runner, and uploads Windows and macOS builds as 14-day Actions artifacts.

The macOS CI artifact is an unsigned development build. Gatekeeper may block it when downloaded; a public macOS release will need signing and notarization.

## First-release target

- 30 handcrafted puzzles across three chapters
- A compact narrative about restoring a lost deep-space signal
- Keyboard and mouse support, remappable controls, color-safe symbols, reduced motion
- Windows first, with Steam Deck support evaluated during QA
- Premium, offline single-player; no accounts, ads, or microtransactions

## Development plan

See `STEAM_RELEASE_PLAN.md` for the staged roadmap and release gates.
`PLAYTEST_PROTOCOL.md` is an optional guide for gathering subjective feedback about clarity and enjoyment; human sessions are not required for automated CI validation.
