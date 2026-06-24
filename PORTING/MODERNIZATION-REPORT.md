# Modernization Report — CBtS Fan Fork

New engine features/systems added in each ported version that *supersede or could improve* what the
mod currently does. These are **NOT applied during the faithful port** (the port only fixes what
broke). One line per relevant addition, with source, for the owner to consider later.

---

## 1.15 (Götterdämmerung)

Additions surfaced while researching the 1.14→1.15 jump (all are NEW capabilities; not required
for the mod to load on 1.15). Sources: hoi4.paradoxwikis.com/Patch_1.15 ;
hoi4.paradoxwikis.com/Map_modding ; hoi4.paradoxwikis.com/Modifiers ; hoi4.paradoxwikis.com/Defines.

- `MIN_SHIPS_FOR_HIGHER_SHIP_RATIO_PENALTY` (new define) — exempt small fleets from the higher
  ship-ratio combat penalty; tune naval balance.
- `ai_wanted_divisions_factor` — new AI knob influencing how many divisions the AI wants; relevant
  to the mod's heavy AI tuning in `common/ai_*`.
- `heavy_fighter` — new **medium**-plane category; could replace bespoke heavy-fighter handling.
- `give_resource_rights` now accepts a variable/keyword receiver — more flexible resource-rights scripting.
- `divisional_commander_xp` — set divisional officer XP on unit creation (OOB / event spawns).
- `add_dynamic_modifier` tooltip variables — richer dynamic-modifier tooltips.
- `is_subject` multi-target tooltip fix — cleaner tooltips when checking subject status of multiple targets.
- `state_resources_<resource>_factor` (new state modifier) — scale a specific resource per state.
- `equipment_production_min_factories_archetype` (new AI strategy) — min factories for a specific
  equipment archetype; finer AI production control.
- `has_naval_invasion_against_state` (new trigger) — detect naval invasions targeting a state.
- New trigger to enumerate all states in a given continent.
- Bindable / boundable localisation variables — define custom variables for use in loc keys,
  collapsing many near-duplicate loc strings (the mod has 151 loc files; potential big cleanup).
- AI division templates can now specify a division **name list**; AI roles are now assigned on
  template creation (replacing the removed `match_to_count` dynamic matching).
- Germany rework + nuclear / secret-weapons (Special Projects) program — large new content systems;
  pure additions, only relevant if the mod ever wants to integrate them.
- "Terrain Traits XP Gain" (`terrain_traits_xp_gain`) — new modifier (replaces the National-Spirit
  role of the old `terrain_penalty_reduction`); only relevant if the owner decides to adopt it.
  NOTE: do NOT treat as a drop-in rename of `terrain_penalty_reduction` — different effect (see
  jump-1.14-to-1.15/UNCERTAINTIES.md U1).

---

## 1.16 (Graveyard of Empires)

Additions surfaced while researching the 1.15→1.16 jump (all are NEW capabilities; none is required
for the mod to load on 1.16 — the only load-bearing change this jump was the `supported_version`
bump). The mod uses none of these today. Sources: hoi4.paradoxwikis.com/Patch_1.16 ;
hoi4.paradoxwikis.com/Patch_1.16.X ; National-focus-modding / AI-modding wiki pages.

- `bypass_effect = { ... }` (national focuses) — an **effect** block that runs when a focus is
  bypassed (manually or auto-bypassed). Distinct from the existing `bypass = { ... }` **trigger**.
  Lets a focus do something on bypass instead of nothing; the mod has many `bypass` triggers that
  currently grant no on-bypass effect.
- `load_focus_tree` gains a `copy_completed_from = TAG` parameter — copy completed focuses from an
  existing country when swapping a focus tree (smoother tree swaps; the mod swaps trees in several
  scripted_effects).
- `front_role_override` for division templates — customise which **front type** a template gets
  assigned to (finer AI/auto-front control). Pure addition to the front-assignment system; does NOT
  change the `common/ai_templates/` role schema (so it does not move the deferred AI-template
  migration target — see DECISIONS-NEEDED D1).
- (1.16.1) `count` field for all `any_object` triggers — true if at least `count` children match;
  supports scoped variables. Collapses some "N-of" checks the mod currently expresses the long way.
- Graveyard of Empires content systems (Afghanistan Quami/Nufus national spirits & focus tree,
  British Raj "martial tribes" recruitment / Agrarian Society rework, Iran/Iraq/Kurdistan trees,
  new subjects) — large new **content**, only relevant if the mod ever wants to integrate or react
  to those nations' new mechanics.

NOTE (scoped OUT of this jump — belongs to 1.17): the State/Province **building-limit rework**
(nested `level_cap = { state_max / province_max / shares_slots }`, per-state-type and per-island
limits) and **Strategic Locations** (e.g. Natural Harbor → +2 naval-base limit in a province) were
introduced in **Patch 1.17**, not 1.16. The mod's `common/buildings/00_buildings.txt` (which
overrides vanilla building defs with the flat `max_level` schema) should be re-evaluated against
that rework in the 1.16→1.17 jump (see jump-1.15-to-1.16/UNCERTAINTIES.md U3).

---

## 1.17 (No Compromise, No Surrender)

Additions surfaced while researching the 1.16→1.17 jump (all are NEW capabilities; none is required
for the mod to LOAD on 1.17 except where escalated — the only load-bearing edit this jump was the
`supported_version` bump). The mod uses none of these today. Sources: hoi4.paradoxwikis.com/Patch_1.17 ;
/Patch_1.17.X ; /No_Compromise,_No_Surrender ; Building / State / Technology / Doctrine / Land-doctrine /
Naval-doctrine / Air-doctrine / Special-forces-doctrine / MIO modding pages (via WebSearch backend +
GitHub mirror) ; GitHub code search over 1.17+ mods.

- **Doctrine system rework (Grand Doctrines + Subdoctrines + Mastery)** — 1.17 replaced the Army/Navy/Air
  doctrine trees with a new system (mutually-exclusive grand doctrines, shared subdoctrine tracks, a
  practical-XP **Mastery** system with milestones, and a new doctrine GUI). New script surface: triggers
  `has_doctrine` / `has_mastery_level` / `has_completed_track` / `has_any_grand_doctrine` (1.17.5);
  effects `set_grand_doctrine` / `set_sub_doctrine` / `add_mastery` / `add_mastery_bonus`; grand-doctrine
  layout props `max_track_columns` / `max_track_rows`. **This is the one 1.17 system that genuinely breaks
  this mod (it ships old-format doctrines) and is therefore NOT a free modernization item — it is escalated
  as a BLOCKER / owner decision (DECISIONS-NEEDED D6, jump UNCERTAINTIES U1).** Listed here too because
  adopting the new schema is also the modernization path.
- **Building-limit rework** — nested `level_cap = { state_max / province_max / shares_slots / group_by /
  exclusive_with }`, per-state-type and per-island building limits, and **Strategic Locations** (provinces
  with bonus building limits, e.g. Natural Harbor → +2 naval base in that province). Plus two new
  infrastructure-scaling buildings (energy-consumption reduction / local-resource-gain efficiency,
  mutually exclusive in a state). The mod's `common/buildings/00_buildings.txt` overrides vanilla building
  defs with the flat `max_level` schema (still valid on 1.17), so it does NOT inherit any of these unless
  migrated to `level_cap`. Owner/modernization choice. (jump UNCERTAINTIES U3.)
- **Naval / carrier rework** — Carrier Stances (split carrier planes between taskforce defense and air
  missions); carriers intercept land-based naval strikes; Fleet Home Base reintroduced (with 'Automatic'
  selection); naval-invasion caps now per simultaneous-plan (planning time no longer scales with division
  count); shore bombardment can critically hit forts; coastal-defense ships can minelay. Pure gameplay/AI;
  only relevant if the owner wants to react to/rebalance for them. (The Medium-Battery **tech line** was
  removed — vanilla content; the mod's self-contained ship modules are unaffected.)
- **MIO** — Naval-Aircraft MIO archetypes now correctly apply Naval Attack/Targeting/Sub-&-Surface-Detection
  bonuses; generic infantry-tank/assault-gun MIO bonuses rebalanced. Bugfix/balance only — no format change.
- New **modifiers**: `army_experience_from_volunteers`, `spotting_chance_against`, `naval_hit_chance_against`,
  `amphibious_invasion_against`, `annex_subject_cost_factor`, `energy_gain_factor`.
- New **trigger**: `has_resources_in_collection` (true if a country has the resources in a given collection).
- **GUI / script**: `fade_delay` on `containerWindowType` (initial delay before a window fades in);
  scripted-effect **buttons** in the focus-tree inlay window; Raid Types can use a **range factor** modifier
  (multiplies effective range of eligible units); `language = X` now usable with or without the `l_` prefix.
- NCNS **content** (Philippines focus tree + the 23 new subdoctrines as playable content) — large new
  content, only relevant if the mod ever integrates it.

---

## 1.18 (Peace for Our Time)

Additions surfaced while researching the 1.17→1.18 jump (all are NEW capabilities / content / balance; **none
is required for the mod to LOAD on 1.18** — the only load-bearing edit this jump was the `supported_version`
bump). 1.18 is a **free update**: a war-score/peace rebalance, a submarine-detection formula overhaul, GER/ITA/UK
AI overhauls, and new Train + Helicopter MIO content. The mod uses none of the new tokens, and where 1.18 touched
a subsystem the mod overrides, the mod is insulated (so it does not *inherit* the improvement — that non-adoption
is the modernization opportunity). Sources: hoi4.paradoxwikis.com/Patch_1.18 ; /Patch_1.18.X ; /Peace_For_Our_Time ;
Equipment / MIO / Modifiers / Defines modding pages (via WebSearch backend + GitHub raw mirror) ; patched.gg /
xpgained.co.uk patch-note mirrors ; GitHub code search over 1.18 mods.

- **Submarine-detection overhaul** — 1.18 reformulated submarine detection via **new defines**
  `SUBMARINE_BASE_STEALTH_VALUE`, `SUBMARINE_REVEAL_DETECTION_MULTIPLIER` (tuned 0.1→0.075→0.065),
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER` (1→1.1). The **equipment stats are unchanged**
  (`sub_detection`/`sub_visibility`/`surface_detection`/`sub_attack` still valid), so the mod's ship hulls/modules
  keep working and the mod **inherits** the new formula automatically. The mod does not override these defines
  today; if the owner wants to preserve a specific pre-1.18 sub-warfare feel, set the three defines in
  `common/defines/cbts_defines.lua`. Pure tuning — not a port fix.
- **Train MIOs + Helicopter MIOs** — new vanilla MIO content (Train → ENG/FRA/BEL/USA/SOV/ITA/JAP/GER; Helicopter
  → BEL/USA/JAP/GER) plus their equipment lines. MIO **schema is unchanged** (no new required field). The mod
  `replace_path`s the MIO `organizations` folder, so it does **not** gain these; adopting them (porting the new
  organizations + equipment into the mod's own MIO set) is the modernization path.
- **War-score / peace-conference rebalance** — faction war-score contribution `0.125 → 0.1`; war score from sunk
  ships **halved** (sunk-IC contribution) to align with land combat. Internal balance values; no peace scripting
  token changed. The mod ships its own `common/peace_conference/*` and sets its own peace defines
  (`PEACE_SCORE_PER_PASS` etc., different keys), so it is unaffected by load but the owner may wish to re-balance
  the mod's peace tuning against 1.18's new war-score weights.
- **AI overhaul (Germany / Italy / UK)** — better MEFO management + Barbarossa commitment + "Service By
  Requirement" conscription + Berlin-Moscow-axis fallback (GER); North-Africa defense/screening + African airforce
  (ITA); Egypt defense + convoy-escort efficiency + Tripoli/Iraq offensives (UK). The mod `replace_path`s
  `ai_strategy`/`ai_focuses`/`ai_strategy_plans`/`ai_equipment`, so it **overrides vanilla AI** and does not inherit
  these; porting the desirable improvements into the mod's own AI files is the modernization path (overlaps the
  deferred D1 `ai_templates` work for division design, which 1.18 did **not** change).
- **`pp_spend_priority` extended to advisors** — the AI-strategy token `pp_spend_priority` can now also **target
  advisors** (not just spend categories). The mod uses it widely in the category form (`id = admiral|relation|…`);
  it could now also weight specific advisors. Additive.
- **Stability-check validation** — 1.18 updated error-checking for stability checks to verify the normalized range
  based on defines. Internal validation; no action.
- **Naval OOB / carrier balance** — Japan 1936/1939 naval OOB corrections (Hatsuharu/Minekaze DDs, Takao CAs, IJN
  Yugao); tuned carrier/naval-strike defines (`NAVAL_STRIKE_CARRIER_MULTIPLIER` 10→12,
  `CARRIER_COMBAT_DAMAGE_STATS_MULTIPLIER` 0.35→0.5). Pure balance/content; only relevant if the owner rebalances
  for it.

NOTE (deferred decisions, unchanged by 1.18): **1.18 made no AI-template / division-designer schema change** (D1
target unchanged) and **no doctrine-system change** (D6 target unchanged — 1.18's naval change is the submarine
*detection* formula, not the naval *doctrine*). Both subsystems remain untouched per HARD RULES 1 & 2.
