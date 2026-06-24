# Jump 5 BUGFIX pass — 1.18 → 1.19 — Escalations (design/scope calls, NOT crash-path)

The crash path (P1 subunit categories, P2 naval static modifiers) and the tractable rest
(P4 designer + frontend GUI, P5 enum) are **FIXED** (see BUGFIX-changes.md). The two items below are
**not crash-relevant** and are genuine content/scope/design calls left for the owner.

---

## E1 — P3: 59 vanilla `special_projects` equipment entries missing from the mod's stale equipment overrides

### What
`common/special_projects/projects/{air,land,naval,nuclear,radar}_projects.txt` are **vanilla** files
(the mod ships none of its own). They reference 59 equipment archetypes / types / modules that do not
exist in the loaded equipment DB, producing `persistent.cpp:67 Entry doesn't exist in database: <X>`
(165 file-references total across the five files).

### Root cause
The mod ships **stale same-filename overrides** of vanilla equipment files it does NOT `replace_path`:
- `common/units/equipment/ship_hull_submarine.txt` (modern submarine *equipment* entries missing)
- `common/units/equipment/modules/00_ship_modules.txt`, `00_plane_modules.txt`, `00_tank_modules.txt`
- `common/units/equipment/plane_airframes.txt`, `x_plane_airframes.txt`
- `common/units/equipment/tank_super_heavy.txt`, `tank_modern.txt`, `railway_gun.txt`
These overrides predate the vanilla-1.19 modern-era content, so the entries vanilla 1.19 added to those
exact files went missing, and vanilla's special-projects (which reference them) can't resolve them.

### Why NOT crash-relevant (so NOT fixed here, per brief triage)
- **Zero** of the 59 are referenced by any 1933 OOB / starting division template / `history/*` —
  verified by exhaustive scan of `history/` for every entry. They are all **modern / late-game** content
  (jet engines, land cruisers, nuclear submarines, modern carriers, super-heavy artillery, supersonic
  fighters) — irrelevant to the 1933 game-init that caused `EXCEPTION_INT_DIVIDE_BY_ZERO`.
- They are **non-fatal**: `persistent.cpp:67` skips the bad entry and continues; the load reached the
  1933 start past all 165 of them. Effect = the corresponding late-game special-project unlock is absent.

### The 59 missing entries (precise list)
**Jet engines (plane modules):** `jet_engine_axial_1x`, `jet_engine_axial_2x`, `jet_engine_axial_3x`,
`jet_engine_axial_4x`, `jet_engine_axial_6x`.
**Airframes / air equip:** `small_plane_airframe_5`, `supersonic_fighter_equipment_1`, `earthshaker_bomb_release`.
**Land cruiser (chassis/equipment + modules):** `land_cruiser_chassis_1`, `land_cruiser_equipment_1`,
`lc_helipad`, `lc_flamethrower_turret`, `lc_heavy_naval_guns`, `lc_medium_naval_guns`,
`lc_super_heavy_howitzer`, `lc_aircraft_catapult`, `lc_internal_fuel_tanks`,
`lc_internal_ammunition_compartments`, `lc_wet_ammunition_storage`, `lc_smoke_generators`,
`lc_stabilizers`, `lc_super_heavy_railway_gun`, `lc_radar`.
**Super-heavy land:** `super_heavy_artillery`, `super_heavy_artillery_equipment_1`,
`self_propelled_super_heavy_artillery`, `self_propelled_super_heavy_artillery_equipment_1`,
`super_heavy_railway_gun`, `assault_engineer`.
**Modern / nuclear navy (hulls + equipment + modules + deck-space):** `ship_hull_fleet_submarine`,
`fleet_submarine`, `ship_hull_nuclear_submarine`, `nuclear_submarine`, `nuclear_missile_submarine`,
`rocket_submarine`, `cruiser_submarine`, `midget_submarine`, `ship_hull_carrier_submarine`,
`ship_hull_carrier_modern`, `modern_carrier`, `ship_hull_heavy_modern`, `modern_battleship`,
`ship_hull_mega_carrier`, `mega_carrier`, `ship_hull_escort_carrier`, `escort_carrier`,
`ship_light_battery_sub`, `sub_missile_launcher`, `slbm_launcher`, `ship_torpedo_sub_nuclear`,
`ship_engine_sub_aip_1`, `ship_anechoic_tile`, `ship_submarine_deck_space`, `big_ship_deck_space`,
`ship_escort_deck_space`, `ship_armor_ice_carrier_deck_1`.
**Nuclear engines (modules):** `sub_ship_nuclear_engine_1`, `heavy_ship_nuclear_engine_1`,
`carrier_ship_nuclear_engine_1`.
(Note: `super_heavy_artillery` / `self_propelled_super_heavy_artillery` ALSO appear as doctrine *subunit*
references — that *subunit* class is fixed by P1; the *equipment* `*_equipment_1` listed here is the
separate stale-equipment miss.)

### Fork for the owner
- **(A) Port the vanilla-1.19 modern equipment into the stale overrides** — i.e. sync
  `ship_hull_submarine.txt`, the three `modules/*` files, `plane_airframes.txt`, `tank_super_heavy.txt`,
  etc. up to vanilla 1.19, adding each missing archetype/type/module with its full stat/module-slot
  block. This is a large, **balance-bearing** late-game content effort (these are end-game ships/tanks/
  jets the mod may intentionally diverge on), and must be done file-by-file against vanilla 1.19 to keep
  module-slot wiring correct. Recommended for the endgame content pass, not the crash-fix pass.
- **(B) Accept the special-projects degradation** — leave the vanilla late-game special projects without
  these unlocks (non-fatal). Cheapest; loses some end-game research content the mod never authored.

**Recommendation:** (A) at the endgame, alongside the other stale-override syncs; not load-bearing now.

---

## E2 — career-profile GUI: 12 missing 1.19 stat rows (cosmetic)

### What
`interface/career_profile/common_components.gui` is a mod same-filename override (6431 lines). It lacks
12 career-stat rows the 1.19 C++ binds in `career_profile_pages` → `containerwindow.cpp:991` "Could not
find <X> in window career_profile_pages" (the error log's "×60" = these 12 across several profile pages):
`mio_size_ups`, `special_forces_deployed`, `equipment_sold`, `special_projects_completed`,
`launched_raids`, `scientist_level_ups`, `faction_goals_completed`, `mastery_gained`,
`naval_headquarters_built`, `captured_commanders`, `rescued_commanders`, `ship_captains_promoted`.

### Severity / disposition
**Cosmetic, non-fatal** (career-profile statistics screen; rows for the new 1.19 systems — Ship Captains,
raids/captures, special projects, MIO, mastery — simply don't display). Not crash-related. The brief
marks this "fix if cheap, else document." Adding 12 vanilla stat-row blocks into a 6431-line GUI override
(each needing exact vanilla structure + a matching `career_profile_pages` layout) is **not cheap** and is
purely cosmetic, so it is **documented rather than risked** in this crash-fix pass.

### Fork for the owner
- **(A)** Port the 12 vanilla-1.19 `career_profile_pages` stat rows into the override at the endgame GUI pass.
- **(B)** Accept the missing career-profile rows (cosmetic).
**Recommendation:** (A) at the endgame GUI/cosmetic pass; not load-bearing.

---

## Out of scope here (left for the orchestrator's cross-cutting pass, per brief)
- `common/script_enums.txt:720` duplicate script-enum `=` (malformed line).
- dynamic token `2RCW_Increase_Ideology_From_Recognizer` (cannot start with a digit).
- `No energy resource defined`, `ITA_mechanized_vehicle_1_entity` missing attachment,
  `map/strategicregions` temperature intervals — non-fatal singletons (section K), not this lane.
