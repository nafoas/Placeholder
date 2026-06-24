# Jump 5 — 1.18 → 1.19 (Thunder at our Gates) — Changes applied

**Three mod files changed** — and unlike Jumps 1, 2, 4 (descriptor-only) and Jump 3 (escalated, no edit), this
final jump required a **real removed-token fix**. 1.19 (Thunder at our Gates) is the one patch in the
1.14→1.19 ladder that ships an explicit modder-facing **removal**: it *"Removes support for
`add_temporary_buff_to_units` and adds new `unit_modifiers` to cover these use cases. All Army HQ abilities now
use `unit_modifiers`."* The mod used `add_temporary_buff_to_units` in **4** army-leader abilities, so those were
faithfully migrated to the new `unit_modifiers` block. Everything else 1.19 changed (Army HQs, Ship Captains,
the Special-Forces rework, Regimental Support, and the new modding tokens `unlock_subunit` /
`captured_army_leader` / `ship_modifiers` / `officer_xp` / subdoctrine `xor`/`allow_in_multiple_tracks` /
`is_leader_visible` / `casualty_trickleback`-as-modifier / decision `war_with_*` scoped variables) is
**additive / content / balance**, and the mod uses none of the new tokens (or only pre-existing forms that
remain valid). **No BLOCKERS.**

The two deferred owner decisions are **unaffected by 1.19's load surface**: `ai_templates` (D1) — 1.19 made no
division-designer **role-schema** change (its designer change is the additive Regimental-Support row + Army-HQ
companies); doctrines (D6) — 1.19's doctrine work (a **fourth Special-Forces doctrine page**, subdoctrine `xor`
/ `allow_in_multiple_tracks` / multi-track assignment, Dispersed Operations subdoctrine) is doctrine-system
**addition** on top of the 1.17 schema and **removes/renames no token the mod's old-format doctrines use**.
Both left **untouched** per HARD RULES 1 & 2. The D6 migration target is updated for the eventual endgame work
(see dossier #8 and the report below).

## Changed

### `3273913964/descriptor.mod`
- **What:** `supported_version="1.18.*"` → `supported_version="1.19.*"` (line 37).
- **Why:** Required so 1.19 (Thunder at our Gates) loads the mod without flagging it as made for an older
  version. `"1.19.*"` is the correct minor-wildcard form: `*` matches any 1.19.x build (1.19.0 / 1.19.0.1 /
  1.19.1 / …). Same convention the mod has used through every prior jump; confirmed as the dominant real-mod
  convention via GitHub code search (`"1.19" filename:descriptor.mod` — `"1.19.*"` is the common HOI4-mod form:
  EaW/equestria_dev, Donbass-Flames, Red-Liberty, Rise-of-Nations-Redux, Choo-Choo-Oreo/RD_T, Paradox-CZ-SK,
  bronesmod, New-Ways; some pin tighter, e.g. Kaiserreich `"1.19.1.*"`, MFU `"1.19.0.1"` — all valid). File
  remains plain ASCII / no UTF-8 BOM (required by the descriptor spec; verified pre- and post-edit via `file` +
  `od` head = `6e 61 6d` = `nam` of `name=`; only the single token changed; no stray `1.18` remains; the
  `tags={}` braces are still balanced and untouched).
- **Source:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM rule);
  GitHub `mcp__github__search_code` `"1.19" filename:descriptor.mod` (convention);
  hoi4.paradoxwikis.com/Patch_1.19.X (1.19.x version table).

### `3273913964/common/abilities/generic_leader_abilities.txt`  — 3 abilities migrated
1.19 removed the effect `add_temporary_buff_to_units` (used here in `one_time_effect` blocks). The three
abilities that used it were re-expressed with the ability-level **`unit_modifiers = { … }`** block — the
documented 1.19 replacement, and the exact form vanilla 1.19 itself ships for these (verified against the
confirmed-1.19 `EoaNB-Team/EoaNB` and `mengxinxier/Adorable-heart-beta1` `generic_leader_abilities.txt`).
**All stat values preserved 1:1**; only the wrapper and three key-renames changed (see mapping below).

- **`force_attack`** (was lines 35–47): `one_time_effect { add_temporary_buff_to_units { combat_offense=0.2
  combat_breakthrough=0.25 org_damage_multiplier=-1.0 str_damage_multiplier=0.6
  war_support_reduction_on_damage=0.2 cannot_retreat_while_attacking=1.0  days=7  tooltip=… } }`
  → **`unit_modifiers { offence=0.2  breakthrough_factor=0.25  org_damage_multiplier=-1.0
  str_damage_multiplier=0.6  war_support_reduction_on_damage=0.2  cannot_retreat_while_attacking=1.0 }`**.
- **`last_stand`** (was lines 66–78): `one_time_effect { add_temporary_buff_to_units { combat_defense=0.2
  combat_entrenchment=0.25 org_damage_multiplier=-1.0 str_damage_multiplier=0.6
  war_support_reduction_on_damage=0.2 cannot_retreat_while_defending=1.0  days=7  tooltip=… } }`
  → **`unit_modifiers { defence=0.2  combat_entrenchment=0.25  org_damage_multiplier=-1.0
  str_damage_multiplier=0.6  war_support_reduction_on_damage=0.2  cannot_retreat_while_defending=1.0 }`**.
- **`SOV_last_stand`** (was lines ~347–362): had a pre-existing `unit_modifiers { paradrop_organization_factor=
  -1.0  paratrooper_aa_defense=-1.0 }` **plus** a `one_time_effect { add_temporary_buff_to_units {
  combat_offense=-0.2 combat_defense=0.2 combat_entrenchment=0.25 org_damage_multiplier=-0.8
  str_damage_multiplier=0.5  days=7  tooltip=… } }`. **Merged** the converted stats into the existing
  `unit_modifiers` block and removed the `one_time_effect`: now `unit_modifiers {
  paradrop_organization_factor=-1.0  paratrooper_aa_defense=-1.0  offence=-0.2  defence=0.2
  combat_entrenchment=0.25  org_damage_multiplier=-0.8  str_damage_multiplier=0.5 }`.

- **Key-rename map (verified against vanilla 1.19, NOT guessed — see dossier #2):**
  `combat_offense`→`offence`, `combat_defense`→`defence`, `combat_breakthrough`→`breakthrough_factor`;
  `combat_entrenchment`, `org_damage_multiplier`, `str_damage_multiplier`, `war_support_reduction_on_damage`,
  `cannot_retreat_while_attacking`, `cannot_retreat_while_defending` **unchanged** (these are valid
  `unit_modifiers` keys — vanilla 1.19 `force_attack`/`last_stand` ship them inside `unit_modifiers`). `days`
  and `tooltip` **dropped** (the ability's `duration` governs the modifier window; vanilla 1.19 omits both).
- **Untouched in this file:** the unrelated `extra_suplies` ability's `one_time_effect = { supply_units = 168 }`
  (now line ~274) — a DIFFERENT, still-valid effect (also present in vanilla 1.19); left as-is. All other
  abilities already used `unit_modifiers` correctly and were unchanged.
- **Source:** wiki Patch_1.19 "Modding" line + xpgained 1.19 mirror (verbatim removal + replacement); vanilla
  1.19 form via `EoaNB-Team/EoaNB` + `mengxinxier/Adorable-heart-beta1` raw reads; ~30-repo GitHub `search_code`
  cross-confirm of `offence`/`breakthrough_factor`.

### `3273913964/common/abilities/GER_abilities.txt`  — 1 ability migrated
- **`GER_bewegungskrieg`** (was lines ~23–36): had a pre-existing `unit_modifiers { army_armor_attack_factor=
  0.05  army_armor_speed_factor=0.05  army_defence_factor=-0.1  air_cas_present_factor=0.1 }` **plus** a
  `one_time_effect { add_temporary_buff_to_units { str_damage_multiplier=0.25  days=7  tooltip=… } }`.
  **Merged** the converted stat into the existing `unit_modifiers` block and removed the `one_time_effect`: now
  `unit_modifiers { army_armor_attack_factor=0.05  army_armor_speed_factor=0.05  army_defence_factor=-0.1
  air_cas_present_factor=0.1  str_damage_multiplier=0.25 }`. (`str_damage_multiplier` is unchanged; `days`/
  `tooltip` dropped.)
- **Source:** as above (same 1.19 removal + vanilla migration form).

## Considered and intentionally NOT changed (with reason)

- **Army HQs / Ship Captains / Special-Forces rework / Regimental Support** (the 1.19 headline systems): **no
  edit** (beyond the `unit_modifiers` migration above, which is the same change vanilla applied to its own
  Army-HQ abilities). All four are **new systems + content** — no token the mod uses in `common/units` /
  `common/characters` / `common/unit_leader` was removed/renamed. SF rework retains
  Mountaineers/Marines/Paratroopers (`special_forces=yes`/`marines=yes`/`mountaineers=yes`/`paratrooper={…}`/
  `can_be_parachuted=yes`/`category_special_forces|marines|mountaineers` all still valid); Ship Captains work
  within the existing `navy_leader` framework (mod uses standard `corps_commander`×388 / `field_marshal`×67 /
  `navy_leader`×84). Adoption = MODERNIZATION (the SF fourth-doctrine page also belongs to deferred D6). →
  dossier #3.

- **1.19 additive modding tokens** (`unlock_subunit`, `captured_army_leader`, `ship_modifiers`,
  `allow_in_multiple_tracks`, `is_leader_visible`, subdoctrine `xor`, unit-medal `officer_xp`,
  `casualty_trickleback`-as-modifier): **no edit.** Whole-mod grep → the mod *uses* **none** of the new tokens
  (0 hits each). The `casualty_trickleback` (64), `officer_xp` (6), and `xor` (33) hits are **pre-existing,
  unrelated** forms: `casualty_trickleback` = an equipment/tech **bonus stat** the mod already used on 1.14–1.18
  (`script_enums.txt`, `technologies/support.txt`, `field_hospital.txt`, … — additive modifier registration
  doesn't break it); `officer_xp` = `modifier_trait_*_officer_xp_gain_factor` **loc strings**; `xor` = the
  long-standing **technology-exclusivity** syntax in the deferred `land_doctrine.txt`. → dossier #4.

- **Decision `war_with_on_remove/timeout/complete` "now scoped variables"**: **no edit.** Additive — the fields
  now *also* accept `var:…` targets; the literal-`TAG` form the mod uses (`war_with_on_remove = DEN/NOR/BEL/…`,
  8 active in `GER.txt`) is unchanged and ubiquitous on 1.19. → dossier #5.

- **`common/ai_templates/` (9 files, pre-1.15 schema, `match_to_count` ×):** untouched per HARD RULE 1 / D1.
  Re-confirmed 1.19 made **no** AI-template/division-designer **role-schema** change (its designer change is the
  additive Regimental-Support row + Army-HQ companies), so the deferred-migration target is unchanged. →
  dossier #7 + MODERNIZATION-REPORT AI-template note.

- **Doctrine files (`land_doctrine.txt`, `special_forces_doctrine.txt`, doctrine folders in
  `00_technology.txt`, the 56 doctrine `has_tech` refs):** untouched per HARD RULE 2 / D6. 1.19's doctrine
  changes (a **fourth Special-Forces doctrine page**; subdoctrine `xor` / `allow_in_multiple_tracks` /
  multi-track assignment; Dispersed Operations subdoctrine) are doctrine-system **additions** on top of the 1.17
  schema and **remove/rename no token** the mod's old-format doctrines use — the same degraded-but-runnable D6
  posture as Jump 3 left it. **D6 migration target updated** for the endgame: 1.17 Grand/Sub/Mastery schema
  **plus** 1.19's SF fourth-doctrine page + subdoctrine `xor`/`allow_in_multiple_tracks`/multi-track. →
  dossier #8.

- **Equipment / MIO / medals / states / buildings / map / GUI / focus / on_actions / scripted_gui:** untouched
  — no 1.19 format break the mod uses. Medals (`00_medals.txt`, `00_default.txt`) unchanged-format; the
  additive `ship_modifiers`/`officer_xp` medal fields are unused. `map/buildings.txt` 7-column +
  `history/states` block parsing unchanged. The new content focus trees (Australia/Democratic-Elections, Siam,
  Dutch East-Indies) + naval balance + 1.19.0.1/1.19.1 hotfixes (Civil War CTD; major-exploit fixes) remove no
  script token. → dossier #6, #9.

## Verification performed
- **Edit integrity (descriptor):** `descriptor.mod:37` now `supported_version="1.19.*"`; encoding still ASCII /
  no BOM (`file` = "ASCII text"; `od` head `6e 61 6d` unchanged); **zero** remaining `1.18` strings; `tags={}`
  braces balanced/untouched; only the single token changed.
- **Edit integrity (abilities):** removed-token sweep `grep -rn add_temporary_buff_to_units` over the whole mod
  (excl. `pdx_documentation/`) → **0** (was 4). Stale-key sweep `grep combat_offense|combat_breakthrough|
  combat_defense` over `common/abilities/` → **0** (all correctly mapped to `offence`/`breakthrough_factor`/
  `defence`). Brace balance: `generic_leader_abilities.txt` 84 `{` / 84 `}` BALANCED;
  `GER_abilities.txt` 12 `{` / 12 `}` BALANCED. Encoding preserved: both files `ASCII text, with CRLF line
  terminators`, no BOM (`od` head `61 62 69` = `abi` of `ability`). The migrated `force_attack`/`last_stand`
  blocks match the verified vanilla-1.19 form byte-for-key. The unrelated `extra_suplies`
  `one_time_effect { supply_units = 168 }` is intact (still-valid effect).
- **New-1.19-token collision check:** the mod uses **none** of the 1.19 additive tokens — grep for
  `unlock_subunit` / `captured_army_leader` / `ship_modifiers` / `allow_in_multiple_tracks` / `is_leader_visible`
  → **0** each; `casualty_trickleback`/`officer_xp`/`xor` hits are pre-existing unrelated forms (stat / loc /
  doctrine-tech-exclusivity); `war_with_on_remove` only in the still-valid literal-TAG form. No forward
  references, no name collisions.
- **SF / character / unit_leader schema check:** the mod's special-forces sub_unit tokens
  (`special_forces`/`marines`/`mountaineers`/`paratrooper`/`can_be_parachuted`/`category_*`) all persist on 1.19
  (SF rework retains them); `corps_commander`/`field_marshal`/`navy_leader` unaffected (Ship Captains within
  `navy_leader`); unit_leader traits/skills unaffected. → no edit needed in those subsystems.
- **replace_path:** all **27** targets verified to exist on disk as canonical 1.19 folders (1.19 restructured
  none): `common/ideas`, `common/units/names_divisions`, `common/ai_strategy`, `common/ai_strategy_plans`,
  `common/decisions`, `common/on_actions`, `common/ai_focuses`, `common/scripted_triggers`,
  `common/countries`, `common/country_tags`, `common/scripted_effects`, `common/scripted_localisation`,
  `common/national_focus`, `common/ai_equipment`, `common/characters`,
  `common/military_industrial_organization/{ai_bonus_weights,organizations,policies}`,
  `common/units/codenames_operatives`, `map/strategicregions`, `history/{general,countries,units,states}`,
  `events`, `gfx/loadingscreens`, `gfx/interface/ideologies`.
- **Working-tree scope:** `git status --short` shows exactly the three intended mod files modified
  (`descriptor.mod`, `common/abilities/generic_leader_abilities.txt`, `common/abilities/GER_abilities.txt`) —
  no `ai_templates`, no doctrine files, no stray edits.
