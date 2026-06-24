# ESCALATIONS — cross-cutting script-cleanup

These are the items I could NOT resolve without a content/design/owner decision. Per the
brief's HARD RULES (no guesses, no inventing content, cite sources, preserve design), I did
NOT fabricate definitions for any of these. Each entry says exactly where it is used and why
it cannot be safely auto-restored.

See `CROSS-CUTTING-changes.md` for the full context and the KEY STRUCTURAL FINDING:
**CBtS runs on a Road to 56 (RT56) base, not pristine vanilla.** The 77 undefined triggers
exist because the mod's `replace_path="common/scripted_triggers"` wiped the vanilla+RT56
scripted_triggers over both layers, while base/RT56 files that call them are not overridden.

---

## DECISION NEEDED #0 (meta) — confirm the base layer & the intended fix strategy

Confirm whether CBtS is meant to load **with Road to 56 as a dependency** (the evidence says
yes). If so, the cleanest fix for ALL of the below is to either (a) re-add a dependency on the
exact RT56 build CBtS forks and stop replacing the whole `common/scripted_triggers` folder
(use additive overrides instead), or (b) re-vendor the missing RT56 + vanilla
`common/scripted_triggers/*` files (CHI/JAP/HUN/RAJ_GOE/peace/00/_special_forces) into the
mod's replaced folder. I restored the safe, fully-validated subset (44 triggers) inline; the
remaining 30 below need the owner to confirm which RT56 build / content set is canonical so the
tag/idea dependencies line up.

---

## mod content missing — owner must restore

### B1. Japan Imperial Influence faction triggers (12) — depend on MISSING ideas
Triggers (all undefined): `JAP_army_faction_is_tier_1..4`, `JAP_army_faction_is_not_dominant`,
`JAP_army_faction_is_not_subdued`, `JAP_naval_faction_is_tier_1..4`,
`JAP_naval_faction_is_not_dominant`, `JAP_naval_faction_is_not_subdued`.
- USED IN: base-layer `common/focus_inlay_windows/jap_imperial_influence_inlay_window.txt`
  (not shipped/overridden by the mod).
- WHY ESCALATED: the upstream (RT56) definitions test ideas like
  `JAP_army_faction_tier_1_equal_navy`, `JAP_army_faction_tier_1_lesser_1`, … These ideas have
  **0 occurrences anywhere in CBtS**. Porting the trigger defs would just move the failure to
  "Invalid idea". The whole Japan Imperial-Influence idea set is missing from CBtS and must be
  restored (or the inlay window / triggers removed) — an owner content decision.
- SOURCE if the owner wants the RT56 defs: `common/scripted_triggers/JAP_scripted_triggers.txt`
  in jameskicklighter/hoi4-ai-base / Packerthrowaway TFB (RT56 family).

### B2. China core + mandate-state triggers (6) — conflict with CBtS's reworked China
Triggers: `is_literally_china`, `is_independent_china_or_warlord`, `WTT_is_chinese_country`,
`CHI_greater_game_states`, `CHI_northern_mandate_states`, `CHI_southern_mandate_states`.
- USED IN: base/RT56 `common/factions/goals/faction_goals_*`, `common/collections/collections.txt`,
  `common/factions/rules/joining_rules.txt`, `common/ai_faction_theaters/ai_faction_theaters.txt`,
  `common/autonomous_states/sea_warlord_subject.txt` (+ integrated), `common/raids/*`,
  `common/peace_conference/cost_modifiers/*`, `common/dynamic_modifiers/*` — none overridden.
- WHY ESCALATED: CBtS **heavily reworked China**. Its own
  `common/scripted_triggers/CBtS_CHI_triggers.txt` defines `is_chinese_TAG` and
  `is_chinese_warlord` using a DIFFERENT warlord tag set
  (`NEA SHX SHD YUL LWH DXH TSY LCH YSN LXI GZC MHK HNA FUJ YUN GXC GDC XSM KML SIK NWA …`)
  than vanilla/RT56 `is_literally_china` (`CHI PRC GXC YUN SHX XSM SIK [TNG]`). So the correct
  tag list for `is_literally_china` / `is_independent_china_or_warlord` is an OWNER call, and
  `CHI_*_mandate/greater_game_states` (state-collection helpers) need the CBtS-intended state
  lists. The empty 0-byte `common/scripted_triggers/CHI_scripted_triggers.txt` is where this
  content belonged and was lost.
- NOTE: the original CHI content lived in RT56's `CHI_scripted_triggers.txt`
  (e.g. Willl-l/RT-56-RP-MP-RB) — usable as a starting reference, but must be reconciled to
  CBtS's tag rework before use.

### B3. RT56 country-tag scope-checks (7) — the TAGS themselves are missing
Tokens (used as `TAG = { … }` country-scope checks, reported as "Invalid trigger"):
`GSM`, `HBC`, `KHM`, `NXM`, `SIC`, `SND`, `XIC`.
- USED IN: base/RT56 `common/factions/goals/faction_goals_short_term.txt`.
- WHY ESCALATED: these are NOT scripted triggers — they are RT56 **country tags** that are
  **absent from CBtS** (`common/country_tags/00_countries.txt` + `zz_dynamic_countries.txt`
  do not define them; they appear in 0 history/focus files). The mod replaced
  `common/country_tags`, dropping them. Defining scripted triggers with these names would be
  wrong. Fix = the owner deciding whether these tags should exist in CBtS (restore the tags +
  their countries) or whether the base faction-goals referencing them should be overridden out.

### B4. GoE / Munich / misc partial-content triggers (4)
- `is_raj_or_raj_inheritor` — used in `common/decisions/categories/RAJ_GOE_decision_categories.txt`
  and `common/dynamic_modifiers/GoE_dynamic_modifiers.txt`. Upstream def is
  `{ OR = { original_tag = RAJ original_tag = BAN … } }`, but **tag `BAN` is absent from CBtS**.
  Source: `RAJ_GOE_scripted_triggers.txt` (RT56 family). Owner must confirm the tag set.
- `CZE_RUT_is_not_its_own_thing` — used in `common/dynamic_modifiers/mun_dynamic_modifiers.txt`.
  References Ruthenia tag `RUT`, which is **absent from CBtS**. Owner call.
- `SPR_scw_in_progress` — used in `common/decisions/categories/BEL_decision_categories.txt` and
  `faction_goals_short_term.txt`. Spanish-Civil-War progress check; SPR exists in CBtS but the
  exact definition (which flags/variables it tests) must come from the specific base build and
  could not be verified uniquely across mirrors. Owner should paste the canonical def.
- `HABSBURG_is_a_habsburg_viable_nation` — used in
  `common/technology_sharing/12_wuw_tech_sharing_groups.txt`. Base-vanilla (Götterdämmerung)
  content living in `HUN_scripted_triggers.txt`; HUN/AUS exist in CBtS, but the full block
  (which tags/conditions count as "viable Habsburg") varies between vanilla and RT56 mirrors,
  so the exact intended version is an owner call. Source candidates:
  `HUN_scripted_triggers.txt` in Road-to-56-RP/roadto56rp or a pristine 1.19 vanilla dump.

### B5. Base-vanilla special-projects facility/nuclear triggers (4) — need pristine 1.19 file
Triggers: `naval_facility`, `land_facility`, `air_facility`, `nuclear_reactor_heavy_water`.
- USED IN: base-vanilla `common/raids/naval_commando_raids.txt`,
  `common/factions/goals/faction_goals_short_term.txt`,
  `common/special_projects/projects/nuclear_projects.txt`.
- WHY ESCALATED: despite being genuine base-vanilla 1.19 triggers, **no scripted-trigger
  definition for them was found in ANY mirror searched** (GitHub code search returned 0 for
  `naval_facility = {` / `nuclear_reactor_heavy_water = {` as scripted triggers). They are
  almost certainly defined in the actual pristine 1.19 vanilla `common/scripted_triggers/*`
  (probably `00_scripted_triggers.txt` and/or a special-projects triggers file) which I could
  not obtain verbatim at 1.19. They must be copied EXACTLY from a confirmed-1.19 vanilla
  install — I will not reconstruct them from inference.

---

## DOCUMENTED, non-fatal (no fix forced) — Task 3 career-profile GUI

`interface/career_profile/common_components.gui` is missing ~13 1.19 playthrough-stat elements
(`mio_size_ups`, `special_forces_deployed`, `equipment_sold`, `special_projects_completed`,
`launched_raids`, `scientist_level_ups`, `faction_goals_completed`, `mastery_gained`,
`naval_headquarters_built`, `captured_commanders`, `rescued_commanders`,
`ship_captains_promoted`). The window is heavily customized (145 nested containers across 8
bespoke pages; none of the standard rows are in a copy-pasteable form). Per the brief, this was
documented rather than forced. Impact: cosmetic only (window loads; those counters don't show).
If desired, the owner can additively add the 13 stat elements following the mod's own page/macro
layout, sourced from the 1.19 vanilla `interface/career_profile/common_components.gui`.
