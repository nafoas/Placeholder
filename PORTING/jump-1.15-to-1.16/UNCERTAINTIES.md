# Jump 2 — 1.15 → 1.16 (Graveyard of Empires) — Uncertainties (non-load-bearing, best-supported calls)

None of the items below block loading or crash the game (so none is a BLOCKER per the mandate).
Each records the best-supported decision plus what the audit agent / owner should confirm.

---

## U1 — Duplicate province building blocks in 3 state files (1.16 now *reports* this; pre-existing bug)
- **1.16 change (verbatim sense):** 1.16 "added a check to detect duplicate province building
  blocks overriding each other in state history files." Forum corroboration: "if you try to tell
  the state which buildings go in provinces twice, you'll get an error message instead of it
  silently failing." (hoi4.paradoxwikis.com/Patch_1.16 ; forum/WebSearch.)
- **Severity / load-bearing?** **Non-load-bearing.** HOI4 logs validation errors of this kind to
  `error.log` and the game **still loads and runs**; the message is surfaced in-game only under
  `-debug`. (hoi4.paradoxwikis.com/Troubleshooting: the game continues with validation errors
  logged.) The runtime building outcome is **identical** to 1.14/1.15 — the later
  `<provinceID> = { ... }` block silently overrides the earlier one, exactly as before. 1.16
  changed *reporting*, not *behavior*.
- **Where (verified by reading each file):**
  - `history/states/327-Philippines.txt` — inside `history.buildings`, province **10265** appears
    twice: lines 20-23 `{ bunker = 1  # Fort William McKinley\n coastal_bunker = 4 }`, then lines
    24-26 `{ naval_base = 4 }`. **Later block wins → bunker + coastal_bunker silently dropped; only
    naval_base = 4 applies.** (Latent content bug — same on 1.14/1.15.)
  - `history/states/466-Quebec.txt` — province **13384** twice: lines 15-17 `{ naval_base = 1 }`,
    lines 21-23 `{ naval_base = 1 }`. **Identical → net result unchanged (naval_base = 1).**
    Harmless apart from the new warning.
  - `history/states/695-Curacao.txt` — province **153** twice: lines 13-15 `{ naval_base = 1 }`,
    lines 16-18 `{ coastal_bunker = 2 }`. **Later block wins → naval_base silently dropped; only
    coastal_bunker = 2 applies.** (Latent content bug — same on 1.14/1.15.)
- **Best-supported call (applied):** **leave all 3 unchanged.** Rationale: (a) non-load-bearing;
  (b) these duplicates **predate 1.16** — the override behavior was identical on the 1.14/1.15
  baseline the faithful port preserves, so 1.16 "broke" nothing here, it only *reports* the
  pre-existing override; (c) merging the duplicate blocks would **change game state** vs. that
  baseline (Philippines would gain a bunker + coastal_bunker; Curaçao would gain a naval_base),
  which is exactly the kind of behavior change the faithful-port mandate reserves for the owner.
  Analogous to jump-1's `locked = yes` disposition — but flagged more strongly here because the
  duplicates cause **silent building loss** the original author very likely did not intend.
- **Audit/owner to confirm / fix (if the buildings were intended):** the correct dedup is to MERGE
  each province's two blocks into one (this matches what the author probably meant and removes the
  1.16 warning):
  - Philippines 10265 → `10265 = { bunker = 1  coastal_bunker = 4  naval_base = 4 }`
    (NB: verify the intended `naval_base` level — currently the second block's `4` wins; if the
    author meant a different value, set it here).
  - Quebec 13384 → `13384 = { naval_base = 1 }` (drop the duplicate; no value change).
  - Curaçao 153 → `153 = { naval_base = 1  coastal_bunker = 2 }`.
  This is a content-fidelity decision (it re-adds buildings that are currently silently dropped),
  so it should be an explicit owner choice, ideally confirmed against a 1.16 `-debug` `error.log`
  grep over `history/states/` for the duplicate-province-building warning.

## U2 — Completeness of the 1.16 removed/renamed-token list (full verbatim Database section not obtainable)
- **Fact:** I could not obtain one verbatim dump of the **full** base-1.16.0 "Database / Modding"
  changelog section. The live Paradox wiki and the official forum release-notes thread
  (forum.paradoxplaza.com/.../graveyard-of-empires-release-notes.1730282) are JS-walled to
  WebFetch/curl, and on this content the forum is also walled to the WebSearch backend; steamdb /
  steam-announcement detail bodies 403/don't render; the GitHub wiki mirror has no "Patch 1.16"
  page. I reconstructed the modder-facing surface by cross-reading the wiki Patch_1.16 /
  Patch_1.16.X summaries (via WebSearch) from ~18 query angles, the sihmar (1.16.1) and updatecrazy
  (1.16.5) rendered mirrors, and **positive token-survival checks** against the current
  (~1.18/1.19) GitHub wiki mirror.
- **Best-supported call:** 1.16 introduced **no removed/renamed/format-changed script token the mod
  uses.** Confidence: HIGH for the items positively confirmed (focus `bypass`/`bypass_effect` both
  valid; MIO folder structure current; `max_level` still valid; `all_enemy_country` still valid),
  MEDIUM-HIGH on exhaustiveness (the same short additive list recurred on every query angle and no
  "Removed/Renamed" line ever surfaced; the mod uses none of the new tokens).
- **Residual risk:** a low-profile removed/renamed token used somewhere in the 2,007 `common/`
  files that no reachable source enumerated for 1.16. Best mitigation = the end-of-port 1.16 (or
  1.19) `-debug` `error.log` pass (same as jump-1 SU-2). I deliberately did NOT assert any crash or
  hard parse-break; the mod will LOAD on 1.16.

## U3 — `common/buildings/00_buildings.txt` flat `max_level` overrides — fine on 1.16, re-verify on 1.17
- **Fact:** the mod ships `common/buildings/00_buildings.txt` (not `replace_path`'d; same filename
  as vanilla → it **overrides** vanilla's building definitions for ALL buildings), using the flat
  `max_level = N` / `shares_slots = yes` schema. On 1.16 this is fully valid (`max_level` unchanged;
  the `level_cap`/`province_max`/`state_max` rework + Strategic Locations is **1.17**).
- **Best-supported call (applied):** **no edit this jump.** On 1.16 the overrides work as before.
- **For the 1.17 (Jump 3) agent:** re-verify this file against the 1.17 building rework. `max_level`
  still works on 1.17 (it coexists with `level_cap`), but because this file **overrides vanilla's
  building defs**, the mod will NOT inherit 1.17's new per-state-type / per-island building limits
  or `level_cap`/Strategic-Location behavior for these buildings unless the file is updated. Whether
  to adopt the 1.17 limits is an owner/modernization decision for that jump.
