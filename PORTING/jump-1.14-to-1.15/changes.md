# Jump 1 — 1.14 → 1.15 — Changes applied

One file changed. Rationale: 1.15 is an early jump and this mod does not use the systems 1.15
reworked; the single load-bearing requirement is the supported-version bump. Two non-fatal 1.15
changes the mod is affected by were deliberately NOT auto-edited (no behavior-preserving fix
exists) and are recorded in `UNCERTAINTIES.md` instead.

## Changed

### `3273913964/descriptor.mod`
- **What:** `supported_version="1.14.*"` → `supported_version="1.15.*"` (line 37).
- **Why:** Required so 1.15 (Götterdämmerung) loads the mod without flagging it as made for an
  older version. `"1.15.*"` is the correct minor-wildcard form (same convention the mod already
  used; matches wiki Mod-structure examples).
- **Source:** hoi4.paradoxwikis.com/Mod_structure ; hoi4.paradoxwikis.com/Modding ;
  hoi4-modding.fandom.com/wiki/.mod_file .

## Considered and intentionally NOT changed (with reason)

- **`terrain_penalty_reduction` (5 uses: `common/unit_leader/00_traits.txt:1162`,
  `common/ideas/japan.txt:940`, `common/ideas/ethiopia.txt:277`,
  `common/ideas/PAR_ideas.txt:16` & `:35`).** 1.15 "replaced" this modifier with the
  semantically-different `terrain_traits_xp_gain`. Not load-bearing (unknown modifier in an
  idea/trait block only warns). No behavior-preserving fix: renaming would change behavior;
  deleting would change behavior. Left as-is → UNCERTAINTIES.

- **`map/airports.txt`, `map/rocketsites.txt`.** Deprecated/removed in 1.15 (air-base &
  rocket-site placement consolidated into `map/buildings.txt`, which the mod already populates).
  Not load-bearing (engine ignores the now-unused files; no error). Deletion would be a content
  change beyond "make it load," so the files are left in place to preserve bytes → UNCERTAINTIES.

- **`locked = yes` typo in 4 templates** (`WGR_stahlhelm.txt:11`, `WGR_reichsbanner.txt:12`,
  `ARM_2RCW_Militia.txt:10`, `BRY_2rcw_start.txt:12`). Pre-existing (the valid key is `is_locked`);
  not introduced by 1.15, so out of scope for a faithful port. → UNCERTAINTIES (FYI to owner).

## Verification performed
- Re-grepped `match_to_count` (the one named removed division-template property) across the repo →
  ABSENT outside `pdx_documentation/`. Mod uses no removed division-template property.
- Confirmed every division_template property the mod uses (`name`, `is_locked`, `priority`,
  `template_counter`, `division_names_group`) is still valid in the current Division-modding wiki.
- Confirmed `all_enemy_country` (seed item) is unused by the mod (docs-only).
- Confirmed `cbts_defines.lua` overrides only still-valid defines.
- `descriptor.mod` edit is a single-token replacement; no brace/structure change; encoding/line
  endings untouched.
