# Jump 1 (1.14 → 1.15) — Independent Audit / Deconstruction Review

Adversarial second-pass review of the updater's port. Method: every claim was re-derived
from primary sources — the bundled 1.14 API docs (`3273913964/pdx_documentation/`), the
fetchable GitHub raw-markdown mirror of the Paradox modding wiki
(`klimPaskov/Agentic-HOI4-Modding/paradox_wiki/*`, Modifiers page committed **2026-05-21**, i.e.
a current post-1.15 snapshot), and `WebSearch` deep-reads of the JS-walled wiki/forum. Confidence
and source are stated per item. No mod files were edited.

**Bottom line:** The descriptor bump is correct and the mod will LOAD on 1.15. But the updater's
dossier contains **two factual errors**, one of which is a real missed issue:
1. The updater's headline worry (U1, `terrain_penalty_reduction` removed) is **WRONG in the
   reassuring direction by luck** — the token was NOT removed, so leaving it is correct, but for
   the opposite reason the dossier gave.
2. The updater's claim that `match_to_count` is "ABSENT across the whole repo outside
   pdx_documentation" is **FALSE** — it appears ~50× in `common/ai_templates/*.txt`, and 1.15
   reworked the AI-template system. This is a genuine miss (non-load-breaking, but a behavior/
   warning concern that belongs in OWNER DECISION, not "no action").

Jump 1 is **sound as-committed for LOADING** (no crash/no load-block found). It is **NOT
"essentially no-change with everything verified"** as the dossier frames it — the AI-template
situation was mis-assessed and needs to be surfaced to the owner.

---

## CONFIRMED CORRECT (independently verified)

### C1 — `descriptor.mod` supported_version `"1.15.*"` is the correct edit. (Confidence: HIGH)
- Verified the edit is in place: `3273913964/descriptor.mod:37` = `supported_version="1.15.*"`.
- The minor-wildcard form is explicitly valid; `*` matches any 1.15.x build (1.15.0–1.15.4).
  Confirmed against wiki examples `1.11.*` and other mods' `1.19.*`.
- Source: hoi4.paradoxwikis.com/Mod_structure ; hoi4-modding.fandom.com/wiki/.mod_file
  (both via WebSearch). 1.15 released 2024-11-14, checksum 79eb (last point release 1.15.4).
- No structural/encoding damage to the descriptor; single-token change.

### C2 — `terrain_penalty_reduction` was NOT removed in 1.15. Leaving all 5 usages is correct. (Confidence: HIGH)
This OVERTURNS the premise of the updater's U1 (which treated removal as an unresolved real
possibility). The token is still a valid registered modifier.
- The **post-1.15 wiki mirror still documents it** (Modifiers page, committed 2026-05-21):
  > **terrain_penalty_reduction** — Effects: Decreases the penalties given by terrain.
  > Modifier type: Percentual.
  > **Notes: Only works in the unit_leader scope despite the modifier being present in vanilla
  > national spirits at the time of writing.** Version added: 1.0
  (scratchpad/modifiers_wiki.md:3923–3931, fetched from
  raw.githubusercontent.com/klimPaskov/Agentic-HOI4-Modding/main/paradox_wiki/Modifiers...md)
- This reconciles the 1.15 patch note perfectly. The note — "Replaced Terrain Penalty Reduction
  modifier which was not working in National Spirits by the modifier Terrain Traits XP Gain" —
  means Paradox swapped which modifier **vanilla's own national spirits** use (because
  `terrain_penalty_reduction` never worked in NS scope). The **token was not deleted**; it still
  works in `unit_leader` scope.
- Per-usage behavior on 1.15 is therefore IDENTICAL to 1.14 (verified each scope):
  - `common/unit_leader/00_traits.txt:1162` — inside trait `adaptable` (`assignable_terrain_trait`),
    `unit_leader` scope → **works** (now and before).
  - `common/ideas/japan.txt:940` (`Ma_war_of_resistance`), `common/ideas/ethiopia.txt:277`,
    `common/ideas/PAR_ideas.txt:16` & `:35` — all inside `country = { … modifier = { … } }`
    national-spirit idea blocks → **inert** (the wiki note says it does nothing in NS scope; this
    was already true on 1.14, so no regression).
  - Bundled 1.14 docs confirm it existed in 1.14 with the same categories
    (`pdx_documentation/modifiers_documentation.md:3645` "army, defensive";
    `script_documentation.json:5879`).
- Net: no warning, no behavior change, no fix needed. The updater reached the right action
  (leave as-is) but its rationale ("if removed, harmless warning") rested on a false premise that
  removal was plausible. Down-grade U1 from "uncertain" to **resolved/no-issue**.
- Note: `terrain_traits_xp_gain` (the new NS modifier) is a *different* token from the
  pre-existing `terrain_trait_xp_gain_factor` (singular, "Version added: 1.5", still present —
  modifiers_wiki.md:5845; also in the 1.14 docs at modifiers_documentation.md:3650). The mod uses
  neither; irrelevant to the mod but clarifies the patch note.

### C3 — `map/airports.txt` & `map/rocketsites.txt` are inert on 1.15; not load-breaking. (Confidence: HIGH)
- Verbatim deprecation confirmed: "/Hearts of Iron IV/map/airports.txt and
  /Hearts of Iron IV/map/rocketsites.txt were deprecated and removed in the patch 1.15."
  (Map modding mirror page, fetched raw; corroborated via WebSearch.)
- The mod's `map/default.map` does not reference them, and no file in `map/` or `common/`
  references either filename (grep) — they were always filename-hardcoded. Post-1.15 the engine
  simply does not read them; unknown/leftover files in `map/` do not produce a load error.
- See OD-1 for the (low-risk) behavior-fidelity caveat — but the LOAD claim is solid.

### C4 — Division-template properties the mod uses (in `history/units`) are all still valid. (Confidence: HIGH)
- Precise brace-tracked extraction of every top-level key inside `division_template = { … }`
  blocks across `history/units/` yields ONLY: `name`, `regiments`, `support`, `is_locked`,
  `division_names_group`, `priority`, `template_counter` (+ the 4 `locked` typos, see OD-2).
- Every one is enumerated as valid on the current Division-modding wiki mirror
  (scratchpad/division_wiki.md:73–79): `division_names_group`, `is_locked`,
  `force_allow_recruiting`, `division_cap`, `priority`, `template_counter`, `override_model`.
- `force_equipment_variants` (used 104× in history/units, NOT mentioned by the updater) is also
  confirmed still-valid (division_wiki.md:101,132). No removed property is used in `history/units`.
- The one named-removed property (`match_to_count`) is NOT used in `history/units` — but IS used
  elsewhere; see NF-1.

### C5 — `cbts_defines.lua` overrides, MIO folder layout, replace_path targets. (Confidence: MEDIUM-HIGH)
- All 23 `replace_path` targets in the descriptor are standard folders that still exist in 1.15
  vanilla (ideas, characters, national_focus, decisions, on_actions, scripted_*, MIO/{organizations,
  policies,ai_bonus_weights}, units/codenames_operatives, map/strategicregions, history/*, etc.).
- MIO subfolders (organizations/policies/ai_bonus_weights) confirmed current. 1.15's MIO changes
  are additive (MIO category equipment-group as bonus type). No required-field break found.
- Defines: spot-confirmed the override file targets long-standing define tables; 1.15 define
  changes found in research are additions (e.g. `MIN_SHIPS_FOR_HIGHER_SHIP_RATIO_PENALTY`). I did
  not exhaustively diff every overridden Lua key against a 1.15 enumerated define list (the live
  Defines page is JS-walled); confidence MEDIUM on completeness, HIGH that nothing obvious breaks.

### C6 — 1.15's other modder-facing changes are additions/fixes the mod is not broken by. (Confidence: MEDIUM-HIGH)
Re-researched the 1.15 change surface independently. Confirmed items and disposition:
- `all_enemy_country` trigger FIX — mod doesn't use it outside docs (re-grepped). No effect.
- New additions (cannot break existing content): `divisional_commander_xp` variable,
  `state_resources_<resource>_factor` modifier, `has_naval_invasion_against_state` trigger,
  AI strategies `equipment_production_min_factories_archetype`, `force_concentration_target_weight`,
  `force_concentration_factor`, MIO-equipment-group bonus type, AI-template division-name-list
  support.
- Land/Coastal Fort max level now capped by province terrain type — a balance cap applied to
  existing forts; not a format break (the mod's forts in buildings.txt are simply capped in-game).
- Götterdämmerung loc-ordering change (contextual loc V1 → saved targets → V2) — ordering only;
  no token removed.
- Source: hoi4.paradoxwikis.com/Patch_1.15 (multiple WebSearch deep-reads);
  updatecrazy.com 1.15.4 mirror.
- Caveat: I could not obtain a single verbatim dump of the FULL "Database & Scripting" section
  (WebSearch summarizes; the live page is JS-walled; archive.org egress-blocked). I cross-checked
  the same item set from ≥3 query angles and found no additional removed/renamed token that the
  mod uses. See SU-2.

---

## NEEDS FIX
**None that block loading.** No defect was found that prevents the mod from loading or that
crashes 1.15. (The most consequential issue, NF-1 below, is non-load-breaking and is a behavior/
owner matter, so it is filed under OWNER DECISION, not here.)

---

## OWNER DECISION (behavior-fidelity; human must resolve)

### OD-1 (was U2) — Air-base / rocket-site province placement. (Confidence: HIGH on facts; in-game check still needed)
- **Corrects the updater's (and a naive) reading of buildings.txt.** Per the 1.15 Map-modding
  spec: `map/buildings.txt` column 1 is the **STATE ID** (not province), and for provincial
  buildings like air bases the game uses the **XYZ coordinate** of each entry to decide which
  province within the state it lands in (map_modding.md:806–815).
- Measured: the mod's `buildings.txt` covers states 1..1234 (1234 distinct state IDs), with
  exactly one `air_base` and one `rocket_site` entry per state, each carrying explicit XYZ
  coordinates. The legacy `airports.txt`/`rocketsites.txt` likewise covered exactly 1234 states
  (state→explicit-province map).
- So the modern placement **is fully expressed** in buildings.txt (coordinates present for every
  air base / rocket site). The only residual risk: a coordinate could resolve to a *different*
  province than the legacy file's explicit province ID, if the two were ever authored
  inconsistently. This is verifiable only in-game.
- **Owner action:** load 1.15, spot-check a few states' air-base/rocket-site provinces vs. the
  1.14 build. If any differ and the legacy province was intended, nudge the XYZ in the
  buildings.txt `air_base`/`rocket_site` entry into the desired province. The two legacy files are
  otherwise inert and can be deleted at the owner's discretion (not required for load).
- Reassurance on a separate crash vector: the wiki warns buildings.txt "will crash if entirely
  empty" / "if left unedited while adding new states." The mod's buildings.txt is fully populated
  and state-complete (2.5 MB, 1234 states), so that crash condition does NOT apply.

### OD-2 (was U3) — `locked = yes` typo in 4 templates. (Confidence: HIGH)
- `history/units/WGR_stahlhelm.txt:11`, `WGR_reichsbanner.txt:12`, `ARM_2RCW_Militia.txt:10`,
  `BRY_2rcw_start.txt:12` use bare `locked = yes`; the valid property is `is_locked`. Bare
  `locked` is an unrecognized key (no-op) and was already a no-op on 1.14 — NOT a 1.15 breakage.
- Confirmed via the current Division-modding wiki: the property is `is_locked` (division_wiki.md:74);
  `locked` is not listed.
- Owner decides whether these 4 templates were meant to be locked (would need `is_locked = yes`).
  Out of scope for a faithful 1.14→1.15 port. Agreeing with the updater here.

---

## NF-1 / PRIMARY MISS — AI templates use removed/legacy schema (`match_to_count` ×~50 + legacy keys). (Confidence: HIGH that the dossier claim is false; MEDIUM on runtime severity)
**Filed as OWNER DECISION (behavior), not NEEDS FIX, because it does not block loading and a
faithful fix is non-trivial.** This is the updater's significant miss.

- **The dossier is factually wrong here.** changes.md and dossier.md state: "Re-grepped
  `match_to_count` … ABSENT outside `pdx_documentation/`. Mod uses no removed division-template
  property." Independent grep shows **`match_to_count` appears ~50 times across all 9
  `common/ai_templates/*.txt`** (generic.txt + templates_{USA,ITA,CHI,JAP,SOV,FRA,ENG,GER}.txt).
  Counts e.g. generic.txt:80/521/573/662/837/964/1073/1274; templates_GER.txt:11/514/570/635/775/890;
  etc.
- `match_to_count` is precisely the property the 1.15 patch note calls out as removed/replaced:
  "AI division templates now get their AI role assigned on creation from the target template,
  instead of dynamic matching via match_to_count." (Patch_1.15, via WebSearch.)
- The mod's AI templates are in the **pre-1.15 `ai_templates` schema** more broadly, not just one
  stray key. Classifying every distinct key the mod uses in `common/ai_templates/*.txt` against the
  post-1.15 `ai_templates` spec (ai_modding.md §"AI templates", lines 2077–2204):
  - **Still valid post-1.15:** `upgrade_prio`, `available_for`, `blocked_for`, `target_template`
    (`regiments`/`support`), `replace_at_match`, `replace_with`, `target_min_match`, `custom_icon`,
    `reinforce_prio`, `can_upgrade_in_field`, `enable`, and the MTTH internals (`modifier`/`factor`).
    The `<name>_default` / `<name>_generic` block names are just the design-block names (fine).
  - **Legacy / NOT in the post-1.15 `ai_templates` spec:** `match_to_count` (48×, patch-note-removed),
    `roles` plural (48×; the spec uses a singular scalar `role =`, ai_modding.md:2093,2125),
    `match_value` (94×), `weight` (94×, inside target_template), `target_width` (94×),
    `width_weight` (94×), `column_swap_factor` (94×), `allowed_types` (94×), `stat_weights` (57×),
    `production_prio` (7×). That's roughly half the structural keys per design block.
  - **Scope caveat (important, corrects a tempting false reassurance):** several of those legacy
    tokens (`roles` plural, `allowed_types`, `match_value`, `_default` blocks) ARE still documented
    — but under the **separate `## AI equipment` schema** for `common/ai_equipment/` (tank/ship
    variant design, ai_modding.md:2206–2295), NOT under `ai_templates`. They share token *names*
    with the legacy division-template format but are a different system. Their validity in
    `ai_equipment` says nothing about whether `ai_templates` still accepts them. So I do NOT treat
    "still documented somewhere" as evidence of `ai_templates` backward-compat.
- **What I could NOT confirm (and won't assert):** whether 1.15 (a) hard-errors on the legacy
  `ai_templates` keys, (b) warns-and-ignores them (HOI4's usual behavior for unknown script keys),
  or (c) tolerates them via a legacy parse path. No source states definitively that old-format
  `ai_templates` fail to load on 1.15. What IS definite: `match_to_count`'s effect is gone (role
  assignment changed at creation time). Realistic expectation: `-debug` warnings for the legacy
  keys + the nine affected nations' AI division-design behavior diverging from the 1.14 build to
  some degree. This degrades AI behavior; it does not block the mod from loading.
  - The mod does **not** `replace_path` `common/ai_templates`, and its filenames
    (generic.txt, templates_<MAJOR>.txt) are the **same canonical names vanilla ships** → within a
    non-replace_path'd folder HOI4 loads last-wins by filename, so the mod's files **override the
    now-updated vanilla AI templates** for those majors. That raises the stakes: if the legacy
    format is partly ignored, the AI for GER/SOV/USA/etc. could design divisions worse than either
    1.14-mod or 1.15-vanilla.
- **Why not auto-fixable:** porting these to the 1.15 schema (singular `role =`, drop
  `match_to_count`, migrate `_default` blocks to the role-level/`target_template` structure) is a
  behavior-changing rewrite of ~3,000 lines of AI tuning — exactly the kind of judgment call the
  faithful-port mandate reserves for the owner.
- **Owner action:** (1) run 1.15 with `-debug` and grep `error.log` for `match_to_count` /
  unexpected-token warnings in `common/ai_templates/` to fix runtime severity; (2) decide whether
  to migrate the nine AI-template files to the 1.15 schema (recommended if the AI visibly
  mis-builds), or to delete them and inherit vanilla 1.15 AI templates. Either way this should be
  tracked, not silently passed as "no action."
- Sources: Patch_1.15 (WebSearch); AI modding mirror page §AI templates
  (raw.githubusercontent.com/klimPaskov/Agentic-HOI4-Modding/main/paradox_wiki/AI modding…md);
  mod grep evidence above.

---

## STILL UNCERTAIN (with best evidence)

### SU-1 — Exact runtime disposition of the legacy `ai_templates` keys on 1.15.
- Best evidence: `match_to_count` is patch-note-confirmed removed (its effect is gone). The other
  legacy keys (`roles` plural, `target_width`, `width_weight`, `column_swap_factor`, `match_value`,
  `weight`, `allowed_types`, `stat_weights`, `production_prio`) are NOT in the post-1.15
  `ai_templates` schema. (They appear in the wiki only under the *separate* `ai_equipment` schema —
  which does not govern `ai_templates`; see NF-1 scope caveat.) Most likely they warn-and-ignore,
  but I found no source stating definitively whether old-format `ai_templates` hard-error, are
  ignored, or are accepted via a legacy parse path.
- A single 1.15 `-debug` run + `error.log` grep over `common/ai_templates/` resolves this
  immediately — strongly recommended (see NF-1 owner action).
- I deliberately do NOT assert a crash or a hard parse-break. The mod will still LOAD; AI-template
  parse issues degrade AI behavior, they do not block loading.

### SU-2 — Completeness of the 1.15 removed/renamed-token list.
- I could not obtain one verbatim full dump of the 1.15 "Database & Scripting" section (live wiki
  JS-walled to WebFetch; archive.org egress-blocked; WebSearch only summarizes). I cross-checked
  the documented 1.15 changes from ≥3 angles and found no *additional* removed/renamed token that
  the mod uses beyond the items covered (terrain modifier = non-issue C2; airports/rocketsites =
  C3; division-template removals = C4/NF-1). Residual risk: a low-profile removed token used
  somewhere in 2,007 `common/` files that no source enumerated. Best mitigation is the same
  `-debug` error.log pass.

### SU-3 — GUI / state / character / scripted_gui format breaks.
- No 1.15 `.gui` containerwindowtype break, state-file break, character-DB break, or
  scripted_guis restructure surfaced in research, and the relevant mirror pages (Interface, State,
  Scripted GUI modding) carry no 1.15 removal/deprecation markers (grep for `1.15|removed|
  deprecat|no longer` → none in those pages). The mod's 44 `.gui` files were not individually
  audited against the full GUI schema (out of proportion to evidence of risk). Confidence that
  these are fine is MEDIUM, based on absence-of-evidence rather than positive confirmation.

---

## Mirror/source provenance note
The `klimPaskov/Agentic-HOI4-Modding` Modifiers page used for the decisive C2 finding was
committed **2026-05-21** (verified via GitHub API), i.e. a current post-1.15 wiki snapshot — so
"token still documented" is strong evidence the token still exists in-engine today. It is a
mirror, not the engine itself; the only 100%-authoritative check (an enumerated 1.15 in-game
`modifiers_documentation.md` or a `-debug` error.log) was not available in this environment. The
recommended `-debug` pass closes SU-1, SU-2, and the residual C2/OD-1 questions in one step.
