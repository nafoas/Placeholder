# Jump 1 — 1.14 → 1.15 — Uncertainties (non-load-bearing, best-supported calls)

None of the items below block loading or crash the game (so none is a BLOCKER per the mandate).
Each records the best-supported decision plus what the audit agent / owner should confirm.

---

## U1 — `terrain_penalty_reduction` modifier: kept vs. deleted in 1.15 (5 mod usages)
- **Verbatim 1.15 note:** "Replaced Terrain Penalty Reduction modifier which was not working in
  National Spirits by the modifier Terrain Traits XP Gain." (hoi4.paradoxwikis.com/Patch_1.15)
- **Semantics:** `terrain_penalty_reduction` reduced terrain combat penalties;
  `terrain_traits_xp_gain` increases XP toward terrain-specialist commander traits — different effect.
  (hoi4.paradoxwikis.com/Terrain)
- **Mod usages:** `common/unit_leader/00_traits.txt:1162` (custom trait, =0.5);
  `common/ideas/japan.txt:940` (=0.1); `common/ideas/ethiopia.txt:277` (=0.3);
  `common/ideas/PAR_ideas.txt:16` (=0.04) and `:35` (=0.06);
  loc `MODIFIER_TERRAIN_PENALTY_REDUCTION` in `localisation/modifiers_l_english.yml:765`.
- **Unresolved:** whether the *token* was removed from the registry, or only its National-Spirit
  behavior changed while a new sibling modifier was added. The enumerated `List_of_modifiers` page
  was unreachable (WebFetch 504/403; absent from the GitHub wiki mirror); WebSearch summaries only
  *infer* removal, they don't quote it.
- **Best-supported call (applied):** leave all 5 usages unchanged. Rationale: (a) non-load-bearing;
  (b) if the token still exists, behavior is preserved exactly (correct); (c) if it was removed,
  the lines warn harmlessly and that one modifier stops applying — but Paradox states it already
  didn't work in National Spirits, so the practical behavior delta is ~nil; (d) renaming to
  `terrain_traits_xp_gain` would silently change game behavior and is forbidden by the faithful-port
  mandate.
- **Audit/owner to confirm:** run 1.15 with `-debug` and check `error.log` for
  "unknown modifier terrain_penalty_reduction"; or read a 1.15+ `List_of_modifiers`. If confirmed
  removed AND the owner wants the *effect* preserved, the correct (behavior-changing, owner-approved)
  step would be to re-implement terrain-penalty reduction via an alternative still-valid mechanism —
  NOT a blind rename to the XP-gain modifier.

## U2 — Inert `map/airports.txt` & `map/rocketsites.txt` after 1.15
- **Fact:** both files were "deprecated and removed in the patch 1.15"; air-base/rocket-site
  placement now lives in `map/buildings.txt`. (hoi4.paradoxwikis.com/Map_modding)
- **Mod state:** ships both files (~16 KB each); `map/buildings.txt` already contains `air_base`
  and `rocket_site` position entries; mod does not `replace_path="map"`.
- **Best-supported call (applied):** leave both files in place (engine ignores them; no load error;
  deletion would be an unrequested content change and risks bytes/encoding churn).
- **Owner to confirm in-game:** that air-base and rocket-site *locations* per state are unchanged
  vs. 1.14. If 1.14 relied on airports.txt/rocketsites.txt to put the air base / rocket site in a
  specific province that `buildings.txt` does not reproduce, those specific placements may shift;
  if so, migrate the intended province into the `buildings.txt` air_base/rocket_site entries. This
  is a behavior-fidelity check, not a load fix.

## U3 — `locked = yes` (vs valid `is_locked`) in 4 templates — pre-existing, out of scope
- **Where:** `history/units/WGR_stahlhelm.txt:11`, `WGR_reichsbanner.txt:12`,
  `ARM_2RCW_Militia.txt:10`, `BRY_2rcw_start.txt:12`.
- **Fact:** the division_template lock property is `is_locked`; bare `locked` is not a recognized
  property and was already a no-op on 1.14. Not a 1.15 change.
- **Call:** left untouched (faithful port fixes only 1.15 breakages). Flagged so the owner can
  decide separately whether these templates were *meant* to be locked (would need `is_locked = yes`).
