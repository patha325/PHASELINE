# Steam release plan — PHASELINE (working title)

## Product direction

**Genre:** atmospheric signal-routing puzzle game  
**Player fantasy:** carry a fragile message through a planet by shaping a beam through matter.  
**Core loop:** inspect a small network → rotate relay nodes → send a pulse → observe how matter changes the signal → solve and unlock the next puzzle.  
**Scope guardrail:** single-player, offline, no procedural campaign, no multiplayer, no live service.

## Ten stages

1. **Choose the hook and prove the mechanic (prototype complete).** The browser slice now contains three puzzles; automated checks verify that each starts unsolved, has a working route, and advances after success.
2. **Automate validation and lock scope (in progress).** GitHub Actions runs the browser logic tests and an autonomous Godot playtest. The Godot test searches each live puzzle board for a solution, minimizes relay clicks, plays it through the scene, and checks progression, randomized misplays, and reset behavior. Use these checks as the repeatable baseline and freeze the first-release feature list. Human sessions are optional and useful only for subjective clarity, accessibility, and enjoyment feedback.
3. **Build the game foundation (in progress).** A native Godot 4.7.2 project now contains the same three puzzles, keyboard controls, move counts, level progression, and local progress saving. Runtime validation, settings, audio, localization-ready UI, and repeatable exports remain to be completed.
4. **Create the campaign.** Build 30 authored puzzles in three chapters, introduce one rule at a time, add hints and optional mastery goals.
5. **Add presentation.** Establish final art direction, readable effects, music, sound, transitions, accessibility settings, and narrative moments.
6. **Test and polish.** Test Windows hardware and Steam Deck controls/resolution; address bugs, performance, save integrity, and usability. Keep a playable demo candidate.
7. **Prepare the Steam presence.** Complete Steamworks onboarding, identity/tax/bank details, store copy, capsules, gameplay screenshots, trailer, tags, pricing, and content survey. Steam Direct is currently $100 per app (or local equivalent); the account holder must complete payment and legal/tax setup.
8. **Publish Coming Soon and gather wishlists.** Submit the store page early, then share the demo with players and collect feedback. Incorporate only changes that do not destabilize the release.
9. **Submit the near-final build.** Complete Steamworks configuration and upload the build; pass Valve’s separate store-page and build reviews. Valve currently advises planning at least seven business days for each review, with extra time for fixes.
10. **Release and maintain.** Release only after the approvals and final QA gate; monitor crash reports and reviews, patch critical issues, and publish a small post-launch roadmap based on player response.

## Working schedule

This is a scope-based schedule, not a promise of a date. For a solo developer at part-time pace: 1–2 weeks for concept validation, 2–4 weeks for the foundation, 4–8 weeks for content and presentation, 2–3 weeks for QA/store preparation, plus Valve review time and any revision cycle. Re-estimate after the first external feedback if available.

## Risks and decisions

- The title is provisional; clear it before store assets or registration.
- The current prototype is intentionally small. Automated tests can validate reachability and regression behavior, but they cannot establish whether the game feels clear, satisfying, accessible, or fun; optional external feedback is still valuable before committing to a large campaign.
- Godot is not installed in this workspace; the native project has not yet been launched or exported. Godot 4.7.2 is the stable release selected for this project.
- Steam submission requires a Steamworks partner account, a paid app credit, bank/tax information, store assets, and the account holder’s actions. Publishing cannot be completed until those are available.
- Do not market scientific simulation accuracy; the game uses neutrino-inspired fiction and simplified puzzle rules.

## Done means

The game has a stable, reviewed build; the Steam store page accurately describes that build; all advertised features work; the controls are clearly presented; and the launch version passes automated start-to-finish playthroughs plus platform QA. Human usability feedback is a quality improvement, not a prerequisite for running the automated pipeline.
