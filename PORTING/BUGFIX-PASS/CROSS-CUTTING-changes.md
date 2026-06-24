# CROSS-CUTTING script-cleanup — changes log

Agent: cross-cutting script-cleanup. Scope: the NON-fatal script cleanups (Tasks 1–4).
The divide-by-zero crash and the 5 per-version crash fixes are owned elsewhere and were
NOT touched. Do-not-touch list from the brief was respected.

Mod root: `3273913964/`. All paths below are relative to it unless absolute.

---

## KEY STRUCTURAL FINDING (read first — changes the premise of Task 1)

**CBtS ("Calm Before the Storm" fan fork) is a sub-mod that runs on top of Road to 56
(RT56), not on pristine vanilla.** This is proven, not assumed:

- The 77 undefined scripted triggers are all CALLED from files in folders the mod does
  **not** ship and does **not** `replace_path` (`common/raids`, `common/factions/goals`,
  `common/collections`, `common/ai_faction_theaters`, `common/focus_inlay_windows`,
  `common/peace_conference/cost_modifiers/RK_peace.txt`,
  `common/autonomous_states/sea_warlord_subject.txt`,
  `common/decisions/categories/RAJ_GOE_*`, `common/dynamic_modifiers/GoE_/mun_`,
  `common/special_projects`, `common/doctrines/tracks`). Those files load from the
  base layer beneath CBtS.
- Several of those callers reference content that **does not exist in base-vanilla HOI4
  1.19** at all (Reichskommissariats / `GER_is_RK*_state`, warlord-China / `is_literally_china`,
  GoE-Raj exile / `is_raj_or_raj_inheritor`, Japan Imperial Influence / `JAP_*_faction_*`,
  the country tags `GSM/HBC/KHM/NXM/SIC/SND/XIC`). These are **Road to 56** features. In
  base vanilla the matching lines in `faction_goals_short_term.txt` and `RK_peace.txt` are
  *commented out*; in CBtS's load they are *active* — which only happens with RT56 present.
- The mod's own `common/autonomous_states/` ships RT56-derived files
  (`reichskommissariat.txt`, `nibenland.txt`, `reststaat.txt`, etc.).

**Root cause of Task 1 (the 77 undefined triggers):** the mod's
`replace_path="common/scripted_triggers"` replaces the WHOLE scripted_triggers folder over
*both* the vanilla and the RT56 layers, so base/RT56 scripted triggers that base/RT56's own
(un-replaced) files still call are gone → `Invalid trigger`, cascading into hundreds of
downstream `in file: faction_goals_*/decisions/*/...` errors. The empty 0-byte
`common/scripted_triggers/CHI_scripted_triggers.txt` is the same data-loss pattern (the mod
replaced RT56's CHI_scripted_triggers.txt with an empty file).

Because the brief's premise ("pristine vanilla 1.19") is only partly correct, only the
triggers whose *exact* definition AND *every dependency* (state IDs / tags / ideas) could be
verified against THIS mod's own data were restored. The rest are escalated (not guessed) in
`ESCALATIONS.md`.

---

## Task 1 — scripted-trigger cascade — A/B split

77 names total. 3 were already defined by the protected file
`common/scripted_triggers/CBtS_doctrine_compat_triggers.txt`
(`ai_has_completed_air_doctrine`, `ai_has_completed_army_doctrine`,
`ai_has_completed_naval_doctrine`) → out of scope, left untouched. 74 remained.

### RESTORED (Category A) — 44 triggers — NEW FILE `common/scripted_triggers/CBtS_vanilla_compat_triggers.txt`

All restored definitions are byte-for-byte from a cited source and every dependency was
validated against the mod.

**A1. Base-vanilla 1.19, dependency-free (2):**
- `should_play_south_american_music` — `{ capital_scope = { is_on_continent = south_america } }`.
  SOURCE: vanilla `common/scripted_triggers/00_scripted_triggers.txt`; verified identical in
  Road-to-56-RP/roadto56rp, deliciousmods/1956_beta, and ~25 other current mirrors.
  CALLED BY base file `music/toa_songs.txt`.
- `can_unlock_second_track_of_sf_doctrine` — full `if/else custom_trigger_tooltip` block on
  `check_variable = { sf_trees > 1 }`. SOURCE: vanilla
  `common/scripted_triggers/_special_forces_scripted_triggers.txt`; verified identical in
  Kaiserreich/Kaiserreich-HOI4 (confirmed 1.19) and a repo's literal
  `(vanilla) 00_scripted_triggers.txt`. CALLED BY base file
  `common/doctrines/tracks/special_forces_tracks.txt`.

**A2. RT56 Reichskommissariat geography (42): all `GER_is_*_state` triggers**
(the 39 in the undef list + 3 of the same coherent set: `GER_is_soviet_greater_romania_state`,
`GER_is_additional_soviet_greater_romania_state`, `GER_is_RKC_zadar_state`).
- SOURCE: `common/scripted_triggers/GER_scripted_triggers.txt` from Road-to-56-RP/roadto56rp
  @ commit `a53aa61c2d9373b5f04d7348f90ef06992b610c6`; cross-referenced identical with
  deliciousmods/1956_beta and jameskicklighter/hoi4-ai-base.
- CALLED BY base-layer file `common/peace_conference/cost_modifiers/RK_peace.txt` (active
  `GER_is_*_state = yes` checks, e.g. `GER_RK_cost_reduction_RKU` → `original_tag = RKU`).
- **VALIDATION (why this is not a guess):** all **933 distinct state IDs** referenced by the
  42 triggers were checked against THIS mod's `history/states/` (1234 states) → **100%
  present**. The mod does not `replace_path` `map/` except `map/strategicregions`, so it
  inherits the base province/state DB; spot-checks confirm IDs map to the same places
  (401=Engels/Balakovo, 251=Samara/Kuybyshev, 249=Kazan, 213=Murmansk, 9=Bohemia, 75=Moravia).

### ESCALATED (Category B / undecidable) — 30 triggers → see `ESCALATIONS.md`

Not restored because each has a dependency (an idea, a country tag, or an exact-definition
ambiguity) that does **not** cleanly match CBtS's reworked content; restoring upstream
definitions verbatim would inject wrong/broken content (forbidden by the no-guess rule).
Summary (full detail in ESCALATIONS.md):
- `JAP_*_faction_*` (12) — depend on ideas (`JAP_army_faction_tier_1_equal_navy`, …) that are
  **absent everywhere in CBtS** (0 occurrences).
- China core/states (6): `is_literally_china`, `is_independent_china_or_warlord`,
  `WTT_is_chinese_country`, `CHI_greater_game_states`, `CHI_northern_mandate_states`,
  `CHI_southern_mandate_states` — CBtS heavily reworked China (its own
  `is_chinese_TAG`/`is_chinese_warlord` use a DIFFERENT tag set: NEA/SHD/YUL/LWH/DXH/… vs
  vanilla CHI/PRC/GXC/YUN/SHX/XSM/SIK), so the correct tag list is an owner call.
- Country-tag scope-checks (7): `GSM HBC KHM NXM SIC SND XIC` — these RT56 country tags are
  **absent** from CBtS `common/country_tags/` (the mod replaced country_tags). They are NOT
  scripted triggers; the fix is restoring the tags, which is content the owner must decide on.
- `is_raj_or_raj_inheritor` (refs tag `BAN` — absent in CBtS),
  `CZE_RUT_is_not_its_own_thing` (refs tag `RUT` — absent in CBtS),
  `SPR_scw_in_progress`, `HABSBURG_is_a_habsburg_viable_nation` — partial/uncertain.
- Base-vanilla special-projects facility triggers `naval_facility`, `land_facility`,
  `air_facility`, `nuclear_reactor_heavy_water` — NO scripted-trigger definition exists in any
  mirror searched; need the actual pristine 1.19 vanilla `common/scripted_triggers/*` (likely
  `00_scripted_triggers.txt`/a special-projects file) to copy exactly. Not reconstructable safely.

**Re-grep confirmation:** after the change, the 44 restored names each resolve to exactly one
definition (only in the new file); zero duplicate definitions against any other
`common/scripted_triggers/*` file; braces balanced 93/93; CRLF preserved; ASCII.

---

## Task 2 — `2RCW_…` digit-leading identifier — FIXED

Clausewitz/Jomini lexer rule: an identifier (scripted-effect/trigger/variable name) cannot
begin with a decimal digit — the parser uses the first char to decide if a token is a numeric
literal vs an identifier. SOURCE: "The Clausewitz Engine Scripting Language" (ititus.github.io
/PDXTools/script) and pdx.tools/blog/a-tour-of-pds-clausewitz-syntax — "A variable name cannot
begin with a decimal digit, so a name like `123_my_variable` is invalid … so the parser can
determine what syntactic type a token represents." Matches error.log.

Renamed `2RCW_Increase_Ideology_From_Recognizer` → `RCW2_Increase_Ideology_From_Recognizer`:
- DEFINITION: `common/scripted_effects/2RCW_scripted_effects.txt:1` — old → new.
- USAGE: `events/CBtS_USSR.txt:4094` (`… = yes`) — old → new.
- Verified: 0 occurrences of the old name remain mod-wide; new name present in both files.

Other `^[0-9]`-leading tokens checked:
- `2RCW_guns` — only appears as a **texture file path** in `interface/ideas.gfx:500`
  (`gfx/interface/ideas/2RCW_guns.tga`). Texture/file-path strings are NOT script identifiers
  (they are quoted string values), so the lexer rule does not apply → **no change needed**.
- The file name `2RCW_scripted_effects.txt` itself — a filename, not a token → no change.
- Full scan of `common/` + `events/` for `^\s*[0-9]+[A-Za-z]…= {` definition tokens → only the
  one fixed above existed (0 others).

---

## Task 3 — career-profile GUI — DOCUMENTED (not forced), per brief

`interface/career_profile/common_components.gui` (a stale mod override, 6431 lines / 181 KB) is
missing ~13 1.19-era playthrough-stat elements that the engine looks up by name in
`window career_profile_pages` (error.log `containerwindow.cpp:991`, line 95). Missing:
`mio_size_ups`, `special_forces_deployed`, `equipment_sold`, `special_projects_completed`,
`launched_raids`, `scientist_level_ups`, `faction_goals_completed`, `mastery_gained`,
`naval_headquarters_built`, `captured_commanders`, `rescued_commanders`,
`ship_captains_promoted` (+`ship_captains_promoted` group).

Assessment: the window is **heavily customized** — 145 nested `containerWindowType`s across 8
bespoke pages (`page0`–`page7`) with custom positioning macros; NONE of the 13 stats exist
anywhere in it, and even the standard stat element names appear restructured. There is no clean
vanilla row to copy-insert. Per the brief's Task-3 instruction ("if the mod heavily customized
this window, document instead of forcing it") and HARD RULE 5 (minimal change / preserve design),
this was **left as-is**. Impact is purely cosmetic and NON-fatal: the profile window still loads;
those 13 newer counters simply do not render. Forcing 13 rows into the bespoke 8-page layout
risks visual breakage for zero functional gain. → also listed in ESCALATIONS.md.

---

## Task 4 — `script_enums.txt` "duplicate script enum definition: =" — FIXED

`common/script_enums.txt` had a **corrupted duplicate block at the very top (old lines 1–17)**:
line 1 was the mangled `\tsmall_planescript_enum_operative_mission_type = {` (a stray
`small_plane` airframe-list fragment fused onto `script_enum_operative_mission_type`, double-
indented), followed by a duplicate `script_enum_advisor_slot_type` block. These duplicated the
correctly-placed canonical definitions at the bottom of the file (lines 714–728). On load the
engine defined the enums from the top copy, then hit the legitimate bottom definitions and
reported the "duplicate script enum definition" near line 720 (the `}` of the bottom
`operative_mission_type`).

FIX: removed the corrupted duplicate block (old lines 1–17) so the file begins cleanly at
`script_enum_equipment_stat`. Done byte-precisely in Python to preserve CRLF.
- VERIFIED: no duplicate enum names remain; the 6 canonical enums each appear exactly once
  (`equipment_stat`, `production_stat`, `equipment_category`, `equipment_bonus_type`,
  `operative_mission_type`, `advisor_slot_type`); braces balanced 6/6; CRLF preserved.
- The bottom `script_enum_advisor_slot_type` keeps the mod's own intentional comment-outs
  (`# theorist`, `# political_advisor`) — not altered. Reference for the canonical block:
  vanilla `common/script_enums.txt` (zhang8128/hoi4-files, EaW-Team/equestria_dev,
  MillenniumDawn — identical structure).

---

## Files changed (4)
1. `common/scripted_triggers/CBtS_vanilla_compat_triggers.txt` — **NEW** — 44 restored triggers.
2. `common/scripted_effects/2RCW_scripted_effects.txt` — rename def `2RCW_…` → `RCW2_…`.
3. `events/CBtS_USSR.txt` — rename usage `2RCW_…` → `RCW2_…`.
4. `common/script_enums.txt` — removed corrupted duplicate enum block (old lines 1–17).

(No commit/push performed, per instructions.)
