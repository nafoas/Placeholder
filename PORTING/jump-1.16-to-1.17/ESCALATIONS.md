# Jump 3 (1.16 → 1.17 NCNS) — Escalations from the deep-fix pass

This pass FIXED everything load-bearing and tractable in the 1.17 lane (buildings schema, energy
resource, technology categories, and the 3 broken doctrine scripted-triggers — see
`BUGFIX-changes.md`). One **non-load-bearing but design-implicating** residual is escalated below.

> Note: the first 1.16→1.17 pass escalated the *whole doctrine system* as a load-bearing BLOCKER
> needing a Grand/Sub/Mastery re-architecture. That was a **misdiagnosis** and is **withdrawn**: the
> mod ships no `common/doctrines/` and no doctrine GUI, so it needs **no doctrine schema migration**;
> its old-format doctrine tech trees parse clean on 1.19. The only real, bounded doctrine breakage
> (3 undefined `ai_has_completed_*_doctrine` scripted-trigger references) is now **fixed**. What
> remains below is a much smaller, **non-fatal** reference-remap with genuine balance implications.

---

## E1 — Mod references to REMOVED vanilla air/naval doctrine techs (24 hits, 4 files) — NEEDS-DECISION

### What 1.17 changed
1.17 (No Compromise, No Surrender) replaced the Army/Navy/Air doctrine trees with the new Grand
Doctrine + Subdoctrine + Mastery system. The old **vanilla** air/naval doctrine *technologies*
(`base_strike`, `air_superiority`, `formation_flying`, `force_rotation`, `day_bombing`,
`night_bombing`, `fleet_in_being`, `trade_interdiction`, `battlefleet_concentration`,
`convoy_interdiction*`, `wolfpacks`, `unrestricted_submarine_warfare`, …) **no longer exist** — they
were reorganised into grand/subdoctrines. (Source: hoi4.paradoxwikis.com/Patch_1.17;
/Air_doctrine; /Naval_doctrine — doctrines are "no longer researched as technologies.")

### What the mod has (verified on disk + error.log)
The mod does **not** override air/naval doctrines (it ships no air/naval doctrine tech tree and no
`common/doctrines/`), so it inherits vanilla 1.17's new ones. But the mod still gates content on the
**old** vanilla air/naval doctrine tech NAMES via `has_tech = …` in **24 places across 4 files**:

- `common/ideas/air_spirits.txt`   — `air_superiority`, `formation_flying`, `force_rotation`
- `common/ideas/navy_spirits.txt`  — `base_strike`, `fleet_in_being`, `trade_interdiction`
- `common/ai_strategy/doctrines.txt` — all of the above + `day_bombing`, `night_bombing` (AI
  research-weight `role_ratio`-style strategies)
- `common/national_focus/GER_Hitler_Military.txt` — `formation_flying`, `fleet_in_being`,
  `trade_interdiction` (focus availability / bonus targeting)

In the error.log these surface as **non-fatal** `database_scoped_variables.cpp:267` warnings
("invalid database object for effect/trigger: air_superiority … use var:var_name …"), ~24 of them in
this class. **The game loads and runs**; each `has_tech` check against a removed tech simply
evaluates **false forever**.

### Why this can't just be auto-fixed
The *correct* remap is not mechanical. Each reference encodes a **design intent** —
"this naval spirit / this air-doctrine AI strategy / this German focus applies when the country has
invested in <air-superiority / strategic-bombing / convoy-raiding / fleet-in-being> doctrine." On
1.17 those map to specific **new** grand-doctrine/subdoctrine identifiers, and choosing the right
target for each (and whether to use `has_doctrine = <id>`, `has_any_grand_doctrine = air/naval`, or
`has_subdoctrine_in_track`) is a balance/design call per reference. Guessing would silently change
which spirits/foci/AI-behaviours fire. This is the same class of decision as the deferred
`ai_templates` migration (D1).

### Impact if left as-is (the cost of NOT deciding now)
- **Loads & plays:** YES. These are warnings, not load-breakers. No crash, no parse abort.
- **Degraded behaviour:** the affected naval/air **spirits** never become available/active for the
  player or AI on the old-tech condition; the affected **AI research-weight** strategies no-op (AI
  picks doctrines by vanilla default weights instead of the mod's tuning); the **German** military
  focuses that gated on `fleet_in_being`/`trade_interdiction`/`formation_flying` lose those gates.
  All silent. Nothing visibly broken; the mod's *intended* doctrine-linked flavour just doesn't fire.

### Options
- **(A) Remap to the new doctrine system.** Replace each `has_tech = <old air/naval doctrine tech>`
  with the new-schema equivalent (`has_doctrine = <new grand/subdoctrine>` or
  `has_any_grand_doctrine = air/naval`), choosing the target that matches each reference's intent.
  ~24 edits across 4 files. **Faithful**, but requires per-reference design decisions and a map of
  the 1.17 air/naval grand/subdoctrine IDs. Best folded into the eventual doctrine/`ai_templates`
  modernization at the 1.19 endgame.
- **(B) Neutralise the dead gates.** Delete the `has_tech = <removed tech>` lines (or the modifier
  blocks containing only them). Removes the warnings; **discards** the mod's doctrine-linked tuning
  (spirits/foci/AI become unconditioned). Low fidelity.
- **(C) Defer (recommended interim).** Leave as-is: non-fatal, the mod loads and runs. Revisit with
  the broader doctrine/AI-template modernization. Zero risk to loading; the only cost is the silent
  degraded flavour above, which the owner may judge acceptable until the doctrine rework is done.

### Recommendation
**Defer (C) for the load-fix milestone; do (A) during the doctrine/AI-template modernization** (it
needs the same 1.17-doctrine-ID map and the same design judgement as D1). (B) only if the owner
wants the warnings gone immediately and accepts losing the gating.

**Cross-lane note:** the same `database_scoped_variables.cpp:267` warning class also contains
non-doctrine tokens (`advanced_medium_tank`, `basic_medium_tank`, `coastal_fort_tech_`,
`land_fort_tech_`, `mechanical_computing`, `sp_naval_repair_ships_pick_*`, …) that are stale
**equipment/tech** references owned by the equipment-content / 1.18 / 1.19 lanes — listed here only
so the owner sees the full warning class; they are **not** part of this 1.17 doctrine escalation.

NEEDS-DECISION: remap (A) vs neutralise (B) vs defer (C) for the 24 air/naval-doctrine `has_tech`
references — a design/balance call, not a mechanical fix. (Non-load-bearing; the mod loads and runs
with them left as-is.)
