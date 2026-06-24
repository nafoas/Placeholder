# Jump 4 — 1.17 → 1.18 (Peace for Our Time) — Independent Deconstructor / Audit review

**Auditor:** Jump-4 Deconstructor/Audit Agent (independent re-derivation; did not rely on the updater's
sources). **Mod root:** `/home/user/Placeholder/3273913964`. **Updater's claim under test:** 1.18 is
additive (balance / AI / content / defines); the only required mod edit is the `descriptor.mod`
`supported_version` bump; nothing else 1.18 changed breaks a token the mod uses.

## BOTTOM LINE

**Jump 4 is SOUND AS-COMMITTED. No load-blocking issue found. No NEEDS FIX.** I independently re-derived the
1.18 modder-facing breaking surface from four mutually-independent patch-note mirrors plus the on-version
modding-wiki mirror and GitHub code search, and checked each candidate against the mod. The updater's central
conclusions all hold, and the headline risk (submarine-detection = defines/formula, **not** a naval-stat
rename) is **confirmed** against the current Equipment-modding page. I found **one item the updater did not
analyze** — the mod's same-filename `common/script_enums.txt` override omits `helicopter_equipment` — but it
is **pre-existing (since Jump 1 / 1.15, when vanilla added helicopters), non-1.18, and non-load-blocking** (at
worst a startup log-error reminder), so it does **not** overturn the "1.18 breaks nothing" conclusion. It is
logged below under OWNER DECISION as a pre-existing-debt note.

Confidence that Jump 4 loads on 1.18.x as committed: **HIGH.**

---

## CONFIRMED CORRECT

### C1 — Descriptor bump is correct and is the only mod edit (HIGH)
- `3273913964/descriptor.mod:37` = `supported_version="1.18.*"` (read directly). `"1.18.*"` minor-wildcard is
  the correct + dominant real-mod convention.
- Git verified: Jump-4 commit `7493440` changed **exactly one** mod file — `descriptor.mod`, a single-line
  `1.17.* → 1.18.*` diff (`git show --name-only 7493440` → only `3273913964/descriptor.mod`; the other four
  files are PORTING docs). Working tree clean (`git status` empty), so no stray uncommitted edits.
- Spec compliance: file is `ASCII text`, **no UTF-8 BOM** (`od` first 3 bytes `6e 61 6d` = `nam`); **zero**
  remaining `1.17` strings; `tags={}` balanced.
- **Sources:** direct file read + `git show`/`git status`; hoi4.paradoxwikis.com/Mod_structure (wildcard + no-BOM);
  GitHub `search_code "1.18.*" filename:descriptor.mod` (convention).

### C2 — Submarine-detection overhaul = DEFINES + FORMULA, NOT a naval-stat/modifier rename (HIGH) — headline risk CLEARED
- **Independently confirmed no naval equipment stat the mod uses was removed or renamed.** The current
  (on-version) **Equipment modding** wiki page — fetched from the `klimPaskov/Chaos-Redux` mirror
  (`paradox_wiki/Equipment modding - Hearts of Iron 4 Wiki.md`, branch `master`) — lists **PRESENT / not
  obsolete**: `sub_detection`, `sub_visibility`, `surface_detection`, `surface_visibility`, `sub_attack`,
  `naval_speed`, `torpedo_attack`, `naval_range`, `anti_air_attack`, `lg_attack`, `hg_attack`,
  `lg_armor_piercing`, `hg_armor_piercing`, `port_capacity_usage`, `search_and_destroy_coordination`,
  `convoy_raiding_coordination`, `naval_strike_attack`, `naval_strike_targetting`.
- The **only** OBSOLETE naval stats are `fire_range`, `shore_bombardment`, `evasion`, and the page's verbatim
  wording proves they are **MtG-era** (pre-1.18), not a 1.18 change: e.g. `shore_bombardment` "(OBSOLETE,
  lg_attack and hg_attack determine shore bombardment)"; `evasion` "(OBSOLETE, naval_speed contributes to
  evasion instead)". The mod uses **none** of these as equipment stats — its only `shore_bombardment*` hits are
  the long-standing **modifier** `shore_bombardment_bonus` (`special_forces_doctrine.txt:809`,
  `unit_leader/00_traits.txt:1635,2205`), and its only `evasion` hits are loc prose ("draft evasion"). No
  `fire_range` anywhere.
- **The submarine rework is defines/formula** — independently corroborated by **four** patch-note mirrors
  (xpgained, patched.gg, se7en.ws, soren via WebSearch) all describing "submarine detection now uses a new
  formula (ported from the open beta)", and the open-beta-II notes naming the three new defines
  `SUBMARINE_BASE_STEALTH_VALUE`, `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`,
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER` (+ value tunes `…REVEAL_DETECTION…` 0.1→0.075;
  `SUBMARINE_HIDE_TIMEOUT` 20→8). **None** of these is a stat/modifier the mod references.
- **Mod uses none of the new submarine defines:** independent grep over the whole mod (excl. `pdx_documentation/`)
  for all three names → **0 files**. `common/defines/cbts_defines.lua` (182 lines) sets **no** submarine,
  stealth, reveal, war-score, sunk-IC, naval-strike, or carrier define (grep verified) — so the mod **inherits**
  1.18's new submarine formula automatically, the faithful-port outcome. A naval-stat-rename edit would have
  been **wrong**; the updater correctly made none.
- **Sources:** Chaos-Redux mirror Equipment-modding page (WebFetch, master branch); patch-note mirrors
  xpgained / patched.gg / se7en / soren (WebSearch backend); mod grep + `cbts_defines.lua` read.

### C3 — 1.18 "Modding" section = exactly two ADDITIVE items; mod's `pp_spend_priority` usage unaffected (HIGH)
- **Four** independent patch-note mirrors converge on the **entire** 1.18 Modding section being just:
  (a) `pp_spend_priority` extended to **target advisors** (additive); (b) stability-check error-checking now
  verifies **normalized range based on defines** (internal validation). No removed/renamed modding token.
- The mod uses `pp_spend_priority` only in the long-standing **category** form (`type = pp_spend_priority` /
  `id = <…>`) across its replace_path'd `common/ai_strategy/*` (verified: `CBTS_general_AI_strategies.txt:9/23/29`,
  `default.txt:2038/2058/2064`, `GER.txt:2204/2227`, `USA.txt:1759`, `JAP.txt:1579`, `FIN.txt:84`). 1.18 only
  **adds** advisor-targeting as an option — existing usage stays valid. Internal validation can't break valid
  script.
- **Sources:** xpgained / patched.gg / se7en (verbatim two-bullet Modding section); mod grep.

### C4 — MIO schema unchanged; no new required field; mod's own MIOs conform (HIGH)
- On-version **Military industrial organization modding** mirror page confirms the required org fields are
  exactly `equipment_type`, `research_categories`, `allowed`, `initial_trait`, `trait` (each "Mandatory?: true"),
  with `name`/`icon`/`available`/`visible`/`production_bonus`/etc. optional. **No field newly required, removed,
  or renamed for 1.18.**
- The mod `replace_path`s `military_industrial_organization/{organizations,policies,ai_bonus_weights}` (full
  folder replacement → vanilla's new Train/Helicopter MIOs simply don't load = non-adoption, not a break). Its
  own `organizations/00_generic_organization.txt` (268 field hits) uses the current schema correctly (read:
  `allowed`, `equipment_type = { mio_cat_eq_… }`, `research_categories`, `initial_trait`, `trait { token … }`).
- **Sources:** Chaos-Redux mirror MIO-modding page (WebFetch); mod read of `00_generic_organization.txt`.

### C5 — Train + Helicopter MIOs = new CONTENT for pre-existing equipment; mod adopts none (HIGH)
- 1.18 adds **MIOs** for **already-existing** train (NSB-era) and **helicopter (Götterdämmerung/1.15-era)**
  equipment — it does **not** introduce new equipment archetypes. Mod ships no helicopter equipment at all
  (no `*helicopter*` file; 0 `helicopter_equipment`/`helicopter_airframe` refs in `common/units`). The mod's
  `train`/`helicopter` grep hits are false positives (the `train_manufacturer` company-designer trait; "rotor
  cipher" encryption loc). Non-adoption only.
- **Sources:** WebSearch (helicopters added in Götterdämmerung; 1.18 adds Train→ENG/FRA/BEL/USA/SOV/ITA/JAP/GER,
  Helicopter→BEL/USA/JAP/GER MIOs); mod find/grep.

### C6 — War-score / peace-conference rebalance = defines/AI values; no peace token removed; mod insulated (HIGH)
- 1.18 = faction war-score contribution `0.125 → 0.1`; war score from sunk-ship IC **halved** — internal
  balance values, **no** peace-conference scripting token removed/renamed (four mirrors; no removed-token surfaced).
- The mod's `common/peace_conference/*` same-filename overrides are intact and current-format
  (`ai_peace/*` ×12, `cost_modifiers/*` ×10, `categories/00_peace_action_categories.txt` — read: standard
  `peace_action_categories = { … name = … }`). Its peace **defines** (`cbts_defines.lua:34-36`:
  `BASE_PEACE_PUPPET_FACTOR=0`, `BASE_PEACE_LIBERATE_FACTOR=0`, `PEACE_SCORE_PER_PASS=0.65`) are under
  `NDiplomacy` and are **different** defines from the ones 1.18 changed → no conflict. (Wiki confirms
  `BASE_PEACE_PUPPET_FACTOR` / `BASE_PEACE_LIBERATE_FACTOR` remain valid, default 100.)
- **Sources:** four patch-note mirrors; mod inventory + `cbts_defines.lua`/`00_peace_action_categories.txt` reads.

### C7 — AI overhaul (GER/ITA/UK) = vanilla AI script/balance; mod replace_path's AI = non-adoption (HIGH)
- 1.18's GER/ITA/UK AI improvements live in vanilla `common/ai_strategy` / `ai_focuses` / `ai_strategy_plans` /
  `ai_equipment` — **all four are replace_path'd by the mod**, so the mod overrides vanilla AI and does not
  inherit (non-adoption). No format break. (se7en surfaced a division-designer **bugfix** — "equipment override
  models now higher priority", "GER medium tanks now show as best match" — which is a display fix, **not** an
  `ai_templates` schema change; see C8.)
- **Sources:** descriptor `replace_path` list; mirrors.

### C8 — No 1.18 division-designer / `ai_templates` schema change; deferred D1 target unchanged (HIGH)
- No 1.18 patch line changes the division designer or the `ai_templates` role schema (`match_to_count` /
  plural `roles` / `target_width`). The only army-AI-adjacent 1.18 items are AI behavior (C7), Train/Helicopter
  MIO content (C5), and a division-designer **match-display bugfix** (C7) — none touches the schema.
- Mod state verified: all **9** `common/ai_templates/*` present and still use `match_to_count` (grep: 9/9). The
  Jump-4 commit did **not** touch `ai_templates`. Deferred D1 target is the same as Jumps 1–3 left it.
- **Sources:** mirrors + se7en division-designer note; mod `ls`/grep; `git show 7493440`.

### C9 — No 1.18 doctrine-system change; deferred D6 target unchanged; doctrine files untouched (HIGH)
- 1.18's naval change is submarine **detection** (defines/formula, C2), **not** the naval **doctrine** system.
  No new/removed doctrine token surfaced for 1.18. `land_doctrine.txt` (57,635 B) and
  `special_forces_doctrine.txt` (24,053 B) present and **not** in the Jump-4 commit (HARD RULE 2 respected). D6
  migration target (1.17 Grand/Sub/Mastery schema) remains correct as of 1.18.
- **Sources:** mirrors; mod `ls`; `git show 7493440`.

### C10 — All 27 `replace_path` targets exist on disk; 1.18 restructured none (HIGH)
- Scripted existence check: **27/27 OK**, 0 missing.
- **Sources:** disk check vs. descriptor list.

---

## NEEDS FIX (load-blocking)

**None.** No 1.18 removed/renamed/format-changed token that the mod uses in a load-breaking way was found
across the independent re-derivation. The descriptor bump (C1) is the only load-bearing change, and it is
correctly applied.

---

## OWNER DECISION

### O1 — Pre-existing: mod's `common/script_enums.txt` override omits `helicopter_equipment` (NOT a 1.18 issue; non-load-blocking) — **the one item the updater did not analyze**
- **What:** The mod ships its **own** `common/script_enums.txt` (a same-filename override — *not* in the
  replace_path list; widely overridden by major mods — 188 GitHub hits incl. Road-to-56, Millennium Dawn,
  Equestria-at-War). It redefines `script_enum_equipment_stat` (lines 18-92) and
  `script_enum_equipment_bonus_type` (lines 138-710). The mod's `equipment_bonus_type` enum lists the **train**
  archetypes (`train_equipment`…`train_equipment_3`) but **no `helicopter_equipment`** (grep: helicopter ABSENT).
- **Why it is NOT a 1.18 regression:** vanilla helicopters were added in **Götterdämmerung (1.15 = Jump 1)**,
  and the mod does **not** `replace_path` `common/units/equipment`, so vanilla's helicopter equipment has
  loaded *underneath* this mod since Jump 1. If the omission were going to matter, it would have mattered at
  Jump 1, not 1.18. 1.18 added helicopter **MIOs**, not helicopter **equipment** — so 1.18 changed nothing here.
  The updater's "uses none of the new content" claim is still true.
- **Why it is non-load-blocking:** the enum's own header comment states the sync check produces a **startup log
  error "as a reminder"**, not a load abort; and because the mod itself defines/references **no** helicopter
  equipment (0 hits in `common/units`), the mod's enum is internally consistent with the mod's own
  (helicopter-free) equipment set. Worst realistic case = a benign `error.log` line about the enum vs. the
  vanilla helicopter archetype that loads beneath it.
- **Decision for owner:** optional. Either (a) leave as-is (pre-existing, cosmetic-log at most), or (b) at the
  planned end-of-port `-debug` pass, if `error.log` shows a `script_enum_equipment_bonus_type` / helicopter
  sync warning, add `helicopter_equipment`(+`_1`) to the mod's enum to silence it. **Do not treat as a Jump-4
  blocker.** Flag also belongs in MODERNIZATION-REPORT as inherited debt, not a 1.18 port fix.
- **Confidence:** HIGH that this is non-load-blocking and not 1.18-caused. (Caveat: I could not obtain a
  verbatim pristine-vanilla-1.18.0 `script_enums.txt` to enumerate the exact vanilla archetype delta — the
  Chaos-Redux mirror copy is itself heavily modded, so it cannot serve as the vanilla baseline. The
  load-blocking assessment does not depend on that delta, because the engine check is a log-reminder by design.)

### O2 — Behavioral non-adoption of 1.18 content/AI (intentional faithful-port; owner balance call)
- By overriding the relevant folders, the mod does **not** inherit the new Train/Helicopter MIOs (MIO folder
  replaced), the GER/ITA/UK AI overhaul (AI folders replaced), or have its peace tuning replaced by 1.18's new
  war-score balance (its peace files/defines apply on top). The submarine **detection formula IS** inherited
  (defines, not overridden). All non-load-bearing; each is an optional modernization choice. No load impact.

---

## STILL UNCERTAIN

### SU1 — Exhaustiveness over the mod's full `common/` surface vs. an un-dumpable verbatim 1.18.0 Database block (LOW residual; non-load-bearing)
- As in every prior jump, the live Paradox wiki/forum is JS-walled to direct fetch (re-confirmed this run:
  `hoi4.paradoxwikis.com/Patch_1.18` returns the "required part couldn't load" client-challenge shell), and no
  per-patch markdown mirror exists, so a single verbatim base-1.18.0 "Database/Modding" dump is not obtainable
  here. I reconstructed the surface from four independent patch-note mirrors + the on-version Equipment/MIO/Defines
  modding mirror pages + GitHub code search, cross-checked ≥2 ways; they **converged**: the Modding section is
  the two additive bullets, the submarine overhaul is defines/formula, MIO schema is unchanged, and
  Train/Helicopter MIOs + war-score + AI are content/balance — **none removes/renames a token the mod uses.**
- Residual: a low-profile removed/renamed token somewhere in the mod's ~2,000 `common/` files that no reachable
  source enumerated for 1.18. Mitigant: the positively-confirmed high-value surfaces (naval stats, MIO fields,
  peace defines, `pp_spend_priority`) are all clear; major 1.18-line overhaul mods (Kaiserreich, Road-to-56)
  ported with balance/content work, not a scripting-token-break scramble. **Close out at the planned
  end-of-port `-debug` `error.log` pass** (grep `unknown` / `unexpected token` / `invalid`). Confidence the
  jump loads as-committed: **HIGH**; confidence on full-surface exhaustiveness: **MEDIUM-HIGH**.

### SU2 — Note on a search artifact (not a contradiction)
- One WebSearch result loosely labeled "1.18.* … 'Musketeer'", which conflicts with the verified **"Peace for
  Our Time"** name for 1.18 (confirmed by four patch-note mirrors + the store page). Treated as a low-confidence
  search conflation (likely an adjacent/later codename), **not** evidence against the 1.18 identity or the
  descriptor value. No action.

---

## Method / sources (consolidated)
- **Independent of the updater's notes.** Live wiki/forum JS-walled (re-confirmed). On-version modding pages via
  the GitHub mirror **`klimPaskov/Chaos-Redux`** `paradox_wiki/*` (Equipment / MIO / Defines / Unit / Technology
  modding — directly fetchable raw on branch `master`; the dossier's cited `klimPaskov/Agentic-HOI4-Modding`
  paths 404'd this session, but Chaos-Redux carries the same current pages and was used instead). Note: the
  Chaos-Redux **Defines** page is SAVE_VERSION-stamped "1.16.0 (Countenance)" and its `script_enums.txt` is
  heavily modded — used accordingly (Equipment/MIO pages are current-format; not relied on as a pristine-vanilla
  baseline for archetype deltas).
- Patch-note mirrors (four, mutually independent, via WebSearch backend / WebFetch): xpgained.co.uk,
  patched.gg, se7en.ws, soren.com — converged on the two-bullet Modding section, submarine "new formula",
  war-score 0.125→0.1 + sunk-IC halved, GER/ITA/UK AI, Train/Helicopter MIOs; open-beta-II notes for the three
  submarine defines + value tunes.
- GitHub `search_code`: naval-stat survival on the on-version Equipment page; `script_enums.txt` override
  prevalence (188 hits) + helicopter-equipment-as-vanilla evidence; descriptor convention.
- Mod-side ground truth: direct reads (`descriptor.mod`, `script_enums.txt`, `cbts_defines.lua`,
  `00_generic_organization.txt`, `00_peace_action_categories.txt`), whole-mod greps (naval stats; submarine
  defines → 0; helicopter → 0 in `common/units`; `pp_spend_priority`; obsolete stats), folder inventories
  (peace_conference, ai_templates, MIO, equipment), 27/27 replace_path existence check, and `git
  show/status/log` (Jump-4 commit `7493440` = descriptor.mod only; tree clean).
