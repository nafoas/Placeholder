# Jump 3 — 1.16 → 1.17 (No Compromise, No Surrender) — Uncertainties & the one BLOCKER

Unlike Jumps 1–2, this jump has a genuine **BLOCKER** (U1, the doctrine rework — load-bearing, escalated
to the human/owner, NOT auto-fixed). U2/U3 are non-load-bearing best-supported calls. The standard
end-of-port close-out for all of them is the owner's **`-debug` `error.log`** pass on 1.17.

---

## U1 — **BLOCKER**: 1.17 doctrine rework vs. the mod's old-format land + special-forces doctrines

- **Why this is a BLOCKER (not a normal uncertainty):** it is **load-bearing** (assessed crash-class — see
  below) AND its only correct fix is a **large interpretive rework** the faithful-port mandate forbids
  guessing at. The mandate: *"If after genuinely exhausting research you still can't resolve something that
  is load-bearing, STOP and report it as a BLOCKER — do NOT insert something random."* That is this item.
- **1.17 change:** "Replaced existing doctrine trees for Army, Navy and Air with a new doctrines system" —
  **Grand Doctrines + Subdoctrines + Mastery**, milestones, and a new doctrine GUI
  (`interface/countrydoctrinetreeview.gui`, "very interconnected with the doctrine definitions"). Doctrines
  are "no longer researched as technologies" but "**still considered technologies in code, with some
  differences in their required definitions**"; vanilla's old `common/technologies/land_doctrine.txt` "no
  longer exists in its original form." New script surface: triggers `has_doctrine`, `has_mastery_level`,
  `has_completed_track`, `has_any_grand_doctrine`; effects `set_grand_doctrine`, `set_sub_doctrine`,
  `add_mastery`/`add_mastery_bonus`; grand-doctrine props `max_track_columns`/`max_track_rows`. 1.17.X
  patched doctrine CTDs (e.g. `has_mastery_level` with a bad sub doctrine).
- **What the mod has (verified by read + grep):**
  - Old-format land + SF doctrine **tech trees** overriding vanilla (same filename = full replacement):
    `common/technologies/land_doctrine.txt` (`mobile_warfare`/`superior_firepower`/`trench_warfare`/
    `mass_assault`/… `doctrine = yes` + `doctrine_name` + `enable_tactic`), `special_forces_doctrine.txt`.
  - Old-style doctrine **folders** in its own `common/technology_tags/00_technology.txt:230-248`
    (`land_/naval_/air_/special_forces_doctrine_folder`, `doctrine = yes`, no grand/track/subdoctrine data).
  - **43** old doctrine-tech references via `has_tech = …` across **6** files:
    `common/ideas/army_spirits.txt` (12), `navy_spirits.txt` (9), `air_spirits.txt` (6),
    `common/ai_strategy/doctrines.txt` (12), `common/scripted_triggers/00_scripted_triggers.txt` (1),
    `common/national_focus/GER_Hitler_Military.txt` (3).
  - **No** doctrine GUI in the mod → uses vanilla 1.17's **new** `countrydoctrinetreeview.gui`.
  - Air/naval doctrines **not** overridden → inherits vanilla 1.17's **new** ones (mixed old-land + new-air/
    naval state). Uses **none** of the new doctrine tokens (no forward refs).
- **Load-bearing assessment (and the honest gap):** the mod's doctrine **data** is internally consistent,
  but the runtime pairing of an **old-format land/SF doctrine folder** with **vanilla 1.17's new doctrine
  engine + GUI** is the exact configuration the community reports **crashing** ("several modders reporting …
  crashes when old custom doctrines are not properly updated to work with the new doctrine tree view
  system"; "doctrine trees moved to a new folder … compatibility issues with older mods"; 1.17.X doctrine
  CTD fixes). **I could not obtain a single authoritative statement pinning the exact failure mode** —
  load-error vs. silent-degrade vs. CTD-only-on-opening-the-doctrine-tab — and that gap is precisely why
  this is escalated rather than dispositioned: the consequence ranges from "playable but doctrines broken"
  to "hard crash," and choosing the remedy depends on which it is.
- **Options for the owner (none is a faithful one-liner — mirrors the `ai_templates` D1 decision):**
  - **(A) Migrate** land + SF doctrines to the new Grand/Sub/Mastery schema, adapt/ship the doctrine GUI,
    and convert the 43 `has_tech = <doctrine>` refs to `has_doctrine` / `has_mastery_level`. Faithful to
    intent; large interpretive rework (best done with the eventual `ai_templates` migration at the 1.19
    endgame).
  - **(B) Delete** the mod's `land_doctrine.txt` + `special_forces_doctrine.txt` overrides and the
    doctrine-folder overrides in `00_technology.txt` → inherit vanilla 1.17 doctrines; the 43 `has_tech`
    refs still need reworking to the new triggers (else they silently no-op).
  - **(C) Defer** (like `ai_templates`), only if `-debug` confirms it does **not** hard-crash on load / on
    opening the doctrine tab.
- **Recommended immediate step:** owner runs **1.17 `-debug`**, loads the mod, opens the Army/Navy/Air
  doctrine tabs, and greps `error.log` for doctrine/`has_mastery_level`/`unknown`/CTD — this turns
  "assessed crash-class" into engine-confirmed fact and selects A/B/C. **Until then, treat the doctrine
  subsystem as broken on 1.17.** Logged to DECISIONS-NEEDED **D6**.
- **Sources:** Patch_1.17 / Patch_1.17.X; wiki Doctrine/Land/Naval/Air/Special-forces doctrine modding;
  WebSearch surfacing modder crash reports + "doctrines moved to a new folder"; GitHub code search showing
  the real new schema in 1.17+ mods (incl. an explicit `sub_doctrine = marines_1 # has_tech = … old
  equivalent` migration comment in Project IRIS); mod reads + greps. (dossier #1)

## U2 — `cl_tech` self-contained override: residual engine-hardcode risk (non-load-bearing)

- **Fact:** 1.17 removed vanilla's `cl_tech` category (merged into `ca_tech` = "Cruiser Technology"). The
  mod is **insulated**: it declares `cl_tech` (and `ca_tech`) itself in `00_technology.txt`, defines its
  light-cruiser techs with `categories = { naval_equipment cl_tech }` in its own naval files, and ships its
  own `cl_tech`/`cl_tech_research` loc — all same-filename full overrides, fully self-consistent. Technology
  categories are mod-definable data (wiki); dozens of 1.17+ mods still declare/use `cl_tech` (GitHub).
- **Best-supported call (applied):** **no edit.** `cl_tech` exists for this mod because the mod declares it;
  every reference is internal; vanilla's removal of *vanilla's* `cl_tech` does not reach the mod. (A
  `cl_tech`→`ca_tech` rename would actively **break** the mod's internal consistency — explicitly avoided.)
- **Residual risk (low, non-load-bearing):** only if the engine hardcodes a `cl_tech`-specific binding the
  mod cannot override (e.g. a ship-designer/naval-UI tie-in). No evidence of this (categories are data;
  other 1.17 mods use `cl_tech` cleanly). Confidence **HIGH** that it loads; close out at the `-debug` pass
  (grep `error.log` for `cl_tech`/`unknown category`). → dossier #3.

## U3 — `00_buildings.txt` flat `max_level` overrides: load fine on 1.17; new limit features not adopted

- **Fact:** the mod's `common/buildings/00_buildings.txt` (same-filename **full override** of all vanilla
  building defs) uses only flat `max_level = N` / `shares_slots`. On 1.17 **`max_level` still parses and
  coexists with the new `level_cap = { state_max / province_max / shares_slots }`** (current Building-modding
  wiki lists `max_level` as a valid alternative; GitHub shows both schemas in current mods). The mod uses
  **zero** new-schema tokens and references no Strategic Locations; the per-state-type limits key off the
  existing mandatory `state_category` (no new state data required), and no building-def field became
  required in 1.17.
- **Best-supported call (applied):** **no edit this jump.** The mod's buildings load and impose the same
  flat caps as on 1.14–1.16.
- **Consequence to note (behavioral, not a load break):** because this file **overrides** vanilla's
  `level_cap`-based defs, the mod will **not** inherit 1.17's per-state-type / per-island building limits,
  `level_cap` behavior, or Strategic-Location bonuses (Natural Harbor etc.) for these buildings. Whether to
  adopt the 1.17 limit system is an **owner/modernization** decision (→ MODERNIZATION-REPORT). Confidence
  **HIGH** that it loads. → dossier #4.

## U4 — Full verbatim 1.17.0 "Database/Modding" changelog section not obtainable as one dump (same caveat as Jumps 1–2)

- **Fact:** as in prior jumps, the single verbatim base-1.17.0 "Database" changelog block is not obtainable
  through any rendering channel here (live wiki/forum JS-walled to WebFetch; mirror has no per-patch page;
  Steam announcement bodies don't render). The 1.17 modder-facing surface was reconstructed from the
  WebSearch-backend reads of Patch_1.17 / Patch_1.17.X (many angles) + the modding mirror pages + GitHub
  code search, cross-checked ≥2 ways per breaking claim. The surface **converged** consistently: the only
  removed/format-changed items relevant to a mod are the **doctrine rework** (U1), **`cl_tech`** (U2/#3),
  the **building-limit** rework (U3/#4), and the **Medium-Battery tech-line** removal (#5) — all of which
  the mod either escapes via self-contained overrides or has flagged. Everything else 1.17 added is
  additive and unused (dossier #8).
- **Best-supported call:** apart from the escalated doctrine BLOCKER, 1.17 removed/renamed/format-changed
  **no other script token the mod uses** in a load-breaking way. Confidence **HIGH** for the positively
  confirmed items (`cl_tech` survives as mod data; `max_level` still parses; MIO structure current; new
  tokens unused), **MEDIUM-HIGH** on exhaustiveness over the mod's ~2,000 `common/` files.
- **Residual risk / mitigation:** a low-profile removed/renamed token somewhere in `common/` that no
  reachable source enumerated for 1.17 → close out with the end-of-port **`-debug` `error.log`** pass (grep
  `unknown`/`unexpected token`/`invalid`). Same SU-2 mitigation as Jumps 1–2.
