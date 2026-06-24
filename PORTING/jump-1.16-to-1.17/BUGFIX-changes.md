# Jump 3 BUGFIX pass — 1.16 → 1.17 (No Compromise, No Surrender) — deep-fix changes

This pass **supersedes** the first 1.16→1.17 pass on two key points (see "Corrections to the
first pass" at the bottom):
1. The first pass said the flat `max_level` building schema "still parses on 1.17" and made **no**
   building edits. The `-debug` error.log proves that is **wrong** — `00_buildings.txt` throws
   `Unexpected token: max_level` (×15) / `shares_slots` (×7) / `provincial` (×5) and the parse break
   cascades to reject `max_fuel_building` / `fuel_gain_from_states` / `nuclear_production_factor`.
   Fixed here.
2. The first pass escalated the doctrine rework as a load-bearing BLOCKER requiring a Grand/Sub/
   Mastery re-architecture. Independent verification against the live tree + error.log shows that is
   a **misdiagnosis**: the mod ships **no** `common/doctrines/` and **no** doctrine GUI, so it needs
   **no doctrine schema migration**. The only doctrine breakage in the mod's own files is **3
   undefined scripted-trigger references** (fixed here, minimally). The `common/doctrines/
   subdoctrines/**` parse errors in the log are **vanilla 1.19 files** failing on stale subunit/
   equipment categories owned by the 1.18/1.19 agents — not a mod doctrine-structure problem.

Format: `file:line — old → new — WHY — SOURCE`.

---

## TASK 1 — Buildings schema rework (`common/buildings/00_buildings.txt`) — 16 defs migrated

1.17 replaced the flat `max_level = N` / `shares_slots = yes` / `provincial = yes` building-limit
schema with a nested `level_cap = { state_max = N / province_max = N / shares_slots = yes }` block.
Setting `province_max` is what now marks a building provincial (the standalone `provincial = yes`
key is gone). The mod's `00_buildings.txt` is a same-filename **full override** of all vanilla
building defs, so it must use the current schema. **Mod's own cap values preserved exactly** — only
the schema was migrated (e.g. the mod keeps `infrastructure` at 5 and `rocket_site` at 5, vs.
vanilla's 10/3).

- `:3-8` — comment header rewritten (`provincial = yes/no` → `province_max` semantics) — doc only.
- `:8-18  infrastructure`    — `max_level = 5`                     → `level_cap = { state_max = 5 }`
- `:20-30 arms_factory`      — `max_level = 20` + `shares_slots`   → `level_cap = { state_max = 20  shares_slots = yes }`
- `:32-42 industrial_complex`— `max_level = 20` + `shares_slots`   → `level_cap = { state_max = 20  shares_slots = yes }`
- `:44-53 air_base`          — `max_level = 10`                    → `level_cap = { state_max = 10 }`
- `:55-67 supply_node`       — `provincial = yes` + `max_level = 1`→ `level_cap = { province_max = 1 }`
- `:69-76 rail_way`          — `provincial = yes` + `max_level = 1`→ `level_cap = { province_max = 1 }`
- `:78-90 naval_base`        — `provincial = yes` + `max_level = 10`→ `level_cap = { province_max = 10 }`
- `:92-103 bunker`           — `provincial = yes` + `max_level = 10`→ `level_cap = { province_max = 10 }`
- `:105-117 coastal_bunker`  — `provincial = yes` + `max_level = 10`→ `level_cap = { province_max = 10 }`
- `:119-131 dockyard`        — `max_level = 20` + `shares_slots`   → `level_cap = { state_max = 20  shares_slots = yes }`
- `:134-144 anti_air_building`— `max_level = 5` + comment          → `level_cap = { state_max = 5 # ... }`
- `:146-160 synthetic_refinery`— `max_level = 3` + `shares_slots`  → `level_cap = { state_max = 3  shares_slots = yes }`
- `:162-174 fuel_silo`       — (`max_level` commented) + `shares_slots` → `level_cap = { #state_max = 1  shares_slots = yes }` (state_max unspecified w/ shares_slots defaults to 15)
- `:176-187 radar_station`   — `max_level = 6` (+commented 0)       → `level_cap = { #state_max = 0  state_max = 6 }`
- `:189-199 rocket_site`     — `max_level = 5` + `shares_slots`    → `level_cap = { state_max = 5  shares_slots = yes }`
- `:201-211 nuclear_reactor` — `max_level = 1` + `shares_slots`    → `level_cap = { state_max = 1  shares_slots = yes }`

Result: zero active `max_level`/`shares_slots`/`provincial` at the building-def level (all
`shares_slots` now nested inside `level_cap`); braces balanced (34/34); the cascading modifier
tokens `max_fuel_building` (×2), `fuel_gain_from_states`, `nuclear_production_factor` now sit inside
parseable defs and are accepted.

- **WHY:** error.log lines 81–111 (`persistent.cpp:67 Unexpected token: max_level/shares_slots/
  provincial in common/buildings/00_buildings.txt`); these aborted each building def's parse, which
  in turn rejected the in-block modifier tokens.
- **SOURCE:** hoi4.paradoxwikis.com/Building_modding (level_cap = { state_max / province_max /
  shares_slots }; "if `province_max` is set, then building is provincial"; state_max defaults to 15
  when shares_slots and unspecified) — cross-referenced against vanilla-faithful current-patch
  `common/buildings/00_buildings.txt` in Rise-of-Nations, Millennium-Dawn, EaW, Project IRIS,
  Chaos-Redux, World-At-War (all use the identical state_max/province_max values for these vanilla
  buildings; the comment header `# if province_max is set, then building is provincial` is shipped
  verbatim by DRAFTik/Arstotzka_mod, Heaven-Dream/HV_buildings, Fantasyland-Era).

## TASK 2 — Energy strategic resource (`common/resources/00_resources.txt`)

- `:33-48` — added a strategic resource `energy = { icon_frame = 7  cic = 0.125  convoys = 0.1 }`
  after `chromium` (the mod's last resource), matching the mod's existing resource style.
- **WHY:** error.log line 44 `strategic_resource_database.cpp:109: No energy resource defined.`
  1.17 introduced the coal/energy mechanic; the engine now requires a strategic resource named
  `energy` to exist (analogous to `NDefines.NGame.FUEL_RESOURCE = "oil"`). The mod's
  `00_resources.txt` is a same-filename **full override** of vanilla's resource list and omitted it,
  so the requirement must be satisfied here. icon_frame = 7 is the next free frame (mod uses 1–6);
  the mod does not override `GFX_resources_strip`, so it resolves against vanilla's sprite (which
  has the energy/coal frames). Resources need no explicit loc (vanilla fallback).
- **SOURCE:** hoi4.paradoxwikis.com/Patch_1.17 + /No_Compromise,_No_Surrender (energy/coal mechanic;
  top-bar shows coal+energy; `energy_gain_factor` modifier); michaelkleen.com 1.17 coal/energy
  article (factories consume energy produced by coal). Definition form cross-referenced against
  current-patch mods that ship the **vanilla 6-resource set (oil/aluminium/rubber/tungsten/steel/
  chromium) plus an `energy` resource**: Weeny-Pouchkinn/Legacy-of-Kattail
  (`energy = { icon_frame = 10  cic = 0.125  convoys = 0 }` appended to the same 6 resources CBtS
  uses), plus eaw_foe, NCRvL-OWB, BydEarth, Lesitia-Map, ULTRA-HOI (coal + energy).

## TASK 3 — Technology categories (`common/technology_tags/00_technology.txt`)

- `:170-179` — added four vanilla categories to `technology_categories { }`: `cat_fortification`,
  `naval_armor`, `naval_artillery`, `mio_cat_artillery` (bare names, per schema).
- **WHY:** error.log lines 3133–3145 `effect.cpp:813 add_tech_bonus: Unknown technology category`
  for `mio_cat_artillery` (×3, common/special_projects/prototype_rewards/generic_land_prototype_
  rewards.txt), `naval_armor` (×3) / `naval_artillery` (×3) (generic_naval_prototype_rewards.txt),
  `cat_fortification` (×4, common/special_projects/projects/land_projects.txt). These are vanilla
  1.17+ categories referenced by **vanilla** special_projects (which the mod does not override). The
  mod's `00_technology.txt` is a same-filename full override of vanilla's category list authored
  before these existed, so vanilla's files couldn't find them. Adding them as bare names (the
  category schema assigns "no other info") makes the references resolve.
- **NOT TOUCHED — `helicopter_tech`:** error.log line 3132 `add_tech_bonus: Unknown technology
  category helicopter_tech` (combat_support_subdoctrines.txt) is **1.18** — left for the 1.18 agent.
- **NOT TOUCHED — `cl_tech`→`ca_tech`:** the mod uses `cl_tech` (declared at :45, alongside `ca_tech`
  at :46, in its own override; used in its own naval tree) but it throws **zero** errors in the log
  (verified). Because the mod is a self-contained override of both the category list and the naval
  tech tree, vanilla's `cl_tech`→`ca_tech` migration does not reach it. A rename would **break** the
  mod's internal consistency (it keeps the two categories distinct). Correctly left unchanged —
  confirmed empirically, not assumed.
- **SOURCE:** hoi4.paradoxwikis.com/Technology_modding (categories are mod-defined data declared as
  bare names in `technology_categories { }`); GitHub: the exact 4-category cluster ships in current-
  patch `common/technology_tags/00_technology.txt` of EaW, Project IRIS, Millennium Dawn, Pax
  Britannica Redux, ender1324/axis, zov-organization/hohli, Ivysaur/HOI4_MAA, et al. — the canonical
  vanilla order is `... electronics / cat_fortification / land_doctrine ...` and (near SF doctrines)
  `... / naval_armor / naval_artillery`, with `mio_cat_artillery` alongside. Patch_1.17 (`cl_tech`
  removed→`ca_tech` = Cruiser Technology) supports the no-rename call.

## TASK 4 — Doctrine compatibility (NEW `common/scripted_triggers/CBtS_doctrine_compat_triggers.txt`)

Created a new scripted_triggers file defining the **3** doctrine-completion triggers the mod's own
`common/technologies/special_forces_doctrine.txt` references but no longer resolves:

- `ai_has_completed_army_doctrine = { is_ai = yes  OR = { has_tech = werwolf_guerillas
  has_tech = modern_blitzkrieg  has_tech = masterful_blitz  has_tech = shock_and_awe
  has_tech = defence_in_depth  has_tech = human_wave_offensive  has_tech = deep_operations
  has_tech = large_front_offensive } }` — all 8 techs verified present in the mod's
  `land_doctrine.txt` (it keeps an old-format land doctrine tree). Fully functional.
- `ai_has_completed_naval_doctrine = { is_ai = yes  has_any_grand_doctrine = naval }`
- `ai_has_completed_air_doctrine  = { is_ai = yes  has_any_grand_doctrine = air }`
  — the mod does NOT override naval/air doctrines (inherits vanilla 1.17's new grand-doctrine
  system); the old naval/air doctrine techs are gone, so these use the engine-native 1.17 trigger
  `has_any_grand_doctrine = <folder>` (the modern "AI has taken a naval/air doctrine" equivalent).

- **WHY:** error.log lines 846–851 `trigger.cpp:568 Unknown trigger-type:
  ai_has_completed_army_doctrine / _naval_doctrine / _air_doctrine in
  common/technologies/special_forces_doctrine.txt` (lines 68 / 499 / 1037). These were vanilla
  scripted triggers (in vanilla's `_special_forces_scripted_triggers.txt`) that 1.17 **removed** when
  it reworked doctrines (they tested old doctrine techs). The mod's SF-doctrine override still calls
  them inside `ai_will_do { modifier { NOT = { … = yes } } }` (AI research-weighting only), so the
  undefined-trigger error aborts those weight blocks. Re-declaring them restores the behavior.
- **SOURCE:** hoi4.paradoxwikis.com/Patch_1.17 (doctrine system rework) + /Doctrine_modding
  (`has_any_grand_doctrine` "checks if a certain folder has any assigned grand doctrine");
  Kaiserreich/Kaiserreich-HOI4 `common/scripted_triggers/_doctrine_scripted_triggers.txt` (confirmed
  1.17+: `has_any_grand_doctrine = land/naval/air` pattern); the original vanilla definition form
  (`is_ai = yes` + `OR { has_tech = werwolf_guerillas  has_tech = modern_blitzkrieg … }`) shipped by
  dozens of current mods (Rise-of-Nations, Red-Liberty, PaxBritannicaRedux, FXA, Breaking-Point, …).

---

## Verification performed
- Brace balance OK on all 4 files (`00_buildings.txt` 34/34; `00_resources.txt` 8/8;
  `00_technology.txt` 30/30; `CBtS_doctrine_compat_triggers.txt` 7/7).
- `00_buildings.txt`: zero active `max_level`/`shares_slots`/`provincial` at def level; 16 `level_cap`
  blocks; cascade modifiers (`max_fuel_building` ×2, `fuel_gain_from_states`, `nuclear_production_
  factor`) intact inside now-parseable defs.
- `energy` resource present; 4 tech categories present; 3 doctrine triggers defined; their 3
  references in `special_forces_doctrine.txt` (lines 68/499/1037) now resolve.
- Stayed in lane: did NOT touch `helicopter_tech` (1.18); subunit `category_*` (1.19); naval-support
  modifiers (1.19); super-heavy / modern-navy / escort-carrier equipment (1.19); `ai_templates`
  (1.15, done). Did NOT rename `cl_tech` (correct, empirically error-free).

## ESCALATED (non-load-bearing; see ESCALATIONS.md → NEEDS-DECISION)
- **Air/naval doctrine `has_tech` references (24 hits, 4 files):** the mod's `common/ideas/
  {air,navy}_spirits.txt`, `common/ai_strategy/doctrines.txt`, and `common/national_focus/
  GER_Hitler_Military.txt` still gate on **removed vanilla air/naval doctrine techs** (`base_strike`,
  `air_superiority`, `formation_flying`, `force_rotation`, `fleet_in_being`, `trade_interdiction`,
  `day_bombing`, `night_bombing`). These are **non-fatal** `database_scoped_variables.cpp:267`
  warnings (the checks silently evaluate false; the game loads & runs). Remapping them correctly to
  the new 1.17 Grand/Sub/Mastery doctrine identifiers is a **design-implicating** rework (which new
  doctrine should each spirit/focus/AI-strategy now favor?), not a bounded token fix — escalated.

## Corrections to the first 1.16→1.17 pass (dossier.md / changes.md / review.md)
- **Buildings (dossier #4 / U3 / review C2):** the claim "flat `max_level` still loads on 1.17, no
  edit needed" is **refuted by the engine** (error.log 81–111). `max_level` is NOT accepted at the
  building-def level on this build. Migrated to `level_cap` (Task 1). (The GitHub examples the first
  pass cited that "mix max_level with level_cap" use `max_level` only in specific nested/special-
  building contexts, not as a flat replacement for `level_cap` — which is why they parse and the
  mod's flat usage does not.)
- **Doctrines (dossier #1 / U1 / review D6):** the "load-bearing BLOCKER → Grand/Sub/Mastery
  re-architecture or escalate" framing is a **misdiagnosis**. The mod ships no `common/doctrines/`
  and no doctrine GUI → **no doctrine schema migration is required**. The mod's old-format
  `land_doctrine.txt` / `special_forces_doctrine.txt` parse **clean** on 1.19 (confirmed: zero parse
  errors for either file) except for **3** undefined scripted-trigger references, now fixed
  minimally (Task 4). The `common/doctrines/subdoctrines/**` parse errors in the log are **vanilla
  1.19 files** cascading on stale **subunit/equipment categories** that belong to the 1.18/1.19
  agents (regimental-support categories, super-heavy/modern-navy equipment, helicopter), NOT a
  mod doctrine-structure defect. The review's "degraded-but-runnable, defer" landing was closer than
  the dossier's "crash-class BLOCKER," but both missed that the mod's doctrine *content* needs no
  structural change at all.
