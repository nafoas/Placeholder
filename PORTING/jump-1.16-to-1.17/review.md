# Jump 3 (1.16 → 1.17 NCNS) — Independent Deconstructor / Audit Review

**Auditor:** Jump-3 Deconstructor/Audit Agent (independent re-derivation; no mod edits made).
**Scope:** verify the escalated doctrine BLOCKER (D6) severity; verify the updater's "no edit" calls
(building rework, `cl_tech`, Medium Battery); independent 1.17 breaking-surface sweep.
**Method:** direct read/grep of the mod on disk; WebSearch deep-read of the JS-walled wiki/forum;
GitHub code search across version-current large mods; `raw.githubusercontent.com` reads of real 1.17/1.19
mods and cwtools config. Live wiki + Patch_1.17 page bodies are JS-walled to WebFetch (confirmed again this
run); `klimPaskov` mirror and arbitrary repos are NOT reachable via the GitHub MCP this session (it is
locked to `nafoas/placeholder`), but **`mcp__github__search_code` works repo-wide** and was the workhorse.

---

## HEADLINE VERDICT (doctrine D6)

**Severity: DEGRADED-BUT-RUNNABLE — with a residual, source-bounded risk of a doctrine-tab CTD.**
On the weight of evidence the mod is **NOT un-loadable**: old-format doctrine *folders*
(`doctrine = yes` in `technology_tags`) and old-format doctrine *technologies* (`doctrine = yes` +
`xp_research_type` + `enable_tactic` + `folder { }` in `common/technologies`) **still parse on 1.17–1.19**
— proven by multiple shipping mods on those exact patches that carry near-identical files. The doctrine
*subsystem* is **functionally broken** (the mod ships none of the new `common/doctrines/` grand-doctrine /
subdoctrine data and no doctrine GUI, so the new engine has nothing to drive). The one thing I could not
reduce to zero from reachable sources is whether **opening the doctrine tab** with vanilla's new
`countrydoctrinetreeview.gui` against the mod's empty (grand-doctrine-less) doctrine folders throws a
**CTD** rather than rendering blank.

**Can the owner safely defer to the 1.19 endgame? → YES, with one gate.** Deferral (option C) is safe for
**loading and general play**. It is only *fully* safe once a `-debug` run confirms the **doctrine tab does
not CTD on open**; the engine's own `has_any_grand_doctrine` trigger (a first-class "this folder has no
grand doctrine" test) is strong evidence the empty-folder state is *tolerated by design*, which is why I
land on "runnable, tab-CTD unconfirmed" rather than the updater's more cautious "assessed crash-class."

This **downgrades the updater's verdict** (it said "load-bearing / assessed crash-class," leaning toward
un-loadable) to **degraded-runnable**, while keeping D6 a real OWNER DECISION (the subsystem is broken; the
fix is a large interpretive rework). Confidence: **HIGH** it loads; **MEDIUM-HIGH** the tab does not hard-
crash; **HIGH** the subsystem is non-functional as shipped.

---

## CONFIRMED CORRECT (updater's calls I independently reproduced)

### C1 — `descriptor.mod` bump — correct, and it is the ONLY mod-file edit
- Verified on disk: `3273913964/descriptor.mod` line 37 = `supported_version="1.17.*"`.
- `git show 2179d0b --stat` confirms Jump 3 touched **only** `descriptor.mod` (2 lines: `-1.16.* / +1.17.*`);
  everything else in the commit is `PORTING/` documentation. The "one mod edit" claim is true.
- `"1.17.*"` is the correct minor-wildcard form (matches 1.17.0–1.17.5+). File is ASCII/LF, no BOM (re-checked).
- Corroboration: confirmed-1.17 mod `kasanakisara/new-aor` ships `supported_version="1.17.*"`; the format is current.

### C2 — Building rework: flat `max_level` still LOADS on 1.17; the `00_buildings.txt` override is safe
- Read `common/buildings/00_buildings.txt`: 17 building defs, **only** flat `max_level = N` + `shares_slots`,
  **zero** new tokens (`level_cap`/`state_max`/`province_max`/`strategic_location` → 0 whole-repo, re-verified).
- **`max_level` is still valid on the current patch and coexists with `level_cap`** — proven by GitHub code
  search over `common/buildings/00_buildings.txt` in version-current mods: **EaW (1.19), `deliciousmods/1956_beta`,
  `Rekordny/Project_IRIS`, `Gtym33/Kursach`** ship files that **mix** flat `max_level` with the new
  `level_cap`/`state_*_max_level_terrain_limit` keys in the same file; **Anterra2, RSR, MFU-Updated,
  Hearts-of-Rokh, GDU-2.0, zcel329/PDX-HOI4-GS** ship flat `max_level` like CBtS. Both schemas parse concurrently.
- No building-def field became required in 1.17; per-state-type limits key off the pre-existing
  `state_category`; Strategic Locations are an **opt-in** province property. The override loads and imposes
  the same flat caps as on 1.14–1.16. **No edit needed.** (Non-adoption of the new limit system = modernization, not a port fix.)

### C3 — `cl_tech` → `ca_tech`: vanilla content migration; mod is self-contained; NO rename
- Verified on disk: mod declares **both** `cl_tech` (00_technology.txt:45) and `ca_tech` (:46) in its own
  same-filename override of the category list. Light-cruiser techs use `categories = { naval_equipment cl_tech }`
  in the mod's own `naval.txt`/`MTG_naval.txt`; mod ships its own `cl_tech`/`cl_tech_research` loc.
- Tech categories are mod-defined data, not an engine enum. **1.17+ mods still freely declare/use `cl_tech`** —
  GitHub `cl_tech path:common/technology_tags` hits dozens of current mods. A blind `cl_tech→ca_tech` rename
  would actively **break** the mod (merging two categories it keeps distinct). **No edit is the correct call.**
- Residual (unchanged from updater U2, LOW): an engine hardcode of vanilla's `cl_tech` in the ship-designer UI
  that a mod can't override. No evidence of it; close at `-debug` (grep `error.log` for `cl_tech`/`unknown category`).

### C4 — Medium Battery tech-line removal: mod's modules unaffected; NO edit
- Verified on disk: `common/units/equipment/modules/00_ship_modules.txt` defines the mod's **own**
  `ship_medium_battery_1..4` (`category = ship_medium_battery`, `module_category = ship_medium_battery`,
  `parent` chains) and the hull's `allowed_module_categories` include the mod's own
  `ship_medium_battery` / `ship_light_medium_battery`. The vanilla *tech-line* removal does not delete the
  mod's *module-category* data; the cruiser designer stays internally consistent. **No edit.**

### C5 — `ai_templates` left untouched; 1.17 made no AI-template schema change
- Verified on disk: all 9 `common/ai_templates/*` still use `match_to_count` + plural `roles = { }`; **zero**
  singular `role =` (no new-schema adoption). The 1.17 army-side change is the *doctrine* rework, not the
  division designer. The deferred 1.15-schema migration target (D1) is **unchanged by 1.17**. Correctly untouched.

### C6 — New-1.17-token collision check is clean (independently reproduced)
- Whole-mod grep (excl. `pdx_documentation/`) for every additive 1.17 token = **0 files** each:
  `level_cap, province_max, state_max, strategic_location, natural_harbor, set_sub_doctrine, set_grand_doctrine,
  has_mastery_level, add_mastery, has_doctrine, has_completed_track, has_any_grand_doctrine, max_track_columns,
  max_track_rows, grand_doctrine, sub_doctrine`. No forward references, no name collisions. Matches changes.md.

---

## NEEDS FIX (load-blocking) — **NONE**

I found **no** change that blocks the mod from loading on 1.17. The descriptor bump is the only required
load edit and it is already applied. The doctrine subsystem is broken but, per the headline, is assessed
**not load-blocking** (see OWNER DECISION D6 for the bounded tab-CTD caveat). Everything else 1.17
removed/renamed/format-changed is either escaped by the mod's self-contained overrides or unused.

---

## OWNER DECISION — D6 doctrine rework (the sharpened verdict; most important output)

### What 1.17 actually did (re-derived, with the mechanism the updater under-specified)
The new doctrine data lives in a **new directory the mod does not have**:
`common/doctrines/grand_doctrines/` (`land_/naval_/air_/special_forces_grand_doctrines.txt`) +
subdoctrines, driving a new GUI **`interface/countrydoctrinetreeview.gui`** (the inner view file other
mods carry is `interface/doctrines/doctrines_view.gui`; the canonical top-level vanilla file modders edit
is `countrydoctrinetreeview.gui` — the dossier's name is correct). A grand doctrine has shape:
`folder = land`, `xp_cost`, `xp_type = army`, `tracks = { infantry combat_support armor operations … }`,
`milestones`, effects (verified against real 1.17/1.19 files + the cwtools `doctrine_grand_doctrines.cwt`
and `doctrine_subdoctrines.cwt` schemas, and EaW's `_documentation.md`). Subdoctrines have **required**
fields `track / name / description / icon / xp_cost / xp_type`.

**Correction to the updater's mental model:** the grand-doctrine `folder = land` field is **not** a
reference to the `technology_folders` script name. Confirmed-1.17 mod `new-aor` declares
`land_doctrine_folder` (doctrine=yes) and has **no** folder literally named `land`, yet its grand doctrine
uses `folder = land` — so `folder =` maps to the doctrine **type/ledger** (`land/air/naval/sea`), linked to
the `doctrine = yes` folder by type. **Consequence:** the mod's `00_technology.txt` override
(`land_/naval_/air_/special_forces_doctrine_folder`, all `doctrine = yes`) is **structurally identical to
what current working 1.17/1.19 mods declare** (new-aor, EaW, Millennium Dawn, East-Showdown all declare the
exact same four `*_doctrine_folder` blocks). The override is **not** deleting a `land` folder that vanilla
grand doctrines depend on. This removes the single scariest "catastrophic dangling folder" hypothesis.

### The three hypotheses, adjudicated
- **(a) Hard CTD on load — REJECTED (HIGH confidence).** Old doctrine *folders* and old doctrine
  *technologies* in `common/technologies/land_doctrine.txt` **parse on 1.17–1.19**. Direct proof:
  `kasanakisara/new-aor` (`supported_version="1.17.*"`) and `East-Showdown` (`"1.19.*"`) each ship a **full,
  live** `common/technologies/land_doctrine.txt` with `doctrine = yes` + `doctrine_name` + `xp_research_type`
  + `enable_tactic` + `folder { name = land_doctrine_folder }` — `new-aor`'s file is **near-identical** to
  CBtS-FF's (same `mobile_warfare … masterful_blitz` tech list). The wiki confirms: doctrines "are still
  considered technologies in the in-game code, although there are some differences in their required
  definitions." A mod is not made un-loadable merely by *having* these.
- **(c) Loads + silently degrades — CONFIRMED as the floor (HIGH confidence).** The mod ships **no**
  `common/doctrines/` and **no** doctrine GUI, so the new engine has zero grand/subdoctrine data to present.
  The old doctrine techs are "still technologies in code" but doctrines are "no longer researched as
  technologies," so the **43-odd `has_tech = <doctrine>` gates degrade**: every check against an old
  *land/SF* doctrine tech (32 hits — see below) can only fire if that tech is still acquirable, and every
  check against an **air/naval** doctrine name (`base_strike`, `air_superiority`, `fleet_in_being`,
  `trade_interdiction`, `formation_flying`, `force_rotation` — these are **vanilla** doctrine techs the mod
  does NOT define and 1.17 reworked) will **silently return false forever**. Net: doctrine-gated AI division
  ratios, doctrine-bonus spirits, and a focus availability quietly stop working. Game runs.
- **(b) CTD only when the doctrine tab is opened — UNRESOLVED, residual risk (MEDIUM-HIGH it does NOT crash).**
  This is the one gap reachable sources won't close deterministically. Arguments it is **tolerated**: (i) the
  engine ships `has_any_grand_doctrine`, an explicit trigger for "folder has no grand doctrine" — engines do
  not add a predicate for a state that always hard-crashes; (ii) the mod's doctrine folders use the same
  vanilla-style identifiers the working mods use. Arguments it **could** crash: the wiki stresses the GUI is
  "very interconnected with the doctrine definitions," and modder reports describe old-doctrine mods showing a
  spectrum of "crashes on the main menu / loading screen issues / empty doctrine tabs" depending on the exact
  mismatch — i.e., some configs DO CTD at the GUI. I could not find a report isolating *exactly* the CBtS
  configuration (vanilla-named doctrine folders + old techs + zero grand doctrines + vanilla GUI).

### Option assessment
- **(A) Migrate** to `common/doctrines/grand_doctrines/` + subdoctrines + adapt `countrydoctrinetreeview.gui`,
  and convert the doctrine `has_tech` refs to `has_doctrine`/`has_mastery_level`. **Correct and faithful**, but
  a large interpretive rework (the mod also re-tunes org/XP/tactics). Best done with the D1 `ai_templates`
  migration at the 1.19 endgame. Note A is **bigger** than the dossier implies: the air/naval refs point at
  vanilla doctrine names, so A must also re-map those to the new naval/air subdoctrines.
- **(B) Delete** the `land_doctrine.txt` + `special_forces_doctrine.txt` overrides and the doctrine-folder
  blocks in `00_technology.txt` → inherit vanilla 1.17 doctrines. **Caveat the dossier got right and I
  reinforce:** B does **not** fix the references — all doctrine `has_tech` refs (land/SF *and* air/naval) must
  still be reworked or they no-op. B also discards the mod's bespoke doctrine tuning. Correctness OK, fidelity low.
- **(C) Defer** (like `ai_templates`). **SAFE for load and play** on the evidence above. Safe for the
  doctrine *tab* **pending** the `-debug` open-the-tab check. This is the recommended interim posture;
  it is *more* defensible than the updater implied, because (a) is rejected, not merely "unconfirmed."

### Required disambiguation (single highest-leverage action — unchanged, but now narrowly targeted)
Owner runs **1.17 `-debug`**, loads the mod, and **opens the Army / Navy / Air doctrine tabs**, then greps
`error.log`/`crashes/`. This is now a **single yes/no** question — "does the tab open without CTD?" — not an
open-ended investigation, because load-CTD (a) and silent-degrade (c) are already settled. If the tab opens
(blank/partial is fine), defer is fully safe and the doctrine work folds into the 1.19 endgame.

---

## STILL UNCERTAIN (bounded; all close out at the end-of-port `-debug` pass)

- **U-A (the one that matters): doctrine-tab CTD on open** — see D6(b). Best evidence says *probably not*
  (engine has `has_any_grand_doctrine`; vanilla-named folders), but no source isolates the exact CBtS config.
  → owner `-debug`, open all three doctrine tabs. **This is the only finding gating the defer decision.**
- **U-B: exact runtime acquirability of old doctrine techs.** Whether the mod's old land/SF doctrine techs can
  still be *granted/completed* at all on 1.17 (some may be reachable via the legacy tech path; air/naval names
  are vanilla and gone). Affects how badly (c) degrades, not whether it loads. → `-debug` + in-game check that
  `has_tech = mobile_warfare` ever turns true.
- **U-C: `cl_tech` engine hardcode** (LOW) — carried from U2; close at `-debug`.
- **U-D: low-profile stale token across ~2,000 `common/` files.** My removed/renamed sweep (doctrines,
  buildings, `cl_tech`, Medium Battery, faction effects) found nothing else load-breaking; the basic faction
  effects the mod uses (`create_faction`/`add_to_faction`/…) are long-standing and untouched by the 1.17
  *additive* faction-mechanics system. Residual exhaustiveness risk over 2k files → `-debug` `error.log` grep
  for `unknown`/`unexpected token`/`invalid`. Same SU-class mitigation as Jumps 1–2.

---

## Reference data (for whoever does the eventual doctrine rework)

**Mod doctrine assets (old schema):** `common/technologies/land_doctrine.txt` (~62 techs,
`mobile_warfare … masterful_blitz`), `common/technologies/special_forces_doctrine.txt` (~30 techs,
`special_forces_mountaineers … paras_keystone_2`), folder block `common/technology_tags/00_technology.txt:230-248`
(`land_/naval_/air_/special_forces_doctrine_folder`, each `doctrine = yes`). Mod has **no** `common/doctrines/`
and **no** doctrine `*.gui`. Mod's `common/combat_tactics.txt` (own override) supplies the `enable_tactic = tactic_*`
targets the old doctrine techs reference (internally consistent as data).

**Doctrine `has_tech` references that need rework (file:line, by target type):**
- *Land/SF doctrine techs (32 hits — internal to the mod, currently consistent as data):*
  `common/ideas/army_spirits.txt` (12: mobile_warfare/superior_firepower/trench_warfare/mass_assault),
  `common/scripted_triggers/00_scripted_triggers.txt` (10: the `ai_land_doctrine_tier_1/2_trigger` OR-blocks —
  elastic_defence/mobile_defence/grand_assault/defence_in_depth/kampfgruppe/mechanised_offensive/branch_interoperation/infiltration_assault/vast_offensives/large_front_offensive),
  `common/ai_strategy/doctrines.txt` (8: mobile_warfare/superior_firepower/concentrated_fire_plans×2/trench_warfare/mass_assault/large_front_operations×2 → `role_ratio` AI strategies),
  `common/technologies/special_forces_doctrine.txt` (1: NOT special_forces_paratroopers),
  `common/ideas/_economic.txt` (1: NOT volkssturm).
- *Air/Naval doctrine names → VANILLA techs the mod does NOT define (these silently no-op on 1.17; **24 hits**
  by exact recount: fleet_in_being / trade_interdiction / base_strike / air_superiority / formation_flying /
  force_rotation, plus battlefield_support / operational_integrity / strategic_destruction occurrences):*
  spread across `common/ideas/navy_spirits.txt`, `common/ideas/air_spirits.txt`, `common/ai_strategy/doctrines.txt`,
  `common/national_focus/GER_Hitler_Military.txt`, and AI-tier triggers.
  *(Recount: **land/SF doctrine `has_tech` = 32**, **air/naval doctrine `has_tech` = 24**, total **56** —
  materially MORE than the dossier's "43 across 6 files," which conflated the two classes and undercounted.
  The 32 land/SF resolve to mod-defined techs [currently consistent as data]; the 24 air/naval resolve to
  vanilla doctrine names 1.17 reworked and **already no-op today**. Under option A both classes need rework;
  option B fixes neither.)*

**Migration exemplars (confirmed correct shape, reachable via raw.githubusercontent):**
`kasanakisara/new-aor` (1.17 — kept old `land_doctrine.txt` + added `common/doctrines/grand_doctrines/`),
`East-Showdown` (1.19), `EaW-Team/equestria_dev` (1.19, has `common/doctrines/grand_doctrines/_documentation.md`),
cwtools `Config/common/doctrine_grand_doctrines.cwt` + `doctrine_subdoctrines.cwt` (authoritative field schema).

---

## Sources
- hoi4.paradoxwikis.com — **Doctrine modding** (current 1.17+ page; quoted: doctrines "still considered
  technologies in the in-game code, although there are some differences in their required definitions";
  `doctrine = yes` marks a doctrine folder; GUI = `interface/countrydoctrinetreeview.gui`, "very interconnected
  with the doctrine definitions"; `has_any_grand_doctrine` "checks if a certain folder has any assigned grand
  doctrine"); **Patch_1.17 / Patch_1.17.X** (doctrine rework; building-limit rework + Natural Harbor; `cl_tech`
  removed→`ca_tech`=Cruiser Technology; Medium Battery tech line removed; 1.17.1 "fixed crash in
  has_mastery_level when invalid subdoctrine used"; 1.17.2 land_mastery_gain_factor / active doctrine-track
  trigger / has_any_grand_doctrine / energy_gain_factor); **Land/Naval/Air/Special-forces doctrine**;
  **Technology / Building / State modding**.
- updatecrazy.com 1.17.2 patch-note mirror (modding bullets quoted).
- GitHub `mcp__github__search_code`: `max_track_columns` (new schema in `common/doctrines/grand_doctrines/*`
  across EaW, East-Showdown, World-Ablaze, MFU-Updated, new-aor, Project IRIS, …); `doctrine_name`
  `path:common/technologies` (old `land_doctrine.txt` still shipped by current mods incl. East-Showdown,
  new-aor, Breaking-Point, Pax Britannica Redux); `"doctrine = yes" "ledger = army"`
  `path:common/technology_tags` (identical 4-folder block in new-aor/EaW/Millennium Dawn/East-Showdown/…);
  `"max_level" "base_cost" path:common/buildings` (flat `max_level` ± `level_cap` mixed in 1.17/1.19 mods).
- raw.githubusercontent reads: new-aor & East-Showdown `land_doctrine.txt` + `descriptor.mod` + `00_technology.txt`;
  new-aor `land_grand_doctrines.txt`; EaW `_documentation.md` & `descriptor.mod`; cwtools
  `doctrine_grand_doctrines.cwt` / `doctrine_subdoctrines.cwt`.
- Mod-on-disk reads + greps (all file:line evidence above); `git show 2179d0b` (Jump-3 changed only descriptor.mod).
- Channel notes: live wiki + Patch_1.17 page bodies JS-walled to WebFetch (re-confirmed); GitHub MCP
  `get_file_contents` locked to `nafoas/placeholder` this session; `search_code` is repo-wide and reliable.
