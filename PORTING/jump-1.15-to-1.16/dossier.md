# Jump 2 — 1.15 → 1.16 (Graveyard of Empires) — Breaking-change dossier

Scope: modder-facing **breaking** changes (removed / renamed / format-changed / new-validation) in
HOI4 1.16, filtered to what the CBtS Fan Fork (`/3273913964`) actually uses. Each entry records what
changed, the source, whether the mod uses it (grep evidence file:line), and the action taken.

**Version facts (verified):** 1.16.0 + Graveyard of Empires DLC released **2025-03-04**, base
checksum **722d**. Point releases (wiki Patch_1.16.X): 1.16.1 (03-12, "Operation HEAD", 48b7);
1.16.2 (03-20, "Operation KNEE", 225a); 1.16.3 (03-27, "Operation SHOULDER", a433); 1.16.4 (03-28,
"Manoeuvre CHIRO", 639e); 1.16.5 (04-28, "Operation EAR", b65d); later 1.16.9 (June 2025).
Graveyard of Empires centred on **Afghanistan / British Raj / Iran / Iraq / Kurdistan** — that
content is pure focus-tree/national-spirit/subject data; it introduced **no** modder-facing schema
change, and the mod does not touch those trees.

**Research method:** the live Paradox wiki + forum are JS-walled to WebFetch/curl (and the forum
release-notes thread is also walled to the WebSearch backend on this content), so breaking claims
below were obtained via the `WebSearch` backend (which can read the wiki summary) cross-checked
against the `klimPaskov/Agentic-HOI4-Modding/paradox_wiki/*` GitHub raw-markdown mirror (current
≈1.18/1.19 modding pages, fetchable; used for "does token X still exist now?" positive
confirmation), the `sihmar.com` and `updatecrazy.com` rendered patch-note mirrors, and the bundled
~1.14 docs at `3273913964/pdx_documentation/`. Every breaking claim was cross-checked against ≥2
sources. The 1.16 modder-facing surface is small and was re-queried from ~18 angles; it converged
on the same short list every time.

---

## Net result (read first)
The **only** change required for the mod to load on 1.16 is the `supported_version` bump (#1 —
applied). 1.16 introduced **no removed/renamed/format-changed script token that the mod uses**.
Its modder-facing changes are **additive** (→ MODERNIZATION-REPORT) plus **one new validation
check** (duplicate province building blocks, #6) that is **non-load-bearing** and surfaces three
**pre-existing** mod bugs — logged to UNCERTAINTIES, not auto-edited (faithful-port mandate).
This "almost-no-change" shape matches Jump 1 and is the expected outcome for a country-pack patch
on a mod that does not lean on the systems 1.16 added.

---

## 1. `descriptor.mod` supported_version — ACTION REQUIRED (done)
- **What:** Mod declared `supported_version="1.15.*"`. To load on 1.16 without the launcher's
  "made for an older version" incompatibility flag, it must declare 1.16.
- **Mod uses it?** Yes — `descriptor.mod:37`.
- **Correct value:** `"1.16.*"` — minor-wildcard form; `*` matches any 1.16.x build (1.16.0–1.16.9).
  Same convention the mod already used; matches wiki Mod-structure examples. descriptor must remain
  non-UTF-8-BOM (verified: file is plain ASCII, LF-only, no BOM — edit preserved this).
- **Action:** Edited `descriptor.mod:37` → `supported_version="1.16.*"`. (Only load-bearing change.)
- **Sources:** hoi4.paradoxwikis.com/Mod_structure (wildcard `*` semantics; descriptor must not be
  UTF-8 BOM); hoi4.paradoxwikis.com/Patch_1.16.X (1.16.x version/checksum table).

## 2. National-focus `bypass_effect` — NEW ADDITION, mod unaffected (→ modernization)
- **What:** 1.16 added a `bypass_effect = { ... }` block to national focuses — an **effect** that
  runs when a focus is bypassed (manually or automatically). This is **separate** from the
  long-standing `bypass = { ... }` **trigger** block (which decides *whether* a focus auto-bypasses).
- **Mod uses it?** Mod uses `bypass = { ... }` (trigger) widely in `common/national_focus/` (e.g.
  `2RCW_Mil_Districts.txt:27/50/80`); it does **not** use `bypass_effect` anywhere
  (`grep -rln bypass_effect common/ history/ events/` → none). The two keys are distinct, so adding
  `bypass_effect` to the engine does not collide with or change the mod's `bypass` blocks.
- **Action:** none (pure addition). Noted in MODERNIZATION-REPORT.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.16 (modding section); National-focus-modding mirror
  page (confirms BOTH `bypass` trigger and `bypass_effect` effect are valid, distinct keys; no
  removal/deprecation marker).

## 3. `load_focus_tree` gains `copy_completed_from` — NEW ADDITION, mod unaffected (→ modernization)
- **What:** 1.16 added an optional `copy_completed_from` parameter to the `load_focus_tree` effect
  (copy completed focuses from an existing country).
- **Mod uses it?** Mod uses `load_focus_tree` ~dozens of times with the existing params (`tree`,
  `keep_completed`) and the bare-token form (e.g. `common/scripted_effects/CBTS_SPR_effects.txt:64`
  `load_focus_tree = { tree = spain_cw_tree keep_completed = yes }`;
  `common/national_focus/ENG_colonial.txt:3965` bare form). It does **not** use
  `copy_completed_from` (grep → none). The new param is optional; existing calls are unaffected.
- **Action:** none (pure addition). Noted in MODERNIZATION-REPORT.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.16 (modding section).

## 4. `front_role_override` for division templates — NEW ADDITION (→ modernization). Also the mandated AI-template note.
- **What:** 1.16 added `front_role_override` for division templates, letting you customise which
  *front type* a template is assigned to. This is an **addition** to the front-assignment side of
  the template system; it does **not** change the `common/ai_templates/` role schema that the
  deferred migration concerns.
- **Mod uses it?** No (`grep -rln front_role_override` → none).
- **AI-template-system note (per mandate — for the deferred 1.19 migration):** the **only**
  modder-facing change 1.16 made to the AI-template / division-designer area is this `front_role_override`
  ADDITION. 1.16 did **not** further rework the `ai_templates` role schema (the 1.15 rework —
  singular `role =`, removal of `match_to_count` — remains the relevant target; 1.16 adds nothing
  that the eventual migration must re-target). The mod's 9 pre-1.15-schema `ai_templates` files
  (`match_to_count` ×; confirmed still present, see #5) remain the owner-deferred item (DECISIONS-NEEDED
  D1); **not touched** this jump.
- **Action:** none (pure addition). Noted in MODERNIZATION-REPORT + AI-template note above.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.16 (modding section); hoi4.paradoxwikis.com/AI_modding
  (target templates defined at the "role" level — the existing 1.15+ system, unchanged in 1.16).

## 5. AI-templates legacy schema (`match_to_count` ×) — NO 1.16 CHANGE; remains DEFERRED, untouched
- **What checked:** whether 1.16 added any further `ai_templates` schema change beyond 1.15's.
- **Finding:** none found (see #4). `match_to_count` remains used in exactly the 9 deferred files
  and **nowhere else** (whole-repo grep: `common/ai_templates/{generic,templates_USA,ITA,CHI,JAP,
  SOV,FRA,ENG,GER}.txt`; zero hits in `common/` outside ai_templates, `history/`, `events/`).
- **Action:** **none — do not touch `ai_templates`** (HARD RULE 1; owner decision D1). Re-confirmed
  the file set for the eventual migration; 1.16 does not move the migration target.
- **Sources:** whole-repo grep; jump-1 review.md NF-1 (establishes the deferral); Patch_1.16 (no
  ai_templates schema change).

## 6. NEW VALIDATION: duplicate province building blocks in state history — mod HIT ×3, NON-load-bearing → UNCERTAINTY
- **What:** 1.16 "added a check to detect duplicate province building blocks overriding each other
  in state history files." Pre-1.16 the engine **silently** let a later `<provinceID> = { ... }`
  block override an earlier one for the same province inside `history.buildings`. 1.16 now **reports**
  this (an `error.log` validation message; surfaced in-game under `-debug`). Forum phrasing: "if you
  try to tell the state which buildings go in provinces twice, you'll get an error message instead
  of it silently failing."
- **Load-bearing?** **No.** This is a validation/report change, not a load-blocker: HOI4 logs such
  validation errors to `error.log` and **still loads and runs** the game (Troubleshooting wiki:
  validation errors are logged; game continues). The runtime building outcome is **identical** to
  1.14/1.15 (the same later-block-wins override). 1.16 changed *reporting*, not *behavior*.
- **Mod uses it / is hit?** **Yes — 3 pre-existing duplicates** (found via a brace-aware whole-folder
  scan of all 1250 `history/states/*.txt`; verified by reading each file):
  - `history/states/327-Philippines.txt`: province **10265** defined twice inside `buildings` —
    first `{ bunker = 1 (Fort William McKinley), coastal_bunker = 4 }` (lines 20-23), then
    `{ naval_base = 4 }` (lines 24-26). Later block wins → the **bunker + coastal_bunker are
    silently dropped**; only `naval_base = 4` applies. (Latent content bug, identical on 1.14/1.15.)
  - `history/states/466-Quebec.txt`: province **13384** defined twice — `{ naval_base = 1 }`
    (15-17) then `{ naval_base = 1 }` (21-23). **Identical** values → net result unchanged
    (naval_base = 1); harmless apart from the new warning.
  - `history/states/695-Curacao.txt`: province **153** defined twice — `{ naval_base = 1 }` (13-15)
    then `{ coastal_bunker = 2 }` (16-18). Later block wins → the **naval_base is silently dropped**;
    only `coastal_bunker = 2` applies. (Latent content bug, identical on 1.14/1.15.)
- **Action:** **No edit.** These are **pre-existing** authoring bugs that predate 1.16 (the override
  behavior was identical on 1.14/1.15); 1.16 only surfaces them. Under the faithful-port mandate
  ("fix only what 1.16 broke"), 1.16 broke nothing here — the files loaded with silent-override on
  1.15 and still load with the **same** override result on 1.16. Auto-merging the duplicate blocks
  would **change game state** vs. the 1.14/1.15 baseline the port preserves (Philippines would gain
  a bunker+coastal_bunker; Curaçao would gain a naval_base), so it is an **owner decision**, not a
  silent port edit. Logged to UNCERTAINTIES (U1) with the exact merge each file needs. Analogous to
  jump-1's `locked = yes` disposition, but flagged more strongly because the duplicates cause silent
  building loss the owner probably did not intend.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.16 (the new check); forum/WebSearch corroboration
  ("error message instead of silently failing"); hoi4.paradoxwikis.com/Troubleshooting (validation
  errors logged, game still loads/runs); State-modding mirror page (province sub-block syntax
  `1234 = { ... }`); mod brace-aware scan + file reads.

## 7. Building definitions (`common/buildings/00_buildings.txt`) — NO 1.16 CHANGE (the building rework is 1.17)
- **What checked:** the mod's `common/buildings/00_buildings.txt` (not `replace_path`'d; shares
  vanilla's filename → **overrides** vanilla building defs) uses the flat `max_level = N` /
  `shares_slots = yes` schema for every building. Did 1.16 change the building-definition format?
- **Finding:** **No.** The current (post-1.16) Building-modding wiki shows `max_level` is **still
  valid** and coexists with the newer nested `level_cap = { state_max / province_max / shares_slots }`
  block (the wiki's own example uses `max_level = 2` **and** `level_cap = { state_max = 2 }` in the
  same definition). The State/Province building-limit rework + `level_cap`/`province_max`/`state_max`
  + **Strategic Locations** (Natural Harbor etc.) were introduced in **Patch 1.17**, **not 1.16** —
  confirmed repeatedly. So the mod's flat-`max_level` overrides remain valid on 1.16. (This becomes
  a Jump-3/1.17 concern, not this jump.)
- **Action:** none this jump. Flagged for the 1.17 agent (the mod's overriding building defs predate
  `level_cap`; on 1.17 they still work via `max_level`, but the 1.17 agent should re-verify against
  the 1.17 building rework / state-type limits).
- **Sources:** hoi4.paradoxwikis.com/Building_modding (mirror: `max_level` + `level_cap` coexist;
  fields list); hoi4.paradoxwikis.com/Patch_1.17 (building rework + Strategic Locations are 1.17).

## 8. `map/buildings.txt` (55,172 lines) — NO 1.16 FORMAT CHANGE
- **What checked:** the mod's `map/buildings.txt` uses the standard 7-column format
  `StateID;buildingID;X;Y;Z;rotation;adjacentSea` with standard building IDs (air_base, arms_factory,
  industrial_complex, naval_base, bunker, coastal_bunker, dockyard, anti_air_building,
  synthetic_refinery, fuel_silo, radar_station, rocket_site, nuclear_reactor, supply_node,
  floating_harbor).
- **Finding:** the current Map-modding spec still describes this exact column format; 1.16 did not
  change it. (The 1.15 airports.txt/rocketsites.txt deprecation was handled in Jump 1; not a 1.16
  item.)
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Map_modding (mirror: buildings.txt column spec).

## 9. MIO (`common/military_industrial_organization/*`) — NO 1.16 FORMAT CHANGE
- **What checked:** mod `replace_path`s the three MIO subfolders (`organizations`, `policies`,
  `ai_bonus_weights`). Did 1.16 change MIO file format / required fields / subfolders?
- **Finding:** **No.** 1.16's MIO changes are **bugfixes/UI only** (fixed MIO selection persisting
  across equipment windows; removed an errant "c" in the vanilla "Anti-Vehicle Landmines" trait;
  fixed connection lines for non-existent traits) — none is a modder-facing format change. The
  current MIO-modding wiki mirror confirms the three subfolders are still the correct structure and
  lists no removed/renamed MIO field.
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.16.X (MIO bugfixes); MIO-modding mirror page (folder
  structure current; no removal markers).

## 10. Characters, scripted_gui, on_actions, decisions, operations/operatives, scripted_diplomatic_actions, GUI — NO 1.16 CHANGE
- **What checked:** the subsystems the mod leans on most (characters 138, decisions 160,
  on_actions 64, scripted_effects 62, scripted_triggers 23, scripted_guis 20, operations 6 +
  operation_phases 16 + operation_tokens 2, intelligence_agencies 1, scripted_diplomatic_actions).
- **Finding:** no 1.16 character-DB format break, scripted_gui containerwindow break, on_action
  schema break, decision-format break, or operatives/operations restructure surfaced across ~18
  query angles. 1.16's operatives/intel-facing items are vanilla content/CTD fixes (prepared-raids
  CTD; operative-mission-name OOS) — not format changes. Positive spot-check: `all_enemy_country`
  (the mod's single non-comment use at `common/operations/00_operations.txt:304`) is a structural
  `all_<scope>` trigger present in the 1.14 bundled docs and still valid; not a 1.16 change.
  Defensive whole-repo grep for tokens removed in *other* versions found only commented-out
  (inert) occurrences of `state_strategic_value` (`common/on_actions/07_nsb_on_actions.txt`,
  3 `#` lines) and `supply_node_range` (`common/country_leader/00_traits.txt:2174`, 1 `#` line) —
  not parsed, no effect.
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.16 + Patch_1.16.X; Character-modding / Scripted-GUI /
  On-actions / Decision-modding mirror pages (no 1.16 removal markers); bundled
  `pdx_documentation/triggers_documentation.md` (all_enemy_country present); whole-repo grep.

## 11. `replace_path` targets — NONE restructured by 1.16
- **What checked:** all 25 `replace_path` directives point at vanilla folders that 1.16 must still
  ship under the same names, or the wholesale replace silently breaks.
- **Finding:** every target is a long-standing canonical folder (common/{ideas, on_actions,
  decisions, scripted_effects, scripted_triggers, scripted_localisation, national_focus, characters,
  countries, country_tags, ai_strategy, ai_strategy_plans, ai_focuses, ai_equipment,
  units/names_divisions, units/codenames_operatives, military_industrial_organization/{organizations,
  policies,ai_bonus_weights}}, map/strategicregions, history/{general,countries,units,states},
  events, gfx/{loadingscreens, interface/ideologies}). 1.16 (a country pack) restructured none of
  these; the building/strategic-location folder/format changes are 1.17. MIO subfolders confirmed
  current (#9).
- **Action:** none.
- **Sources:** descriptor.mod; MIO-modding / Map-modding mirror pages; Patch_1.16 / Patch_1.17
  (folder changes are 1.17, not 1.16).

---

### Sources (consolidated)
- hoi4.paradoxwikis.com/Patch_1.16 ; /Patch_1.16.X ; /Patch_1.17 (scoping the building rework out)
- hoi4.paradoxwikis.com/Graveyard_of_Empires (content scope)
- hoi4.paradoxwikis.com/Mod_structure ; /Map_modding ; /Building_modding ; /AI_modding ;
  /Military_industrial_organization_modding ; /Troubleshooting ; /Conditions
- GitHub mirror klimPaskov/Agentic-HOI4-Modding/paradox_wiki/{National focus modding, Military
  industrial organization modding, State modding, Map modding, Building modding}.md
- sihmar.com (1.16.1 notes) ; updatecrazy.com (1.16.5 notes) — rendered patch-note mirrors
- Bundled `3273913964/pdx_documentation/` (~1.14 effects/triggers/modifiers reference)
- Mod grep + brace-aware state-file scan (evidence cited inline)
