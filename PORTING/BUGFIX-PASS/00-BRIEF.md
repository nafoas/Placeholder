# BUGFIX PASS — shared brief for all per-version agents

The first port pass was too conservative (descriptor bump + 1 ability file, deferred D1/D6, MISSED
many real breakages). The mod loaded far enough to reach the 1933 start date and then **crashed with
`EXCEPTION_INT_DIVIDE_BY_ZERO` at game init**. The `-debug` `error.log` (distilled below) exposes
dozens of version-introduced breakages across every subsystem.

This pass corrects that. **One agent per version**, run in order. Each agent owns the COMPLETE set of
changes its version (relative to the prior one) introduced — not just what appears in the log.

## HARD RULES (non-negotiable)
1. **No guesses.** Every fix must be backed by a real source: the official patch notes / wiki, a
   vanilla file, or how a confirmed-on-that-version mod does it. Cite the source per fix.
2. **No deferrals.** If your version changed something the mod uses, FIX it now. Nothing is "deferred",
   "degraded-but-runnable", or "left for the owner". D1 (AI templates) and D6 (doctrines) are IN SCOPE.
3. **If you cannot determine the correct fix even after looking it up, STOP and escalate** (write it to
   `ESCALATIONS.md` in your jump folder and end your report with `NEEDS-DECISION:`). Do not guess.
4. **Cross-reference at least two independent sources** for any non-trivial schema/token change.
5. **Preserve the mod's design and balance.** Default to the *minimal* change that makes the content
   LOAD and FUNCTION correctly on 1.19 while keeping the mod's existing values/intent. Only escalate if
   even the minimal fix forces a genuine either/or design choice with balance implications.
6. The mod root is `3273913964/`. The raw log is at
   `/tmp/claude-0/-home-user-Placeholder/7c8e0bee-543f-587f-b610-ed2191881c29/scratchpad/error.log`.

## METHOD (per agent)
1. Research your version's FULL changelog: every removed/renamed/reworked **effect, trigger, modifier,
   equipment stat, building-schema key, subunit category, technology category, defines key, GUI
   element, scripted-token rule**. Use the existing `PORTING/jump-*/` dossiers as a starting index, but
   go beyond them (they missed things).
2. For each candidate change, `grep` the ENTIRE mod for usages (mod files AND remember the mod overrides
   ~25 vanilla folders via `replace_path` — a stale override can break *vanilla's* files too).
3. Apply the fix in the mod files. Keep edits surgical and consistent with surrounding code.
4. Re-grep to confirm the broken token is gone mod-wide.
5. Write `PORTING/jump-X/BUGFIX-changes.md`: every fix as `file:line — old → new — WHY — SOURCE(url)`.

## ESCALATION → return to orchestrator
End your final message with one of:
- `DONE:` + count of fixes + path to your changes file, or
- `NEEDS-DECISION:` + the specific fork(s) you could not resolve without a design/owner call.

---

# ERROR INVENTORY (distilled from error.log — the starting point, NOT the full scope)

Counts are occurrences in the log. "in file" = the file the engine blamed. Remember cascades: one
broken definition file can invalidate hundreds of downstream references.

## A. Equipment stats — removed/renamed (MOD's own equipment files)
- `naval_supremacy_factor` — unexpected token in `common/units/equipment/ship_hull_{carrier,cruiser,heavy,submarine}.txt` (×4)
- `naval_general_support_value_factor` (×3), `naval_general_support_factor` (×2), `naval_repair_support_value_factor` (×2), `naval_repair_support_factor` (×1)
- `nuclear_production_factor` (×1), `fuel_gain_from_states` (×1), `max_fuel_building` (×2)
- missing static modifier definitions referenced by mod: `naval_general_support`, `naval_repair_support`, `the_great_wall`

## B. Building schema rework (1.17 building-limit rework) — `common/buildings/00_buildings.txt`
- unexpected tokens: `allowed_types` (×94), `max_level` (×15), `shares_slots` (×7), `production_prio` (×7)
- (the flat `max_level` schema was reworked into nested `level_cap = { state_max / province_max / shares_slots / allowed_types ... }` — verify exact 1.17/1.19 schema)

## C. Subunit categories — invalid/unexpected (subunit + Regimental-Support rework)
Appear BOTH as `Unexpected token: category_*` (mod unit/template files) AND `Invalid subunit category`
(vanilla files failing because the mod's category set is stale):
`category_regimental_support_battalions`, `category_regimental_support_artillery`,
`category_tank_destroyer_regimental_support`, `category_self_propelled_anti_air_regimental_support`,
`category_divisional_support_battalions`, `category_self_propelled_artillery`,
`category_self_propelled_anti_air`, `category_tank_destroyers`, `category_vehicle_infantry`,
`category_rangers`, `category_anti_tank`, `category_mobile_anti_tank`,
`category_helicopter_support_companies`, `category_maritime_patrol_bomber`,
`category_carrier_nav_bomber`, `category_carrier_cas`, `category_carrier_fighter`,
`category_mobile_and_mobile_combat_sup`. Determine the authoritative 1.19 subunit-category list and how
the mod is supposed to declare custom categories; reconcile.

## D. Equipment DB entries missing ("Entry doesn't exist in database") — stale equipment overrides
Land cruiser modules `lc_*` + `land_cruiser_chassis_1`/`land_cruiser_equipment_1`;
`super_heavy_artillery(+_equipment_1)`, `self_propelled_super_heavy_artillery(+_equipment_1)`,
`super_heavy_railway_gun`; nuclear/modern navy (`nuclear_submarine`, `nuclear_missile_submarine`,
`rocket_submarine`, `fleet_submarine`, `cruiser_submarine`, `midget_submarine`, `escort_carrier`,
`mega_carrier`, `modern_carrier`, `modern_battleship`, `ship_hull_*` modern/escort/fleet/nuclear,
`sub_ship_nuclear_engine_1`, `heavy_ship_nuclear_engine_1`, `carrier_ship_nuclear_engine_1`,
`ship_engine_sub_aip_1`, `ship_torpedo_sub_nuclear`, `slbm_launcher`, `sub_missile_launcher`,
`ship_light_battery_sub`, `ship_anechoic_tile`, `big_ship_deck_space`, `ship_escort_deck_space`,
`ship_submarine_deck_space`, `ship_armor_ice_carrier_deck_1`);
`jet_engine_axial_{1,2,3,4,6}x`, `small_plane_airframe_5`, `supersonic_fighter_equipment_1`,
`earthshaker_bomb_release`, `assault_engineer`. Root: the mod overrides equipment files with versions
predating this vanilla content; reconcile (add defs to the override or remove dead references — choose
the one that matches the mod's design).

## E. Technology categories — unknown
`cat_fortification` (×4), `naval_artillery` (×3), `naval_armor` (×3), `mio_cat_artillery` (×3),
`helicopter_tech` (×1) — referenced by `common/special_projects/*` and
`common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt`. Reconcile the mod's tech-category
set with what these (vanilla or mod) files expect.

## F. Doctrines (1.17 Grand/Sub/Mastery rework) = D6 — `common/doctrines/subdoctrines/**`
Parse errors: `combat_support_subdoctrines.txt` (×47), `armor_subdoctrines.txt` (×18),
`infantry_subdoctrines.txt` (×14), `operations_subdoctrines.txt` (×11),
`special_forces_subdoctrines.txt` (×13). Determine fatal vs degraded; migrate the mod's doctrines to
the 1.17 schema (+1.19 SF-doctrine features) so they LOAD and FUNCTION.

## G. AI division templates (1.15 designer-AI rework) = D1 — `common/ai_templates/*.txt` (625 lines)
Deprecated props `width_weight`, `weight`, `target_width`, `match_value`, `column_swap_factor` (and the
removed `match_to_count`). Migrate to the post-1.15 singular-`role` schema. Templates also reference the
invalid categories (C) and possibly missing equipment (D) — reconcile together.

## H. Scripted-trigger cascade (likely one+ broken `common/scripted_triggers/*` file)
`Invalid trigger`: `is_literally_china`, `is_independent_china_or_warlord`, `is_raj_or_raj_inheritor`,
`naval_facility`, `land_facility`, `air_facility`, `should_play_south_american_music`,
`JAP_naval_faction_is_tier_#`, `JAP_army_faction_is_tier_#`, `WTT_is_chinese_country`,
`SPR_scw_in_progress`, `GER_is_RK_south_urals_state`, `GER_is_west_coast_north_america_state`,
`nuclear_reactor_heavy_water`. These are mostly the mod's OWN scripted triggers — find why they fail to
register (a fatal token inside a scripted_triggers file kills every trigger in that file, cascading into
100+ downstream `in file: faction_goals_*/decisions/*` errors). HIGH leverage.

## I. Effects — invalid idea / unknown tech category in effects
`add_timed_idea: Invalid idea:` USA_wounded_national_pride_idea, JAP_day_of_infamy_#,
idea_CHI_central_government_integration_pressure, GER_eben_emael_*, CZE_sokolov_*,
special_project_consumer_costs_{low,medium,high}, JAP_public_awareness_* — ideas missing (removed or in
a file that failed to load — may be a cascade). `add_tech_bonus` unknown categories → see E.

## J. GUI overrides stale (1.17 fade/inlay, 1.19 Army-HQ designer + career profile)
`interface/divisiondesignerview.gui` missing: `save_and_deploy_button`, `non_hq_view`, `hq_view`,
`niche_button`, `toggle_model_selector_button`, `hardness_stat`, `org_stat`, `strength_stat`,
`speed_stat`, `combat_width_view`, `hq_overlay_images` (×11) — likely the **division-designer crash
surface**; reconcile against 1.19 designer gui. `career_profile/common_components.gui` (×60) missing
1.19 stat rows. `frontendgamesetupview.gui` missing `new_content`. Reconcile the mod's `interface/`
overrides with 1.19.

## K. Misc singletons
- `common/script_enums.txt:720` duplicate script enum `=` (malformed line) — fix.
- dynamic token `2RCW_Increase_Ideology_From_Recognizer` can't start with a digit — rename (mod bug).
- `strategic_resource_database.cpp: No energy resource defined` — determine which version made an
  `energy` resource expected and how to satisfy it.
- `pdx_entity: ITA_mechanized_vehicle_1_entity` missing attachment (3D model) — gfx/entity.
- `map/strategicregions` overlapping/short temperature intervals (mod replace_path) — non-fatal, fix if cheap.
- IGNORE (not the mod): `settings.txt skip_account_link` (user settings); `ugc_3738027260.mod invalid
  supported_version` (a different subscribed workshop mod); most missing `.dds` textures (cosmetic — fix
  only if trivially tied to a real fix).

## Provisional version routing (VERIFY — do not take as fact)
- 1.15: G/D1 (AI templates). Possibly start of subunit-category renames.
- 1.16: likely minimal — confirm.
- 1.17: B (buildings), F/D6 (doctrines), E (some tech cats), K (energy), `cl_tech→ca_tech`.
- 1.18: naval sub-detection (defines, mostly inherited), Train/Helicopter MIO + `helicopter_tech`/helicopter categories.
- 1.19: C (regimental/divisional subunit categories), A (naval support modifiers), D (regimental-support
  + modern-navy equipment), J (Army-HQ designer + career-profile GUI), SF-doctrine part of F.
- Cross-version / unclear: D (equipment content added across several versions), H (trigger cascade — find the root file).
