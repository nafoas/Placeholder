# Jump 1 — 1.14 → 1.15 (Götterdämmerung) — Breaking-change dossier

Scope: modder-facing **breaking** changes (removed / renamed / format-changed) in HOI4 1.15,
filtered to what the CBtS Fan Fork (`/3273913964`) actually uses. Each entry records what
changed, the source, whether the mod uses it (with grep evidence), and the action taken.

Research method note: the live Paradox wiki + forum are JS-walled to WebFetch/curl and
web.archive.org is egress-blocked, so claims below were obtained via the `WebSearch` backend
(which can read the wiki) and via the GitHub mirror of the wiki
`klimPaskov/Agentic-HOI4-Modding/paradox_wiki/*` (current ≈1.18/1.19 modding pages, fetchable as
raw markdown). Every breaking claim was cross-checked against ≥2 sources.

Verbatim 1.15 patch-note lines obtained (Patch 1.15 wiki page, via WebSearch):
- "Removed a bunch of properties from division templates that either didn't make sense or were simply not useful."
- "Replaced Terrain Penalty Reduction modifier which was not working in National Spirits by the modifier Terrain Traits XP Gain."
- "/Hearts of Iron IV/map/airports.txt and /Hearts of Iron IV/map/rocketsites.txt were deprecated and removed in the patch 1.15." (Map modding page)

---

## 1. `descriptor.mod` supported_version  — ACTION REQUIRED (done)
- **What:** Mod declared `supported_version="1.14.*"`. To load without the launcher
  incompatibility flag on 1.15, it must declare 1.15.
- **Mod uses it?** Yes — `descriptor.mod:37`.
- **Correct value:** `"1.15.*"` (minor-wildcard convention, matches the form the mod already
  used and the wiki Mod-structure docs e.g. `supported_version="1.11.*"`).
- **Action:** Edited `descriptor.mod` → `supported_version="1.15.*"`. (Only load-bearing change in this jump.)
- **Sources:** hoi4.paradoxwikis.com/Mod_structure ; hoi4-modding.fandom.com/wiki/.mod_file ;
  hoi4.paradoxwikis.com/Modding (wildcard `*` semantics).

## 2. Division-template removed properties — NO ACTION (mod unaffected)
- **What:** 1.15 removed several `division_template` properties. The only one named in any
  source is `match_to_count` (AI templates now get their AI role assigned on creation from the
  target template, instead of dynamic matching via `match_to_count`).
- **Mod uses it?** **No.** Grep of all `history/units/*.txt` division_template blocks:
  top-level scalar properties in use are `name`, `is_locked`, `priority`, `template_counter`,
  `division_names_group` (+ standard `regiments`/`support` sub-blocks). `match_to_count` is
  ABSENT across the whole repo (`grep -rln match_to_count` → none outside pdx_documentation).
- **Still-valid confirmation:** current Division-modding wiki (GitHub mirror) explicitly lists
  `name`, `regiments`, `support`, `division_names_group`, `is_locked`, `force_allow_recruiting`,
  `division_cap`, `priority`, `template_counter`, `override_model` as valid — i.e. everything the
  mod uses is still valid; no deprecation notes on them.
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.15 ; hoi4.paradoxwikis.com/Division_modding
  (mirror: Division modding - Hearts of Iron 4 Wiki.md).
- **Side note (out of scope, NOT a 1.15 issue):** 4 templates use `locked = yes`
  (`WGR_stahlhelm.txt:11`, `WGR_reichsbanner.txt:12`, `ARM_2RCW_Militia.txt:10`,
  `BRY_2rcw_start.txt:12`). The valid property is `is_locked`; bare `locked` is a long-standing
  mod typo that was already silently ignored on 1.14. Per the faithful-port mandate (fix only
  what 1.15 broke) this is left untouched; logged in UNCERTAINTIES for the owner.

## 3. `all_enemy_country` trigger fix — NO ACTION (mod unaffected)
- **What:** 1.15 fixed `all_enemy_country` to evaluate ALL countries (previously behaved like "any").
- **Mod uses it?** **No.** Only occurrences are in `pdx_documentation/` (the bundled API docs),
  never in mod script. (`grep -rn all_enemy_country` → docs only.)
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.15 .

## 4. Terrain Penalty Reduction modifier replaced — NO BEHAVIOR-PRESERVING FIX EXISTS → UNCERTAINTY
- **What:** 1.15 "Replaced Terrain Penalty Reduction modifier which was not working in National
  Spirits by the modifier Terrain Traits XP Gain." Old `terrain_penalty_reduction` reduced terrain
  combat penalties; new `terrain_traits_xp_gain` increases XP gain toward terrain-specialist
  commander traits (Winter Specialist, Desert Fox, etc.) — a **different effect**.
- **Mod uses it?** **Yes**, 5 usages of `terrain_penalty_reduction`:
  - `common/unit_leader/00_traits.txt:1162` (a custom commander trait modifier = 0.5)
  - `common/ideas/japan.txt:940` (= 0.1, national-spirit modifier block)
  - `common/ideas/ethiopia.txt:277` (= 0.3)
  - `common/ideas/PAR_ideas.txt:16` and `:35` (= 0.04 / 0.06)
  - plus loc string `MODIFIER_TERRAIN_PENALTY_REDUCTION` in `localisation/modifiers_l_english.yml:765`.
- **Load-bearing?** **No.** An unknown modifier key inside an `idea`/commander-trait `modifier`
  block is non-fatal in HOI4 (logs a warning in error.log under `-debug`; does not block loading
  or crash). The trait usage is on a unit-leader, where the modifier was valid pre-1.15.
- **Unresolved fact:** Whether the *token* `terrain_penalty_reduction` was actually deleted from
  the modifier registry, or merely had its National-Spirit scope behavior swapped while a NEW
  sibling modifier was added, could not be confirmed verbatim — the enumerated
  `List_of_modifiers` page is unreachable (WebFetch 504/403; not in the GitHub mirror), and the
  WebSearch summarizer only *infers* removal, it does not quote it.
- **Action:** **No edit.** Renaming to `terrain_traits_xp_gain` would change behavior (XP gain ≠
  penalty reduction) and violate the faithful-port mandate; deleting the lines would also change
  behavior. Worst case if the token is gone: those lines emit a harmless warning and that single
  modifier stops applying — and per Paradox it already didn't work in National Spirits anyway.
  Logged to UNCERTAINTIES with recommendation that the audit agent confirm against a 1.15+
  `List_of_modifiers` and/or an `-debug` error.log.
- **Sources:** hoi4.paradoxwikis.com/Patch_1.15 ; hoi4.paradoxwikis.com/Terrain ;
  hoi4.paradoxwikis.com/Modifiers .

## 5. map/airports.txt & map/rocketsites.txt removed — NO LOAD FIX REQUIRED → note + UNCERTAINTY
- **What:** Both files were "deprecated and removed in the patch 1.15". Air-base / rocket-site
  model placement is now consolidated into the single `map/buildings.txt` (the `air_base` /
  `rocket_site` building entries).
- **Mod uses it?** **Yes** — the mod ships custom `map/airports.txt` (16 KB) and
  `map/rocketsites.txt` (16 KB). It does **not** `replace_path="map"` (only `map/strategicregions`),
  so these are overlay files, and `map/default.map` never referenced them (their filenames were
  hardcoded). The mod's `map/buildings.txt` (2.5 MB) **already contains** `air_base` and
  `rocket_site` position lines (grep: 6,170 building-position lines incl. both types).
- **Load-bearing?** **No.** Post-1.15 the engine simply stops reading airports.txt/rocketsites.txt;
  extra/unknown map files do not produce a load error. Building/air-base/rocket placement is driven
  by `buildings.txt`, which the mod already provides.
- **Action:** **No edit.** The two files are now inert. Deleting them is a content change beyond
  "make it load" and is not required; left in place to preserve bytes. Behavior caveat (air-base /
  rocket-site *province assignment* that the legacy files used to express) logged to UNCERTAINTIES
  so the owner can verify in-game that placements are unchanged.
- **Sources:** hoi4.paradoxwikis.com/Map_modding (mirror: Map modding - Hearts of Iron 4 Wiki.md,
  verbatim deprecation line) ; hoi4.paradoxwikis.com/Patch_1.15 .

## 6. Defines — NO ACTION (mod overrides only stable tokens)
- **What checked:** mod overrides defines in `common/defines/cbts_defines.lua`.
- **Finding:** every overridden token is a long-standing, still-valid define (NGame, NCountry,
  NTrade, NDiplomacy, NPolitics, NBuildings, NTechnology, NOperatives, NMilitary, NAI, NGraphics,
  plus the `Nlua.NTopbar` table). None matches any 1.15 removed/renamed define found in research.
  1.15's define-facing changes are additions (e.g. `MIN_SHIPS_FOR_HIGHER_SHIP_RATIO_PENALTY`).
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Defines (mirror) ; cbts_defines.lua read in full.

## 7. MIO folder structure — NO ACTION
- **What checked:** mod `replace_path`s `common/military_industrial_organization/{organizations,
  policies,ai_bonus_weights}`.
- **Finding:** current MIO-modding wiki confirms those three are still the correct subfolders; no
  1.15 MIO file-format/required-field change found.
- **Action:** none.
- **Sources:** hoi4.paradoxwikis.com/Military_industrial_organization_modding (mirror).

## 8. Interface / GUI, State files, characters, codenames_operatives — NO ACTION
- No 1.15 `.gui` containerwindowtype format break, state-file format break, character-DB format
  break, or `common/units/codenames_operatives` restructure was found in research. The mod's
  replace_path targets for these still match current vanilla folder layout.
- **Sources:** Interface modding / State modding / Map modding wiki pages (GitHub mirror); Patch
  1.15 page.

---

### Net result
The only change required for 1.15 loading is the `supported_version` bump (#1). Items #4 and #5
are real 1.15 changes the mod is *touched* by, but neither blocks loading nor crashes, and neither
has a behavior-preserving automatic fix — both are logged to UNCERTAINTIES for in-game verification.
All other 1.15 modder-facing changes are additions (→ MODERNIZATION-REPORT.md), not applied.
This "almost-no-change" outcome is the expected shape of an early jump for a mod that does not lean
on the systems 1.15 reworked.
