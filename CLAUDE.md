# Cut the Sky — working instructions

**The one constraint that rules everything (read first, repeated at the
bottom):** this game launches **August 15, 2026, 8:00 IST** — India's
Independence Day. One developer + Claude Code, native Apple Silicon macOS,
Godot 4 (stable, pinned). No work may be added unless it protects or
improves the core 60-second experience. Full spec: [DESIGN.md](DESIGN.md).

## What this is

A tiny kite-fighting score-attack game celebrating the Independence Day
kite tradition. Pointer steers, one button tightens the ribbon; sharp
ribbons cut, over-tension snaps your own line. Runs last 45–120 s, restart
in under one second, the results card is worth sharing as an image.

## Non-negotiables (from the ten pillars — never trade these away)

- One pointer, one button. Keyboard fallback only.
- First cut or near-miss within five seconds of a run starting.
- Failure always attributable to a readable player decision.
- No login, server, leaderboard or network anything.
- No flag kites; flags are never cuttable. No religious imagery, party
  symbols or real politicians. Abstract skyline, not monuments.
- Celebration through colour, paper, wind, sound, crowd — joyful, welcoming
  to players who know nothing about India.

## Hard dates (enforced on behavioral evidence, not opinions)

- **July 21** — physics checkpoint: pointer-spring steering feels good, or
  fall back to click-to-move.
- **July 22** — KILL GATE: five cold testers grasp the rule in 10 s, ≥3
  voluntarily replay, they blame themselves not the collision system.
  Fail → pivot to Rangoli Relay (DESIGN.md §18) on July 23. Playable main
  branch from this date onward.
- **Aug 5** — feature freeze. After this only comprehension, crash or
  distribution fixes.
- **Aug 12** — release candidate. **Aug 15, 8:00 IST** — launch on itch.io.

## Engineering rules

- Godot 4 stable, pinned — never upgrade mid-project. GDScript only; no
  native plugins unless Godot genuinely cannot do the task.
- ALL tuning constants live in `GameConfig.tres` — feel iteration must
  never require hunting through scripts.
- Simulation logic strictly separate from presentation effects.
- Deterministic seeded randomness everywhere practical (seeds are a
  feature: replay + shareability).
- No realistic aerodynamics, no rope physics, no severed-string simulation
  — authored fakes read better and cannot destroy the schedule.
- Commit every independently working mechanic; short imperative subject,
  body explains the *feel lesson* when there is one.
- 60 FPS on a base M1 is an acceptance test, not an aspiration.

## Working methodology (carried over from civ7-netaji-mod / humankind-mod)

- **Loop Engineering:** research → verify → implement → validate → playtest
  (user has eyes on the game) → commit. The user drives all in-game feel
  verdicts; never claim something "feels good" from code inspection.
- **Sandwiching:** critical constraints at the start AND end of any long
  brief or agent dispatch.
- **Advisor/Executioner split:** heavy external research goes to the user's
  external chat projects; mechanical batch work goes to cheaper-model
  agents; judgment calls and debugging stay here.
- **Token discipline:** dispatch exploration to background agents, batch
  independent tool calls, persist hard-won facts here and in auto-memory
  rather than re-deriving.
- **Verify field-saves:** after editing any Godot resource/scene via text,
  confirm the change actually persisted (lesson from the Humankind
  Inspector silent-save failure).

## Division of labor

Implementation, Godot work, tuning plumbing, build/notarization, store-page
mechanics → Claude Code here. Playtesting verdicts, kill-gate decisions,
art/audio taste calls, marketing posts under their own name → the user.
Cold-tester recruitment (five people, July 22) → the user, offline.

## Distribution

itch.io day one: signed + notarized ZIP, free with optional payment ($3
suggested). Mac App Store parallel submission ~Aug 10–12. Steam
post-launch only. Marketing calendar: DESIGN.md §16 — teaser GIF July 28,
itch page Aug 5, Show HN + Product Hunt on launch day.

---
**Reminder (sandwiched):** Aug 15 8:00 IST is immovable. July 22 kill gate
is behavioral and cannot be postponed by any amount of new art, effects or
enemies. When in doubt, cut scope — never the date. The loop is the
product; everything else is decoration.
