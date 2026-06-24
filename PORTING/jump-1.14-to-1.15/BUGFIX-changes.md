# Jump 1 (1.14 → 1.15) — BUGFIX PASS — Changes applied

Deep-fix pass correcting the first port's misses for the 1.14→1.15 jump. The first pass changed
only `descriptor.mod` and **mis-assessed the AI division templates as "no action"** (its own audit,
`review.md` NF-1, flagged this as the primary miss). This pass migrates the entire `ai_templates`
tree (D1) to the post-1.15 schema and re-verifies every other 1.15 modder-facing breaking change.

Format: `file:line(s) — old → new — WHY — SOURCE`.

---

## SOURCES (1.15 AI-template / division-template schema)

- **S1** — Official Patch 1.15 notes, "Database & Scripting": *"Removed a bunch of properties from
  division templates that either didn't make sense or were simply not useful."* and
  *"AI division templates now get their AI role assigned on creation based on their target template,
  rather than being dynamically matched to a role based on `match_to_count`."*
  https://hoi4.paradoxwikis.com/Patch_1.15 (read via WebSearch; the live page is JS-walled to WebFetch)
- **S2** — Wiki "AI modding" page, *AI templates* section (post-1.15 schema): role declared with a
  **singular `role = <token>`** at the block top level; each named design sub-block contains
  `upgrade_prio`, `reinforce_prio`, `custom_icon`, `enable`, `can_upgrade_in_field`,
  `target_template = { support = {…} regiments = {…} }`, and the replacement chain
  `replace_at_match` / `replace_with` / `target_min_match`. **No** `target_width`, `width_weight`,
  `column_swap_factor`, `weight`/`match_value` (inside target_template), `stat_weights`,
  `allowed_types`, `production_prio`, `match_to_count`, or `roles` (plural).
  https://hoi4.paradoxwikis.com/AI_modding
  (raw mirror: raw.githubusercontent.com/klimPaskov/Agentic-HOI4-Modding/main/paradox_wiki/AI%20modding%20-%20Hearts%20of%20Iron%204%20Wiki.md)
- **S3** — Vanilla-derived, confirmed-current mod `EaW-Team/equestria_dev`,
  `common/ai_templates/generic.txt` — uses exactly `role = infantry`, role-level `upgrade_prio`,
  sub-block `reinforce_prio` + `target_template{support,regiments}`; contains **none** of the removed
  tokens. https://github.com/EaW-Team/equestria_dev (commit d9cb88b)
- **S4** — Confirmed-1.19 mod `MillenniumDawn/Millennium-Dawn`, `common/ai_templates/MD_generic.txt` —
  same post-1.15 structure; an independent WebFetch enumerated its keys and confirmed **absence** of
  every removed token listed above. https://github.com/MillenniumDawn/Millennium-Dawn
- **S5 — the mod's own `-debug` error.log** (authoritative engine disposition). In
  `common/ai_templates/*`: `roles`(48×), `match_to_count`(48×), `target_width`(94×),
  `width_weight`(94×), `column_swap_factor`(94×), `weight`(94×), `match_value`(94×),
  `stat_weights`(57×) → `ai_strategy_template.cpp` **"Using deprecated property …"** (warn + ignore,
  loses behavior); `allowed_types`(94×) and `production_prio`(7×) → `persistent.cpp`
  **"Unexpected token"** (hard parse error that breaks the surrounding block).

---

## CHANGED — D1: AI division templates migrated to post-1.15 schema

Migration applied to all 9 files in `common/ai_templates/` (the mod does NOT `replace_path` this
folder, but ships the same canonical filenames as vanilla — `generic.txt`, `templates_<MAJOR>.txt` —
so these files override vanilla's now-updated AI templates for those majors; leaving them in the
legacy format would both spam parse errors AND make those nations' AI design divisions worse).

Transformations (each backed by S1–S5):
1. **`roles = { <token> }` → `role = <token>`** (singular scalar). 48 blocks. — *1.15 renamed the
   plural set to a single scalar role assigned on template creation.* (S1, S2, S5)
2. **Deleted `match_to_count = <n>` lines** (49 total: 48 caught by the migrator + 1 in
   `templates_JAP.txt:188` that carried a trailing inline comment, removed by hand). — *Removed in
   1.15; role is now assigned on creation from the target template, not matched dynamically.* (S1, S5)
3. **Deleted removed single-line scalars** `target_width`, `width_weight`, `column_swap_factor`,
   `weight` (the one inside `target_template`), `match_value` (≈470 lines). — *Removed division-
   template designer-AI tuning properties; no post-1.15 equivalent.* (S1, S2, S5)
4. **Deleted `stat_weights = { … }` blocks** (57). — *Removed; not in the post-1.15 `ai_templates`
   schema.* (S2, S5)
5. **Deleted `allowed_types = { … }` blocks** (94) — *HARD "Unexpected token" parse error in 1.15;
   removed from `ai_templates`.* (S2, S5)
6. **Deleted `production_prio = { … }` blocks** (7 uncommented) — *HARD "Unexpected token" parse
   error in 1.15; removed from `ai_templates`.* (S2, S5)

Commented-out lines/blocks (leading `#`, e.g. several `# production_prio = {…}`) were left untouched
(already inert; no error). The migration removes **whole** brace blocks, so brace balance is
preserved (validated: every file's brace-depth tracker stays ≥0 and ends at 0).

Design/intent **preserved**: every `role`, `upgrade_prio` (priority), `target_template`
(support+regiments = the actual division design), `reinforce_prio`, `custom_icon`,
`can_upgrade_in_field`, `enable`, and `replace_at_match`/`replace_with`/`target_min_match` is kept
verbatim. Only the removed 1.15 tuning knobs (which have no new-schema home) were stripped — exactly
what vanilla 1.19 and the reference mods (S3, S4) contain. **`target_template` block count is
identical before/after in every file** (none lost): generic 14, CHI 1, ENG 12, FRA 5, GER 15,
ITA 11, JAP 8, SOV 14, USA 14.

Per-file (lines before → after):
- `common/ai_templates/generic.txt` — 1351 → 870 — roles→role ×8, blocks/scalars removed.
- `common/ai_templates/templates_CHI.txt` — 62 → 46 — roles→role ×1.
- `common/ai_templates/templates_ENG.txt` — 1178 → 574 — roles→role ×7.
- `common/ai_templates/templates_FRA.txt` — 283 → 204 — roles→role ×3.
- `common/ai_templates/templates_GER.txt` — 1221 → 768 — roles→role ×6.
- `common/ai_templates/templates_ITA.txt` — 1189 → 555 — roles→role ×6.
- `common/ai_templates/templates_JAP.txt` — 777 → 517 — roles→role ×4 (+1 hand-removed
  `match_to_count` at old line 188).
- `common/ai_templates/templates_SOV.txt` — 1415 → 695 — roles→role ×7.
- `common/ai_templates/templates_USA.txt` — 1377 → 617 — roles→role ×6.

**Post-migration verification (all PASS):**
- Brace-stack validator: depth never negative, ends at 0 in all 9 files.
- `grep` for uncommented `match_to_count|target_width|width_weight|column_swap_factor|weight|
  match_value|stat_weights|allowed_types|production_prio|roles=` across `common/ai_templates/` → **0**.
- `role =` (singular) now present in every file; `target_template` counts unchanged vs. backup.
- Backup of the originals kept at
  `scratchpad/ai_backup/` for diffing.

---

## VERIFIED — other 1.15 changes the mod touches (NO code change required, with evidence)

### `terrain_penalty_reduction` — NOT removed in 1.15; leave all 5 usages unchanged. (CONFIRMED)
The brief flagged this ("`terrain_traits_xp_gain` is NOT a drop-in rename — verify and handle
correctly"). **Verified the token was NOT deleted; it is still a valid modifier in `army`/`defensive`
(`unit_leader`) scope.** A rename to `terrain_traits_xp_gain` would silently change behavior (that
modifier grants XP toward terrain-specialist commander traits — a *different* effect) and is
therefore forbidden. Evidence:
- 1.15 patch note (S1 page): *"Replaced Terrain Penalty Reduction modifier which was not working in
  National Spirits by the modifier Terrain Traits XP Gain."* This describes Paradox swapping which
  modifier **vanilla's own national spirits** reference (because `terrain_penalty_reduction` never
  worked in NS scope) and adding a new NS modifier — it does **not** delete the token.
  https://hoi4.paradoxwikis.com/Patch_1.15
- The mod's own bundled 1.14 docs categorize it `["army","defensive"]`
  (`pdx_documentation/script_documentation.json:5879-5882`;
  `pdx_documentation/modifiers_documentation.md:3645-3648`) — i.e. it was always a unit_leader/army
  modifier, never a state/country (national-spirit) one, which is exactly why Paradox's note says it
  "was not working in National Spirits."
- Current (2026-05-21) wiki Modifiers mirror still documents it as valid with note "Only works in the
  unit_leader scope" (per the prior independent audit `review.md` §C2). https://hoi4.paradoxwikis.com/Modifiers
- **Per-usage:** `common/unit_leader/00_traits.txt:1162` (trait `adaptable`, unit_leader scope) —
  **works**, unchanged. `common/ideas/japan.txt:940`, `common/ideas/ethiopia.txt:277`,
  `common/ideas/PAR_ideas.txt:16` & `:35` (all inside `country={modifier={…}}` NS blocks) — inert in
  NS scope, but this was **already true on 1.14** (wrong category) → no regression, non-fatal.
- **Action: none.** Not a 1.15 breakage. The mod's loc `MODIFIER_TERRAIN_PENALTY_REDUCTION` also
  stays valid.

### `map/airports.txt` & `map/rocketsites.txt` — deprecated/removed in 1.15, inert, non-fatal.
The engine simply stops reading them post-1.15; the mod's `map/buildings.txt` already carries the
`air_base`/`rocket_site` placement. Unknown/leftover files in `map/` produce no load error, and the
mod does not `replace_path="map"`. **Action: none** (deletion would be an unrequested content
change). Behavior-fidelity check (province placement) is an owner in-game item, not a load fix —
already logged in this jump's `UNCERTAINTIES.md`/`review.md` OD-1.
Source: https://hoi4.paradoxwikis.com/Map_modding (verbatim deprecation line).

---

## OUT OF SCOPE (verified, deliberately NOT touched)

- **`common/ai_equipment/*`** (tank/ship/plane variant design) uses `roles`, `match_value`,
  `stat_weights`, `allowed_types` — these belong to the **separate `ai_equipment` schema** where they
  remain valid. The mod's `-debug` error.log flags **zero** `ai_equipment` files. Left untouched.
- Token reuse in `common/terrain/00_terrain.txt` (`match_value`), `common/ideas/CAT_ministers.txt`
  (`roles`), `common/units/equipment/plane_airframes.txt` (`stat_weights`/`allowed_types`) — different
  systems, not flagged by the engine. Left untouched.
- **Equipment-stat "Unexpected token" errors** (`naval_supremacy_factor`,
  `naval_general_support_value_factor`, etc.) and the **subunit-category / regimental-support** errors
  are **1.19** changes (naval-support modifiers + regimental-support equipment), NOT 1.15 — they
  belong to the 1.19 agent. Confirmed not 1.15 via the 1.15 changelog (those tokens are absent from
  the 1.15 "Database & Scripting" additions/removals).

---

## Net result
**9 files changed** (all in `common/ai_templates/`). The mod's AI division templates now load on
1.19 without the ~625 deprecated-property warnings and the `allowed_types`/`production_prio` hard
parse errors, and FUNCTION on the post-1.15 designer-AI schema with every division design preserved.
No other 1.15 modder-facing change requires a code edit (terrain modifier verified non-removed;
airports/rocketsites inert). No escalation required.
