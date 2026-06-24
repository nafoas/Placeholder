# Jump 5 — 1.18 → 1.19 (Thunder at our Gates) — Uncertainties

**No BLOCKERS this jump.** 1.19 required **two** mod edits (changes.md): the real removed-token fix
(`add_temporary_buff_to_units` → `unit_modifiers`, 4 ability usages) and the `descriptor.mod` bump. The items
below are **non-load-bearing**, best-supported calls. The standard close-out for all of them is the owner's
end-of-port **`-debug` `error.log`** pass (planned at this 1.19 endgame), which converts static analysis into
engine-confirmed fact.

---

## U1 — `tooltip`/`days` were dropped from the migrated abilities (LOW, non-load-bearing — cosmetic only)

- **Fact:** the old `add_temporary_buff_to_units` blocks carried `days = 7` (a buff duration) and
  `tooltip = ABILITY_FORCE_ATTACK_TOOLTIP` / `ABILITY_LAST_STAND_TOOLTIP` (a custom hover string). In the
  `unit_modifiers` migration, `days` is **dropped** (the ability's own `duration` now governs how long the
  modifier applies) and `tooltip` is **dropped** to match the **canonical vanilla-1.19 form** (vanilla's
  `force_attack`/`last_stand` `unit_modifiers` blocks carry neither). A small minority of 1.19 mods (e.g.
  `mengxinxier/Adorable-heart-beta1`'s `SOV_abilities.txt`) kept `tooltip` inside `unit_modifiers`; the majority
  + vanilla omit it.
- **Best-supported call (applied):** **drop both**, matching vanilla 1.19. Behavior is preserved: the abilities
  still apply the same stat modifiers for the same effective window (governed by `duration = 168`, as the
  abilities already declared). The two custom `*_TOOLTIP` loc keys still exist in the mod's localisation (now
  simply unreferenced) — harmless.
- **Residual risk (LOW, cosmetic):** the in-game ability tooltip auto-generates from the `unit_modifiers` block
  rather than the bespoke `*_TOOLTIP` string, so the hover text reads slightly differently than pre-1.19 (it
  now lists the modifiers). No load impact, no behavioral/balance impact. If the owner wants the bespoke tooltip
  back, `tooltip = ABILITY_FORCE_ATTACK_TOOLTIP` can be re-added inside the `unit_modifiers` block (observed to
  parse in at least one 1.19 mod) — purely optional polish. Confidence the migration loads + behaves
  faithfully: **HIGH**.

## U2 — `combat_offense`/`combat_defense`/`combat_breakthrough` → `offence`/`defence`/`breakthrough_factor` rename correctness (LOW; cross-confirmed)

- **Fact:** the migration renames three keys (`combat_offense`→`offence`, `combat_defense`→`defence`,
  `combat_breakthrough`→`breakthrough_factor`). These were **parameters of the removed effect's own namespace**,
  not general modifier names; the general `unit_modifiers` pipeline uses `offence`/`defence`/`breakthrough_factor`.
  This is **not a guess** — it is the exact rename **vanilla 1.19 itself** performs on the very same
  `force_attack`/`last_stand` abilities (recovered from the confirmed-1.19 `EoaNB-Team/EoaNB` +
  `mengxinxier/Adorable-heart-beta1` `generic_leader_abilities.txt`), and it is uniform across ~30 confirmed-1.19
  repos (Kaiserreich, Millennium Dawn, East-Showdown, Red-Liberty, World-Ablaze, LotrMod, deliciousmods/1956,
  diosaurreal/tgwr, …). `combat_entrenchment` is **kept** because vanilla 1.19 `last_stand` keeps that exact
  token inside `unit_modifiers`.
- **Best-supported call (applied):** the verified vanilla rename map. A literal carry-over of `combat_offense`
  into `unit_modifiers` (as one minority mod did) risks a silently-ignored key (the buff would not apply); the
  vanilla `offence`/`breakthrough_factor` names are the safe, behavior-preserving choice.
- **Residual risk (LOW):** the live `List_of_modifiers` page was 403/JS-walled this run, so the rename rests on
  the vanilla-1.19 ability text + ~30-repo convergence rather than a single canonical wiki table. Mitigant: the
  vanilla source is authoritative and the convergence is overwhelming; the values are preserved 1:1. Close out
  at `-debug` (grep `error.log` for `unknown`/`unexpected token` in `common/abilities/`, and confirm the
  abilities apply their modifiers in-combat). Confidence: **HIGH**.

## U3 — `add_temporary_buff_to_units` removal: exact failure mode if the fix were absent (FYI; moot — fix applied)

- **Fact:** the wiki/patch-note wording is *"Removes support for `add_temporary_buff_to_units`"*, and community
  reports describe "broken functionality" for old `force_attack`/`last_stand` mods on 1.19. Whether the removed
  token produces a hard `error.log` line, a silent no-op (the ability fires but applies nothing), or is fully
  ignored could not be pinned to a single verbatim source (live wiki/forum JS-walled). This is **moot** for the
  port because the fix was applied (all 4 usages migrated; 0 stragglers), so the abilities now use the supported
  `unit_modifiers` path regardless of the precise pre-fix failure mode.
- **Best-supported call (applied):** **migrate** (done). Faithful-port mandate: re-express the removed token in
  the supported form rather than leave a removed/no-op token in the files.
- **Residual risk:** none for loading (the removed token no longer appears anywhere in the mod). Confidence:
  **HIGH**.

## U4 — Non-adoption of 1.19's new systems is intentional (FYI; behavioral, not a load risk)

- **Fact:** the mod does **not** adopt Army HQs, Ship Captains, the Special-Forces fourth-doctrine page +
  Dispersed Operations subdoctrine, or the 12 Regimental-Support / 11 Army-HQ support companies — these are new
  vanilla systems + content the mod neither ships nor references (and the SF doctrine page belongs to the
  deferred D6 doctrine work). The mod also does not pick up the new content focus trees (Australia/Democratic
  Elections, Siam, Dutch East-Indies) or use any of the new additive modding tokens.
- **Best-supported call (applied):** **no edit** — this is correct faithful-port behavior (preserve the mod's
  systems; don't graft new vanilla content/systems). Each non-adoption is an **optional modernization** item →
  MODERNIZATION-REPORT.
- **Residual risk:** none for loading. Purely a feature/balance decision for the owner. Confidence: **HIGH**.

## U5 — Full verbatim 1.19.0 "Database/Modding" changelog block not obtainable as one dump (same channel caveat as Jumps 1–4)

- **Fact:** as in every prior jump, the single verbatim base-1.19.0 "Database/Modding" changelog block is not
  obtainable through any rendering channel here (live wiki/forum/store-news JS-walled to WebFetch — re-confirmed
  this run: `Patch_1.19` returns the client-challenge shell; `soren.com`/`mod-coop`/`hoi4-modding` Fandom/live
  `List_of_modifiers` → 403). The 1.19 modder-facing surface was reconstructed from WebSearch-backend reads of
  Patch_1.19 / Patch_1.19.X / Thunder_at_our_Gates (many angles) + the **xpgained** (which returned the verbatim
  "Modding" line) and **patched.gg** mirrors + GitHub code search over confirmed-`1.19.*` mods + raw reads of
  vanilla-1.19 ability files, cross-checked ≥2 ways per claim. The surface **converged** consistently: the only
  modding **removal** is `add_temporary_buff_to_units` (fixed); the rest of the "Modding" section is **additive**
  (`unlock_subunit`, `ship_modifiers`, `captured_army_leader`, subdoctrine `xor`/`allow_in_multiple_tracks`/
  multi-track, `officer_xp` on unit medals, `casualty_trickleback` modifier, `is_leader_visible`, decision
  `war_with_*` scoped variables); Army HQs / Ship Captains / SF rework / Regimental Support are **systems +
  content**.
- **Best-supported call:** apart from the `add_temporary_buff_to_units` migration and the descriptor bump, 1.19
  removed/renamed/format-changed **no script token the mod uses** in a load-breaking way. Confidence **HIGH**
  for the positively confirmed items (the removal is the documented one and is fixed; SF/units/characters tokens
  survive; new tokens unused; `war_with_*` literal form survives), **MEDIUM-HIGH** on exhaustiveness over the
  mod's ~2,000 `common/` files.
- **Residual risk / mitigation:** a low-profile removed/renamed token somewhere in `common/` that no reachable
  source enumerated for 1.19 → close out with the end-of-port **`-debug` `error.log`** pass (grep
  `unknown`/`unexpected token`/`invalid`). Same SU-class mitigation as Jumps 1–4. Note 1.19 is a content
  expansion whose modder-facing **breaking** surface is, per all converged sources, the single
  `add_temporary_buff_to_units` removal — so the exhaustiveness residual is the same low-profile-token tail as
  prior jumps, now with the one known removal already handled.

## U6 — D6 doctrine-migration target updated by 1.19's SF doctrine additions (FYI for the deferred endgame, not this jump)

- **Fact:** 1.19 added a **fourth Special-Forces doctrine page** + subdoctrine `xor` / `allow_in_multiple_tracks`
  / multi-track-assignment + a Dispersed Operations subdoctrine — doctrine-system **additions** on top of the
  1.17 Grand/Sub/Mastery schema. These **remove/rename no token** the mod's old-format `special_forces_doctrine.txt`
  / `land_doctrine.txt` currently use (so D6 stays the same degraded-but-runnable, safe-to-defer posture).
- **Implication for D6 (endgame):** when the deferred D6 migration is eventually performed, the target is now
  the 1.17 schema **plus** these 1.19 SF-doctrine features — i.e. the mod's special-forces doctrine should be
  migrated onto the new fourth SF doctrine page using the 1.19 subdoctrine properties. Logged here +
  dossier #8 + the MODERNIZATION-REPORT so the endgame migration aims at the correct final schema.
- **Best-supported call (applied):** **no edit** (HARD RULE 2 / D6). Non-load-bearing for this jump. Confidence:
  **HIGH**.
