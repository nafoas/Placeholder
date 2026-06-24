# Jump 2 — 1.15 → 1.16 (Graveyard of Empires) — BUGFIX pass (deep re-verification)

**Agent:** 1.15→1.16 deep-fix agent (BUGFIX pass).
**Date:** 2026-06-24.
**Mandate:** Find and FIX everything HOI4 **1.16** changed that this mod uses. Rigorously verify the
first port pass's claim that 1.16 needed only a `descriptor` bump; catch anything it missed.

## RESULT: 1.16 is CLEAN for this mod — **0 code fixes required.**

This is a *verified negative*, not a deferral. Every removed/renamed-token candidate in the 1.19
`error.log` traces to **1.17 / 1.18 / 1.19** (owned by other agents); 1.16's modder-facing surface is
**additive** and the mod uses none of it; the single 1.16 *validation* the mod is touched by
(duplicate province building blocks) is **non-fatal and emits zero output on 1.19**. The first pass's
conclusion holds under independent attack. No `ESCALATIONS.md` written; no `NEEDS-DECISION`.

The descriptor concern from the first pass is **moot/superseded**: `descriptor.mod:37` is now
`supported_version="1.19.*"` (set by the later Jump-5 1.18→1.19 commit `4dc5e0f`), which is the
correct final-state value for a 1.19 target. **Not touched** (reverting it toward `1.16.*` would
break the 1.19 goal).

---

## CHANGES APPLIED
**None.** No mod file required a 1.16-specific fix. (See evidence below for why this is correct, not a
skip.)

---

## EVIDENCE THAT 1.16 IS CLEAN (the verification, with sources)

### V1 — 1.16's modder-facing surface is ADDITIVE; the mod uses none of it → no collision
1.16.0 / 1.16.x added exactly these scripting features (re-confirmed this pass from ~6 fresh angles;
the WebSearch backend, sihmar 1.16.1 mirror, and live-mod GitHub corpus all return only additions,
never a "removed/renamed/no longer" line):
- `bypass_effect = { … }` on national focuses — an **effect**, distinct from the long-standing
  `bypass = { … }` **trigger**. (Both keys valid & non-deprecated.)
- `load_focus_tree` gains optional `copy_completed_from`.
- `front_role_override` for division templates.
- (1.16.1) `count` field for `any_object` triggers (and scoped-variable support).

Collision/forward-reference check (whole mod, excl. `pdx_documentation/`):
- `bypass_effect` → **0** files. `front_role_override` → **0**. `copy_completed_from` → **0**.
- The mod uses `bypass` (trigger) and `load_focus_tree` with long-standing params only.
→ Adding these tokens to the engine cannot collide with or change any mod content.
- **Source:** sihmar.com 1.16.1 patch-notes mirror (additive `count` only; "no removals, renames, or
  deprecations listed"); GitHub code search `bypass_effect path:common/national_focus` (220+ hits in
  real version-current mods incl. the GoE `goe_shared_saadabad_branch.txt` Saadabad-Pact focus — pure
  addition); WebSearch backend Patch_1.16 / Patch_1.16.X (additions only across ~6 angles); first-pass
  dossier #2/#3/#4 + audit C2 (independently reproduced here).

### V2 — No 1.16-removed/renamed token is used by the mod (empirical, via the 1.19 error.log)
The mod is being run on 1.19, whose `-debug error.log` rejects every token the current engine does not
accept. I extracted the **complete** set of rejected tokens and classified each by the version that
removed/renamed it. **None is 1.16.** Mapping (token → owning version, per the BRIEF's routing,
confirmed by the file the engine blamed):

| Rejected token(s) in 1.19 log | Blamed file(s) | Version that changed it |
|---|---|---|
| `max_level`, `shares_slots`, `allowed_types`, `production_prio`, `provincial`, `max_fuel_building`, `fuel_gain_from_states`, `nuclear_production_factor` | `common/buildings/00_buildings.txt` | **1.17** building-limit rework (whole file fails the new schema; the fuel/nuclear modifier tokens are *consequences* of the schema parse-break, NOT 1.16 modifier removals — `fuel_gain_from_states`/`max_fuel_building` are Man-the-Guns-era (~1.6) fuel modifiers, never removed in 1.16) |
| `naval_supremacy_factor`, `naval_general_support_(value_)factor`, `naval_repair_support_(value_)factor`; missing static mods `naval_general_support` / `naval_repair_support` | `common/units/equipment/ship_hull_*.txt` | **1.19** naval-support modifiers (BRIEF §A) |
| `category_regimental_support_*`, `category_divisional_support_battalions`, `category_self_propelled_*`, `category_tank_destroyer(s)`, `category_vehicle_infantry`, `category_rangers`, `category_anti_tank`, `category_mobile_anti_tank`, `category_helicopter_support_companies`, `category_maritime_patrol_bomber`, `category_carrier_*` | `common/units/*` + vanilla unit files | **1.18 / 1.19** subunit & regimental-support rework (BRIEF §C) |
| `armored_engineer/maintenance/signal`, `*_military_police`, `ranger_battalion`, `helicopter_*`, `heavy_sp_anti_air_support`, `assault_engineer`, `land_cruiser_chassis`, `super_heavy_artillery`, `self_propelled_super_heavy_artillery` | equipment/subunit defs | **1.18 / 1.19** equipment content (BRIEF §D) |
| `Invalid idea: …`, `Invalid resource: coal`, `Invalid trait: motivated`, `Invalid subunit category: …` | various | downstream **cascades** of the rows above (BRIEF §E/§I) — none 1.16 |
| `can_unlock_second_track_of_sf_doctrine`, `nuclear_reactor_heavy_water`, `WTT_is_chinese_country`, the §H trigger cascade | `common/doctrines/tracks/special_forces_tracks.txt`, `common/special_projects/*`, `common/collections/*` | **1.19** SF-doctrine + **1.17** special-projects/building schema (BRIEF §F/§H). Root tokens are SF-doctrine/special-projects, not 1.16. |
| `skip_account_link` | user `settings.txt` | **not the mod** — BRIEF says IGNORE |

Defensive grep for era-boundary removed/renamed tokens (live, non-comment uses across
`common/ history/ events/ interface/`): `match_to_count` 0, `width_weight` 0, `target_width` 0,
`column_swap_factor` 0, `add_temporary_buff_to_units` 0 (a 1.19 removal — unused), `state_strategic_value`
0 live, `supply_node_range` 0 live, `can_be_called_to_war` 0. `naval_strike_targetting` (83 uses) is the
**correct** vanilla spelling and is **not** rejected by the 1.19 engine (0 hits in error.log) → valid,
not a 1.16 change.
- **Source:** `error.log` token extraction + the file the engine blamed per line; BRIEF §A–§K routing;
  whole-mod grep (commands + counts in this agent's transcript).

### V3 — The one 1.16 validation the mod is hit by (duplicate province building blocks) is NON-FATAL on 1.19 → SAFE, no fix
1.16 "added a check to detect duplicate province building blocks overriding each other in state
history files" (a **report**, surfaced in `error.log` under `-debug`; the game still loads & runs —
later-block-wins semantics, identical to 1.14/1.15). The brief asked me to determine *fatal vs.
non-fatal on 1.19* and fix only if it's a real problem. **Determination: non-fatal, and on 1.19 it
does not even surface** — therefore safe; no edit.

- **Independent brace-aware scan of all 1250 `history/states/*.txt`** (this agent's own scanner)
  reproduces **exactly three** files with a duplicate province sub-block inside `buildings`, and no
  others — matching the first pass:
  - `history/states/327-Philippines.txt` — prov **10265** twice: L20-23 `{ bunker=1 (Fort William
    McKinley); coastal_bunker=4 }` then L24-26 `{ naval_base=4 }`. Later block wins → bunker +
    coastal_bunker silently dropped.
  - `history/states/466-Quebec.txt` — prov **13384** twice: L15-17 `{ naval_base=1 }` and L21-23
    `{ naval_base=1 }`. Identical → net unchanged.
  - `history/states/695-Curacao.txt` — prov **153** twice: L13-15 `{ naval_base=1 }` then L16-18
    `{ coastal_bunker=2 }`. Later block wins → naval_base silently dropped.
- **The 1.19 `error.log` contains ZERO duplicate-province-building / state-history / building-override
  warnings.** No `state*.cpp`, `province*.cpp`, or building-history validator fires anywhere in the
  log (full cpp-source histogram checked — the only `mapbuildings.cpp` line is an unrelated
  `landmark_spawn` entity-missing message). The three state files load **cleanly** on 1.19. (The two
  `10265` hits in the log are a *different* error — `not a province building type: 10265` in
  `faction_goals_*`, a scope/effect bug unrelated to the state-history duplicate, and not 1.16.)
- **`git log`** confirms all three state files are at the **pristine 1.14 baseline** (`5074c94`),
  untouched by any port agent → the duplicates are genuinely **pre-existing** (1.14), so 1.16 "broke"
  nothing; merging them would **change game state** vs. the preserved baseline (re-add the dropped
  buildings) — an owner content decision, not a port fix. Already recorded in this jump's
  `UNCERTAINTIES.md` U1 with the exact merge each file would need, if the owner wants it.
- **Conclusion:** non-load-bearing on 1.16 **and** silent on 1.19. **No fix; documented as safe.**
- **Source:** independent 1250-file brace-aware scan; full `error.log` grep + cpp-source histogram;
  `git log` per file; Patch_1.16 (the new check); Troubleshooting (validation errors logged, game
  continues) — all corroborated by first-pass dossier #6 / UNCERTAINTIES U1 / audit O1.

### V4 — `common/buildings/00_buildings.txt` has NO duplicate building *definitions* (the other half of the brief's "duplicate building blocks" task)
Brace-aware scan of `00_buildings.txt` → **16** building definitions, **0 duplicates**
(`infrastructure, arms_factory, industrial_complex, air_base, supply_node, rail_way, naval_base,
bunker, coastal_bunker, dockyard, anti_air_building, synthetic_refinery, fuel_silo, radar_station,
rocket_site, nuclear_reactor`). The "~3 duplicate building blocks" referenced by the brief are the
**three state-history province duplicates** in V3, not duplicate defs in this file. The file's own
errors in the 1.19 log are the **1.17 building-schema** parse break (`max_level` / `shares_slots` /
`provincial`), explicitly the **1.17 agent's** lane — not 1.16. (1.16 left the building-definition
format unchanged; `max_level` was still valid on 1.16. First-pass dossier #7 / audit C5.)
- **Source:** this agent's `00_buildings.txt` brace-aware def scan; `error.log` lines 81-100;
  BRIEF §B routing (building rework = 1.17).

---

## OUT-OF-LANE OBSERVATIONS (NOT 1.16; logged for the orchestrator, not actioned here)
- The 1.19 `error.log`'s 625 `ai_strategy_template.cpp` "Using deprecated property
  (`roles`/`match_to_count`/`target_width`/…)" warnings are **stale**: the log was captured *before*
  the 1.15 agent's `ai_templates` migration. The **current** tree has `common/ai_templates/generic.txt`
  using singular `role =` and **0 live deprecated props** across all 9 template files (commented-out
  legacy blocks remain only in `templates_JAP.txt`). The 1.15 migration is effectively complete in the
  working tree; these warnings will not recur on a fresh run. Not a 1.16 item, not touched (BRIEF: the
  1.15 agent owns `ai_templates`).
- General takeaway for downstream agents: **the `error.log` predates the other agents' edits** — use it
  to attribute a token to a *version*, not to judge current file state.

---

## SOURCES (consolidated)
- HOI4 wiki Patch_1.16 / Patch_1.16.X / Patch_1.17 (JS-walled to WebFetch; bodies read via the
  WebSearch backend — additions only; building rework scoped to 1.17).
- sihmar.com 1.16.1 patch-notes mirror (additive `count`; explicitly no removals/renames/deprecations).
- GitHub code search (`mcp__github__search_code`): `bypass_effect path:common/national_focus`
  (version-current real mods, incl. GoE Saadabad-Pact focus) — confirms `bypass_effect` is a live
  addition; `klimPaskov/Agentic-HOI4-Modding/paradox_wiki` confirmed to have **no Patch-1.16 page**.
- The mod's own `-debug error.log` (1.19) — empirical token-rejection set + cpp-source histogram +
  zero duplicate-province warnings.
- Local: independent 1250-file brace-aware state scan; `00_buildings.txt` def scan; whole-mod greps;
  `git log` per file.
- First-pass dossier / changes / UNCERTAINTIES / review (independently re-verified, not merely cited).

### Channel limitation (carried forward, unchanged)
The full **verbatim** base-1.16.0 "Database/Modding" changelog section remains unobtainable here (live
wiki + forum + Steam announcement + steamdb all JS-walled / 403, GitHub mirror has no 1.16 page) —
same limitation the first pass honestly flagged (U2/SU1). I add stronger *negative* evidence: the
empirical 1.19 error.log proves no 1.16-removed token survives in the mod (V2), which closes the
practical risk regardless of the prose changelog. Confidence: **HIGH**.
