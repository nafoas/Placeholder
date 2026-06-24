# Jump 4 — 1.17 → 1.18 (Peace for Our Time) — Changes applied

**One mod file changed** (the `supported_version` bump). 1.18 (Peace for Our Time) is a **free update**, not
a full expansion: its headline items — a **war-score / peace-conference rebalance**, a **submarine-detection
formula overhaul**, **AI overhauls (GER/ITA/UK)**, and new **Train + Helicopter MIO content** — are
**balance / AI / content / defines** changes, **not** script-format breaks. The entire 1.18 + 1.18.X
**"Modding" section is two additive items** (`pp_spend_priority` extended to advisors; stability-check
range validation). **No token the mod uses was removed or renamed**, and where 1.18 touched a subsystem the
mod overrides, the mod is insulated by its **self-contained same-filename / replace_path overrides** (ship
hulls & modules, MIO, peace_conference, AI strategy/focuses, defines). **No BLOCKERS.** This jump resembles
Jumps 1–2 (descriptor-only), not Jump 3 (the 1.17 doctrine rework).

The two deferred owner decisions are **unaffected by 1.18**: `ai_templates` (D1) — 1.18 made no
division-designer / role-schema change; doctrines (D6) — 1.18's naval change is the submarine *detection*
formula, not the naval *doctrine* system. Both left **untouched** per HARD RULES 1 & 2.

## Changed

### `3273913964/descriptor.mod`
- **What:** `supported_version="1.17.*"` → `supported_version="1.18.*"` (line 37).
- **Why:** Required so 1.18 (Peace for Our Time) loads the mod without flagging it as made for an older
  version. `"1.18.*"` is the correct minor-wildcard form: `*` matches any 1.18.x build (1.18.0 / 1.18.1 /
  1.18.2 / …). Same convention the mod has used through every prior jump; confirmed as the dominant real-mod
  convention via GitHub code search (`"1.18.*" filename:descriptor.mod`, 99 hits — `"1.18.*"` by far most
  common; `"1.18.*.*"`/`"1.18.*.0"` also valid). File remains plain ASCII / no UTF-8 BOM (required by the
  descriptor spec; verified pre- and post-edit via `file` + `od` head = `6e 61 6d` = `nam` of `name=`; only
  the single token changed; no stray `1.17` remains; the `tags={}` braces are still balanced and untouched).
- **Source:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM rule);
  GitHub `mcp__github__search_code` `"1.18.*" filename:descriptor.mod` (convention);
  hoi4.paradoxwikis.com/Patch_1.18.X (1.18.x version table).

## Considered and intentionally NOT changed (with reason)

- **Submarine-detection overhaul** (1.18 "new submarine detection formula"): **no edit.** It is a **defines +
  formula** change — 1.18 added `SUBMARINE_BASE_STEALTH_VALUE`,
  `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`, `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER` and tuned
  their values — **NOT** a stat/modifier rename. The equipment stats that feed it (`sub_detection`,
  `sub_visibility`, `surface_detection`, `surface_visibility`, `sub_attack`, `naval_speed`, `torpedo_attack`,
  `naval_range`, `anti_air_attack`) are **all still valid** (current Equipment-modding page). The mod uses
  those stats heavily in its **own** ship-hull/module overrides (456 hits / 23 files) but uses **none** of the
  new submarine defines (grep → 0) and does not override them in `cbts_defines.lua`, so it **inherits** the
  new behavior cleanly. A stat-rename edit would be **wrong** (nothing was renamed). The only stats marked
  OBSOLETE (`fire_range`, `shore_bombardment`, `evasion`) are pre-1.18 (MtG-era) and the mod does **not** use
  them (its `shore_bombardment_bonus` is a long-standing *modifier*; `evasion` hits are loc prose). → dossier
  #2; re-tuning the new defines = MODERNIZATION; residual → UNCERTAINTIES U1.

- **Train + Helicopter MIOs** (new 1.18 vanilla MIO content for several majors): **no edit.** MIO
  organization schema is **unchanged** (`equipment_type` / `research_categories` / `allowed` / `initial_trait`
  / `trait`; no field newly required/removed). The mod `replace_path`s the MIO `organizations` folder (full
  replacement), so vanilla's new Train/Helicopter MIOs **don't load** for it — non-adoption, not a break. The
  `train_manufacturer`/`mio_header_trains` hits are the existing company designer trait + a loc header key,
  not the new MIOs. → dossier #3; adoption = MODERNIZATION.

- **War-score / peace-conference rebalance** (faction contribution 0.125→0.1; sunk-ship-IC halved): **no edit.**
  Internal **defines/AI** values, **no** peace-conference scripting token removed/renamed. The mod's own
  `common/peace_conference/*` same-filename overrides (cost_modifiers/categories/ai_peace) use unchanged
  formats, and the peace **defines** it sets (`PEACE_SCORE_PER_PASS`, `BASE_PEACE_PUPPET_FACTOR`,
  `BASE_PEACE_LIBERATE_FACTOR`) are **different** defines from the ones 1.18 changed (no conflict). →
  dossier #4; re-balancing against the new war-score = MODERNIZATION.

- **AI overhaul (GER/ITA/UK)**: **no edit.** Vanilla AI script/balance. The mod `replace_path`s
  `common/ai_strategy`, `ai_strategy_plans`, `ai_focuses`, `ai_equipment` — it **overrides vanilla AI**, so
  the 1.18 improvements live in files the mod doesn't load (non-adoption). No format break. → dossier #5;
  porting in the AI improvements = MODERNIZATION.

- **`pp_spend_priority` advisor-targeting + stability-check validation** (the entire 1.18 "Modding" section):
  **no edit.** Both **additive/internal**. The mod's existing `pp_spend_priority` usage is the category form
  (`id = admiral|relation|guarantee|…`), unchanged and still valid; the advisor-targeting capability is an
  *addition*. → dossier #6.

- **`common/ai_templates/` (9 files, pre-1.15 schema, `match_to_count` ×):** untouched per HARD RULE 1 / D1.
  Re-confirmed 1.18 made **no** AI-template/division-designer schema change (1.18's army changes are AI
  *behavior* + MIO *content*, not the division designer), so the deferred-migration target is unchanged. →
  dossier #7 + MODERNIZATION-REPORT AI-template note.

- **Doctrine files (`land_doctrine.txt`, `special_forces_doctrine.txt`, doctrine folders in
  `00_technology.txt`, the 56 doctrine `has_tech` refs):** untouched per HARD RULE 2 / D6. Re-confirmed 1.18
  made **no** doctrine-system change (1.18's naval change is the submarine *detection* formula, not the naval
  *doctrine*), so the D6 BLOCKER is unchanged by 1.18 and its migration target (1.17 Grand/Sub/Mastery schema)
  is still correct. → dossier #8.

- **`common/defines/cbts_defines.lua`:** **no edit.** Its ~110 overridden define keys are all long-standing
  core defines (NAI/NCountry/NDiplomacy/NMilitary/NOperatives/NTechnology/NTrade/NGraphics/NGame/NBuildings/
  NPolitics/NWiki); none corresponds to anything 1.18 removed (1.18's define changes were *additive* submarine
  defines + *value* tweaks to war-score/naval-strike/carrier defines the mod doesn't set). Inherited-baseline,
  not part of the 1.18 breaking surface. → dossier #2/#4; residual → UNCERTAINTIES U1.

- **Characters / decisions / on_actions / scripted_gui / states / focus / map / GUI:** untouched — no 1.18
  format break (additive or content/balance; 1.18.X hotfixes are crash/balance/content). `map/buildings.txt`
  7-column format and `history/states` building-block parsing unchanged. → dossier #9.

## Verification performed
- **Edit integrity:** `descriptor.mod:37` now `supported_version="1.18.*"`; encoding still ASCII / no BOM
  (`file` = "ASCII text"; `od` head `6e 61 6d` unchanged), no trailing-newline change (line 39
  `remote_file_id` still has no terminating newline, as in the original); **zero** remaining `1.17` strings
  anywhere; `tags={}` braces balanced/untouched. Only the single token changed.
- **Removed/renamed-token sweep (whole mod, excl. `pdx_documentation/`):** the naval equipment stats the mod
  uses (`sub_detection`, `sub_visibility`, `surface_detection`, `surface_visibility`, `sub_attack`,
  `naval_range`, etc.) **all survive on 1.18** (Equipment-modding page) — 456 hits across 23 mod override
  files, all valid. The OBSOLETE stats `fire_range`/`shore_bombardment`/`evasion` are **not used** by the mod
  (its `shore_bombardment_bonus` is a different, still-valid modifier; `evasion` hits are loc text). No other
  1.18-removed token exists (1.18 removed none the mod uses).
- **New-1.18-token collision check:** the mod uses **none** of the 1.18 additive defines/tokens —
  `grep SUBMARINE_BASE_STEALTH_VALUE|SUBMARINE_REVEAL_DETECTION_MULTIPLIER|SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER`
  over `common/` → **0**; no new Train/Helicopter MIO adoption (the `train`/`helicopter` hits are the existing
  company trait + a loc key); `pp_spend_priority` only in its long-standing category form. No forward
  references, no name collisions.
- **replace_path:** all **27** targets verified to exist on disk as canonical 1.18 folders (1.18 restructured
  none): `common/ideas`, `common/units/names_divisions`, `common/ai_strategy`, `common/ai_strategy_plans`,
  `common/decisions`, `common/on_actions`, `common/ai_focuses`, `common/scripted_triggers`,
  `common/countries`, `common/country_tags`, `common/scripted_effects`, `common/scripted_localisation`,
  `common/national_focus`, `common/ai_equipment`, `common/characters`,
  `common/military_industrial_organization/{ai_bonus_weights,organizations,policies}`,
  `common/units/codenames_operatives`, `map/strategicregions`, `history/{general,countries,units,states}`,
  `events`, `gfx/loadingscreens`, `gfx/interface/ideologies`.
