# Jump 3 — 1.16 → 1.17 (No Compromise, No Surrender) — Breaking-change dossier

Scope: modder-facing **breaking** changes (removed / renamed / format-changed / new-required-validation) in
HOI4 1.17, filtered to what the CBtS Fan Fork (`/3273913964`) actually uses. Each entry: what changed,
source(s), whether the mod uses it (grep evidence file:line), required action.

**Version facts (verified):** 1.17.0 + No Compromise, No Surrender (NCNS) DLC released **2025-11-20**.
Point releases on wiki Patch_1.17.X run through **1.17.5 (2026-03-17)** (1.17.1, 1.17.2 12-04, 1.17.3,
1.17.4 02-19, 1.17.5 03-17). NCNS was a **full expansion** (Philippines focus tree + a game-wide
**doctrine system rework** + naval/carrier rework + building-limit rework), so the modder-facing surface
is **materially larger than 1.15/1.16** (both of which needed only the descriptor bump).

**Research method:** live Paradox wiki + forum are JS-walled to WebFetch/curl, so breaking claims were
obtained via the **WebSearch backend** (which reads wiki/forum bodies and quotes them), cross-checked
≥2 ways against: the **GitHub raw-markdown mirror** `klimPaskov/Agentic-HOI4-Modding/paradox_wiki/*`
(current ≈1.18/1.19 pages — Building/State/Technology/MIO/Map modding fetchable; no per-patch pages),
**GitHub code search** over large version-current mods (Kaiserreich, Millennium Dawn, Equestria at War,
1956, Sons of Mobius, Project IRIS, Road to 56, Chaos-Redux, …) for token-survival / new-schema shape,
the `updatecrazy` 1.17.2/1.17.4 rendered mirrors, and the bundled ~1.14 `pdx_documentation/`.

---

## NET RESULT (read first)

Two 1.17 systems genuinely touch this mod; everything else 1.17 changed is additive and unused.

1. **BLOCKER — the 1.17 doctrine rework (item #1).** 1.17 "replaced existing doctrine trees for Army,
   Navy and Air with a new doctrines system" (Grand Doctrines + Subdoctrines + Mastery). The mod ships
   **old-format** land + special-forces doctrine trees (`common/technologies/land_doctrine.txt`,
   `special_forces_doctrine.txt`) that **override** vanilla, declares old-style doctrine folders in its
   own `common/technology_tags/00_technology.txt`, references old doctrine techs via `has_tech = …` in
   **43 places / 6 files**, and uses **vanilla's new** doctrine GUI (it ships no
   `countrydoctrinetreeview.gui`). Modder consensus + a patched-CTD note indicate old custom doctrines +
   the new doctrine tree view **crash**. The correct remedy is a **large interpretive rework** (migrate
   doctrines to the new Grand/Sub/Mastery schema, or delete the overrides to inherit vanilla's, or defer
   like `ai_templates`). Per the mandate this is **load-bearing + cannot be guessed** → escalated as a
   **BLOCKER / owner decision** (see #1 and UNCERTAINTIES U1 / DECISIONS-NEEDED). **No code guessed.**

2. **`descriptor.mod` bump (item #2) — APPLIED.** `supported_version` 1.16.* → 1.17.*. The only mod-file
   edit this jump.

The `cl_tech` removal (#3), the building-limit rework / `max_level` question (#4), the Medium-Battery
tech-line removal (#5), MIO/character/decision/on_action/scripted_gui/state/map (#7) are all **NOT
load-bearing for this mod**: the mod ships **self-contained same-filename overrides** of its tech
categories, naval tree, ship modules and building defs, so vanilla's content migrations do not reach it,
and `max_level` still parses on 1.17 (coexists with `level_cap`). All additive 1.17 tokens are unused
(collision check clean). Full detail below.

---

## 1. DOCTRINE SYSTEM REWORK — **BLOCKER (load-bearing; owner decision; NOT auto-fixed)**

- **What 1.17 changed:** "Replaced existing doctrine trees for Army, Navy and Air with a **new doctrines
  system**." Land/Naval/Air doctrines are now split into **Grand Doctrines** and **Subdoctrines** across
  tracks (land: Infantry / Artillery & Combat Support / Armor / Operations; naval: Submarines / Screens /
  Capital Ships / Carriers), with a **Mastery** practical-XP system, **milestones**, and a **new doctrine
  tree GUI**. Doctrines are *no longer researched as technologies* but "are **still considered
  technologies in the in-game code, although there are some differences in their required definitions**."
  Vanilla's old `common/technologies/land_doctrine.txt` "**no longer exists in its original form**" —
  doctrines were reorganized within `common/technologies` + `common/technology_tags` into the new schema,
  and the new GUI (`interface/countrydoctrinetreeview.gui`) "is **very interconnected** with the doctrine
  definitions." New script surface introduced: triggers `has_doctrine`, `has_mastery_level = { amount = N
  sub_doctrine = X }`, `has_completed_track`, `has_any_grand_doctrine` (1.17.5); effects
  `set_grand_doctrine`, `set_sub_doctrine`, `add_mastery`, `add_mastery_bonus`; grand-doctrine props
  `max_track_columns` / `max_track_rows`; an "active trigger for doctrine tracks." 1.17.X patched
  doctrine CTDs (e.g. "crashes in the `has_mastery_level` trigger if a bad sub doctrine was provided").
- **Does the mod use it? YES — heavily, in the OLD schema:**
  - Ships old-format doctrine **technology trees** (override vanilla via same filename):
    `common/technologies/land_doctrine.txt` (57 KB; `mobile_warfare`, `delay`, `superior_firepower`,
    `trench_warfare`, `mass_assault`, … each with `doctrine = yes`, `doctrine_name`, `enable_tactic`,
    `xp_research_type`), and `common/technologies/special_forces_doctrine.txt` (`special_forces_mountaineers`,
    …). (`grep 'doctrine = yes' common/technologies` → exactly these two files.)
  - Declares **old-style doctrine folders** in its own
    `common/technology_tags/00_technology.txt:230-248` (`land_doctrine_folder`, `naval_doctrine_folder`,
    `air_doctrine_folder`, `special_forces_doctrine_folder` — each `doctrine = yes`, **no** grand-doctrine
    / track / subdoctrine structure). This file is a same-filename **full override** of vanilla's
    folder/category list.
  - References old doctrine **technologies by name** in **43 places across 6 files** via `has_tech = …`:
    `common/ideas/army_spirits.txt` (12), `navy_spirits.txt` (9), `air_spirits.txt` (6),
    `common/ai_strategy/doctrines.txt` (12), `common/scripted_triggers/00_scripted_triggers.txt` (1),
    `common/national_focus/GER_Hitler_Military.txt` (3) — e.g. `has_tech = mobile_warfare`,
    `has_tech = superior_firepower`, `has_tech = base_strike`, `has_tech = air_superiority`. (These resolve
    to techs the mod itself defines, so they are internally consistent **as data**.)
  - Air & naval **doctrines are NOT overridden** by the mod (its `air_techs.txt`/`naval.txt`/`MTG_naval.txt`
    are equipment trees, not doctrine trees — `grep` for air/naval doctrine tech defs → none) → the mod
    **inherits vanilla 1.17's NEW air/naval doctrines**, while overriding land + SF with the **old**
    schema, and uses vanilla's **new** doctrine GUI. This is precisely the "old custom doctrines + new
    doctrine tree view" configuration modders report **crashes** with.
  - Uses **none** of the new doctrine tokens (`set_sub_doctrine`, `set_grand_doctrine`, `has_mastery_level`,
    `add_mastery`, `has_doctrine`, `has_completed_track`, `has_any_grand_doctrine`, `max_track_columns/rows`
    → 0 hits whole-repo). No forward references; also no adoption of the new system.
- **Load-bearing?** **YES — assessed load-bearing / crash-class.** The data is internally consistent, but
  the runtime interaction of an **old-format land/SF doctrine folder** with **vanilla 1.17's new doctrine
  engine + GUI** is what the community reports crashing ("several modders reporting … crashes when old
  custom doctrines are not properly updated to work with the new doctrine tree view system"; "moving
  entire doctrine trees to a new folder … can cause compatibility issues with older mods"; 1.17.X fixing
  doctrine CTDs). I could **not** obtain a single authoritative statement nailing the exact failure mode
  (load-error vs. silent-degrade vs. CTD-only-when-the-doctrine-tab-is-opened), and that distinction is
  the difference between "ship it degraded" and "hard crash." Under the mandate, an unresolved
  **load-bearing** unknown whose only correct fix is a **large interpretive rework I must not guess at**
  is a **BLOCKER to escalate**, not something to patch speculatively.
- **Required action:** **ESCALATE to the human/owner — do NOT auto-edit.** Three options, none a faithful
  one-liner (mirrors the deferred `ai_templates` decision, HARD RULE 1):
  - **(A) Migrate** land + SF doctrines to the new Grand-Doctrine/Subdoctrine/Mastery schema, adapt/ship
    the doctrine GUI, and convert the 43 `has_tech = <doctrine>` references to `has_doctrine` /
    `has_mastery_level`. Faithful to intent but a major interpretive rework (the mod also re-tunes org/XP).
  - **(B) Delete** the mod's `land_doctrine.txt` + `special_forces_doctrine.txt` overrides (and the
    doctrine-folder overrides in `00_technology.txt`) → inherit vanilla 1.17 doctrines; then the 43
    `has_tech` refs to old doctrine techs must still be reworked to the new triggers, or they silently fail.
  - **(C) Defer** (like `ai_templates`) to the 1.19 endgame, accepting the doctrine subsystem is broken
    until then — only acceptable if the owner confirms via `-debug` it does **not** hard-crash on load /
    on opening the doctrine tab.
  The single highest-leverage disambiguation is the owner's end-of-port **`-debug` run**: load the mod on
  1.17, open the Army/Navy/Air doctrine tabs, and grep `error.log` — that converts "assessed crash-class"
  into engine-confirmed fact and picks A/B/C.
- **Sources:** wiki Patch_1.17 + Patch_1.17.X (doctrine rework; doctrine CTD fixes); wiki Doctrine modding
  / Land doctrine / Naval doctrine / Air doctrine / Special forces doctrine (new schema: `doctrine = yes`
  on folder, grand doctrines, subdoctrine tracks, mastery, `countrydoctrinetreeview.gui` coupling; "old
  `land_doctrine.txt` no longer exists in its original form"; "still technologies in code with differences
  in required definitions"); WebSearch surfacing Steam/forum modder reports of doctrine-tree-view crashes
  with un-updated doctrines and "doctrines moved to a new folder"; GitHub code search showing the real new
  schema in 1.17+ mods (Kaiserreich `set_sub_doctrine`/`has_doctrine`; Project IRIS `sub_doctrine =
  marines_1 # has_tech = … old equivalent`; East-Showdown/NAD/Road-to-56 `set_sub_doctrine` + `add_mastery`;
  EoaNB focus filter `grand_doctrine/sub_doctrine/track`); whole-repo greps (evidence cited inline).

## 2. `descriptor.mod` supported_version — **ACTION REQUIRED (DONE)**

- **What:** mod declared `supported_version="1.16.*"`. To load on 1.17 without the launcher's "made for an
  older version" flag it must declare 1.17.
- **Mod uses it?** Yes — `descriptor.mod:37`.
- **Correct value:** `"1.17.*"` — minor-wildcard form; `*` matches any 1.17.x build (1.17.0–1.17.5+). Same
  convention the mod already used; the wiki confirms either `"1.17.*"` (preferred, survives hotfixes) or a
  full `"1.17.x.0"` is valid, and that `descriptor.mod` must **not** be UTF-8 BOM (verified: file is plain
  ASCII / LF-only / no BOM — edit preserved this).
- **Action:** edited `descriptor.mod:37` → `supported_version="1.17.*"`. (Only load-bearing change applied.)
- **Sources:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM); Patch_1.17.X (1.17.x table).

## 3. `cl_tech` removed → migrated to `ca_tech` ("Cruiser Technology") — mod **self-contained**, NO EDIT

- **What 1.17 changed:** "**Removed `cl_tech` from the game. All uses have been migrated to `ca_tech`, and
  `ca_tech` has been renamed to Cruiser Technology.**" This is a **vanilla content/data migration**:
  Paradox merged vanilla's light-cruiser tech category into the cruiser category and re-localised vanilla's
  `ca_tech`. Technology categories are **fully mod-definable data** (declared in
  `common/technology_tags/*.txt` `technology_categories = { … }` with "no other info assigned," used via
  `categories = { }`, `research_bonus`/`*_research` loc, `add_tech_bonus`, AI focuses, tech-sharing); they
  are **not** a fixed engine enum (the mod itself declares dozens of bespoke categories).
- **Does the mod use it? YES, but on its OWN terms (does NOT depend on vanilla's `cl_tech`):**
  - **Declares** `cl_tech` AND `ca_tech` itself in `common/technology_tags/00_technology.txt:45-46` — a
    same-filename **full override** of vanilla's category list (override = complete file replacement, per
    Mod_structure), so the mod's list is authoritative.
  - **Defines** the light-cruiser techs with `categories = { naval_equipment cl_tech }` in its own
    `common/technologies/naval.txt` (`early_light_cruiser`/`basic_light_cruiser`/… L180-309) and
    `common/technologies/MTG_naval.txt` (cruiser hulls with `categories = { naval_equipment cl_tech ca_tech }`
    L508-554) — both same-filename overrides of vanilla's naval tree.
  - **Provides its own loc:** `localisation/research_l_english.yml:516 cl_tech:1 "Light Cruiser models"`;
    `localisation/modifiers_l_english.yml:158 cl_tech_research:0 "…Light Cruiser Research Speed"`.
  - **References** `cl_tech` consistently in research-weight/bonus contexts: `common/ai_focuses/*` (11
    files, `cl_tech = 8.0/5.0/3.0`), `common/ideas/{germany,italy_ministers}.txt` (`cl_tech = 0.05/0.1`),
    `events/{CBts_GER,CBtS_USSR}.txt` (`category = cl_tech`), `common/national_focus/*` (research bonuses
    `category = cl_tech`). All resolve to the mod's own declared category.
- **Load-bearing?** **No.** Because the mod overrides vanilla's category list, naval tree, and loc with its
  own self-consistent set, vanilla's removal of *vanilla's* `cl_tech` does not reach it: `cl_tech` exists
  because the **mod** declares it, and every reference is internal. Confirmed by GitHub: many version-current
  (1.17+) mods still declare and use a `cl_tech` category freely (Sons of Mobius, HeartsOfRemnant,
  Breaking-Point, 1956, The Great War, Pax Britannica Redux …), several keeping **both** `cl_tech` and
  `ca_tech`. A naive "rename `cl_tech`→`ca_tech`" edit would be **wrong** here (it would break the mod's
  internal consistency and merge two categories the mod keeps distinct).
- **Residual (non-load-bearing):** only if the engine *hardcodes* a `cl_tech`-specific binding the mod
  cannot override (e.g. ship-designer UI). No evidence of that (categories are data; other 1.17 mods use
  `cl_tech` without issue). Carry to the `-debug` close-out. → UNCERTAINTIES U2.
- **Action:** **none.** → also noted in changes.md "considered & not changed."
- **Sources:** Patch_1.17 / Patch_1.17.X (the `cl_tech`→`ca_tech` line); wiki Technology modding (categories
  are mod-defined data; loc convention `cat:` + `cat_research:`); Mod_structure (same filename = full
  replacement); GitHub code search `cl_tech path:common/technology_tags` (dozens of 1.17-era mods); mod
  greps + file reads.

## 4. BUILDING-LIMIT REWORK (`level_cap` / `state_max` / `province_max` / Strategic Locations) — flat `max_level` STILL LOADS, NO EDIT

- **What 1.17 changed:** "Reworked and added limits for State and Province type buildings, depending on the
  state type. Added **Strategic Locations** — provinces that can have increased building limits, e.g.
  **Natural Harbor** (+2 naval-base limit in a province)." Building defs now express caps via a nested
  `level_cap = { state_max = N  province_max = N  shares_slots = yes  group_by  exclusive_with }` block
  (`state_max` defaults to 15 if `shares_slots = yes` and unspecified). The per-state-type limits key off
  the state's existing **`state_category`** (a long-standing mandatory state field — **no new required
  state field** was introduced; State modding lists `id/name/manpower/state_category/provinces` as the
  pre-existing mandatory set).
- **Crucial compatibility fact (verified ≥3 ways):** the **flat `max_level = N` schema still parses on
  1.17 and coexists with `level_cap`.** The current (post-1.17) wiki Building modding page lists, verbatim,
  that a building's max level can be set with `level_cap = { … }` *"or use `max_level` for a specific
  numeric cap,"* and its own field examples still include `max_level = 2` alongside `level_cap` blocks.
  GitHub corroborates: HOI4 mods on current patches ship building defs using flat `max_level` (Anterra2,
  RSR, schizoreich, Hearts-of-Rokh, Magna-Europa, 1956 `r56e_buildings`), while others use `level_cap`
  (Millennium Dawn, Equestria at War, Sons of Mobius, Chaos-Redux, Project IRIS) — both schemas valid
  concurrently; some files mix them per-building.
- **Does the mod use it?** The mod ships `common/buildings/00_buildings.txt` — **not** `replace_path`'d,
  **same filename as vanilla → full override of ALL vanilla building defs** — using **only** flat
  `max_level = N` / `shares_slots = yes` (17 building entries; verified by read). It uses **zero** of the
  new schema: `grep -E 'level_cap|province_max|state_max|strategic_location|natural_harbor'` whole-repo →
  **no files**. No `history/states/*` or `map/buildings.txt` reference to strategic locations.
- **Load-bearing?** **No.** `max_level` is still a valid building-def key on 1.17 (coexists with
  `level_cap`), so the mod's overriding building defs continue to load and impose the same flat caps as on
  1.14–1.16. The new per-state-type / per-island limits and Strategic-Location bonuses simply **do not
  apply** to the mod's buildings (its override replaces vanilla's `level_cap`-based defs) — that is a
  *behavioral non-adoption*, not a load break, and is a **modernization** choice, not a port fix.
  Sub-checks: (a) no building-def field became **required** in 1.17 such that a flat def errors (the wiki
  field list is additive; `max_level`/`base_cost`/`icon_frame`/etc. all still valid; no "X is now
  mandatory" line found); (b) no new map/state data is *required* (Strategic Locations are an opt-in
  province property; per-state-type limits use the existing `state_category`); (c) `history/states`
  building-block parsing is unchanged (the only recent building-block validation change was 1.16's
  duplicate-province check — see Jump-2 U1/D4; 1.17 added nothing here).
- **Action:** **none** (faithful port). Adoption of `level_cap`/`state_max`/`province_max`/Strategic
  Locations recorded as a **modernization** item (NOT applied). → MODERNIZATION-REPORT; UNCERTAINTIES U3.
- **Sources:** Patch_1.17 + NCNS page (building rework + Natural Harbor); wiki Building modding mirror +
  body (`max_level` listed as still-valid alternative to `level_cap`; `state_max` default 15; field list);
  wiki State modding mirror (mandatory state fields incl. existing `state_category`; no new required
  field); GitHub code search (`max_level` and `level_cap` both in current building files; mixed usage); mod
  file read + whole-repo grep.

## 5. Naval rework: "Medium Battery tech line removed" + carrier/fleet/invasion changes — mod **self-contained**, NO EDIT

- **What 1.17 changed (modder-facing):** "Removed the **Medium Battery tech line** (all medium battery
  modules moved into the light and heavy battery lines)" — a **vanilla technology-category** removal
  (`cat_ship_medium_battery`-style), part of the naval/cruiser tech cleanup. Plus carrier stances /
  carrier interception of land-based naval strikes, Fleet Home Base reintroduction, naval-invasion caps
  now per-plan, shore-bombardment crits, coastal-defense minelaying — these are **gameplay/AI** changes,
  not script-format changes.
- **Does the mod use it?** The mod ships its **own** cruiser hull and ship-module files (same-filename full
  overrides, not `replace_path`'d): `common/units/equipment/ship_hull_cruiser.txt` and
  `common/units/equipment/modules/00_ship_modules.txt`. `00_ship_modules.txt` **defines its own**
  `ship_medium_battery_1/2` modules (`category = ship_medium_battery`, `module_category`,
  `forbid_module_categories`), and the hull's `allowed_module_categories` reference the mod's own
  `ship_medium_battery` / `ship_light_medium_battery` categories. (Ship-module categories, like tech
  categories, are mod-defined data on each module.)
- **Load-bearing?** **No.** The vanilla *tech-line* removal does not remove the mod's *module-category*
  definitions; the mod's hulls reference modules the mod itself defines, so the cruiser designer remains
  internally consistent. (Same self-contained-override logic as #3.) Equipment archetypes/variants in
  `history/units` reference the mod's own equipment; no vanilla medium-battery tech dependency.
- **Action:** **none.** (Carrier/fleet/invasion gameplay changes are additive content — no edit; not even a
  modernization-script item, just balance.)
- **Sources:** Patch_1.17 (Medium Battery tech line removed; carrier/fleet/invasion reworks);
  Mod_structure (same-filename = full override); mod file reads (`ship_hull_cruiser.txt`,
  `00_ship_modules.txt`) + grep.

## 6. AI division-template / division-designer schema — NO 1.17 CHANGE; `ai_templates` stays DEFERRED, untouched

- **What checked (per mandate):** whether 1.17 made any further AI-template/division-designer schema change
  beyond 1.15's `role`/`match_to_count` rework (which would move the deferred-migration target).
- **Finding:** **none.** The 1.17 army-side rework is the **doctrine** system (#1), not the
  division-designer or `ai_templates` role schema. No 1.17 patch line or AI-modding-page change touches
  `ai_templates` role assignment, `match_to_count`, `target_width`, etc. The deferred 1.15-schema target is
  unchanged by 1.17. (The mod's 9 legacy `ai_templates` files still use `match_to_count`/plural `roles` —
  confirmed still the relevant target; untouched per HARD RULE 1 / DECISIONS-NEEDED D1.)
- **Action:** **none — do not touch `ai_templates`.** Re-confirmed the migration target is unchanged by 1.17.
- **Sources:** Patch_1.17 / Patch_1.17.X (army change is doctrines, not division designer); wiki AI modding
  (role schema unchanged); whole-repo grep (match_to_count still only in the 9 deferred files).

## 7. Characters / MIO / decisions / on_actions / scripted_gui / states / focus / map / GUI — NO 1.17 FORMAT BREAK

- **MIO** (`common/military_industrial_organization/{organizations,policies,ai_bonus_weights}` —
  `replace_path`'d): 1.17 MIO changes are **bugfix/balance only** (Naval Aircraft MIO now applies Naval
  Attack/Targeting/Sub-&-Surface-Detection correctly; generic infantry-tank/assault-gun MIO bonuses
  reduced). No format/required-field/subfolder change (MIO-modding mirror structure current). No edit.
- **Characters / decisions / on_actions / scripted_gui / states (history) / focus / map** (the subsystems
  the mod leans on most): no 1.17 character-DB / decision / on_action / scripted-GUI containerWindow /
  state-history / focus / map-format **break** surfaced across the query angles run. 1.17's modder-facing
  changes outside doctrines/buildings/naval are **additive** (see below). `map/buildings.txt` 7-column
  format unchanged; `history/states` building-block parsing unchanged (1.16's duplicate-province check is
  the most recent and is non-load-bearing — Jump-2 D4). No edit.
- **`replace_path` targets (25):** all remain canonical folders 1.17 still ships under the same names
  (folder restructures in 1.17 were within `common/technologies`+`technology_tags` for doctrines — neither
  is `replace_path`'d, both are same-filename overrides covered by #1/#3). MIO subfolders current. No edit.
- **Sources:** Patch_1.17 / Patch_1.17.X; MIO / Character / Scripted-GUI / Decision / State / Map modding
  mirror pages; mod greps.

## 8. 1.17 ADDITIVE modder surface (mod uses NONE — collision check clean) → MODERNIZATION-REPORT

New (additive) tokens/features in 1.17.0–1.17.5; the mod references none (whole-repo grep; the only
substring hits — `*_range_factor` — are the long-standing `navy_max_range_factor`/`air_range_factor`
modifiers, **not** the new raid `range_factor`):
- Modifiers: `army_experience_from_volunteers`, `spotting_chance_against`, `naval_hit_chance_against`,
  `amphibious_invasion_against`, `annex_subject_cost_factor`, `energy_gain_factor`.
- Triggers: `has_resources_in_collection`; doctrine triggers `has_doctrine` / `has_mastery_level` /
  `has_completed_track` / `has_any_grand_doctrine` (1.17.5).
- Effects: doctrine `set_grand_doctrine` / `set_sub_doctrine` / `add_mastery` / `add_mastery_bonus`.
- GUI/script: `fade_delay` on `containerWindowType`; scripted-effect buttons in the focus-tree inlay
  window; grand-doctrine `max_track_columns` / `max_track_rows`; Raid Types `range factor` modifier;
  `language = X` usable with or without the `l_` prefix.
- New buildings (two infrastructure-scaling buildings, mutually exclusive in a state) + Strategic Locations
  + per-state-type limits (the building-rework adoption — see #4).

---

### Sources (consolidated)
- hoi4.paradoxwikis.com/Patch_1.17 ; /Patch_1.17.X ; /No_Compromise,_No_Surrender (via WebSearch backend)
- hoi4.paradoxwikis.com/Building_modding ; /State_modding ; /Technology_modding ;
  /Doctrine_modding ; /Land_doctrine ; /Naval_doctrine ; /Air_doctrine ; /Special_forces_doctrine ;
  /Military_industrial_organization_modding ; /Mod_structure ; /Map_modding ; /Character_modding ;
  /Scripted_GUI_modding ; /Decision_modding
- GitHub raw-markdown mirror klimPaskov/Agentic-HOI4-Modding/paradox_wiki/{Building, State, Technology,
  Military industrial organization, Map} modding.md (current ≈1.18/1.19; no per-patch pages)
- GitHub code search (mcp__github__search_code): `cl_tech path:common/technology_tags`;
  `max_level`/`level_cap state_max path:common/buildings`; `sub_doctrine`/`grand_doctrine path:common` —
  across Kaiserreich, Millennium Dawn, Equestria at War, 1956, Sons of Mobius, Project IRIS, Road to 56,
  Chaos-Redux, East-Showdown, NAD, EoaNB, The Great War, Breaking-Point, …
- updatecrazy.com 1.17.2 / 1.17.4 rendered patch-note mirrors
- Bundled 3273913964/pdx_documentation/ (~1.14 effects/triggers/modifiers reference)
- Mod grep + file reads (evidence cited inline)
