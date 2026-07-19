# CUT THE SKY — Master Build Brief

**The blended spec.** Synthesized 2026-07-19 from three independent research
reports (Grok, Kimi, and a third build-brief-only report) that were all given
the same Project Swaraj research brief and **independently converged on
Independence Day kite fighting** as the winning concept. Engineering backbone
from the "Cut the Sky" brief; tactical checkpoints from Kimi; marketing
calendar from Grok. Divergences between the three were resolved explicitly —
see "Resolved decisions" at the bottom.

- **Launch:** August 15, 2026, 8:00 IST — India's Independence Day
- **Platform:** macOS, Apple Silicon native, 60 FPS on a base M1
- **Engine:** Godot 4 (current stable), pinned for the entire project
- **Distribution:** itch.io day one (signed + notarized ZIP), free with
  optional payment (suggested $3). Mac App Store parallel submission ~Aug
  10–12 as bonus channel. Steam post-launch only.
- **Team:** One developer + Claude Code. No work may be added unless it
  protects or improves the core 60-second experience.

## 1. Product thesis

Cut the Sky is a tiny score-attack game about steering a paper kite through a
crowded celebratory sky. The player moves with the pointer and holds one
button to tighten their glowing ribbon. A tightened ribbon can cut opponents,
but holding too long snaps the player's own line. Understandable in five
seconds, satisfying in thirty, hard to stop replaying after failure.

The game celebrates the Indian Independence Day kite-flying tradition through
paper craft, colour, motion, percussion and collective festivity — and must
remain welcoming to a player who knows nothing about India.

**Player promise:** "Guide your kite. Tighten the line. Cut a path through
the sky."

## 2. Non-negotiable design pillars

1. One pointer, one button.
2. First cut or dangerous near-miss within five seconds.
3. Expected run length: 45–120 seconds.
4. Restart from the result screen in under one second.
5. Every ten seconds the sky becomes visibly more chaotic.
6. Failure must be attributable to a readable player decision.
7. No login, server, leaderboard or network requirement.
8. The final screen must be worth sharing as an image.
9. No national flag may be cut, damaged or used as an opponent.
10. No religious imagery, party symbols or real politicians.

## 3. Core controls

**Pointer** defines the desired kite position. The kite does not teleport —
it follows through spring acceleration, drag and a max turning rate. The gap
between pointer and kite creates momentum and expressive movement.

**Hold primary button:** increases steering acceleration, tightens the
ribbon, raises the tension meter, enables cutting while tension is in the
active zone.
**Release:** reduces steering acceleration, wind pushes the kite more, lowers
tension, deactivates cutting.

**Keyboard fallback:** arrows/WASD steer, Space tightens, R instant restart,
Esc pause. No controller support before launch.

**Feel references (steal proven feel, don't invent):** Asteroids momentum
model; Fishing Paradiso tension mechanics.

## 4. Core simulation

- Logical resolution 1440×900 landscape; critical gameplay inside a 16:10
  safe region; scale cleanly to common Mac aspect ratios.
- **Kite state:** position, velocity, desired position, max acceleration,
  max speed, turn responsiveness, tension 0.0–1.0, alive/dead. Lightweight
  custom movement model. **Do not use realistic aerodynamics.**
- **Ribbon:** visual + collision trail from recent kite positions. Sample
  ~20×/sec, keep ~2.5–3 s history, render as smooth tapered polyline,
  simplified segments for intersection checks, cap collision samples to hold
  60 FPS. Three states: **Loose** (can't cut), **Sharp** (can cut),
  **Critical** (near snapping; warnings intensify).
- **Initial tension tuning (prototype values, all in one config resource):**
  hold +0.55/s · release −0.75/s · sharp zone ≥0.35 · critical ≥0.82 ·
  snap at 1.0 · min sharp crossing angle ~30–40°.
- **Cut resolution:** valid when player segment intersects enemy segment,
  player ribbon is sharp, crossing angle exceeds minimum, neither already
  cut. On cut: freeze/slow 50–80 ms, flash intersection, paper fragments +
  ribbon recoil, one strong cut sound, score, combo, remove enemy, resume.
  **Do not simulate severed-string physics** — authored drift-and-fade.
- **Player death:** enemy sharp ribbon cuts player, or tension hits 1.0.
  Death feedback completes within ~600 ms, then results card + instant
  restart.

## 5. Enemy system

One parameterized enemy controller — no bespoke AI classes. Parameters:
preferred altitude, oscillation rate, aggression, pointer attraction/
avoidance bias, tighten/release rhythm, speed, palette + silhouette.
Behaviours combine sine roaming, offset steering near player, short attack
windows, retreat after failed crossings, mild seeded variation. Intentional-
looking, not optimal.

**Ramp:** start with 1 enemy; +1 at ~12 s; +1 every 15–20 s; max 5; wind
variation and aggression rise gradually. No bosses, no unique abilities.

## 6. Scoring & sharing

- Base cut 100 · combo window ~3 s · multiplier grows on consecutive cuts,
  capped for UI clarity.
- Results: big final score; best combo, survival time, wind seed secondary.
- Persist locally: personal best, highest combo, settings, last seed.
- **Share:** copyable text + locally generated PNG result card (final sky,
  score, combo, seed, logo, launch URL + QR code to the itch page). No web
  service involved.
- **"Kai Po Che!" moment:** on a 3+ combo, a celebratory vocal/percussion
  sting — the traditional kite-cutter's victory cry. Joy layer, not required
  for comprehension.

## 7. Seeded challenge

Every run gets a compact seed controlling wind, spawns, cosmetic sky. Results
card shows the seed + **Replay Seed**; seeds can be pasted at the title
screen. No daily-challenge server, no enforced one-attempt.

## 8. Visual direction & cultural safeguards

Flat 2D paper craft, slight texture, imperfect edges, bold silhouettes
readable at thumbnail size. Warm celebratory palette: saffron, warm ivory,
green, deep blue + bright paper colours. Celebration expressed through
colour, paper, wind, sound and crowd ambience.

**Safeguards:** no flag kites; never cut flags/political symbols/maps/
emblems; no religious buildings or icons; abstract rooftop silhouette, not
identifiable monuments.

**Minimum art:** six kite silhouettes (reusable vector geometry), one
abstract skyline, three procedural clouds, one shifting background gradient,
ribbon shader, paper particles, title treatment, results-card frame. No
character animation, no narrative scenes.
**Placeholder pipeline:** Kenney.nl CC0 + AI-generated concept art until the
final art pass.

## 9. Audio

One original 60–90 s loop (light Indian percussion influence, not a formal
raga), cut sound ×3–4 pitch variants, tension-rise, critical warning, snap,
combo escalation layer, menu sounds, low rooftop-crowd ambience, "Kai Po
Che!" sting. Settings: master/music/effects volume + mute. No adaptive music
beyond a simple intensity layer. Sources: Freesound + AI-generated.

## 10. UI

**Title:** logo, Play, Enter Seed, Settings, Credits, one animated control
demo, one sentence: "Move to steer. Hold to tighten. Cross their ribbon
before they cross yours."
**HUD:** score, combo, tension meter, minimal pause. No minimap, missions,
progression bars or currency.
**Results:** big score; combo/time/seed; Restart, Replay Seed, Copy Result,
Save Result Card, Back to Title.

## 11. Accessibility & Mac behaviour

Windowed + fullscreen, crisp at Retina scale, mouse + trackpad + keyboard
fallback, volume controls, reduced screen-shake toggle, ribbon state never
conveyed by colour alone (width/glow/animation too), pause on focus loss,
save data survives builds. Test: fresh macOS account, trackpad-only,
external mouse, fullscreen/windowed, multiple display scales, launch of the
downloaded notarized archive.

## 12. MVP — ships August 15

Endless score-attack mode · pointer steering + hold/release tension · ribbon
intersection & cutting · one parameterized enemy system · ramp to five
enemies · combo scoring · seeded runs + replay · six kite appearances ·
local high scores + settings · title/pause/results screens · copyable result
text · local PNG result card (+QR) · one music loop + essential SFX ·
signed, notarized macOS release · public itch page with trailer,
screenshots, install instructions.

## 13. Explicit cut list — does NOT ship

Multiplayer (any form) · online leaderboards · accounts/cloud saves · Steam
achievements · Game Center · campaign/story · bosses · dialogue · rooftop
exploration · kite economy/unlocks · skill trees · multiple cities · weather
beyond parameterized wind/clouds · controller support · mobile build ·
Windows build · localization beyond English · realistic rope/cloth/aero ·
replay video export · user kite art · live daily backend · analytics ·
ads/IAP/DLC · custom launcher · **any feature proposed after Aug 5 unless it
fixes comprehension, crashes or distribution.**

## 14. Technical structure (Godot)

`Main.tscn` (flow) · `Game.tscn` (run) · `PlayerKite.tscn/.gd` ·
`EnemyKite.tscn/.gd` · `RibbonTrail.gd` (sampling/render/segments) ·
`CutResolver.gd` (intersections + arbitration) · `WindSystem.gd` (seeded) ·
`EnemyDirector.gd` (ramp) · `ScoreManager.gd` · `RunSeed.gd` · `SaveData.gd`
· `HUD.tscn` · `ResultsCard.tscn` · `ShareExporter.gd` · `AudioManager.gd` ·
`GameConfig.tres` (ALL tuning values).

Rules: simulation separate from presentation · deterministic seeded
randomness · no native plugins unless Godot can't do it · commit every
independently working mechanic · **playable main branch from July 22
onward.**

## 15. Acceptance tests (launch gates)

1. Five first-time players understand the objective within ten seconds.
2. At least four of five restart without being prompted.
3. Median cold-player run exceeds 30 s after three attempts.
4. A player can identify why their line broke.
5. A complete run plays with trackpad only.
6. Restart takes under one second.
7. Result PNG saves to a user-accessible location.
8. A copied seed closely reproduces wind + spawns.
9. 60 FPS on the lowest-spec Apple Silicon test Mac.
10. Public download launches under Gatekeeper after notarization.
11. Playable without internet.
12. No destructible asset resembles the Indian national flag.

## 16. Milestones, kill gates & marketing calendar

**W1 · July 19–25 — prove the game.** Movement, tension, one enemy, ribbon
intersections, cut + death, score, instant restart. Ugly but complete loop.
- **July 21 — physics checkpoint:** if pointer-spring steering doesn't feel
  good, fall back to simpler click-to-move steering. Feel is the product.
- **July 22 — KILL GATE (behavioral, not verbal):** five cold testers
  understand the rule in ten seconds; ≥3 voluntarily replay three runs; they
  blame themselves, not the collision; attempts visibly improve. **Fail →
  stop and pivot to Rangoli Relay on July 23.** Nothing may postpone this.
- July 25 — three-person fun test closes the week.

**W2 · July 26–Aug 1 — content & juice.** Difficulty director, combos, final
movement tuning, wind seeds, paper visual treatment, six kites, cut
feedback/particles, music + SFX, results screen, local save, share
text/PNG prototype. By Aug 1 no mechanic remains hypothetical.
- *Marketing:* **July 28 — teaser GIF** → r/india, r/macgaming, X. Devlog #1:
  "Building an Independence Day game in 27 days with AI."

**W3 · Aug 2–8 — polish & store.** Feature-complete Aug 4. **Feature freeze
Aug 5.** Menus/settings, Retina + aspect pass, reduced-shake + non-colour
cues, final result card, trailer + screenshots, public itch page, external
beta, first signing + notarization.
- *Marketing:* itch page live Aug 5; devlog #2 GIF thread; Indian gaming
  YouTuber/streamer outreach with demo keys Aug 5–9.

**W4 · Aug 9–15 — protect the launch.** Bug fixes only. Clean-account +
M1 + offline tests. **RC Aug 12.** Mac App Store submission Aug 10–12. Final
notarized archive + backup build. **Public release Aug 15, 8:00 IST.**
- *Marketing:* countdown posts; Aug 15: "Show HN: I built a Mac game in 27
  days with AI for India's Independence Day" + Product Hunt +
  #IndependenceDay wave. The AI-build story is evergreen marketing.

## 17. Biggest risk & mitigation

**Risk:** the trail-cut interaction looks attractive but feels arbitrary —
deaths the player can't predict destroy the one-more-try loop.
**Mitigation:** no rope physics; explicit sharp/loose states exaggerated via
width, glow, sound and tension UI; the five key movement/tension constants
centralized for rapid tuning; the July 22 kill gate enforced on behavioral
evidence only.

## 18. Fallback: Rangoli Relay

If the kill gate fails: 60-second score mode; drag one continuous ribbon
around a dot grid; valid closed regions bloom into symmetric paper patterns;
invalid crossings gently unwind; five base layouts × rotation/reflection/
seeded omission; combo for no-lift completions; result PNG = finished
pattern + score + seed. Chosen over Monsoon Drift because the fallback must
carry near-zero *physics-feel* risk — the exact failure mode being escaped.

## Resolved decisions (blend log)

| Divergence | Options across reports | Resolution |
|---|---|---|
| Engine | SpriteKit (Grok) vs Godot (Kimi, CtS) | **Godot 4 stable** — 2/3 vote, spec written for it, GDScript+AI synergy, MIT, future Windows port |
| Fallback | Monsoon Drift (Kimi) vs Rangoli (Grok, CtS) | **Rangoli Relay** — fallback must not share the physics-feel risk |
| Steam at launch | Fragile (Grok) vs July 29 submit (Kimi) vs omitted (CtS) | **No Steam at launch**; post-launch page |
| Pricing | Free (Grok) vs PWYW $3 (Kimi) vs free+optional (CtS) | **Free with optional payment, $3 suggested** |
| Title | Cut the Sky vs Patang Swaraj vs Patang: Sky Duel | **Cut the Sky** (user-confirmed 2026-07-19); cultural anchor in tagline + Kai Po Che moments |
