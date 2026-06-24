# Jump 5 Audit — 1.18 → 1.19 (Thunder at our Gates) — Independent Review

**Auditor:** Jump-5 Deconstructor/Audit Agent (final jump). **Date:** 2026-06-24.
**Scope:** Independently verify the updater's `add_temporary_buff_to_units` → `unit_modifiers` migration (the
first real code change in the whole 1.14→1.19 port), confirm it is the only 1.19 removal hitting the mod, and
re-derive the 1.19 modder-facing removal surface from scratch. No mod files edited; no commit; no agents.

**Method:** read the post-edit ability files + the `4dc5e0f^→4dc5e0f` git diff (recovers the exact pre-edit
form, byte-level); independent mod-wide removal greps (excl. `pdx_documentation/`); ground-truth the canonical
1.19 form via raw reads of confirmed-`1.19.*` mods (EoaNB, Millennium Dawn) + `mcp__github__search_code` across
~30 `1.19.*` repos; 1.19 modding changelog via WebSearch backend (quotes the live wiki) + the xpgained.co.uk
1.19 mirror. Live `hoi4.paradoxwikis.com/List_of_modifiers` was 403/JS-walled this run (as in prior jumps); the
retained-key validity therefore rests on **live shipping 1.19 mod `unit_modifiers` blocks**, which is stronger
ground truth than a wiki table anyway.

---

## HEADLINE VERDICT (read first)

1. **Is the ability migration EXACTLY correct?  → YES.** All 5 migrated abilities across the 2 files are
   faithful and valid. The 3 key renames (`combat_offense`→`offence`, `combat_defense`→`defence`,
   `combat_breakthrough`→`breakthrough_factor`) are exactly what vanilla/flagship 1.19 ships, confirmed
   byte-for-byte against EoaNB's 1.19 `force_attack`/`last_stand` blocks and ~30 other `1.19.*` repos. The 6
   retained keys are all valid inside a 1.19 ability `unit_modifiers` block (they appear in those same live 1.19
   blocks). All stat values preserved 1:1; the 2 merges (`SOV_last_stand`, `GER_bewegungskrieg`) dropped nothing
   and collided with nothing; `days`/`tooltip` correctly dropped (matches vanilla). Brace/encoding integrity
   clean. **No wrong modifier. No fix required.**

2. **Is `add_temporary_buff_to_units` the ONLY 1.19 removal hitting the mod?  → YES.** Independently
   re-derived: the entire 1.19.0 "Modding" surface beyond this one removal is **additive** (new tokens) — the
   xpgained mirror's modding list shows exactly one "Removes support for…" line and that is
   `add_temporary_buff_to_units`. Mod-wide grep for every new-1.19 token = 0 *use* hits (no collisions, no
   forward refs). SF / character / unit_leader tokens the 1.19 reworks touch all survive (the reworks retain
   them). The migration removed all 4 usages with 0 stragglers in real mod files. **The updater missed no
   removal.**

**No BLOCKERS. No NEEDS-FIX items. The jump is sound as committed (`4dc5e0f`).**

---

## CONFIRMED CORRECT

### C1 — `force_attack` migration is byte-exact to the canonical 1.19 form  (HIGH)
`common/abilities/generic_leader_abilities.txt:35-42`. Pre-edit (from `4dc5e0f^`) was
`one_time_effect { add_temporary_buff_to_units { combat_offense=0.2 combat_breakthrough=0.25
org_damage_multiplier=-1.0 str_damage_multiplier=0.6 war_support_reduction_on_damage=0.2
cannot_retreat_while_attacking=1.0 days=7 tooltip=ABILITY_FORCE_ATTACK_TOOLTIP } }`. Now:
```
unit_modifiers = {
    offence = 0.2
    breakthrough_factor = 0.25
    org_damage_multiplier = -1.0
    str_damage_multiplier = 0.6
    war_support_reduction_on_damage = 0.2
    cannot_retreat_while_attacking = 1.0
}
```
This is **identical** to the `force_attack` `unit_modifiers` block shipped by confirmed-1.19 **EoaNB-Team/EoaNB**
(raw read), **Kaiserreich**, **Choo-Choo-Oreo**, **Donbass-Flames**, **diosaurreal/tgwr**, **deliciousmods/1956**,
**JoeBidenWhatAreYouHiding/kx** (= Kaiserreich), and many more (`search_code`). Renames + values correct; nothing
dropped that vanilla keeps. **Faithful + valid.**
- *Sources:* git `4dc5e0f^→4dc5e0f`; raw read `EoaNB-Team/EoaNB/common/abilities/generic_leader_abilities.txt`
  (force_attack `unit_modifiers` = offence/breakthrough_factor/org_damage_multiplier/str_damage_multiplier/
  war_support_reduction_on_damage/cannot_retreat_while_attacking — no `add_temporary_buff_to_units`/`days`/
  `tooltip`); `mcp__github__search_code` `unit_modifiers offence breakthrough_factor … path:common/abilities`
  (consistent across ~30 `1.19.*` repos).

### C2 — `last_stand` migration is byte-exact to the canonical 1.19 form  (HIGH)
`generic_leader_abilities.txt:61-68`. Pre-edit buff keys `combat_defense=0.2 combat_entrenchment=0.25
org_damage_multiplier=-1.0 str_damage_multiplier=0.6 war_support_reduction_on_damage=0.2
cannot_retreat_while_defending=1.0`. Now `unit_modifiers { defence=0.2 combat_entrenchment=0.25
org_damage_multiplier=-1.0 str_damage_multiplier=0.6 war_support_reduction_on_damage=0.2
cannot_retreat_while_defending=1.0 }`. **Identical** to EoaNB's 1.19 `last_stand` block (raw read) and to
Millennium-Dawn's 1.19 `last_stand` (same keys; MD differs only in two numeric values = balance, not schema).
`combat_offense→combat_defense` is correctly the `combat_defense→defence` rename; `combat_entrenchment`
correctly **kept** (it is a valid `unit_modifiers` key — vanilla 1.19 `last_stand` ships it, and it appears in
1.19 `unit_modifiers` blocks in nadivided-dev, whoward92, GEACPS, Wickedonezzz, zov-organization, etc.).
- *Sources:* git diff; raw reads EoaNB + Millennium-Dawn `generic_leader_abilities.txt` (both: last_stand
  `unit_modifiers` = defence/combat_entrenchment/org_damage_multiplier/str_damage_multiplier/
  war_support_reduction_on_damage/cannot_retreat_while_defending).

### C3 — `SOV_last_stand` merge is lossless and collision-free  (HIGH)
`generic_leader_abilities.txt:337-345`. Pre-edit had a pre-existing `unit_modifiers { paradrop_organization_factor=
-1.0 paratrooper_aa_defense=-1.0 }` **plus** a separate `one_time_effect { add_temporary_buff_to_units {
combat_offense=-0.2 combat_defense=0.2 combat_entrenchment=0.25 org_damage_multiplier=-0.8
str_damage_multiplier=0.5 days=7 tooltip=… } }`. Post-edit single block:
```
unit_modifiers = {
    paradrop_organization_factor = -1.0   # pre-existing, retained
    paratrooper_aa_defense = -1.0         # pre-existing, retained
    offence = -0.2                        # was combat_offense
    defence = 0.2                         # was combat_defense
    combat_entrenchment = 0.25
    org_damage_multiplier = -0.8
    str_damage_multiplier = 0.5
}
```
Both pre-existing keys survive; all 5 migrated keys added with correct renames + 1:1 values; **no key collision**
(the pre-existing pair is paradrop-domain, the migrated set is combat-domain — disjoint). The `one_time_effect`
wrapper correctly removed. **Lossless merge.**
- *Source:* git `4dc5e0f^→4dc5e0f` (the diff shows the merge in place).

### C4 — `GER_bewegungskrieg` merge is lossless and collision-free  (HIGH)
`common/abilities/GER_abilities.txt:23-29`. Pre-edit had pre-existing `unit_modifiers { army_armor_attack_factor=
0.05 army_armor_speed_factor=0.05 army_defence_factor=-0.1 air_cas_present_factor=0.1 }` **plus**
`one_time_effect { add_temporary_buff_to_units { str_damage_multiplier=0.25 days=7 tooltip=… } }`. Post-edit:
the 4 pre-existing keys retained + `str_damage_multiplier=0.25` appended into the same block; wrapper removed.
1 migrated key, no rename needed (`str_damage_multiplier` is unchanged), no collision. **Lossless merge.**
- *Source:* git diff.

### C5 — Dropping `days=7` + `tooltip` preserves behavior  (HIGH)
The old `add_temporary_buff_to_units` carried `days=7` (buff window) and `tooltip=ABILITY_*_TOOLTIP`. All 5
abilities already declare `duration = 168` (hours = 7 days), so the ability-level `unit_modifiers` now applies
for that 7-day window — **identical effective window** to the old `days=7`. `days`/`tooltip` are correctly
dropped to match the canonical vanilla-1.19 form (EoaNB's migrated blocks carry **neither**, confirmed by raw
read). Tooltip now auto-generates from the modifier list (cosmetic; the bespoke `*_TOOLTIP` loc keys are simply
unreferenced — harmless). `force_attack` and `last_stand` are the same `ABILITY_FORCE_ATTACK`/`ABILITY_LAST_STAND`
abilities vanilla migrated, so vanilla's own choice to drop `days`/`tooltip` is the authoritative target. See
also STILL-UNCERTAIN SU1 for the residual (cosmetic) tooltip caveat.
- *Sources:* the abilities' own `duration = 168` (visible in-file); EoaNB raw read (no `days`/`tooltip` in the
  migrated blocks); 1.19 changelog ("adds new `unit_modifiers` to cover these use cases").

### C6 — Retained 6 keys are all valid in a 1.19 ability `unit_modifiers` block  (HIGH)
`org_damage_multiplier`, `str_damage_multiplier`, `combat_entrenchment`, `war_support_reduction_on_damage`,
`cannot_retreat_while_attacking`, `cannot_retreat_while_defending` — each appears inside a **live, shipping 1.19**
ability `unit_modifiers` block: all six in EoaNB's 1.19 `force_attack`/`last_stand`; `cannot_retreat_while_attacking`
+ `war_support_reduction_on_damage` explicitly in Millennium-Dawn's 1.19 `force_attack`;
`cannot_retreat_while_defending` + `combat_entrenchment` in MD's 1.19 `last_stand`. None was renamed/removed by
the SF/combat rework. (The live `List_of_modifiers` wiki table was 403 this run, but a key that flagship 1.19
mods ship inside `unit_modifiers` is necessarily valid on 1.19 — stronger than the table.)
- *Sources:* raw reads EoaNB + Millennium-Dawn; `search_code` (the `cannot_retreat_while_attacking` /
  `combat_entrenchment` matches inside `unit_modifiers` across `1.19.*` repos).

### C7 — Removal sweep: `add_temporary_buff_to_units` fully removed, 0 stragglers in real mod files  (HIGH)
Independent mod-wide grep for `add_temporary_buff_to_units|combat_offense|combat_defense|combat_breakthrough`
returns hits **only** in `pdx_documentation/` (the bundled ~1.14 reference, correctly excluded) and one
unrelated substring `naval_has_potf_in_combat_defense` (a different naval modifier in `unit_leader/00_traits.txt`,
not a migrated key). Both edited files: residual `add_temporary_buff_to_units` = 0, residual stale keys = 0.
Brace balance 84/84 and 12/12; encoding ASCII/CRLF, no BOM (first bytes `61 62 69` = `abi`). Working tree clean;
commit `4dc5e0f` touches exactly the 3 intended mod files (+ the 4 PORTING docs).
- *Sources:* Grep (mod root); Bash brace/encoding/residual check; `git diff --name-only 4dc5e0f^ 4dc5e0f`.

### C8 — `add_temporary_buff_to_units` is the ONLY 1.19 modding removal  (HIGH)
The xpgained.co.uk 1.19 mirror's Modding section lists exactly one removal ("Removes support for
`add_temporary_buff_to_units` and adds new `unit_modifiers`…"); everything else is **additive**: new tokens
`unlock_subunit`, `ship_modifiers`, `captured_army_leader`, `officer_xp`, `casualty_trickleback` (modifier),
`is_leader_visible`, `ai_min_success_chance`, `max_distance`, subdoctrine `allow_in_multiple_tracks` / `xor`,
multi-track subdoctrines, decision `war_with_*` scoped variables, `reduce_focus_completion_cost` localizes
dynamic text, scope `avg_unit_entrenchment_ratio`. WebSearch-backend reads of the live wiki Patch_1.19 + the
Kaiserreich "eight generic temporary general traits to replace now deprecated temporary unit buffs" note
corroborate the single removal. **No second removal exists to miss.**
- *Sources:* xpgained.co.uk 1.19 patch-note mirror (full Modding list, recovered this run); WebSearch backend
  (live Patch_1.19 quote + Kaiserreich adaptation note).

### C9 — Mod uses NONE of the new 1.19 tokens (no collision / forward-ref)  (HIGH)
Independent grep over the mod root (excl. `pdx_documentation/`) for `unlock_subunit | captured_army_leader |
ship_modifiers | allow_in_multiple_tracks | is_leader_visible | ai_min_success_chance |
avg_unit_entrenchment_ratio` → **0 hits each**. So the additive tokens introduce no name collision or forward
reference. (The `casualty_trickleback` / `officer_xp` / `xor` hits the updater flagged are pre-existing,
unrelated forms — an equipment/tech bonus stat, loc strings, and technology-exclusivity syntax respectively —
unaffected by 1.19 additionally registering those names elsewhere.)
- *Source:* Grep (mod root).

### C10 — SF / character / unit_leader tokens the 1.19 reworks touch all survive  (HIGH)
1.19's Special-Forces rework + Army HQs + Ship Captains are **new systems + content**; they retain the existing
sub_unit/character tokens. Mod grep confirms the mod's SF tokens are present and unaffected:
`special_forces=yes`/`marines=yes`/`mountaineers=yes`/`can_be_parachuted=yes`/`category_special_forces|marines|
mountaineers` = 46 occurrences across 15 `common/units/*` files. Ship Captains work within the existing
`navy_leader` framework (no new forced character type); the mod's `corps_commander`/`field_marshal`/`navy_leader`
characters are unaffected. No removed/renamed token in `common/units` / `common/characters` / `common/unit_leader`.
- *Sources:* Grep (`common/units`); 1.19 changelog (SF retains Mountaineers/Marines/Paratroopers; Ship Captains
  within `navy_leader`).

### C11 — `descriptor.mod` = `"1.19.*"`, encoding intact  (HIGH)
`descriptor.mod:37` `supported_version="1.18.*"` → `"1.19.*"` (git diff confirms the single-token change).
`"1.19.*"` is the correct minor-wildcard form (matches 1.19.0/1.19.0.1/1.19.1/…) and the dominant real-mod
convention (EoaNB, Kaiserreich-family, Donbass-Flames, Choo-Choo-Oreo, etc. all `1.19.*`-class). No BOM, plain
ASCII (consistent with the descriptor spec). No stray `1.18` remains.
- *Sources:* git `4dc5e0f^→4dc5e0f` (descriptor); `search_code` `"1.19" filename:descriptor.mod` convergence.

### C12 — Deferred systems untouched (per HARD RULES)  (HIGH)
`git diff --name-only 4dc5e0f^ 4dc5e0f` shows **no** `common/ai_templates/*` and **no** doctrine files
(`land_doctrine.txt`, `special_forces_doctrine.txt`, `00_technology.txt`) among the changes. Both remain at the
prior degraded-but-runnable posture. Independently confirmed 1.19 introduces **no AI-template/division-designer
role-schema change** (its designer change is the additive Regimental-Support row + Army-HQ companies) and that
1.19's doctrine work (4th SF doctrine page + subdoctrine `xor`/`allow_in_multiple_tracks`/multi-track + Dispersed
Operations) is doctrine-system **addition** that removes/renames no token the mod's old-format doctrines use →
the D1/D6 deferral remains correct and safe.
- *Sources:* git name-only diff; xpgained mirror + WebSearch backend (division-designer change is content; SF
  doctrine additions are additive).

---

## NEEDS FIX (load-blocking OR wrong modifier rename)

**None.** No load-blocker, no wrong modifier rename, no dropped/colliding key. The migration is faithful and
valid; the descriptor is correct; the only 1.19 removal that hits the mod was found and fixed correctly.

---

## OWNER DECISION (non-load-bearing; for the owner, not this jump)

- **OD1 — Bespoke ability tooltips.** The migration intentionally drops the bespoke `*_TOOLTIP` strings (matching
  vanilla 1.19), so the in-game hover for `force_attack`/`last_stand`/`SOV_last_stand`/`GER_bewegungskrieg`
  auto-generates from the modifier list instead of the old custom text. Cosmetic only. If the owner prefers the
  bespoke text, `tooltip = ABILITY_FORCE_ATTACK_TOOLTIP` can be re-added inside `unit_modifiers` (a minority of
  1.19 mods kept it and it parses) — purely optional polish, no behavioral/load impact.
- **OD2 — Adopt 1.19 systems (modernization).** Army HQs, Ship Captains, the SF 4th-doctrine page + Dispersed
  Operations subdoctrine, the 12 Regimental-Support / 11 Army-HQ companies, and the new content focus trees
  (Australia/Democratic Elections, Siam, Dutch East-Indies) are all unadopted. Correct faithful-port behavior;
  adoption is optional modernization (already routed to MODERNIZATION-REPORT). The SF 4th-doctrine page is also
  part of the deferred D6 doctrine endgame.
- **OD3 — D6 endgame target updated.** When D6 is eventually done, the target is the 1.17 Grand/Sub/Mastery
  schema **plus** 1.19's SF 4th-doctrine page + subdoctrine `xor`/`allow_in_multiple_tracks`/multi-track. Logged
  by the updater (dossier #8); concur.

---

## STILL UNCERTAIN (best evidence stated; non-load-bearing)

- **SU1 — Exact tooltip auto-generation wording / `unit_modifiers` duration semantics (LOW; cosmetic + behaviorally
  near-certain).** I could not open a dedicated wiki "Ability modding" page describing, in prose, that ability
  `unit_modifiers` apply for `duration` and that the tooltip auto-generates (the live wiki ability/modifier pages
  were 403/JS-walled, and the GitHub wiki mirror has no `Ability` page; its `Modifiers` page is an overview that
  doesn't enumerate these combat tokens). **Best evidence (HIGH confidence the behavior is preserved):** vanilla
  1.19's own `force_attack`/`last_stand` use exactly this pattern — a duration-bearing ability with a
  `unit_modifiers` block and no `days`/`tooltip` — recovered from EoaNB/MD/Kaiserreich; ~30 `1.19.*` mods do the
  same; and the 1.19 changelog states `unit_modifiers` was *added to cover the `add_temporary_buff_to_units`
  use-cases* (the timed-unit-buff use-case). So the timed-window + auto-tooltip behavior is engine-standard; only
  the precise generated-tooltip string is unverified, and that is cosmetic. Definitive close-out = the owner's
  end-of-port `-debug error.log` pass (grep `unknown`/`unexpected token` over `common/abilities/`, and confirm
  the abilities apply their modifiers in-combat for ~7 days).

- **SU2 — `war_with_on_timeout = event_target:TS_escalator` at `common/decisions/UKR.txt:413` (LOW; NOT a
  regression — corrects an inaccuracy in the updater's notes).** The updater's dossier #5 stated the mod uses
  "**only** the literal-`TAG`" form of the `war_with_*` decision fields. That is **slightly inaccurate**: this
  one usage passes an `event_target:` (scoped/target) value, not a literal TAG, and it has been present since the
  pristine 1.14 import (git blame `5074c94`) — i.e. it ran through 1.14→1.18. The 1.19 change ("Decision's
  `war_with_on_remove/timeout/complete` are **now scoped variables**") **widens** this field to accept scoped
  targets like `event_target:` — it is **additive in the direction that helps this usage**, and it does not
  remove the literal-TAG form used 8× in `GER.txt`. So: **no edit, no regression** — if anything 1.19 makes the
  mod's pre-existing `event_target:` form first-class. The only correction is documentary: the mod uses *both*
  the literal-TAG form (GER.txt) *and* one scoped/`event_target:` form (UKR.txt:413), and both are valid on 1.19.
  Confidence the field needs no change: **HIGH**. (Residual: the precise pre-1.19 vs 1.19 resolution of a
  *global* `event_target:` on this field couldn't be pinned to a verbatim source — but since the construct
  already shipped and ran pre-1.19 and 1.19 only broadens acceptance, there is no plausible 1.19-introduced
  break. Close out at `-debug` if desired.)

- **SU3 — Exhaustiveness of the removal sweep over ~2,000 `common/` files (LOW; same SU-class tail as Jumps
  1–4).** All converged sources agree 1.19's only modding removal is `add_temporary_buff_to_units` (handled), and
  every enumerated new token greps clean in the mod. Residual = a low-profile removed/renamed token that no
  reachable 1.19 source enumerated. **Best evidence (MEDIUM-HIGH):** the xpgained mirror's full Modding list +
  the live-wiki quote both show a single removal; the SF/Army-HQ/Ship-Captain reworks are systems+content that
  retain the mod's tokens (verified). Definitive close-out = the end-of-port `-debug error.log` pass. This is the
  same residual posture as every prior jump, now with the one known removal already fixed.

---

## Bottom line
The single real code change in the entire 1.14→1.19 port is **correct, faithful, and complete**: 5 ability
migrations across 2 files, exact vanilla-1.19 key renames, all values 1:1, both merges lossless, `days`/`tooltip`
correctly dropped, integrity clean — verified byte-level against the `4dc5e0f^` pre-edit form and against live
shipping 1.19 mod blocks (EoaNB, Millennium Dawn, Kaiserreich, +~30). `add_temporary_buff_to_units` is the **only**
1.19 modding removal, and it is the **only** one that touches the mod; the updater missed no removal. Descriptor =
`"1.19.*"`. Deferred `ai_templates`/doctrines correctly untouched. **No NEEDS-FIX. No BLOCKERS.** Two minor
documentary nuances logged (SU1 cosmetic tooltip; SU2 the `event_target:` `war_with_on_timeout` usage the
updater's notes mis-described as "literal-TAG only" — harmless, 1.19 widens rather than breaks it). Recommend the
standard end-of-port `-debug error.log` pass as the final engine-confirmation step.
