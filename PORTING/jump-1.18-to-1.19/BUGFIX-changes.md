# Jump 5 BUGFIX pass — 1.18 → 1.19 (Thunder at our Gates) — crash-fix changes

The first 1.18→1.19 pass (changes.md) did only the additive surface (`add_temporary_buff_to_units`
→ `unit_modifiers`, descriptor bump) and **missed the entire crash path**. The game reached the 1933
start and crashed `EXCEPTION_INT_DIVIDE_BY_ZERO`. This pass fixes the crash and the tractable rest.

**Root finding:** the mod ships several **same-filename overrides** of vanilla files it does NOT
`replace_path` (`common/unit_tags/00_categories.txt`, `common/modifiers/00_static_modifiers.txt`,
`interface/divisiondesignerview.gui`, `interface/frontendgamesetupview.gui`, the equipment
`modules/*`, `ship_hull_submarine.txt`, …). A same-filename file in those folders loads **instead of**
vanilla's identically-named file, so every entry vanilla 1.19 ADDED to those files went missing — and
the vanilla files that load beneath the mod (`common/units/*`, `common/doctrines/subdoctrines/**`,
`common/special_projects/*`) then failed to resolve those entries. The 1933 division-template width
computation divided by zero because units whose subunit category was "Invalid" registered with zero
width. **Reconciling the stale overrides with the vanilla-1.19 additions is the fix.**

Format: `file:line — old → new — WHY — SOURCE`.

---

## P1 (CRASH-CRITICAL) — Subunit-category reconciliation

### `3273913964/common/unit_tags/00_categories.txt:36-61` — added 20 vanilla-1.19 categories to `sub_unit_categories`
- **old:** `sub_unit_categories` ended at `category_bus` (36 categories; missing the entire 1.19
  Regimental/Divisional-Support + carrier-air + helicopter/maritime + self-propelled-family set).
- **new:** appended, before the closing `}` (all values verbatim vanilla 1.19):
  `category_vehicle_infantry`, `category_mobile_and_mobile_combat_sup`,
  `category_self_propelled_artillery`, `category_self_propelled_anti_air`, `category_tank_destroyers`,
  `category_helicopter_support_companies`, `category_rangers`, `category_anti_tank`,
  `category_mobile_anti_tank`, `category_rocket_artillery`, `category_carrier_fighter`,
  `category_carrier_cas`, `category_carrier_nav_bomber`, `category_maritime_patrol_bomber`,
  `category_marines_and_amphibious`, `category_divisional_support_battalions`,
  `category_regimental_support_battalions`, `category_regimental_support_artillery`,
  `category_self_propelled_anti_air_regimental_support`, `category_tank_destroyer_regimental_support`.
  (55 categories total; braces 1/1; ASCII/CRLF preserved.)
- **WHY (the crash):** the mod's stale override omitted these. Vanilla `common/units/*` (`fire_support`,
  `hq_support`, `helicopter_brigade`, `land_cruiser`, `blackshirt_assault_battalion`,
  `sturmtruppe_battalion`, `recon`, …) and `common/doctrines/subdoctrines/**` load beneath the mod and
  reference them → `Invalid subunit category` → those vanilla subunits registered with **0 combat
  width** → 1933 division-template width sum = 0 → `EXCEPTION_INT_DIVIDE_BY_ZERO` at game init. Re-grep
  after fix: **all 18 error-log categories now defined**; comm-diff of the log's category set vs the
  file = empty.
- **CASCADE (verified, per brief's prediction):** this single fix also clears the **section-F vanilla
  doctrine-subfile** "Unexpected token" errors for the regimental/divisional **unit types**
  (`helicopter_recon`, `helicopter_field_hospital`, `helicopter_transport`, `assault_engineer`,
  `armored_engineer`, `armored_signal`, `armored_maintenance`, `ranger_battalion`,
  `motorized_military_police`, `heavy_sp_anti_air_support`, `super_heavy_artillery`,
  `self_propelled_super_heavy_artillery`). Mechanism: vanilla defines those subunits with
  `categories = { … category_helicopter_support_companies / category_regimental_support_* / category_rangers … }`;
  while the category was invalid the **whole subunit failed to register**, so the doctrine refs to it
  were "Unexpected token". With the categories now valid the subunits register and the doctrine refs
  resolve. (The `category_*` tokens those same doctrine files choked on are now defined directly.)
- **SOURCE:** vanilla-1.19 `00_categories.txt` tail cross-referenced across confirmed-1.19 mods
  `Defaultmetric/theirfinestrehost` (full vanilla `sub_unit_categories` block, raw read), `EaW-Team/equestria_dev`,
  and the regimental/divisional tail identical across ~17 GitHub `00_categories.txt` matches
  (`HoI4-LOTRMod-Team/HoI4-LotrMod`, `Choo-Choo-Oreo/aNCFO_cco`, `EoaNB-Team/EoaNB`, `Mumiago/MFU-Updated`,
  `Defaultmetric/theirfinestrehost`, …); cascade confirmed via raw read of vanilla
  `common/units/helicopter_brigade.txt` + `recon.txt` (`categories = { category_support_battalions
  category_army category_helicopter_support_companies }`) in `JoeBidenWhatAreYouHiding/kx` (Kaiserreich-X),
  `EaW-Team/equestria_dev`, et al.

---

## P2 (CRASH-RELEVANT) — Naval support static modifiers

### `3273913964/common/modifiers/00_static_modifiers.txt:670-692` — added 3 vanilla-1.19 static modifiers
- **old:** the mod's same-filename `00_static_modifiers.txt` override ended at
  `SOV_for_the_common_good_relation` and **did not define** `naval_general_support`,
  `naval_repair_support`, `the_great_wall` (vanilla 1.19 added them to its `00_static_modifiers.txt`,
  which the override shadows).
- **new:** appended at end of file (verbatim vanilla 1.19):
  - `naval_general_support = { max_organisation = 0.2  navy_max_range_factor = 0.2  naval_morale_factor = 0.2 }`
  - `naval_repair_support = { naval_critical_effect_factor = -0.25  naval_ship_recovery_chance = 0.1  naval_attrition = -0.075 }`
  - `the_great_wall = { dig_in_speed_factor = 0.15  max_dig_in_factor = 0.1 }`
  (braces 122/122; ASCII/CRLF preserved.)
- **WHY:** `modifier.cpp:2455 missing static modifier definition: naval_general_support / naval_repair_support /
  the_great_wall`. These are engine-/content-referenced static modifiers. Their absence ALSO made the
  **vanilla** `common/doctrines/subdoctrines/sea/*` tokens `naval_general_support_value_factor`,
  `naval_repair_support_value_factor`, `naval_general_support_factor`, `naval_repair_support_factor`
  parse as "Unexpected token" (those `*_(value_)factor` keys are the modifier handles that only exist
  once the static modifier is registered). Adding the definitions back registers the modifiers and the
  doctrine tokens resolve. (`navy_capital_subdoctrines.txt` / `navy_carrier_doctrines.txt` are vanilla
  files the mod does not override; several confirmed-1.19 mods comment those lines out "for error
  suppression" instead of restoring the static modifiers — restoring is the correct, behaviour-preserving fix.)
- **`naval_supremacy_factor` (mod's `ship_hull_carrier/cruiser/heavy/submarine.txt`): NO EDIT — and
  correct as-is.** The stale crash log flagged it "Unexpected token", but `naval_supremacy_factor = 2.4`
  is a **valid, current 1.19 ship-hull stat** (byte-identical to the vanilla value across dozens of
  confirmed-1.19 mods). The mod's four ship-hull files are structurally valid (braces balanced, ASCII,
  token at correct depth). The log entry was a **cascade** from the same naval static-modifier database
  being incomplete during the equipment-stat registration pass (the four `naval_supremacy_factor` errors
  sit in the same 20:03:45 batch as the `missing static modifier` lines). Removing the stat would be
  wrong (HARD RULE 5 — preserve design); restoring the static modifiers is the root fix.
- **SOURCE:** exact definitions from a pristine `(vanilla) 00_static_modifiers.txt` (raw read,
  `Kama-Pushka/Kursach-Fizika`) and identical across `Kaiserreich/Kaiserreich-HOI4`, `EaW-Team/equestria_dev`,
  `JoeBidenWhatAreYouHiding/kx`, `deliciousmods/1956_beta`, `Defaultmetric/theirfinestrehost`,
  `Mumiago/MFU-Updated` (~30 `00_static_modifiers.txt` GitHub matches); `naval_supremacy_factor` currency
  confirmed via `ship_hull_carrier.txt` across `East-Showdown/East-Showdown`, KX, MFU, and ~30 more 1.19 repos.

---

## P4 (functional; not the crash) — Division-designer + frontend GUI reconciliation

### `3273913964/interface/divisiondesignerview.gui:1124-1790` — ported the vanilla-1.19 Army-HQ designer elements
- **old:** the mod's same-filename override (1502 lines) was a stale pre-Army-HQ copy: it lacked 11
  elements the 1.19 C++ designer binds by name in `countrydivisiondesignerview` — `hq_overlay_images`,
  `toggle_model_selector_button`, `hardness_stat`, `org_stat`, `strength_stat`, `speed_stat`,
  `combat_width_view`, `subunits_hq`, `save_and_deploy_button`, `non_hq_view`, `hq_view` (+ their
  sub-elements) → `containerwindow.cpp` "Could not find <X> in window countrydivisiondesignerview".
- **new:** extracted those 11 blocks **verbatim from pristine vanilla 1.19** (each brace-matched) and
  inserted them as additional sibling children just before the `countrydivisiondesignerview` window's
  closing brace (these are *additive sibling* containers in vanilla 1.19 — `non_hq_view`/`hq_view` do
  NOT wrap the existing designer content, which sits earlier in the window — so a surgical add is the
  correct structure, not a rewrite). +667 lines; braces 644/644; ASCII/CRLF (one verbatim vanilla
  em-dash in a comment normalised to ASCII `-`).
- **Mod customisation preserved:** the mod's bespoke softness-ratio stat panel (`armor_softness`,
  `inf_softness`, `softness`, `softness_ratio_frame`, `combat_adjuster_header_label`,
  `combat_header_label`, `3d_view_entry_bg`) is untouched — confirmed present post-edit. A
  named-element diff (mod vs vanilla) drove this: 10 mod-only elements (preserved) vs 62 vanilla-only
  (the Army-HQ subsystem, added).
- **WHY / severity:** these are **non-fatal** GUI binding warnings (the core designer remained usable);
  they are NOT the divide-by-zero (that's P1). But they were "the last subsystem logged before the
  crash" and the brief asked the designer to build; with these added the designer binds cleanly and the
  1.19 Army-HQ deploy UI renders.
- **SOURCE:** pristine vanilla-1.19 `interface/divisiondesignerview.gui` (raw read, `prisle123/hoi4-archive`,
  SHA `80e30c2…` shared byte-identically by `HerderDg/thelastdaysofpoland`, `WolfxeS6/NovumVexillum`,
  `gotolanzhoubuycake/bare-repository`); presence of the same elements cross-confirmed in
  `EoaNB-Team/EoaNB`, `East-Showdown/East-Showdown`, `MillenniumDawn/Millennium-Dawn`, `Mumiago/MFU-Updated`.

### `3273913964/interface/frontendgamesetupview.gui:150` and `:212` — added `new_content` icon to `country_entry` + `country_entry_mini`
- **old:** the mod's stale override lacked the 1.19 `new_content` (unplayed-DLC-content notification)
  `iconType` in both country-entry windows → `containerwindow.cpp` "Could not find new_content in window
  country_entry / country_entry_mini" (×many).
- **new:** added `iconType { name="new_content" position={x=100 y=15} spriteType="GFX_unplayed_content_notification" alwaystransparent=yes }`
  to both windows (canonical vanilla position/sprite). Braces 625/625; ASCII/CRLF.
- **WHY:** cosmetic main-menu binding warning; cleared for a clean log. `GFX_unplayed_content_notification`
  is a vanilla-1.19 sprite provided beneath the mod.
- **SOURCE:** vanilla form via `Red-Liberty-Mod/red-liberty-mod` (raw read) + identical across
  `EoaNB-Team/EoaNB`, `World-Ablaze/world-ablaze-beta`, `JoeBidenWhatAreYouHiding/kx`,
  `MillenniumDawn/Millennium-Dawn`, ~30 `frontendgamesetupview.gui` matches.

---

## P5 (log-reminder) — `script_enum_equipment_bonus_type`

### `3273913964/common/script_enums.txt:371-372` — added `helicopter_equipment` + `helicopter_equipment_1`
- **old:** the enum listed the train equipment archetypes (`train_equipment`..`train_equipment_3`) but
  omitted `helicopter_equipment` / `helicopter_equipment_1` → startup log reminder ("helicopter_equipment
  not in script_enum_equipment_bonus_type … update at the same time as common/units/equipment").
- **new:** inserted the two entries right after `train_equipment_3`. Braces 8/8; ASCII/CRLF.
- **WHY:** the mod doesn't `replace_path common/units/equipment`, so vanilla helicopter equipment
  (`helicopter_equipment` archetype, `helicopter_equipment_1`, year 1936) loads beneath it; the enum
  must list it. Non-load-blocking reminder, fixed per NOTES §2 / brief P5. (The `script_enums.txt:720`
  duplicate-`=` and the `2RCW_…` digit-token were left for the orchestrator's cross-cutting pass, per brief.)
- **SOURCE:** `helicopter_equipment`/`helicopter_equipment_1` confirmed real vanilla equipment via raw
  `common/units/equipment/helicopter.txt` in `JoeBidenWhatAreYouHiding/kx` (Kaiserreich-X, year 1936),
  `Tassen1221/TPMP`, `zVSciy/Florian-Friends-United-FFU`, `battleskorpion/nadivided-dev`.

---

## P3 — Equipment-DB "Entry doesn't exist" (59 entries) — NOT crash-relevant → ESCALATED
See `ESCALATIONS.md`. All 59 are referenced only by **vanilla** `common/special_projects/*` (late-game
research projects); **zero** are referenced by any 1933 OOB / starting division template / `history/*`
(verified by exhaustive scan) → none touch the divide-by-zero. They are non-fatal `persistent.cpp:67`
skip-and-continue parse warnings (the load reached the 1933 start past all 165 of them). Root = the mod's
stale equipment same-filename overrides (`ship_hull_submarine.txt`, `modules/00_ship_modules.txt`,
`00_plane_modules.txt`, `00_tank_modules.txt`, `plane_airframes.txt`, `tank_super_heavy.txt`, …) predate
the vanilla-1.19 modern-era content. Full port is a large, balance-bearing late-game content effort →
design call escalated.

---

## Verification performed
- **P1:** comm-diff of the error-log category set vs the post-edit file = **empty** (all 18 referenced
  categories defined; 55 total). Cascade verified: every section-F doctrine-subfile "Unexpected token"
  token is now either a defined category, a resolved static modifier, or a vanilla subunit whose
  category is now valid (so it registers).
- **P2:** all 3 static modifiers defined; no broken `naval_*_support_*factor` token remains in any
  mod-owned file. Ship-hull files confirmed valid/unchanged.
- **P4:** all 11 designer elements + both `new_content` present; mod-custom softness panel intact;
  `countrydivisiondesignerview` still the single top-level window; outer `guiTypes` intact.
- **P5:** both helicopter enum entries present inside the `script_enum_equipment_bonus_type` block.
- **Brace balance + encoding (all 5 edited files):** balanced, ASCII text, CRLF preserved, no BOM,
  0 non-ASCII bytes. `git diff --stat`: 5 files, +740/-4.
