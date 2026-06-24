# Jump 3 — 1.16 → 1.17 (No Compromise, No Surrender) — Changes applied

**One mod file changed** (the `supported_version` bump). Unlike Jumps 1–2 (country-pack patches whose
surface was purely additive), 1.17 was a **full expansion** with a game-wide **doctrine rework**, a naval
rework, and a building-limit rework. Of those, exactly **one** system genuinely breaks this mod — the
**doctrine rework** — and its only correct fix is a **large interpretive rework that the faithful-port
mandate forbids guessing at**, so it is **escalated as a BLOCKER / owner decision (U1, DECISIONS-NEEDED
D6)** rather than auto-edited. The other big 1.17 systems do **not** break this mod because it ships
**self-contained, same-filename full overrides** of its technology categories, naval tech tree, ship
modules and building definitions, so vanilla's content migrations (`cl_tech`→`ca_tech`, Medium-Battery
tech-line removal) do not reach it, and the flat `max_level` building schema still parses on 1.17.

## Changed

### `3273913964/descriptor.mod`
- **What:** `supported_version="1.16.*"` → `supported_version="1.17.*"` (line 37).
- **Why:** Required so 1.17 (No Compromise, No Surrender) loads the mod without flagging it as made for an
  older version. `"1.17.*"` is the correct minor-wildcard form: `*` matches any 1.17.x build (1.17.0
  through 1.17.5+). Same convention the mod already used; wiki confirms either `"1.17.*"` (preferred,
  survives hotfixes) or a full `"1.17.x.0"` is valid. File remains plain ASCII / LF-only / **no UTF-8 BOM**
  (required by the descriptor spec; verified pre- and post-edit via `file` + `od` — only the single token
  changed; braces still balanced: the `tags={}` pair).
- **Source:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM rule);
  hoi4.paradoxwikis.com/Patch_1.17.X (1.17.x version table).

## ESCALATED — NOT changed (load-bearing; owner decision; cannot be guessed)

### Doctrine system rework → **BLOCKER (UNCERTAINTIES U1 / DECISIONS-NEEDED D6)**
1.17 replaced the Army/Navy/Air doctrine trees with a new **Grand Doctrine + Subdoctrine + Mastery**
system and a new doctrine GUI. The mod ships **old-format** land + special-forces doctrine trees that
override vanilla (`common/technologies/land_doctrine.txt`, `special_forces_doctrine.txt`), declares
old-style doctrine folders in its own `common/technology_tags/00_technology.txt`, references old doctrine
technologies via `has_tech = …` in **43 places across 6 files** (`common/ideas/{army,navy,air}_spirits.txt`,
`common/ai_strategy/doctrines.txt`, `common/scripted_triggers/00_scripted_triggers.txt`,
`common/national_focus/GER_Hitler_Military.txt`), and uses **vanilla's new** doctrine GUI (it ships no
`countrydoctrinetreeview.gui`). This "old custom doctrines + new doctrine tree view" configuration is the
one modders report **crashing** (and 1.17.X patched several doctrine CTDs). The data is internally
consistent, but the runtime interaction is assessed **load-bearing / crash-class**, and the only correct
remedies — **(A)** migrate the doctrines to the new schema + adapt the GUI + convert the 43 `has_tech`
refs to `has_doctrine`/`has_mastery_level`; **(B)** delete the doctrine overrides to inherit vanilla's new
doctrines (still must rework the 43 refs); **(C)** defer like `ai_templates` — are all **major
interpretive decisions**, not faithful one-liners. Per the mandate ("if load-bearing and unresolved →
STOP and report as BLOCKER; do not insert something random"), **escalated, not edited**. The owner's
end-of-port **`-debug`** run (open the doctrine tabs; grep `error.log`) disambiguates the exact failure
mode and picks A/B/C. Full evidence in dossier #1.

## Considered and intentionally NOT changed (with reason)

- **`cl_tech` (1.17 "removed `cl_tech`, migrated to `ca_tech`, renamed ca_tech → Cruiser Technology"):**
  **no edit.** This is a **vanilla content migration**; technology categories are **mod-definable data**.
  The mod declares `cl_tech` AND `ca_tech` itself in `common/technology_tags/00_technology.txt:45-46` (a
  same-filename full override), defines the light-cruiser techs with `categories = { naval_equipment
  cl_tech }` in its own `naval.txt`/`MTG_naval.txt`, and ships its own `cl_tech`/`cl_tech_research` loc —
  fully self-consistent. Vanilla removing *its* `cl_tech` does not reach the mod. A naive
  `cl_tech`→`ca_tech` rename would be **wrong** (it would break the mod's internal consistency and merge
  two categories the mod keeps distinct). Many 1.17+ mods still declare/use `cl_tech` freely (GitHub).
  → dossier #3; residual engine-hardcode risk → UNCERTAINTIES U2.

- **`common/buildings/00_buildings.txt` (flat `max_level` schema, overrides vanilla building defs):**
  **no edit.** 1.17 reworked building limits (`level_cap = { state_max/province_max/shares_slots }`,
  per-state-type limits, Strategic Locations / Natural Harbor), but **flat `max_level = N` still parses on
  1.17 and coexists with `level_cap`** (current Building-modding wiki lists `max_level` as a valid
  alternative to `level_cap`; GitHub shows both schemas in current mods). The mod uses zero new-schema
  tokens (`grep level_cap|province_max|state_max|strategic_location` → none). No building-def field became
  required, and the per-state-type limits use the existing mandatory `state_category` (no new state data
  needed). The mod's buildings simply won't gain the new limits/Strategic-Location behavior — a
  *behavioral non-adoption*, not a load break. → dossier #4; adoption recorded in MODERNIZATION-REPORT;
  UNCERTAINTIES U3.

- **Naval "Medium Battery tech line removed" + carrier/fleet/invasion reworks:** **no edit.** The removal
  is a **vanilla tech-category** cleanup; the mod ships its **own** `ship_hull_cruiser.txt` +
  `00_ship_modules.txt` (full overrides) defining its own `ship_medium_battery` modules/categories, so its
  cruiser designer stays internally consistent. Carrier/fleet/invasion changes are additive gameplay.
  → dossier #5.

- **`common/ai_templates/` (9 files, pre-1.15 schema, `match_to_count` ×):** untouched per HARD RULE 1 /
  DECISIONS-NEEDED D1. Confirmed 1.17 made **no** AI-template/division-designer schema change (the 1.17
  army change is the doctrine rework, not the division designer), so the deferred-migration target is
  unchanged. → dossier #6 + MODERNIZATION-REPORT AI-template note.

- **MIO / characters / decisions / on_actions / scripted_gui / states / focus / map / GUI:** untouched —
  no 1.17 format break (MIO changes are bugfix/balance; the rest additive). `map/buildings.txt` 7-column
  format and `history/states` building-block parsing unchanged. → dossier #7.

## Verification performed
- **Edit integrity:** `descriptor.mod:37` now `supported_version="1.17.*"`; encoding still ASCII / no BOM
  (`file` + `od` head unchanged), LF-only, no trailing-newline change; **zero** remaining `1.16` strings;
  braces balanced (1 open / 1 close — the `tags={}` block, untouched). Only the single token changed.
- **Removed/renamed-token sweep (whole mod, excl. `pdx_documentation/`):** `cl_tech` appears in 33 mod
  files — **all** within the mod's own overriding tech/loc/focus/idea/event files (self-contained, dossier
  #3); no other 1.17-removed token used. `level_cap`/`province_max`/`state_max`/`strategic_location` → **0
  files** (mod uses neither new building schema nor strategic locations). The old doctrine `has_tech`
  references are present (33 file:line hits across the 6 files) — the BLOCKER #1 dependency, escalated.
- **New-token collision check:** the mod uses **none** of the 1.17 additive tokens (`set_sub_doctrine`,
  `set_grand_doctrine`, `has_mastery_level`, `add_mastery`, `has_completed_track`, `has_any_grand_doctrine`,
  `army_experience_from_volunteers`, `spotting_chance_against`, `naval_hit_chance_against`,
  `amphibious_invasion_against`, `annex_subject_cost_factor`, `energy_gain_factor`,
  `has_resources_in_collection`, `fade_delay`, `max_track_columns`, `max_track_rows`) — `grep` → 0 (the
  only `*range_factor` hits are the long-standing `navy_max_range_factor`/`air_range_factor` modifiers, not
  the new raid `range_factor`). No forward references, no name collisions.
- **replace_path:** all 25 targets remain canonical 1.17 folders (the 1.17 folder reorg was inside
  `common/technologies`+`technology_tags` for doctrines — neither `replace_path`'d; both same-filename
  overrides, covered by #1/#3). MIO subfolders current.
