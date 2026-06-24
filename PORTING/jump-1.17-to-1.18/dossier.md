# Jump 4 — 1.17 → 1.18 (Peace for Our Time) — Breaking-change dossier

Scope: modder-facing **breaking** changes (removed / renamed / format-changed / newly-required-validation) in
HOI4 1.18, filtered to what the CBtS Fan Fork (`/3273913964`) actually uses. Each entry: what changed,
source(s), whether the mod uses it (grep evidence file:line), required action.

**Version facts (verified):** 1.18.0 + the **Peace for Our Time** free update released **2026-04-22**
(checksum `3bae`). Point releases run on wiki Patch_1.18.X (1.18.1, **1.18.2** — Paradox forum thread
`hearts-of-iron-iv-patch-1-18-2.1923735`, …). 1.18 is a **free update**, not a full expansion: its headline
items are a **war-score / peace-conference rebalance**, a **submarine-detection formula overhaul**, **AI
overhauls (GER/ITA/UK)**, and new **Train + Helicopter MIO content** for several majors. The modder-facing
**breaking** surface is therefore **small** — materially smaller than 1.17 (the doctrine rework) and on par
with the additive-only Jumps 1 (1.15) and 2 (1.16).

**Research method:** live Paradox wiki + forum bodies are JS-walled to WebFetch/curl (re-confirmed this run —
`forum.paradoxplaza.com` returns the "required part couldn't load" shell; `soren.com` 403; `patched.gg` 403),
so breaking claims were obtained via the **WebSearch backend** (which reads wiki/forum bodies and quotes them),
cross-checked ≥2 ways against: the **GitHub raw-markdown mirror** `klimPaskov/Agentic-HOI4-Modding/paradox_wiki/*`
(current ≈1.18/1.19 pages — Equipment / Modifiers / MIO / Defines modding fetchable as raw `.md`; **no
per-patch page** — `Patch_1.18.md` 404, same as every prior jump), **GitHub code search**
(`mcp__github__search_code`, repo-wide) over 1.18-current mods for token-survival / descriptor convention,
the **patched.gg / xpgained.co.uk** rendered patch-note mirrors (via WebSearch backend + one successful
WebFetch of xpgained), and the bundled ~1.14 `pdx_documentation/`. GitHub MCP `get_file_contents` is locked to
`nafoas/placeholder` this session (same as the Jump-3 audit); `search_code` is repo-wide and was used.

---

## NET RESULT (read first)

**1.18 requires exactly ONE mod edit — the `descriptor.mod` `supported_version` bump (item #1, APPLIED).**
Nothing else 1.18 changed breaks this mod. Every other 1.18 change is **additive**, **balance/AI**, or **new
content**, and where it touches a subsystem the mod overrides, the mod is **insulated by its self-contained
same-filename overrides** (the same posture that protected it through 1.17's `cl_tech`/Medium-Battery/building
migrations). Specifically:

- **Submarine-detection overhaul (item #2) = a DEFINES + FORMULA change, NOT a stat/modifier rename.** 1.18
  added the defines `SUBMARINE_BASE_STEALTH_VALUE`, `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`,
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER` and tuned their values. The **equipment stats** that
  feed the formula — `sub_detection`, `sub_visibility`, `surface_detection`, `surface_visibility`,
  `sub_attack`, `naval_speed`, `torpedo_attack`, `naval_range`, `anti_air_attack` — are **all still valid** on
  the current Equipment-modding page. The mod uses these stats heavily in its own ship-hull/module overrides
  (456 occurrences / 23 files) but uses **none** of the new submarine defines (0 hits), and does **not**
  override them in `common/defines/cbts_defines.lua`. → **No edit.** The mod inherits the new formula
  automatically; re-tuning the new defines is an optional **modernization** item.
- **Train + Helicopter MIOs (item #3) = new CONTENT, format unchanged.** MIO organization schema
  (`equipment_type` / `research_categories` / `allowed` / `initial_trait` / `trait`) gained **no required
  field**. The mod `replace_path`s the MIO `organizations` folder, so it simply **does not gain** the new
  vanilla Train/Helicopter MIOs — a behavioral non-adoption, not a load break. The `train_manufacturer` hits
  in the mod are the long-standing equipment-designer **company trait**, not the new MIO. → **No edit.**
- **War-score / peace-conference rebalance (item #4) = DEFINES/AI values, no token removed.** Faction war-score
  contribution `0.125 → 0.1`; sunk-ship-IC war-score halved. These are internal balance values; **no
  peace-conference scripting token was removed/renamed.** The mod's own `common/peace_conference/*` overrides
  (cost_modifiers / categories / ai_peace) use unchanged formats. → **No edit.**
- **AI overhaul GER/ITA/UK (item #5) = vanilla AI script/balance.** The mod `replace_path`s `common/ai_strategy`,
  `ai_focuses`, `ai_strategy_plans`, `ai_equipment`, so it **overrides vanilla AI** for these areas; the 1.18
  vanilla AI improvements do not reach the mod (non-adoption). No format break. → **No edit.**
- **Modding section (item #6)** — the entire 1.18.0 + 1.18.X "Modding" section is **two additive items**:
  (a) `pp_spend_priority` now also supports **targeting advisors**; (b) stability-check error-checking now
  verifies normalized range based on defines. Both additive/internal. The mod's existing `pp_spend_priority`
  usage (category form, e.g. `id = admiral`) is unchanged. → **No edit.**
- **`ai_templates` / doctrines** — re-confirmed **no 1.18 schema change** to either (items #7, #8). Both stay
  **untouched** per HARD RULES 1 & 2 (deferred D1 / D6).
- **`replace_path` (27 targets) all remain canonical 1.18 folders** (verified each exists on disk) — 1.18
  restructured no replaced folder. → **No edit.**

The descriptor bump (#1) is the only load-bearing change. **No BLOCKERS.** This jump resembles Jumps 1–2.

---

## 1. `descriptor.mod` supported_version — **ACTION REQUIRED (DONE)**

- **What:** mod declared `supported_version="1.17.*"`. To load on 1.18 without the launcher's "made for an
  older version" flag it must declare 1.18.
- **Mod uses it?** Yes — `descriptor.mod:37`.
- **Correct value:** `"1.18.*"` — minor-wildcard form; `*` matches any 1.18.x build (1.18.0, 1.18.1, 1.18.2, …).
  Same convention the mod already used through every prior jump. Verified the dominant convention among real
  1.18 mods via GitHub `search_code` (`"1.18.*" filename:descriptor.mod`, 99 hits): `"1.18.*"` is by far the
  most common (e.g. `roteKlaue/eaw-stl` [Equestria at War addon], `inkitter/HOI4_mod` Easybuff,
  `Total-Mobilisation/No-Shells-No-Victory`, `chardynamics/vanilla-training-wheels` [TNO addon],
  `Vodanov/tzarmod`, …); a few use `"1.18.*.*"` or `"1.18.*.0"` (also valid). `descriptor.mod` must **not** be
  UTF-8 BOM (verified: file is plain ASCII / no BOM — first 3 bytes `6e 61 6d` = `nam` of `name=`; edit
  preserved this).
- **Action:** edited `descriptor.mod:37` → `supported_version="1.18.*"`. (Only mod-file edit this jump.)
- **Sources:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM rule); GitHub code search
  `"1.18.*" filename:descriptor.mod` (real-mod convention); wiki Patch_1.18 / Patch_1.18.X (1.18.x version table).

## 2. SUBMARINE-DETECTION OVERHAUL — defines + formula only; equipment stats UNCHANGED; mod self-contained, NO EDIT

- **What 1.18 changed:** "Submarine detection now uses a new formula (ported from the open beta)" + "Tweaked
  the submarine detection formula." Mechanically this is a **defines** change: 1.18 carries the open-beta
  submarine-rework defines `SUBMARINE_BASE_STEALTH_VALUE`, `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`,
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER`, with tuned values
  (`SUBMARINE_REVEAL_DETECTION_MULTIPLIER` 0.1→0.075→**0.065** across the beta/point releases;
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER` 1→1.1). It is a **reformulation of how the existing
  stats combine**, NOT a removal/rename of any stat or modifier.
- **Verified that NO naval equipment stat or modifier was removed/renamed:** the current (≈1.18/1.19)
  Equipment-modding page lists, still valid: `sub_detection` ("Ability to detect submarines"), `sub_visibility`
  ("How easy it is to detect"), `surface_detection`, `surface_visibility`, `sub_attack` ("Anti-submarine
  attack"), `naval_speed`, `torpedo_attack`, `naval_range`, `anti_air_attack`, `lg_/hg_attack`,
  `lg_/hg_armor_piercing`, `port_capacity_usage`, `search_and_destroy_coordination`,
  `convoy_raiding_coordination`. The only stats marked **(OBSOLETE)** are `fire_range`, `shore_bombardment`,
  `evasion` — and those have been obsolete since the **MtG** naval rework (pre-1.18), not a 1.18 change.
- **Does the mod use it? YES (the stats), on its OWN terms — and NOT the new defines:**
  - Uses the naval stats heavily in its **own same-filename overrides** of ship hulls/modules:
    `common/units/equipment/ship_hull_submarine.txt` (36), `ship_hull_cruiser.txt` (56),
    `ship_hull_heavy.txt` (43), `ship_hull_light.txt` (31), `ship_hull_carrier.txt` (25),
    `modules/00_ship_modules.txt` (28), `upgrades/naval_upgrades.txt` (10), `convoys.txt` (3), plus MIO
    (`organizations/00_generic_organization.txt:82`, `policies/_navy_policies.txt`, `ai_bonus_weights.txt`),
    ideas (`germany.txt`, `romania.txt`), `country_leader/companies.txt`, `unit_leader/00_traits.txt` — 456
    occurrences / 23 files total (grep). All resolve to stats that **still exist on 1.18**.
  - Ships a **defines override** `common/defines/cbts_defines.lua` (Lua additive override of ~110 named
    defines across NAI/NCountry/NDiplomacy/NMilitary/NOperatives/NTechnology/NTrade/NGraphics/NGame), but it
    overrides **none** of the three new submarine defines (grep
    `SUBMARINE_BASE_STEALTH_VALUE|SUBMARINE_REVEAL_DETECTION_MULTIPLIER|SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER`
    over `common/` → **0**).
  - Does **not** use the OBSOLETE stats: the mod's only `shore_bombardment*` hits are the **modifier**
    `shore_bombardment_bonus` (`special_forces_doctrine.txt:809`, `unit_leader/00_traits.txt:1635,2205` —
    a long-standing modifier, distinct from the obsolete equipment stat `shore_bombardment`), and the only
    `evasion` hits are **localisation prose** ("draft evasion" in `CBTS_YUG_l_english.yml`). No `fire_range`
    use anywhere. So the obsolete-stat list is irrelevant to the mod (and was already obsolete pre-1.18).
- **Load-bearing?** **No.** The overhaul renamed/removed no token the mod references; the mod doesn't touch the
  new defines. The mod's ship designer stays internally consistent (its hulls reference its own modules/stats),
  and it simply **inherits** 1.18's new submarine-detection behavior — exactly the faithful-port outcome.
- **Required action:** **none.** Re-tuning the three new submarine defines to taste is an **optional
  modernization** item (the mod re-tunes many other defines but has no submarine-detection defines today) →
  MODERNIZATION-REPORT. → UNCERTAINTIES U1 (residual: confirm at `-debug` that no submarine-define key the
  mod *doesn't* set produces a warning — it won't; not setting a define is normal).
- **Sources:** wiki Patch_1.18 + Patch_1.18.X (submarine detection new formula; tweaks); patched.gg open-beta
  naval-rework notes (the three submarine defines + their values); GitHub mirror **Equipment modding** page
  (naval stat list still valid; OBSOLETE set = fire_range/shore_bombardment/evasion, pre-1.18); mod grep +
  reads (`cbts_defines.lua`, ship-hull files) — evidence cited inline.

## 3. TRAIN + HELICOPTER MIOs — new CONTENT, MIO format unchanged; mod self-contained, NO EDIT

- **What 1.18 changed:** Added **Train MIOs** (to ENG, FRA, BEL, USA, SOV, ITA, JAP, GER) and **Helicopter
  MIOs** (to BEL, USA, JAP, GER) — new vanilla MIO **content** for those majors, plus the corresponding
  train/helicopter equipment lines those MIOs attach to.
- **MIO schema change?** **None.** The MIO-modding page's required organization fields are unchanged —
  `equipment_type`, `research_categories`, `allowed`, `initial_trait`, `trait` — and no field was made newly
  required, removed, or renamed for 1.18. (The MIO doc carries no version stamp but is the current ≈1.18/1.19
  page.)
- **Does the mod use it?** The mod ships its **own** MIO definitions (it `replace_path`s
  `military_industrial_organization/{organizations,policies,ai_bonus_weights}` — full folder replacement, so
  vanilla's MIO files for those majors do not load at all). It defines a generic tank/ship/air MIO set in
  `organizations/00_generic_organization.txt` (verified schema: `equipment_type = { mio_cat_eq_… }`,
  `research_categories`, `initial_trait`, `trait { token … equipment_bonus … }` — all current-format). The
  `train`/`helicopter` grep hits in the mod are **false positives**: `train_manufacturer` (company designer
  trait in `country_leader/companies.txt:803`, `ideas/{czechoslovakia,italy_ministers,germany}.txt`) and
  `mio_header_trains` (a localised MIO header-text key at `00_generic_organization.txt:1252`) — neither is a
  new-1.18 Train MIO. The mod adopts **none** of the new Train/Helicopter MIO content.
- **Load-bearing?** **No.** New vanilla MIO content for those majors is simply **not loaded** (the mod replaces
  the MIO `organizations` folder), so there is nothing to conflict. Non-adoption of the new Train/Helicopter
  MIOs = a **modernization** choice, not a port fix.
- **Required action:** **none.** Adopting the new Train/Helicopter MIOs (and their equipment lines) → optional
  MODERNIZATION-REPORT item.
- **Sources:** wiki Patch_1.18 (Train MIOs → ENG/FRA/BEL/USA/SOV/ITA/JAP/GER; Helicopter MIOs →
  BEL/USA/JAP/GER); GitHub mirror **MIO modding** page (required fields unchanged); Mod_structure (replace_path
  = full folder replacement); mod read (`00_generic_organization.txt`) + grep.

## 4. WAR-SCORE / PEACE-CONFERENCE REBALANCE — defines/AI values; no scripting token removed; mod self-contained, NO EDIT

- **What 1.18 changed:** the headline "Peace for Our Time" rebalance of how war score is earned: **faction
  war-score contribution `0.125 → 0.1`**; **war score from sunk ships halved** (halved the contribution from
  sunk ship IC, to align with land-combat warscore gain); plus AI peace-deal behavior tuning. These are
  **internal balance values** (in the war-score/peace defines + engine), not a change to peace-conference
  **script formats**.
- **Peace-conference modding-format change?** **None surfaced.** No removed/renamed peace-conference scripting
  token (e.g. no `scripted_diplomacy_action`-class removal found across the query angles). The peace-conference
  cost-modifier / category / ai_peace formats are unchanged.
- **Does the mod use it?** The mod ships **same-filename overrides** under `common/peace_conference/`
  (`cost_modifiers/*` incl. `00_generic_peace.txt`, `ENG/ITA/JAP/FRA/FIN/DEN/ETH_peace.txt`, `yalta_peace.txt`;
  `categories/00_peace_action_categories.txt`; `ai_peace/*`) — these are **not** `replace_path`'d, so they
  override the matching vanilla files by filename. It also sets a few **peace defines** in `cbts_defines.lua`
  (`PEACE_SCORE_PER_PASS = 0.65`, `BASE_PEACE_PUPPET_FACTOR = 0`, `BASE_PEACE_LIBERATE_FACTOR = 0`) — these are
  **different** defines from the ones 1.18's war-score rebalance changed (faction-contribution / sunk-IC), so
  there is **no conflict**: the mod's peace tuning continues to apply on top of 1.18's rebalanced war-score
  values.
- **Load-bearing?** **No.** No token removed/renamed; formats unchanged; the mod's peace files and peace
  defines load and apply exactly as before. The interaction of the mod's existing peace tuning with 1.18's new
  war-score balance is a **behavioral** matter (the owner may wish to re-balance), not a load break.
- **Required action:** **none.** Re-balancing the mod's peace tuning against 1.18's war-score changes →
  optional MODERNIZATION-REPORT note.
- **Sources:** wiki Patch_1.18 + patched.gg/soren.com/xpgained mirrors (faction contribution 0.125→0.1; sunk-IC
  halved); WebSearch for removed peace/diplomacy scripting tokens (none found); mod inventory
  (`common/peace_conference/*`) + `cbts_defines.lua` read.

## 5. AI OVERHAUL (Germany / Italy / UK) — vanilla AI script/balance; mod OVERRIDES vanilla AI, NO EDIT

- **What 1.18 changed:** large vanilla-AI behavior improvements — **Germany** (better MEFO-bill management,
  more Barbarossa troops, "Service By Requirement" conscription priority, Berlin-Moscow-axis fallback if
  surrounded), **Italy** (North-Africa defense/screening, airforce use in Africa), **UK** (Egypt defense,
  convoy-escort efficiency, Tripoli/Iraq offensives). These are changes to **vanilla** `common/ai_strategy` /
  `ai_focuses` / scripted AI behavior and weights.
- **Does the mod use it?** The mod **`replace_path`s** `common/ai_strategy`, `common/ai_strategy_plans`,
  `common/ai_focuses`, and `common/ai_equipment` — i.e. it **wholesale replaces** vanilla's AI strategy/focus
  files with its own (CBtS is heavily AI-tuned: `ai_strategy/{GER,SOV,USA,JAP,ITA,FIN,…}.txt`, `default.txt`,
  `CBTS_general_AI_strategies.txt`). 1.18's vanilla AI improvements live in files the mod **does not load**.
- **Load-bearing?** **No.** No format break; the AI changes are content the mod overrides. Consequence: the mod
  **does not inherit** 1.18's GER/ITA/UK AI improvements (non-adoption) — a known, accepted property of a
  heavily-AI-replacing mod, not a port fix.
- **Required action:** **none.** Porting desirable 1.18 AI improvements into the mod's own AI files →
  optional MODERNIZATION-REPORT note (and overlaps the deferred D1 `ai_templates` question for division
  design, which 1.18 did **not** change — see #7).
- **Sources:** wiki Patch_1.18 + mirrors (GER/ITA/UK AI bullets); mod descriptor `replace_path` list + grep
  (`common/ai_strategy/*`).

## 6. MODDING-SECTION ADDITIONS (`pp_spend_priority` → advisors; stability-check validation) — additive, NO EDIT

- **What 1.18 changed (the entire 1.18.0 + 1.18.X "Modding" section, verbatim, two items):**
  (a) "Added support for **`pp_spend_priority` to target advisors**" — extends an existing AI-strategy token
  to a new target class; (b) "Updated the error checking for stability checks to verify the **normalized range
  based on defines**" — an internal validation tweak (tightens range-checking of stability triggers against
  defines).
- **Does the mod use it?** Yes — `pp_spend_priority` is used widely in the mod's (replace_path'd)
  `common/ai_strategy/*` in the **category** form: `{ type = pp_spend_priority  id = <admiral|relation|
  guarantee|…>  value = N }` (e.g. `default.txt:2038-2064`, `GER.txt:2204,2227`, `CBTS_general_AI_strategies.txt:9,23,29`,
  `JAP.txt`, `USA.txt`, `SOV.txt`, `FIN.txt`). 1.18 only **adds** advisor-targeting as an *additional*
  capability; the existing category usage is **unchanged and still valid**.
- **Load-bearing?** **No.** Additive extension of a token the mod already uses correctly; internal validation
  change cannot break valid script. No mod usage of any new advisor-targeting form to validate.
- **Required action:** **none.** (Using `pp_spend_priority` to also weight specific advisors → optional
  modernization.)
- **Sources:** wiki Patch_1.18 + Patch_1.18.X "Modding" bullets (via WebSearch backend + xpgained/patched
  mirrors, cross-checked); mod grep (`pp_spend_priority` usages + sample read).

## 7. AI division-template / division-designer schema — NO 1.18 CHANGE; `ai_templates` stays DEFERRED, untouched

- **What checked (per mandate):** whether 1.18 made any AI-template/division-designer schema change that would
  move the deferred-migration target (D1).
- **Finding:** **none.** 1.18's army-relevant changes are AI *behavior* (item #5) and Train/Helicopter MIO
  *content* (item #3), not the division designer or the `ai_templates` role schema. No 1.18 patch line or
  AI-modding change touches `match_to_count` / plural `roles` / `target_width` / `front_role_override`. The
  deferred 1.15-schema target is **unchanged by 1.18**. (Re-verified: all 9 `common/ai_templates/*` still use
  `match_to_count` + plural `roles =`; the deferred-migration target is the same.)
- **Action:** **none — do not touch `ai_templates`** (HARD RULE 1 / D1).
- **Sources:** wiki Patch_1.18 / Patch_1.18.X (army change is AI behavior + MIO content, not division designer);
  GitHub mirror **MIO modding** (no division-designer change); mod grep.

## 8. DOCTRINE SYSTEM — NO 1.18 CHANGE; doctrines stay DEFERRED (D6), untouched

- **What checked (per mandate):** whether 1.18 further changed the doctrine system (which is the deferred D6
  BLOCKER from Jump 3 — old-format land/SF doctrines vs. 1.17's new Grand/Sub/Mastery engine).
- **Finding:** **no 1.18 doctrine-system change** surfaced. 1.18's naval-relevant change is the **submarine
  *detection* formula** (defines — item #2), not the **naval *doctrine*** system. No new/removed doctrine
  token (`set_grand_doctrine` / `set_sub_doctrine` / `has_mastery_level` / `has_any_grand_doctrine` /
  `add_mastery` / `max_track_columns|rows`) and no change to the doctrine GUI coupling was reported for 1.18.
  The D6 situation is **unchanged by 1.18**: the mod still ships old-format `land_doctrine.txt` +
  `special_forces_doctrine.txt` overriding vanilla, old doctrine folders in `00_technology.txt`, and the 56
  doctrine `has_tech` refs — all exactly as Jump 3 left them.
- **Action:** **none — do not touch the doctrine files** (HARD RULE 2 / D6). The 1.18-relevant note for the
  eventual D6 migration: 1.18 added no doctrine surface, so the Jump-3 migration target (1.17 Grand/Sub/Mastery
  schema) is still the correct target as of 1.18.
- **Sources:** wiki Patch_1.18 / Patch_1.18.X (submarine *detection* is defines/formula, not the naval
  *doctrine*; no doctrine bullets); GitHub mirror **Naval doctrine** unchanged; mod state unchanged from Jump 3.

## 9. Characters / decisions / on_actions / scripted_gui / states / focus / map / GUI — NO 1.18 FORMAT BREAK

- No 1.18 character-DB / decision / on_action / scripted-GUI / state-history / focus / map-format **break**
  surfaced across the query angles run. 1.18's modder-facing changes outside the above are **additive** (item
  #6) or **content/balance**. `map/buildings.txt` 7-column format and `history/states` building-block parsing
  unchanged. The 1.18.X hotfixes are crash/balance/content fixes (rocket-silo SAM-on-naval-region CTD; Mac
  peace-conference CTD; duplicate Slovak-navy-chief idea-token fix; army-leader-cost-reduction removals;
  taskforce/strike-force/supply fixes) — none removes a script token.
- **`replace_path` targets (27):** all remain canonical 1.18 folders (verified each exists on disk; list in
  changes.md). 1.18 restructured no replaced folder. No edit.
- **Sources:** wiki Patch_1.18 / Patch_1.18.X (additive + content/balance + hotfix list); GitHub mirror
  State / MIO / Modifiers / Equipment / Defines pages (formats current); mod greps + descriptor verify.

## 10. 1.18 ADDITIVE / content surface (mod uses NONE — collision check clean) → MODERNIZATION-REPORT

New (additive) defines/features/content in 1.18.0–1.18.X; the mod references none of the new tokens (whole-mod
grep clean):
- Defines (additive): `SUBMARINE_BASE_STEALTH_VALUE`, `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`,
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER` (submarine rework), plus tuned naval-strike/carrier
  defines (`NAVAL_STRIKE_CARRIER_MULTIPLIER` 10→12, `CARRIER_COMBAT_DAMAGE_STATS_MULTIPLIER` 0.35→0.5 — value
  tweaks of pre-existing defines). Mod overrides none.
- Script: `pp_spend_priority` extended to advisor targets (additive); stability-check normalized-range
  validation (internal).
- Content: Train MIOs (ENG/FRA/BEL/USA/SOV/ITA/JAP/GER) + Helicopter MIOs (BEL/USA/JAP/GER) and their
  equipment lines; war-score/peace rebalance; GER/ITA/UK AI overhaul; Japan 1936/1939 naval-OOB corrections
  (Hatsuharu/Minekaze DDs, Takao CAs, IJN Yugao). Mod adopts none.

---

### Sources (consolidated)
- hoi4.paradoxwikis.com/Patch_1.18 ; /Patch_1.18.X ; /Peace_For_Our_Time (via WebSearch backend — JS-walled to
  direct WebFetch, re-confirmed)
- hoi4.paradoxwikis.com (via GitHub raw-markdown mirror, current ≈1.18/1.19):
  Equipment modding (naval stat list still valid; OBSOLETE = fire_range/shore_bombardment/evasion);
  Military industrial organization modding (required org fields unchanged); Modifiers ; Defines ; Mod_structure
- patched.gg "Peace for Our Time" + open-beta naval-rework notes (submarine defines + values); xpgained.co.uk
  1.18 patch notes (Modding section = the two additive bullets; submarine "new formula"); soren.com 1.18
  summary (war-score 0.125→0.1, sunk-IC halved; GER/ITA/UK AI) — all via WebSearch backend (bodies JS-walled)
- GitHub code search (mcp__github__search_code): `"1.18.*" filename:descriptor.mod` (99 hits → `"1.18.*"`
  convention) across eaw-stl, HOI4_mod/Easybuff, No-Shells-No-Victory, vanilla-training-wheels, tzarmod, …
- Bundled 3273913964/pdx_documentation/ (~1.14 effects/triggers/modifiers reference)
- Mod grep + file reads (descriptor.mod, common/defines/cbts_defines.lua, ship-hull/module overrides,
  00_generic_organization.txt, ai_strategy/*, peace_conference/*) — all file:line evidence cited inline.
