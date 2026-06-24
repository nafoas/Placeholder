# Jump 4 — 1.17 → 1.18 (Peace for Our Time) — Uncertainties

**No BLOCKERS this jump.** 1.18 required only the `descriptor.mod` bump (changes.md). The items below are
**non-load-bearing**, best-supported calls. The standard close-out for all of them is the owner's end-of-port
**`-debug` `error.log`** pass (planned at the 1.19 endgame), which converts static analysis into
engine-confirmed fact.

---

## U1 — Submarine-detection overhaul is defines/formula-only; mod inherits it; residual = "did 1.18 rename a stat I didn't catch?" (LOW, non-load-bearing)

- **Fact:** 1.18's submarine-detection overhaul is a **defines + formula** change (added
  `SUBMARINE_BASE_STEALTH_VALUE`, `SUBMARINE_REVEAL_DETECTION_MULTIPLIER`,
  `SUBMARINE_REVEAL_TORPEDO_FIRING_DETECTION_MULTIPLIER`; tuned their values), **not** a stat/modifier rename.
  The naval **equipment stats** the mod uses (`sub_detection`, `sub_visibility`, `surface_detection`,
  `surface_visibility`, `sub_attack`, `naval_speed`, `torpedo_attack`, `naval_range`, `anti_air_attack`) are
  **all still valid** on the current Equipment-modding page (cross-checked). The mod overrides **none** of the
  new submarine defines and does not set them in `cbts_defines.lua`, so it **inherits** the new formula
  automatically — the faithful-port outcome.
- **Best-supported call (applied):** **no edit.** Re-tuning the three new submarine defines (to preserve a
  specific pre-1.18 detection feel) is an **optional modernization** choice, not a port fix → MODERNIZATION-REPORT.
- **Residual risk (LOW, non-load-bearing):** the verbatim base-1.18.0 "Database" block is not obtainable as a
  single dump (live wiki/forum JS-walled — same caveat as every prior jump), so there is a thin chance a
  low-profile naval stat was *also* renamed and not surfaced. Mitigants: the current Equipment-modding page
  shows the full naval-stat list intact; the patch-note "submarine detection" wording is **formula**, not
  "renamed/removed stat"; the OBSOLETE set is unchanged (and unused by the mod). Confidence **HIGH** that no
  stat the mod uses was renamed. Close out at `-debug` (grep `error.log` for `unknown`/`unexpected token` in
  `common/units/equipment/`). → dossier #2.

## U2 — `cbts_defines.lua` override vs. any 1.18-removed define name (LOW, non-load-bearing)

- **Fact:** the mod's `common/defines/cbts_defines.lua` is a Lua **additive** override of ~110 named defines
  (all long-standing core keys; full enumeration in dossier #2/#4). 1.18's define changes were **additive**
  (submarine defines) + **value tweaks** (war-score faction-contribution / sunk-IC; naval-strike/carrier
  multipliers) — to defines the mod **does not set**. No 1.18 patch line removed/renamed a define the mod
  overrides.
- **Best-supported call (applied):** **no edit.** The override loads and applies as on 1.14–1.17. A define
  that no longer exists would be a silent no-op in the Lua override (HOI4 tolerates setting an
  unknown/removed define key), so even a missed rename is **non-load-bearing**.
- **Residual risk (LOW):** exhaustiveness over ~110 keys against an un-dumpable 1.18.0 Database block. Mitigant:
  none of the mod's keys relate to 1.18's actual changes (submarine / war-score / AI / MIO). Close out at
  `-debug` (grep `error.log` for `define`/`unknown`). → dossier #2.

## U3 — Non-adoption of new 1.18 behavior is intentional (FYI; behavioral, not a load risk)

- **Fact:** because the mod overrides the relevant folders/files, it **does not inherit** several 1.18
  improvements: the new **Train/Helicopter MIOs** (mod `replace_path`s MIO `organizations`), the **GER/ITA/UK
  AI** overhaul (mod `replace_path`s `ai_strategy`/`ai_focuses`/`ai_strategy_plans`/`ai_equipment`), and the
  new war-score *balance* interacts with the mod's own peace tuning rather than replacing it. The submarine
  *detection formula* **is** inherited (defines, not overridden).
- **Best-supported call (applied):** **no edit** — this is correct faithful-port behavior (preserve the mod's
  systems; don't graft new vanilla content/AI). Each non-adoption is logged as an **optional modernization**
  item → MODERNIZATION-REPORT.
- **Residual risk:** none for loading. Purely a balance/feel decision for the owner. Confidence **HIGH**.

## U4 — Full verbatim 1.18.0 "Database/Modding" changelog block not obtainable as one dump (same caveat as Jumps 1–3)

- **Fact:** as in every prior jump, the single verbatim base-1.18.0 "Database/Modding" changelog block is not
  obtainable through any rendering channel here (live wiki/forum JS-walled to WebFetch — re-confirmed:
  `forum.paradoxplaza.com` returns the JS-shell error; `soren.com`/`patched.gg` 403; mirror has no per-patch
  page — `Patch_1.18.md` 404). The 1.18 modder-facing surface was reconstructed from WebSearch-backend reads
  of Patch_1.18 / Patch_1.18.X (many angles) + the xpgained/patched mirrors + the current modding mirror
  pages (Equipment / MIO / Modifiers / Defines) + GitHub code search, cross-checked ≥2 ways per claim. The
  surface **converged** consistently: the **entire 1.18 "Modding" section is two additive items**
  (`pp_spend_priority`→advisors; stability-check range validation), the submarine overhaul is **defines/formula**,
  and Train/Helicopter MIOs + war-score + AI are **content/balance** — none removes/renames a token the mod uses.
- **Best-supported call:** apart from the descriptor bump, 1.18 removed/renamed/format-changed **no script
  token the mod uses** in a load-breaking way. Confidence **HIGH** for the positively confirmed items (naval
  stats survive; MIO schema unchanged; `pp_spend_priority` additive; new submarine defines unused; defines
  unaffected), **MEDIUM-HIGH** on exhaustiveness over the mod's ~2,000 `common/` files.
- **Residual risk / mitigation:** a low-profile removed/renamed token somewhere in `common/` that no reachable
  source enumerated for 1.18 → close out with the end-of-port **`-debug` `error.log`** pass (grep
  `unknown`/`unexpected token`/`invalid`). Same SU-class mitigation as Jumps 1–3.
