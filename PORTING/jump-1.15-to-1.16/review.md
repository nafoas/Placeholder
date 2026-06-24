# Jump 2 — 1.15 → 1.16 (Graveyard of Empires) — Independent audit / deconstruction

**Auditor:** Jump-2 Deconstructor/Audit Agent (independent of the updater).
**Date:** 2026-06-24.
**Mandate:** hunt for flaws the updater missed or got wrong; never guess; cite + state confidence per
claim. No mod files edited; no commit; findings-only.

## VERDICT (read first)

**Jump 2 is SOUND as-committed. No load-blocking defect found. No NEEDS-FIX item.**

I tried to break the updater's "1.16 broke nothing the mod uses; only the `supported_version` bump
is required" conclusion from multiple independent angles and could not. Every load-bearing claim
re-verified true against primary/secondary sources I gathered myself (not just the updater's). The
mod will LOAD and RUN on 1.16; the only mod-file change in the Jump-2 commit is the one required
line. The three duplicate-province items remain an OWNER DECISION (content fidelity), exactly as the
updater classified them — independently confirmed pre-existing and non-load-bearing.

Residual exhaustiveness risk on the full verbatim 1.16.0 "Database" section is **the same MEDIUM-HIGH
the updater honestly flagged** (the section is unobtainable through every rendering channel that
exists here); I add new *negative* evidence that strengthens it but cannot make it 100%. The correct
final mitigation is unchanged: a `-debug` `error.log` pass at end-of-port.

---

## Method (independent)

- Re-derived the 1.16 modder-facing surface myself via the `WebSearch` backend against the live wiki
  Patch_1.16 / Patch_1.16.X pages from ~14 fresh query angles (incl. explicit "Removed/Renamed/
  Changed/no longer" probes).
- **New channel the updater did not exploit: GitHub code search (`mcp__github__search_code`) over the
  whole public HOI4 modding corpus** — used to positively confirm define/token survival into 1.16+
  against real version-current mods (notably the live Kaiserreich repo, which tracks 1.16→1.19) and
  against multiple verbatim vanilla `00_defines.lua` dumps. This is authoritative for "does token X
  still exist" in a way the JS-walled wiki is not.
- Re-read all 3 state files, the descriptor, `cbts_defines.lua`, `00_buildings.txt`, `bop/*`,
  `script_enums.txt`; re-ran an **independent brace-aware duplicate-province scan** of all 1250
  `history/states/*.txt`; used `git log`/`git show`/`git log -S` to verify provenance and the exact
  Jump-2 diff.
- Confirmed the GitHub markdown mirror (`klimPaskov/Agentic-HOI4-Modding`, last updated 27 Nov 2025,
  ≈1.18/1.19 pages) has **no Patch-1.16 page** (raw 404) — the updater's claim is true — and read its
  National-focus / AI / State reference pages via the correct `… - Hearts of Iron 4 Wiki.md`
  filename convention.

Channel reality confirmed (matches the briefing): live wiki & forum & Steam announcement bodies do
NOT render to WebFetch (error-page or chrome-only); `web.archive.org` blocked; the WebSearch backend
CAN read wiki *body* detail (it surfaced the Patch_1.19 "Removes support for
`add_temporary_buff_to_units`" line verbatim — proving it *would* surface a 1.16 removal line if one
existed) but **could not** read the forum release-notes thread or Steam announcement body for 1.16.

---

## CONFIRMED CORRECT (independently re-verified)

### C1 — Descriptor edit is correct and complete (dossier #1, #5)
- `descriptor.mod:37` = `supported_version="1.16.*"`. `"MAJOR.MINOR.*"` is the documented wildcard
  form (wiki Mod_structure; examples `1.8.*`, `1.11.*`), matching all 1.16.x builds. **Confirmed.**
- File is plain **ASCII, no UTF-8 BOM** (`file` → "ASCII text"; `od -c` shows it begins `n a m e =`
  with no BOM bytes) — satisfies the descriptor no-BOM rule. **Confirmed.**
- `git show 801306c` proves the Jump-2 commit's **only mod-file change is this single line**
  (1 insertion / 1 deletion); all other files in the commit are PORTING docs. The pre-existing
  "no newline at end of file" is unchanged on both sides. **"Exactly one mod edit" verified.**
- *Sources:* hoi4.paradoxwikis.com/Mod_structure (wildcard + no-BOM, via WebSearch backend);
  Kaiserreich/Kaiserreich-HOI4 `descriptor.mod` (real wildcard descriptor); local `git`, `file`, `od`.

### C2 — 1.16 modder-facing surface is ADDITIVE; the mod uses none of it (dossier #2, #3, #4)
Independently re-confirmed the 1.16.0 modding additions are exactly:
1. `bypass_effect = { … }` on national focuses — an **effect**, distinct from the existing `bypass`
   **trigger**. Both keys valid/non-deprecated on the current National-focus-modding page.
2. `load_focus_tree` gains optional `copy_completed_from`.
3. `front_role_override` for division templates.
4. (1.16.1) `count` for `any_object` triggers.
- Whole-repo greps: the mod uses none of `bypass_effect`, `copy_completed_from`,
  `front_role_override`; it uses `bypass` (trigger) and `load_focus_tree` with the long-standing
  params only. No collision, no forward reference. **Confirmed.**
- The backend's enumeration of the 1.16.0 modding section returned **only these additions — no
  Removed/Renamed/format line** on any of ~14 angles. (See SU1 for the exhaustiveness caveat.)
- I also chased the one "extra" lead the updater's notes didn't mention: search noise about
  `build_railway` / `create_entity` / `set_entity_*` effects. **Ruled out as not-1.16** — the
  `build_railway`/nudger-railways feature traces to a 2021 dev diary (No Step Back era, ~1.11), not
  1.16. Not a regression; the mod doesn't use them anyway.
- *Sources:* wiki Patch_1.16 / Patch_1.16.X (WebSearch backend); mirror
  `National focus modding - … .md` (both `bypass` and `bypass_effect` documented, neither deprecated);
  repo greps.

### C3 — Defines overrides are valid on 1.16; this was the highest silent-failure risk and it is clean
This is the area the updater treated only lightly, and the place a renamed/removed key fails
*silently* (logged, ignored, game still loads). I audited `common/defines/cbts_defines.lua` in full.
- The file uses the **recommended single-member override pattern** (`NDefines.X.Y = value`), and the
  mod ships **no full `00_defines.lua`/`00_graphics.lua`** (verified by `find`). This avoids the known
  "missing define in a copied defines file → crash on startup" footgun. **Good.**
- I scrutinised the two keys that looked most at-risk given a 1.16/1.17 "AI scoring for defense areas
  from defines" patch line: `NDefines.NAI.AREA_DEFENSE_SETTING_VP` and `…_COASTLINES`. **Both are
  real, current vanilla defines** — confirmed via (a) multiple verbatim vanilla `00_defines.lua`
  dumps on GitHub showing the canonical block `AREA_DEFENSE_SETTING_FORTS/_COASTLINES/_RAILWAYS/_VP`,
  and (b) the **live Kaiserreich `KR_defines.lua` (tracks 1.16+)** actively setting
  `AREA_DEFENSE_SETTING_COASTLINES = false -- Vanilla is true` and `AREA_DEFENSE_SETTING_VP = true`.
  The "AI scoring for defense areas from defines" patch note refers to **additive** new keys
  (`PLAN_AREA_DEFENSE_*_IMPORTANCE`), which do not touch the mod's existing keys. So the mod's
  `AREA_DEFENSE_SETTING_VP = true` / `_COASTLINES = false` overrides remain effective on 1.16. **No
  issue.**
- The other active overridden defines (NAI invasion/battleplan, NMilitary, NDiplomacy, NOperatives,
  NGraphics, NCountry, etc.) are long-standing keys; none surfaced in any 1.16 change. `cbts_defines.lua`
  was untouched by Jump 1/Jump 2 (`git log` → only the 1.14 baseline), so the port introduced nothing
  here.
- *Sources:* `mcp__github__search_code` AREA_DEFENSE_SETTING_VP / _COASTLINES (Kaiserreich + ≥8 vanilla
  dumps); wiki Defines page (existence); modder guidance "never ship 00_defines.lua" (forum, via
  WebSearch); local `find`/`git`.

### C4 — AI templates correctly left untouched; 1.16 did not move the deferred target (dossier #4, #5)
- Current AI-modding page documents singular `role =`; **`match_to_count` is absent** from the current
  schema docs (confirms it was removed in the 1.15 rework). The mod's 9 legacy files still using
  `match_to_count` are therefore pre-1.15 schema — the owner-deferred item (D1), correctly **not
  touched** this jump.
- 1.16's only AI-template/division-designer change is the additive `front_role_override` (C2) — it
  does **not** re-target the deferred migration. **Confirmed.**
- *Sources:* mirror `AI modding - … .md` (singular `role`; no `match_to_count`); repo grep.

### C5 — `00_buildings.txt` flat `max_level` is valid on 1.16; 1.17 rework correctly out of scope (U3, dossier #7)
- Read the file: it uses **only** flat `max_level = N` (17 entries) + `shares_slots`; **zero**
  `level_cap` / `province_max` / `state_max` (verified by grep). That is the pre-1.17 schema and is
  valid on 1.16. The `level_cap`/Strategic-Locations rework is 1.17. **Confirmed out of scope.** (The
  file overrides vanilla building defs by filename, so the 1.17 agent must re-verify it then — already
  flagged in U3.)
- *Sources:* file read + grep; wiki Building_modding / Patch_1.17 (rework is 1.17, via WebSearch).

### C6 — Removed-in-other-versions tokens appear only in inert/commented lines (dossier #10)
- Defensive whole-repo grep for a known-risky token set. The only hits for genuinely
  removed/changed tokens are **commented**: `supply_node_range` (`country_leader/00_traits.txt:2174`,
  `# supply_node_range = 0.15`) and `state_strategic_value`
  (`on_actions/07_nsb_on_actions.txt:179/268/272`, all inside `# …` lines). Not parsed → no effect.
  Other matches (`create_wargoal`, `annex_country`, `release_puppet`, `give_resource_rights`,
  `naval_strike`, `air_map_icon`) are long-standing valid tokens, not 1.16-changed. **Confirmed.**
- *Sources:* repo grep + line reads.

---

## OWNER DECISION (behavior-fidelity; not load-blocking — updater classified these correctly)

### O1 — U1 duplicate province building blocks in 3 state files
**Independently reproduced and confirmed exactly as the updater reported.** My own brace-aware scan of
all **1250** `history/states/*.txt` returns precisely three files with a duplicate province sub-block
inside `buildings` — and no others:
- `327-Philippines.txt`: prov **10265** twice — `{ bunker=1 (Fort William McKinley); coastal_bunker=4 }`
  (L20-23) then `{ naval_base=4 }` (L24-26). Later block wins → bunker + coastal_bunker silently
  dropped.
- `466-Quebec.txt`: prov **13384** twice — `{ naval_base=1 }` (L15-17) and `{ naval_base=1 }` (L21-23),
  with an unrelated `13405` block between them. **Identical values → net unchanged.**
- `695-Curacao.txt`: prov **153** twice — `{ naval_base=1 }` (L13-15) then `{ coastal_bunker=2 }`
  (L16-18). Later block wins → naval_base silently dropped.

Disposition **confirmed = OWNER DECISION, not NEEDS-FIX**, on three independent grounds:
1. **Pre-existing.** `git log` shows all three files were last modified at the **1.14 baseline import**
   (`5074c94`) and were **not** touched by Jump 1 or Jump 2. The silent-override behavior is identical
   on 1.14/1.15/1.16; 1.16 changed only *reporting*. (The updater's "pre-existing" claim (a) — TRUE.)
2. **Non-load-bearing on 1.16.** Independently corroborated: the wiki frames the 1.16 check as "a
   warning mechanism for modders to catch these errors" (a report, surfaced under `-debug` in
   `error.log`); Troubleshooting confirms validation errors are logged and the game continues. Not a
   CTD, not a load-block. (Claim (b) — TRUE.)
3. **Fixing it changes game state vs. the preserved baseline** (re-adds the dropped buildings), which
   is precisely the kind of content change a faithful port reserves for the owner. The updater's
   proposed merges are correct **as the likely-intended fix**, and I'll restate them so the owner has
   them in one place (claim (c) — the merges are correct; note Quebec is a pure de-dup, no value
   change):
   - Philippines `10265 = { bunker = 1  coastal_bunker = 4  naval_base = 4 }` (verify intended
     `naval_base` level — currently the 2nd block's `4` wins).
   - Quebec `13384 = { naval_base = 1 }` (drop the duplicate; no value change).
   - Curaçao `153 = { naval_base = 1  coastal_bunker = 2 }`.

Confidence: **HIGH** on classification and on the scan being exhaustive.
*Sources:* independent brace-aware scan (1250 files); `git log` per file; wiki Patch_1.16.X +
Troubleshooting + State_modding (via WebSearch backend).

---

## STILL UNCERTAIN (best evidence; unchanged risk level, with new supporting evidence)

### SU1 — Full verbatim base-1.16.0 "Database/Modding" changelog section not obtainable (updater U2)
- **Status: confirmed unobtainable here, exactly as the updater stated.** I independently hit every
  channel: live wiki Patch_1.16 (WebFetch → error page), Steam announcement
  `…detail/517454908873508473` (chrome only / 403), the forum release-notes thread `…1730282`
  (WebFetch error; WebSearch backend also will not open this thread body), `patchbot.io` (only shows
  1.18/1.19), `updatecrazy` 1.16.5 mirror (gameplay only, no modding section), GitHub mirror
  (**no Patch-1.16 page**, raw 404), `web.archive.org` (egress-blocked).
- **New negative evidence raising confidence (but not to certainty):**
  (i) The WebSearch backend demonstrably *can* surface a wiki "Removes support for …" modding line —
  it returned Patch_1.19's `add_temporary_buff_to_units` removal verbatim — yet across ~14 explicit
  "Removed/Renamed/Changed/no longer" probes of Patch_1.16 it surfaced **only the four additions**,
  never a removal. Absence is therefore at least partly *informative*, not merely a fetch failure.
  (ii) Positive token-survival now confirmed against a **version-current real mod** (Kaiserreich
  1.16→1.19) for the one silent-risk class I considered most exposed (defines, incl.
  `AREA_DEFENSE_SETTING_*`), plus `bypass`/`bypass_effect`, `role`, `max_level`, per-province
  buildings syntax.
- **Best-supported call (unchanged):** 1.16 removed/renamed/format-changed **no** script token the mod
  uses. Confidence **HIGH** for the positively-confirmed items; **MEDIUM-HIGH** on exhaustiveness over
  the mod's ~1,993 `common/` files. The mod will LOAD. No crash asserted.
- **Residual risk:** a low-profile removed/renamed token somewhere in `common/` that no reachable
  source enumerated for 1.16, producing a *silent* behavior drift (not a load-break). **Mitigation
  (recommended, carry to end-of-port): one `-debug` run on 1.16 and grep `error.log` for `unknown` /
  `unexpected token` / `invalid` / the duplicate-province-building warning over the mod's files.** This
  is the same SU-2 mitigation as Jump 1 and is the only thing that closes this to 100%.

---

## Peripheral observations (NOT Jump-2 defects — pre-existing, 1.16-irrelevant; logged for completeness)

These are **not** chargeable to Jump 2 and **not** load-blocking; 1.16 does not touch them and the
faithful-port mandate is "fix only what 1.16 broke." Noting them only so they aren't mistaken for
audit gaps, and as candidates for the owner's general-cleanup backlog:

- **`common/bop/*.txt` are all empty (0 bytes):** BRA, DEN, ETH, FIN, ITA, SWE, SWI. `common/bop` is
  **not** in `replace_path`, so these are harmless empty additive overlays (ignored by the parser);
  not introduced by the port. No action.
- **`common/script_enums.txt` line 1 authoring artifact:** the line reads
  `\tsmall_planescript_enum_operative_mission_type = {` — the string `small_plane` is concatenated
  onto the enum name (file is CRLF). Last touched at the **1.14 baseline** (untouched by either jump);
  `script_enums` parsing is unchanged by 1.16. Effect (pre-existing, version-independent): the parser
  likely reads a malformed enum name, so that operative-mission enum override may be silently
  ineffective — but it is **not** a 1.16 regression and **not** load-blocking. Owner may wish to fix
  the glued token independently of this port.

---

## Bottom line for the orchestrator
The updater's conclusion holds under independent attack. **Commit Jump 2 as-is.** One required edit,
correctly made; everything else 1.16 did is additive and unused by the mod, or a pre-existing
content/authoring matter the port rightly left to the owner. The only open item is the
already-acknowledged inability to diff the full verbatim 1.16.0 Database section — for which I add
stronger negative evidence and the standard `-debug error.log` close-out.
