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
- `common/script_enums.txt` `script_enum_equipment_bonus_type` omits `helicopter_equipment` (the mod's
  same-filename enum override). Pre-existing (helicopters arrived in 1.15; the mod ships a
  helicopter-free equipment set and doesn't replace `common/units/equipment`); per the enum's own design
  this is a **startup log-reminder, not a load abort**. One-line add only if the end `-debug` `error.log` flags it.

---

## D6 — 1.17 doctrine rework vs. the mod's old-format doctrines  ⚠️ BLOCKER / HIGH PRIORITY (Jump 3 / 1.17)
**Facts (verified by read + grep + research):** 1.17 (No Compromise, No Surrender) **replaced the
Army/Navy/Air doctrine trees with a new Grand-Doctrine + Subdoctrine + Mastery system** and a new
doctrine GUI. The mod ships **old-format** land + special-forces doctrine trees that override vanilla
(`common/technologies/land_doctrine.txt`, `special_forces_doctrine.txt`), declares old-style doctrine
folders in its own `common/technology_tags/00_technology.txt`, references old doctrine technologies via
`has_tech = …` in **43 places across 6 files** (`common/ideas/{army,navy,air}_spirits.txt`,
`common/ai_strategy/doctrines.txt`, `common/scripted_triggers/00_scripted_triggers.txt`,
`common/national_focus/GER_Hitler_Military.txt`), uses **vanilla's new** doctrine GUI (it ships no
`countrydoctrinetreeview.gui`), and uses **none** of the new doctrine tokens. Vanilla's old
`land_doctrine.txt` "no longer exists in its original form"; modder consensus + 1.17.X CTD fixes indicate
**old custom doctrines + the new doctrine tree view crash**.

**Severity — UPDATED by the Jump-3 audit (DOWNGRADED): DEGRADED-BUT-RUNNABLE, not un-loadable →
safe to DEFER to the 1.19 endgame, gated on one quick `-debug` doctrine-tab check.** Old-format
doctrine folders + technologies still parse on 1.17–1.19 (proven by live mods
`kasanakisara/new-aor` @1.17.* and `East-Showdown` @1.19.* shipping near-identical `land_doctrine.txt`;
the mod's `00_technology.txt` doctrine-folder override is structurally identical to current working
mods and deletes nothing vanilla grand doctrines need). What IS broken: the doctrine SUBSYSTEM is
non-functional (mod ships no `common/doctrines/` grand/subdoctrine data and no doctrine GUI) and **56**
doctrine `has_tech` refs degrade (32 land/SF → mod-defined techs; 24 air/naval → vanilla doctrine names
1.17 reworked, already silent no-ops). Only residual unknown: whether opening the doctrine TAB CTDs vs.
vanilla's new GUI — evidence leans MEDIUM-HIGH that it does NOT (the engine ships a
`has_any_grand_doctrine` trigger, implying "no grand doctrine" is a supported, non-crashing state).
_Original (now-superseded) escalation assessment follows._
**Severity:** **load-bearing / assessed crash-class** (the exact failure mode — load-error vs.
silent-degrade vs. CTD-only-on-opening-the-doctrine-tab — could not be pinned from available sources; that
gap is why it is escalated, not patched). This is the first true BLOCKER of the port. Unlike D1, the
faithful fix is not a deletion — the 43 `has_tech` references and three doctrine-bonus spirit files depend
on the doctrine techs, so any path requires real rework.

**Options:**
- **(A) Migrate** the mod's land + special-forces doctrines to the new Grand/Sub/Mastery schema, adapt/ship
  the doctrine GUI, and convert the 43 `has_tech = <doctrine>` refs to `has_doctrine` / `has_mastery_level`.
  Faithful to the mod's doctrine intent; **large interpretive rework** — best done **together with the D1
  `ai_templates` migration at the 1.19 endgame**.
- **(B) Delete** the mod's `land_doctrine.txt` + `special_forces_doctrine.txt` overrides and the
  doctrine-folder overrides in `00_technology.txt` → inherit vanilla 1.17 doctrines; the 43 `has_tech` refs
  still must be reworked to the new triggers (else they silently no-op). Cleaner/correct doctrines, loses
  the mod's custom doctrine tuning.
- **(C) Defer** (like D1) to the 1.19 endgame — **only** if `-debug` confirms it does NOT hard-crash on
  load / on opening the doctrine tab.

**Required immediate step (disambiguates + picks A/B/C):** run **1.17 with `-debug`**, load the mod, open
the **Army / Navy / Air doctrine tabs**, and grep `error.log` for doctrine / `has_mastery_level` / `unknown`
/ CTD. This is the single highest-leverage action for this jump. **Default taken: ESCALATE — no mod edit
made** (faithful-port mandate forbids guessing a load-bearing rework). See
jump-1.16-to-1.17/{dossier.md #1, UNCERTAINTIES.md U1, changes.md}.

---

## End-of-port step (critical, do not skip)
Run **1.19 with `-debug`**, load the mod, and play a few in-game hours; send me `error.log`. I'll do
a final cleanup pass against **real engine errors** — this catches any low-profile stale token
across the 2,007 `common/` files, GUI breaks, or missing references that static analysis cannot
fully exclude.
