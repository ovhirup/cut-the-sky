# Cut the Sky — build progress & resume point

Living status file. A fresh session should read this first (alongside
[CLAUDE.md](CLAUDE.md) and [DESIGN.md](DESIGN.md)) to know exactly where the
build stands. Update it at the end of each work block.

## Where we are (as of 2026-07-19, end of Day 1)

**Core loop is COMPLETE and runs error-free.** Built ahead of schedule —
this is effectively the July 22 kill-gate build, reached on Day 1.

Playable now:
```
/Applications/Godot.app/Contents/MacOS/Godot --path ~/dev/cut-the-sky scenes/Main.tscn
```

## What's built

- **Flight model** (`PlayerKite.gd` → `Kite.gd` base): pointer-spring
  movement with momentum, drag, wind push. **Feel approved by user Day 1**
  (July 21 physics checkpoint passed early).
- **Tension mechanic**: hold LMB/Space to tighten → more steering authority
  + less wind, but tension rises through Loose→Sharp→Critical to a snap.
- **Ribbon** (`RibbonTrail.gd`): ~3s tapered trail; state shown by colour
  AND width AND pulse (never colour alone — accessibility pillar).
- **Enemies** (`EnemyKite.gd`, one parameterized controller): seeded ramp
  1→5 via `EnemyDirector.gd`, first enemy spawns immediately.
- **Cutting** (`CutResolver.gd`): sharp-vs-loose ribbon crossing above a
  min angle = cut; hit-stop + flash + combo score; enemy drifts and fades.
- **Scoring** (`ScoreManager.gd`): base 100 × combo multiplier (cap x8),
  3s combo window.
- **Death + game-over**: enemy sharp crossing or self-snap → 0.6s feedback
  → card with score/best combo/survival/seed → R restarts.
- All tuning in `resources/GameConfig.tres` (edit via `GameConfig.gd`).

## Immediate next step (start here in the new session)

**Awaiting the user's playtest verdict on the full loop.** Two open
questions the user must answer by playing (feel/fun are the user's call):
1. Does cutting feel good (hit-stop weight, moment of connection)?
2. Is death *fair* — can you always tell why you died? (Pillar 6.)
   And underneath both: after dying, do you want to press R?

Then: tune `GameConfig.tres` from that feedback. After feel is locked,
Week 2 content/juice per DESIGN.md §16 (difficulty director polish, paper
visual treatment, six kite variants, audio, results-card PNG + share text).

## Not yet built (Week 2+)

Paper-craft art pass · audio (music loop, cut/tension SFX, "Kai Po Che!"
sting) · results-card PNG export with QR · title/pause/settings screens ·
seed entry UI · local high-score persistence (`SaveData.gd`) · reduced-
shake toggle · notarized build + itch page. Full list: DESIGN.md §12.

## Guardrails (never drift from these)

Launch Aug 15 8:00 IST · Godot 4.7.x pinned · one pointer + one button ·
no flag kites / no religious imagery / no politicians · loop is the
product, everything else decoration. Kill-gate fallback if feel ever
fails: Rangoli Relay (DESIGN.md §18).
