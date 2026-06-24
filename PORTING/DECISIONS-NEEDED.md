# Owner Decisions — running list (resolve at end-of-port review)

Behavior/scope choices only the owner can rule on. **None blocks loading.** The single
highest-leverage step to resolve most of these is to run **1.19 with `-debug`** at the end and
send me the `error.log` — that turns static-analysis "probably" into engine-confirmed fact.

---

## D1 — AI division templates are in the obsolete pre-1.15 schema  ⚠️ HIGH PRIORITY
**Facts (verified by grep + audit):** `3273913964/common/ai_templates/` has 9 files
(`generic.txt` + `templates_{GER,SOV,USA,ENG,FRA,ITA,JAP,CHI}.txt`) using removed/legacy keys:
`match_to_count` (48×), `roles` plural (48×; the post-1.15 schema uses a singular `role =`),
`target_width`/`width_weight`/`column_swap_factor`/`match_value`/`allowed_types` (94–97× each),
`stat_weights`, `production_prio`. Patch 1.15 reworked AI templates (roles assigned at creation;
`match_to_count` removed). These files share vanilla filenames and are **NOT** `replace_path`'d,
so they **override vanilla's updated AI templates** for those 9 majors.

**Severity:** non-load-breaking (legacy keys warn-and-ignore; the mod still loads). But for those
9 majors the AI division design diverges from 1.14 and likely degrades; there is a tail risk of a
runtime `hourly_tick`/`client_ping` AI crash if a country can't resolve a valid template under the
new role system. The `-debug` `error.log` pass is the definitive check.

**Options:**
- **(A) Migrate** the 9 files to the final 1.19 AI-template schema (faithful re-expression of the
  mod's AI intent; ~3,000 lines; interpretive). **Recommended**, done **once at the 1.19 endgame**.
- **(B) Delete** the 9 files → inherit vanilla 1.19 AI templates for those majors (clean, correct
  AI, but loses the mod's custom AI tuning).
- **(C) Leave** as-is (not advised; ships degraded/risky AI).

**Default taken (reversible):** **DEFER.** Leave files untouched through jumps 2–5; revisit at the
1.19 endgame. Later jump agents are instructed not to touch `ai_templates` (only to note any
further AI-template changes in 1.16–1.19 so the eventual migration targets the right final schema).

---

## D2 — Air-base / rocket-site placement (`map/airports.txt` + `map/rocketsites.txt` removed in 1.15)
Legacy files are inert post-1.15 (non-load-breaking). The mod's `map/buildings.txt` already places
one `air_base` + one `rocket_site` per state (states 1–1234) with explicit coordinates, so
placement IS expressed in the modern system. **Residual risk:** a coordinate could resolve to a
different province than the legacy file's explicit province ID. **Owner action:** in-game
spot-check a few states' air-base/rocket-site provinces vs. the 1.14 build; nudge the XYZ coords in
`buildings.txt` if any differ. The two legacy files can be deleted at will (not required for load).

---

## D3 — `locked = yes` typo in 4 division templates (pre-existing, NOT a 1.15 issue)
`history/units/{WGR_stahlhelm.txt:11, WGR_reichsbanner.txt:12, ARM_2RCW_Militia.txt:10,
BRY_2rcw_start.txt:12}` use bare `locked = yes`; the valid key is `is_locked`. Bare `locked` is a
long-standing no-op (already inert on 1.14). Decide whether these templates were meant to be locked
(would need `is_locked = yes`). Left untouched (faithful port fixes only version breakage).

---

## D4 — Duplicate province building blocks in 3 state history files (Jump 2 / 1.16)  [LOW]
1.16 added a check that *reports* (error.log/`-debug`) duplicate province building blocks; it does
not block loading and does not change runtime behavior (the later block silently overrides the
earlier, exactly as on 1.14/1.15). These are **pre-existing** (present on the 1.14 baseline). For a
faithful port they were left as-is, because merging changes game state vs. baseline (re-adds
currently-dropped buildings). Owner decides whether to apply the dedup merges:
- `history/states/327-Philippines.txt` prov 10265 → `10265 = { bunker = 1  coastal_bunker = 4  naval_base = 4 }` (re-adds a silently-dropped bunker + coastal_bunker; verify intended naval_base level)
- `history/states/466-Quebec.txt` prov 13384 → `13384 = { naval_base = 1 }` (drop pure duplicate; no value change)
- `history/states/695-Curacao.txt` prov 153 → `153 = { naval_base = 1  coastal_bunker = 2 }` (re-adds a silently-dropped naval_base)
Confirm against a 1.16+ `-debug` `error.log` grep over `history/states/`.

## D5 — Minor pre-existing authoring artifacts (FYI; not version breakage)  [LOW]
- `common/script_enums.txt:1` — a `small_plane` token appears glued onto the enum name (latent
  authoring artifact; non-load-breaking, pre-existing). Owner may want to clean it up.
- `common/bop/*.txt` (all 7) are empty stubs — harmless/additive, no action needed.

---

## End-of-port step (critical, do not skip)
Run **1.19 with `-debug`**, load the mod, and play a few in-game hours; send me `error.log`. I'll do
a final cleanup pass against **real engine errors** — this catches any low-profile stale token
across the 2,007 `common/` files, GUI breaks, or missing references that static analysis cannot
fully exclude.
