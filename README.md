# PHASELINE — working title

An atmospheric, single-player signal-routing puzzle game about sending a neutrino message through a planet.

## Browser prototype

Open `index.html` in a modern desktop browser. Click relay tiles to rotate them, then press **Send pulse**. The pulse follows the arrows; route it to the receiver while avoiding the dampening field. `R` resets the board. There are three sequential field tests. This is a concept prototype, not a release build.

## Godot project

Open `godot/project.godot` with Godot 4.7.2 stable and run the main scene. The native prototype contains the same three puzzles, keyboard and touch controls, move counts, level progression, and a local save for unlocked progress. The interface contracts to a phone layout by hiding desktop-only mission notes and scaling the relay board to the available width.

## Tests

Run `npm test` with Node.js 22 or newer. The tests execute the browser game logic in a lightweight DOM mock and verify that each puzzle starts unsolved, reaches the receiver through its intended relay rotations, and advances to the next level. GitHub Actions imports the Godot project and runs `godot/tests/AutomatedPlaytest.gd`. The Godot test searches each actual board for a valid relay route, plays the lowest-click route through the scene, checks compact-phone and desktop UI layouts, verifies campaign progression, and exercises randomized relay misplays and reset behavior. CI exports Windows, Linux, universal macOS, and Android App Bundle builds; it launches the Linux export headlessly, runs the macOS app headlessly on a macOS runner, validates the Android App Bundle structure, and uploads platform artifacts for 14 days.

The macOS CI artifact is an unsigned development build. Gatekeeper may block it when downloaded; a public macOS release will need signing and notarization.

The Android CI artifact is a debug-signed App Bundle for build validation, not a Play Store submission. A Play release still needs a production upload key managed outside the repository, final launcher artwork and store assets, device testing, and Play Console review. New Google Play submissions currently need to target Android 16 (API 36) or higher.

## First-release target

- 30 handcrafted puzzles across three chapters
- A compact narrative about restoring a lost deep-space signal
- Keyboard and mouse support, remappable controls, color-safe symbols, reduced motion
- Windows first, with Steam Deck support evaluated during QA
- Premium, offline single-player; no accounts, ads, or microtransactions

## Development plan

See `STEAM_RELEASE_PLAN.md` for the staged roadmap and release gates.
`PLAYTEST_PROTOCOL.md` is an optional guide for gathering subjective feedback about clarity and enjoyment; human sessions are not required for automated CI validation.
