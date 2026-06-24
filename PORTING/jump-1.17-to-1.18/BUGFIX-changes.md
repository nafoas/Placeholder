# Jump 1.17→1.18 (Peace for Our Time) — BUGFIX PASS changes

Deep-fix pass over the four in-lane 1.18 items (sub-detection defines; `helicopter_tech` tech
category; Train/Helicopter MIO; other 1.18 removed/renamed naval stat/define). The first port pass
concluded "descriptor-only, no edits"; this pass found **one** real in-lane load error it missed
(`helicopter_tech`) and fixed it. The other three items were independently re-verified against the
LIVE tree + real sources and confirmed **no-action** (correct faithful-port behavior), with the
reasoning recorded so they are not re-touched.

Format: `file:line — old → new — WHY — SOURCE(url)`.

---

## FIX APPLIED (1 file changed)

### `3273913964/common/technology_tags/00_technology.txt:180` (category list close)
- **old →  new:** inside `technology_categories = { … }`, after the 1.17 agent's four added
  categories (`cat_fortification` / `naval_armor` / `naval_artillery` / `mio_cat_artillery`) and
  before the closing `}`, appended a comment block + the bare category **`helicopter_tech`**:
  ```
  	# Vanilla technology category added in the 1.18 (Peace for Our Time) cycle, alongside the
  	# helicopter content. Vanilla's common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt
  	# (SUBDOCTRINE_AIR_CAVALRY) does add_tech_bonus = { ... category = helicopter_tech ... }; because
  	# this file is a same-filename full override of vanilla's category list, the category must be
  	# re-declared here or that vanilla effect throws "Unknown technology category helicopter_tech".
  	# Declared as a bare name per the Technology-modding schema (no other info assigned).
  	helicopter_tech
  ```
- **WHY:** `error.log:3132` —
  `common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt:297: add_tech_bonus: Unknown
  technology category helicopter_tech`. The mod ships **no** `common/doctrines/` and does **not**
  `replace_path` it, so **vanilla's** `combat_support_subdoctrines.txt` loads beneath the mod. Its
  `SUBDOCTRINE_AIR_CAVALRY` subdoctrine runs
  `add_tech_bonus = { bonus = 0.5  uses = 2  category = helicopter_tech  name = SUBDOCTRINE_AIR_CAVALRY }`.
  But the mod's `common/technology_tags/00_technology.txt` is a **same-filename full override** of
  vanilla's category list authored before the 1.18-cycle helicopter content, so `helicopter_tech` was
  absent → the effect threw `Unknown technology category`. Helicopters/their tech line were added in
  the 1.18 development cycle (helicopter MIOs are the 1.18 headline; the air-cavalry subdoctrine + its
  `helicopter_tech` category ship with it). Re-declared as a **bare name** (the schema for a category
  with no extra config — matching exactly how the 1.17 agent added its four, and how vanilla declares
  it). Verified `helicopter_tech` is the correct id (not e.g. `helicopter_techs`/`cat_helicopter`):
  it is the bare category id used by vanilla's own `combat_support_subdoctrines.txt` and declared in
  `00_technology.txt`.
- **SOURCE:**
  - Pristine-vanilla `combat_support_subdoctrines.txt` (the `category = helicopter_tech` /
    `SUBDOCTRINE_AIR_CAVALRY` block) — Paradox Game Converters **blank_mod** (unmodified vanilla copy):
    `https://github.com/ParadoxGameConverters/Vic2ToHoI4/blob/master/data/blank_mod/common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt`
    and `https://github.com/ParadoxGameConverters/Vic3ToHoI4/blob/master/data/blank_mod/common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt`
    (both contain `add_tech_bonus = { bonus = 0.5 uses = 2 category = helicopter_tech name = SUBDOCTRINE_AIR_CAVALRY }`).
    Corroborated across 40+ current mods (Road-to-56, Kaiserredux/KX, Rise-of-Nations, …) via GitHub
    code search (`mcp__github__search_code` `helicopter_tech filename:combat_support_subdoctrines.txt`,
    48 hits — identical block).
  - `helicopter_tech` declared as a **bare technology category** in vanilla-derived
    `common/technology_tags/00_technology.txt`, in the cluster `naval_armor` / `naval_artillery` /
    `helicopter_tech` / `pykrete_tech` / `transport_planes_cat` (GitHub code search
    `helicopter_tech path:common/technology_tags`, 92 hits — Equestria-at-War, World-At-War, tzarmod,
    Cold War, Project-IRIS, …). Same id, same declaration form.
  - 1.18 "Peace for Our Time" patch notes confirm the 1.18 cycle is the helicopter-MIO cycle:
    `https://patched.gg/games/hearts-of-iron-iv/peace-for-our-time-patch-notes` (Helicopter MIOs →
    BEL/USA/JAP/GER); wiki `https://hoi4.paradoxwikis.com/Patch_1.18`.
- **VERIFY:** post-edit grep — `helicopter_tech` present in the file; braces balanced (31 `{` / 31
  `}`); the only `Unknown technology category` errors in error.log are now fully covered (the 1.17
  agent's 4 + this one). The `{` inside the comment is on a `#` line (comment to EOL) and does not
  affect parsing.

---

## CONSIDERED — NO ACTION (re-verified against the LIVE tree; do not re-touch)

### Item #1 — Submarine-detection overhaul (defines + formula only): **NO EDIT**
- 1.18 reworked submarine detection via the **new additive defines** `SUBMARINE_BASE_STEALTH_VALUE`,
  `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`, `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER`
  (+ tuned `SUBMARINE_HIDE_TIMEOUT` 20→8, `SUBMARINE_REVEALED_TIMEOUT` 16→12,
  `SUBMARINE_REVEAL_DETECTION_MULTIPLIER` 0.075→0.065). It **removed/renamed no equipment stat or
  modifier**. (Brief item #1 + patch notes.)
- LIVE-tree grep: the mod sets **none** of the new submarine defines (0 hits over `common/`,
  `.lua`+`.txt`, excl. `pdx_documentation`), and `common/defines/cbts_defines.lua` (read in full, 183
  lines) overrides **no** submarine/stealth/reveal/naval-stat define — its naval-relevant keys are AI
  invasion / volunteer / trade defines only (e.g. `ENEMY_NAVY_STRENGTH_DONT_BOTHER`,
  `MAX_INVASION_SIZE`), all long-standing. → mod **inherits** the new formula automatically (the
  faithful-port outcome).
- The mod uses the still-valid stats `sub_detection`/`sub_visibility`/`surface_detection`/
  `surface_visibility` (313 hits in `common/`) — all present on the current Equipment-modding page. It
  uses **none** of the OBSOLETE stats `fire_range`/`shore_bombardment`/`evasion` as equipment stats in
  `common/units/equipment/` (0 hits; those are pre-1.18 MtG-era anyway). A stat-rename edit would be
  **wrong** (nothing was renamed). → **No edit.**
- **SOURCE:** `https://hoi4.paradoxwikis.com/Patch_1.18` (submarine new formula);
  `https://www.gamewatcher.com/news/hearts-of-iron-4-open-balance-beta-update-ii-patch-notes`
  (the three submarine defines + `SUBMARINE_HIDE_TIMEOUT`/`SUBMARINE_REVEALED_TIMEOUT`/
  `SUBMARINE_REVEAL_DETECTION_MULTIPLIER` value tunes); mod greps + `cbts_defines.lua` read.

### Item #3 — Train + Helicopter MIO content: **NO EDIT — safe non-adoption (no FATAL error)**
- 1.18 added vanilla **Train MIOs** (ENG/FRA/BEL/USA/SOV/ITA/JAP/GER) and **Helicopter MIOs**
  (BEL/USA/JAP/GER). The mod `replace_path`s
  `common/military_industrial_organization/organizations`, so vanilla's MIO files (old AND new) do
  **not** load — the mod ships only generic MIOs (`00_generic_organization.txt` +
  `_template_organization.txt`), and that generic set defines **no** `generic_helicopter_organization`
  / `generic_train_organization` template. → the new Train/Helicopter MIOs are simply **not adopted**
  (additive, safe).
- **Determined this is NOT a FATAL error:** the only MIO-database messages in error.log are
  `mio:GER_focke_wulf_organization does not match any MIO in database` (lines 259-260, `eventtarget.cpp`)
  and `mio:JAP_sasebo_naval_arsenal_organization does not match any MIO in database` (lines 371/375,
  `scopedvariable.cpp`). These are **non-fatal runtime scope-resolution warnings**, NOT load-aborting
  `persistent.cpp` parse errors. They are **pre-existing / non-1.18**: Focke-Wulf and Sasebo MIOs are
  **NSB-era** vanilla MIOs (defined in vanilla `…/organizations/GER_organization.txt` /
  `JAP_organization.txt`), and they are *referenced* from **vanilla `common/special_projects/projects/
  {air,naval}_projects.txt`** — files the mod **does not ship** (it has no `common/special_projects/`),
  so they load beneath the mod and their `mio:` completion-bonus scope can't resolve the named MIOs the
  mod's folder-replacement intentionally drops. (The mod's own `focke_wulf`/`sasebo` tokens in
  `common/ideas/germany.txt`/`japan.txt` are the **old equipment-designer company ideas** with
  `traits = { … _manufacturer… }`, NOT MIOs — false-positive name overlap.) No Train/Helicopter MIO
  organization token is referenced anywhere in the mod (grep `*_helicopter_organization` /
  `*_train_organization` / `focke_achgelis` → 0). → **No FATAL error; no edit.** (Adopting the new MIOs
  would be a modernization choice, out of scope.)
- **SOURCE:** `https://hoi4.paradoxwikis.com/Patch_1.18` (Train/Helicopter MIO additions);
  `https://patched.gg/games/hearts-of-iron-iv/peace-for-our-time-patch-notes` (MIO schema unchanged;
  Modding section = 2 additive items only); pristine-vanilla `GER_organization.txt` defining
  `GER_focke_wulf_organization` + `GER_focke_achgelis_organization` (`include =
  generic_helicopter_organization`) via GitHub code search
  (`GER_focke_wulf_organization path:common/military_industrial_organization`, 31 hits incl.
  Road-to-56); mod greps + folder inventory + error.log message-class analysis.

### Item #4 — other 1.18 removed/renamed equipment / naval stat / define: **NONE found**
- **Peace defines keys still exist (verified):** the mod sets `BASE_PEACE_PUPPET_FACTOR`,
  `BASE_PEACE_LIBERATE_FACTOR`, `PEACE_SCORE_PER_PASS` (`cbts_defines.lua:34-36`, NDiplomacy). All
  three are present in current vanilla `00_defines.lua` and in up-to-date mods (GitHub code search,
  many hits incl. Millennium-Dawn `MD_defines.lua`, Cold War, KX). These are **different** defines from
  the ones 1.18's war-score rebalance tuned (faction-contribution / sunk-ship-IC — internal values, no
  key removed/renamed). The mod's peace tuning loads and applies on top of 1.18's values. → **No edit.**
- **War-score / peace-conference rebalance = internal balance values, no scripting token removed**
  (patch notes). The mod's `common/peace_conference/*` same-filename overrides use unchanged formats.
  → **No edit.**
- **No 1.18 stat/modifier/category removal or rename exists at all:** the **entire** 1.18 "Modding"
  section is the **two additive items** (`pp_spend_priority`→advisors; stability-check normalized-range
  validation), and patched.gg confirms "No removals or renames of equipment stats, modifiers, define
  keys, technology categories, or subunit categories." The only `Unknown technology category` errors in
  error.log are the 5 known ones — the 1.17 agent's 4 + `helicopter_tech` (fixed above); `pykrete_tech`
  / `transport_planes_cat` are **not** referenced by any file the mod loads (0 in tree, 0 in
  error.log). → nothing else in-lane to fix.
- **SOURCE:** `https://patched.gg/games/hearts-of-iron-iv/peace-for-our-time-patch-notes` (Modding
  section = 2 additive items; explicit "no removals/renames"); `https://hoi4.paradoxwikis.com/Patch_1.18`
  (war-score = internal values); current vanilla + mod `00_defines.lua` peace-key presence via GitHub
  code search; mod greps.

---

## OUT OF LANE — observed, documented, NOT edited (→ NOTES-for-1.19.md)
- **Helicopter SUBUNIT category** `category_helicopter_support_companies` (missing from the mod's
  `common/unit_tags/00_categories.txt`) + helicopter support-company **unit types**
  (`helicopter_field_hospital`/`helicopter_recon`/`helicopter_transport`), referenced by vanilla
  `combat_support_subdoctrines.txt` / `infantry_subdoctrines.txt` / `helicopter_brigade.txt` that load
  beneath the mod. This is the **subunit-category SYSTEM** (1.19 agent's lane) — a **different
  namespace** from the `helicopter_tech` **tech category** fixed here. Left untouched; full detail +
  recommendation written to `NOTES-for-1.19.md` §1.
- `helicopter_equipment` missing from the mod's `script_enums.txt` enum (pre-existing / non-1.18,
  non-load-blocking log reminder) → `NOTES-for-1.19.md` §2.

## Files changed (this pass)
1. `3273913964/common/technology_tags/00_technology.txt` — added `helicopter_tech` category (the one
   in-lane load fix).

(Plus PORTING docs: this file + `NOTES-for-1.19.md`. No commit/push performed.)
