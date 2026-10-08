# PHASELINE optional human feedback guide

Automated validation is the default: GitHub Actions solves the live Godot boards and checks progression, misplays, and reset behavior. Use this guide only when people are available and subjective feedback on clarity or enjoyment would help. A human session is not required to run or pass CI.

## Purpose

Find out whether a first-time player understands the signal-routing rules, can solve the first puzzle without coaching, and wants to continue. This is a usability and fun check, not a test of the player.

## Session setup

- Recruit 3–5 people who have not seen the prototype.
- Use the browser build at `index.html` in a desktop browser.
- Allow about 10–15 minutes per person.
- Ask permission before recording audio or video. Notes alone are sufficient; do not collect names or other personal details.
- Give the player the controls: click a relay to rotate it, **Send pulse** to test the route, and **Reset** to restart.
- Do not explain the rules or point out a route during the session.

## Observe

Start timing when the board appears. Let the player think aloud if comfortable. Record observations without correcting them:

| Measure | Record |
| --- | --- |
| Time to first relay click | seconds |
| Time to first pulse | seconds |
| Did they identify the receiver and goal? | yes / no; note their wording |
| Did they understand why the first pulse failed? | yes / no / uncertain |
| Did they solve puzzle 1 without a hint? | yes / no; time and attempts |
| Did they discover and start puzzle 2? | yes / no |
| Did they reach puzzle 3? | yes / no |
| Any confusion, frustration, or bug | short observation |

If the player is stuck, wait 60 seconds, then ask only: “What do you think the game is asking you to do?” Give no hint unless they ask to stop.

## Ask afterwards

Use a 1–5 rating (1 = strongly disagree, 5 = strongly agree):

1. I understood the goal quickly.
2. I understood what the pulse did after each attempt.
3. The relay controls felt predictable.
4. Solving a puzzle felt satisfying.
5. I would play another level.

Then ask: “What was the most confusing moment?” and “What would you change first?”

## Optional product feedback

Treat these as initial signals, not statistical claims. If you choose to recruit players, consider campaign expansion when:

- At least 4 of 5 players can describe the goal within one minute.
- At least 4 of 5 solve puzzle 1 without a hint.
- Average ratings for goal clarity and control predictability are at least 4/5.
- Most players want to continue after the first puzzle.

If a threshold is missed, consider fixing the rules, feedback, or first-puzzle layout before expanding to 30 levels. Automated checks continue to catch broken routes and regressions, but they cannot judge enjoyment or discover every usability problem.

## Session notes template

Copy this section once per participant; keep participants anonymous.

```text
Participant: P__
First relay click: __ sec
First pulse: __ sec
Goal identified within 1 min: yes / no
Understood failure feedback: yes / no / uncertain
Puzzle 1 solved without hint: yes / no; __ sec; __ attempts
Reached puzzle 2: yes / no
Reached puzzle 3: yes / no
Ratings (goal / feedback / controls / satisfaction / continue): __ / __ / __ / __ / __
Most confusing moment:
First change they would make:
Observed bugs or friction:
```
