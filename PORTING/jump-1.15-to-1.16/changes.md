# Jump 2 — 1.15 → 1.16 (Graveyard of Empires) — Changes applied

One file changed. Rationale: 1.16 is a country-pack patch (Afghanistan / British Raj / Iran / Iraq)
whose modder-facing surface is **additive** (`bypass_effect`, `load_focus_tree`'s
`copy_completed_from`, `front_role_override`, the 1.16.1 `count` for `any_object` triggers) plus
**one new validation check** (duplicate province building blocks). The mod uses **none** of the new
tokens and **none** of any removed/renamed token (1.16 removed/renamed nothing the mod uses). The
only load-bearing requirement is the supported-version bump. The single 1.16 change the mod is
*touched* by (the duplicate-province-buildings validation) is non-load-bearing and surfaces 3
**pre-existing** authoring bugs; per the faithful-port mandate it is NOT auto-edited and is recorded
in `UNCERTAINTIES.md`.

## Changed

### `3273913964/descriptor.mod`
- **What:** `supported_version="1.15.*"` → `supported_version="1.16.*"` (line 37).
- **Why:** Required so 1.16 (Graveyard of Empires) loads the mod without flagging it as made for an
  older version. `"1.16.*"` is the correct minor-wildcard form: `*` matches any 1.16.x build
  (1.16.0 checksum 722d through 1.16.9). Same convention the mod already used; matches wiki
  Mod-structure examples. File remains plain ASCII / LF-only / no UTF-8 BOM (required by the
  descriptor spec; verified pre- and post-edit — only the single token changed).
- **Source:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM rule);
  hoi4.paradoxwikis.com/Patch_1.16.X (1.16.x version/checksum table).

## Considered and intentionally NOT changed (with reason)

- **Duplicate province building blocks (3 state files):**
  `history/states/327-Philippines.txt` (province 10265 ×2 → bunker+coastal_bunker silently
  dropped, naval_base wins), `history/states/466-Quebec.txt` (province 13384 ×2, identical → net
  unchanged), `history/states/695-Curacao.txt` (province 153 ×2 → naval_base silently dropped,
  coastal_bunker wins). 1.16 added a check that **reports** these (error.log / `-debug`), but does
  **not** block loading and does **not** change the runtime building outcome (same later-block-wins
  override as 1.14/1.15). They are **pre-existing** bugs that predate 1.16. Merging the duplicate
  blocks would **change game state** vs. the preserved 1.14/1.15 baseline (re-add the dropped
  buildings), so it is an owner decision, not a faithful-port edit. → UNCERTAINTIES U1 (with the
  exact merge each file needs).

- **`common/ai_templates/` (9 files, pre-1.15 schema, `match_to_count` ×):** untouched per HARD
  RULE 1 / owner decision D1 (deferred to the 1.19 endgame). Confirmed 1.16 made **no further**
  AI-template/division-designer schema change beyond the additive `front_role_override`, so the
  deferred migration target is unchanged. → noted in dossier #4/#5 + MODERNIZATION-REPORT.

- **`common/buildings/00_buildings.txt` (flat `max_level` schema, overrides vanilla building
  defs):** unchanged. 1.16 did **not** change the building-definition format — `max_level` is still
  valid (coexists with the newer `level_cap` block). The `level_cap`/`province_max`/`state_max`
  building-limit rework + Strategic Locations is **1.17**, out of scope here. Flagged for the 1.17
  agent. → dossier #7.

## Verification performed
- **Edit integrity:** `descriptor.mod:37` now `supported_version="1.16.*"`; `git diff` = exactly
  1 line changed (1 insertion / 1 deletion); encoding still ASCII, no BOM (`od` head unchanged),
  LF-only, no trailing-newline change. No brace/structure touched (descriptor has no braces beyond
  the `tags={…}` block, which was not touched).
- **Removed/renamed token sweep (whole mod, excl. pdx_documentation):** 1.16 removed/renamed no
  token the mod uses. Defensive grep of a known-removed-in-other-versions set found only the
  deferred `ai_templates` `match_to_count` (9 files, untouched) and **commented-out/inert**
  occurrences of `state_strategic_value` / `supply_node_range`. `all_enemy_country`
  (operations:304) confirmed still-valid (structural `all_<scope>` trigger; in 1.14 docs).
- **New-token collision check:** mod uses none of `bypass_effect` / `front_role_override` /
  `copy_completed_from` → no forward-reference, no name collision with the 1.16 additions.
- **Duplicate-province-buildings scan:** brace-aware Python scan of all 1250 `history/states/*.txt`
  → exactly the 3 files above; each verified by reading the file. No duplicate **scalar**
  state-building keys found within any buildings block.
- **replace_path:** all 25 targets are canonical folders 1.16 still ships under the same names
  (folder/format restructures are 1.17). MIO subfolders confirmed current.
