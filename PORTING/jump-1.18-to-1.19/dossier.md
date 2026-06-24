# Jump 5 — 1.18 → 1.19 (Thunder at our Gates) — Breaking-change dossier

Scope: modder-facing **breaking** changes (removed / renamed / format-changed / newly-required-validation) in
HOI4 1.19, filtered to what the CBtS Fan Fork (`/3273913964`) actually uses. Each entry: what changed,
source(s), whether the mod uses it (grep evidence file:line), required action. **This is the FINAL jump and the
highest-risk one for removals** — 1.19 is the one patch in the 1.14→1.19 ladder that ships a true wiki-grade
"Removes support for…" line. It surfaced, the mod uses the removed token, and it was faithfully fixed.

**Version facts (verified):** 1.19.0 + the **Thunder at our Gates** expansion released **2026-06-10** (the
new content DLC; the patch is partly free). Point releases run on wiki Patch_1.19.X: **hotfix 1.19.0.1**
(2026-06-12, Civil War CTD fix) and **1.19.1** (2026-06-17, major-exploit fixes). Headline 1.19 systems:
**Army HQs** (deploy generals into the field; 11 unique HQ support companies + 5 new commander abilities),
**Ship Captains** (naval-vessel commanders that can be promoted to Admirals; works within the existing
`navy_leader` framework), a **Special Forces rework** (a new fourth doctrine page + 12 new **Regimental
Support** companies; Mountaineers/Marines/Paratroopers are **retained** — "countries continue to make use of"
them), naval balance, and new **content** focus trees (Australia + Democratic Elections, Siam, Dutch
East-Indies).

**Research method:** live Paradox wiki + forum + store-news bodies remained JS-walled to WebFetch this run
(re-confirmed: `hoi4.paradoxwikis.com/Patch_1.19` → the "required part couldn't load" client-challenge shell;
`steamcommunity.com/.../announcements` body JS-walled; `soren.com` / `mod-coop`/`hoi4-modding` Fandom / live
`List_of_modifiers` / `Modifiers` → 403). So the modder-facing surface was obtained via the **WebSearch
backend** (which quotes wiki/forum/patch-note bodies) cross-checked ≥2 ways against: the **patched.gg** and
**xpgained.co.uk** rendered 1.19 patch-note mirrors (the xpgained mirror returned the verbatim 1.19 "Modding"
line), **GitHub code search** (`mcp__github__search_code`, repo-wide) over confirmed-1.19 mods
(`supported_version="1.19.*"`) for token-survival, the canonical-migration form, and descriptor convention,
plus **direct raw-file reads** of confirmed-1.19 mod files (e.g. `EoaNB-Team/EoaNB`,
`mengxinxier/Adorable-heart-beta1`) to recover the exact vanilla-1.19 ability form. Mod-side ground truth via
whole-mod grep + file reads. The bundled `pdx_documentation/` (~1.14) was used as a baseline-delta reference.

---

## NET RESULT (read first)

**1.19 requires exactly TWO mod edits this jump — a real one and the descriptor bump:**

1. **`common/abilities/` — `add_temporary_buff_to_units` REMOVED in 1.19 → migrated 4 usages to `unit_modifiers`
   (item #2, APPLIED).** This is the first *removed-token* fix in the whole 1.14→1.19 port (the mandate's
   predicted outcome for the high-risk final jump). 1.19's only explicit modding **removal** is the effect
   `add_temporary_buff_to_units`; the mod used it in 4 army-leader abilities. Faithfully re-expressed as the new
   ability-level `unit_modifiers` block, matching the verified vanilla-1.19 form.
2. **`descriptor.mod` `supported_version` 1.18.* → 1.19.*** (item #1, APPLIED).

**Everything else 1.19 changed is additive / content / balance, and the mod is insulated where it overrides:**

- **Army HQs / Ship Captains / Special-Forces rework / Regimental Support (item #3) = NEW SYSTEMS + content.**
  No existing token removed/renamed in `common/units` or `common/characters` or `common/unit_leader`. Army HQ
  abilities "now use `unit_modifiers`" — that is the *same* migration as item #2 (vanilla's own HQ abilities
  moved to `unit_modifiers`); it does not impose a new required field on the mod. Ship Captains work within the
  existing `navy_leader` framework (no new character type forced). The SF rework adds a **fourth doctrine page**
  (D6 doctrine space — NOTE only, untouched) and a new Regimental-Support division-designer row + 12 support
  companies (new content the mod does not adopt). Mountaineers/Marines/Paratroopers tokens persist.
- **1.19 additive modding tokens (item #4) — mod uses NONE of the new ones:** `unlock_subunit`,
  `captured_army_leader` (raid target), `ship_modifiers` (on medals), `allow_in_multiple_tracks` /
  `xor` (subdoctrines), `is_leader_visible` (trigger), `officer_xp` (on unit medals), `casualty_trickleback`
  (now a modifier) — whole-mod grep: **0** hits for each new-token *use* (the `casualty_trickleback` and
  `officer_xp`/`xor` hits are PRE-EXISTING, unrelated forms; see item #4).
- **Decision `war_with_on_remove/timeout/complete` "now scoped variables" (item #5) = ADDITIVE.** These fields
  now *also* accept `var:…` syntax; the literal-TAG form the mod uses (`war_with_on_remove = DEN`, 8 active in
  `GER.txt`) is unchanged and is used identically by dozens of confirmed-1.19 mods. → No edit.
- **`ai_templates` / doctrines** — re-confirmed **no 1.19 schema change to the AI-template/division-designer
  role schema**, and the 1.19 doctrine work (SF fourth doctrine page + subdoctrine `xor`/`allow_in_multiple_tracks`)
  is **doctrine-system** change → **NOTE for D6**, do not edit (items #7, #8). Both stay untouched per HARD RULES 1 & 2.
- **`replace_path` (27 targets) all remain canonical 1.19 folders** (verified each exists on disk) — 1.19
  restructured no replaced folder. → No edit.

**No BLOCKERS.** Two edits load-bearing (item #2 = the removed-token fix; item #1 = descriptor). This is the
jump that needed a real fix, exactly as the higher-risk-final-jump mandate anticipated.

---

## 1. `descriptor.mod` supported_version — **ACTION REQUIRED (DONE)**

- **What:** mod declared `supported_version="1.18.*"`. To load on 1.19 without the launcher's "made for an
  older version" flag it must declare 1.19.
- **Mod uses it?** Yes — `descriptor.mod:37`.
- **Correct value:** `"1.19.*"` — minor-wildcard form; `*` matches any 1.19.x build (1.19.0 / 1.19.0.1 /
  1.19.1 / …). Same convention the mod has used through every prior jump. Verified the dominant convention
  among real **1.19** HOI4 mods via GitHub `search_code` (`"1.19" filename:descriptor.mod`): `"1.19.*"` is the
  most common HOI4-mod form (e.g. `EaW-Team/equestria_dev`, `Donbass-Flames-Team/DonbassFlames`,
  `Red-Liberty-Mod`, `Rise-of-Nations-Team/Rise-of-Nations-Redux`, `Choo-Choo-Oreo/RD_T`,
  `Paradox-CZ-SK-Community`, `lukebrones/bronesmod`, `Kama-Pushka/Kursach-Fizika` [New Ways]); some pin more
  specifically (`Kaiserreich` uses `"1.19.1.*"`; `MFU-Updated`/`Warcraft-GoA` use `"1.19.0.1"`/`"1.19.0.6"`;
  `Yusseter/yb_map` uses `"1.19.*.*"` — all valid). `descriptor.mod` must **not** carry a UTF-8 BOM (verified:
  file is plain ASCII / no BOM — first 3 bytes `6e 61 6d` = `nam` of `name=`; edit preserved this).
- **Action:** edited `descriptor.mod:37` → `supported_version="1.19.*"`.
- **Sources:** hoi4.paradoxwikis.com/Mod_structure (wildcard semantics; no-BOM rule); GitHub code search
  `"1.19" filename:descriptor.mod` (real-mod convention); wiki Patch_1.19 / Patch_1.19.X (1.19.x version table).

## 2. `add_temporary_buff_to_units` REMOVED — migrated 4 ability usages to `unit_modifiers` — **ACTION REQUIRED (DONE)**

- **What 1.19 changed (verbatim, the 1.19.0 "Modding" line):** *"Removes support for
  `add_temporary_buff_to_units` and adds new `unit_modifiers` to cover these use cases. All Army HQ abilities
  now use `unit_modifiers`."* This is 1.19's **only explicit modding removal**. The effect
  `add_temporary_buff_to_units` (a `one_time_effect` that applied a `days`-limited temporary unit buff) no
  longer exists; its use-cases are replaced by the ability-level **`unit_modifiers = { … }`** block (the same
  block the mod already uses on other abilities, e.g. `staff_office_plan`, `siege_artillery`, `glider_planes`,
  `probing_attack`, `makeshift_bridges`).
- **Mod uses it? YES — 4 usages across 2 files (whole-mod grep, excl. `pdx_documentation/`):**
  - `common/abilities/generic_leader_abilities.txt:36` — `force_attack` (in `one_time_effect`)
  - `common/abilities/generic_leader_abilities.txt:67` — `last_stand` (in `one_time_effect`)
  - `common/abilities/generic_leader_abilities.txt:352` — `SOV_last_stand` (in `one_time_effect`; the ability
    *also* had a pre-existing `unit_modifiers` block)
  - `common/abilities/GER_abilities.txt:31` — `GER_bewegungskrieg` (in `one_time_effect`; ability *also* had a
    pre-existing `unit_modifiers` block)
  These four abilities are near-verbatim copies of the vanilla `force_attack`/`last_stand` abilities (same
  `ABILITY_FORCE_ATTACK`/`ABILITY_LAST_STAND` loc keys + stat values), so vanilla's own 1.19 migration is the
  authoritative target.
- **Load-bearing?** **Yes.** With the effect removed, the four abilities lose their temporary-buff effect
  entirely (and the removed token is expected to produce an `error.log` entry / "broken functionality" per
  modder reports). A faithful port must re-express them.
- **The exact, verified migration (NOT guessed — recovered from the canonical vanilla-1.19 form):** move the
  contents of `add_temporary_buff_to_units` into the ability's `unit_modifiers = { … }` block (creating it, or
  **merging** into a pre-existing one), with this key mapping confirmed against ~30 confirmed-1.19 repos and the
  vanilla-1.19 ability text (`EoaNB-Team/EoaNB` raw read; identical across Kaiserreich, Millennium Dawn, EaW,
  East-Showdown, Red-Liberty, World-Ablaze, LotrMod, deliciousmods/1956, diosaurreal/tgwr,
  mengxinxier/Adorable-heart, …):
  - `combat_offense`  → **`offence`**
  - `combat_defense`  → **`defence`**
  - `combat_breakthrough` → **`breakthrough_factor`**
  - `combat_entrenchment` → **`combat_entrenchment`** (UNCHANGED — vanilla 1.19 `last_stand` keeps this exact
    token inside `unit_modifiers`)
  - `org_damage_multiplier`, `str_damage_multiplier`, `war_support_reduction_on_damage`,
    `cannot_retreat_while_attacking`, `cannot_retreat_while_defending` → **UNCHANGED**
  - `days = 7` → **DROPPED** (the ability's existing `duration` now governs the modifier window)
  - `tooltip = ABILITY_*_TOOLTIP` → **DROPPED** (vanilla 1.19 drops it; non-load-bearing either way — a couple
    of mods kept it inside `unit_modifiers`, but vanilla does not, so the faithful/canonical form omits it)
  - the `one_time_effect = { add_temporary_buff_to_units = { … } }` wrapper → replaced by a single
    `unit_modifiers = { … }`
  Rationale for the renames: `combat_offense`/`combat_defense`/`combat_breakthrough` were **parameters of the
  removed effect's own namespace**, not general modifier names; the general `unit_modifiers` pipeline uses
  `offence`/`defence`/`breakthrough_factor`. Vanilla 1.19 itself performs exactly these renames (so they are
  correct, not interpretive). `combat_entrenchment`, the `*_damage_multiplier`s, and the
  `cannot_retreat_*`/`war_support_reduction_on_damage` tokens are valid `unit_modifiers` keys (proven by vanilla
  1.19 `force_attack`/`last_stand` shipping them inside `unit_modifiers`).
- **Action (applied, all 4):**
  - `force_attack` → `unit_modifiers { offence=0.2  breakthrough_factor=0.25  org_damage_multiplier=-1.0
    str_damage_multiplier=0.6  war_support_reduction_on_damage=0.2  cannot_retreat_while_attacking=1.0 }`
  - `last_stand` → `unit_modifiers { defence=0.2  combat_entrenchment=0.25  org_damage_multiplier=-1.0
    str_damage_multiplier=0.6  war_support_reduction_on_damage=0.2  cannot_retreat_while_defending=1.0 }`
  - `SOV_last_stand` → **merged** into its existing `unit_modifiers` block: kept
    `paradrop_organization_factor=-1.0  paratrooper_aa_defense=-1.0`; added `offence=-0.2  defence=0.2
    combat_entrenchment=0.25  org_damage_multiplier=-0.8  str_damage_multiplier=0.5`; removed the
    `one_time_effect` wrapper.
  - `GER_bewegungskrieg` (GER_abilities.txt) → **merged** into its existing `unit_modifiers` block: kept
    `army_armor_attack_factor=0.05  army_armor_speed_factor=0.05  army_defence_factor=-0.1
    air_cas_present_factor=0.1`; added `str_damage_multiplier=0.25`; removed the `one_time_effect` wrapper.
  All stat values preserved 1:1 (faithful — only the wrapper/keys changed per the rename map). The unrelated
  `one_time_effect = { supply_units = 168 }` in the `extra_suplies` ability (generic_leader_abilities.txt:274)
  is a DIFFERENT, still-valid effect and was left untouched.
- **Sources:** wiki Patch_1.19 "Modding" line + xpgained.co.uk 1.19 mirror (verbatim "Removes support for
  `add_temporary_buff_to_units` … `unit_modifiers` … All Army HQ abilities now use `unit_modifiers`"); Paradox
  forum "general commands like last stand" thread + community reports (removal breaks force_attack/last_stand
  for old mods → migrate to `unit_modifiers`); **vanilla-1.19 ability form recovered via raw reads of
  confirmed-1.19 mods** `EoaNB-Team/EoaNB` (`force_attack`/`last_stand` = `unit_modifiers { offence /
  breakthrough_factor / combat_entrenchment / org_damage_multiplier / str_damage_multiplier /
  war_support_reduction_on_damage / cannot_retreat_* }`) and `mengxinxier/Adorable-heart-beta1`
  (`generic_leader_abilities.txt` identical; `SOV_force_attack` confirms the migration shape); GitHub
  `search_code` cross-confirm across ~30 `1.19.*` repos (Kaiserreich, Millennium Dawn, East-Showdown,
  Red-Liberty, World-Ablaze, LotrMod, deliciousmods/1956, diosaurreal/tgwr, …) all using
  `offence`/`breakthrough_factor`; mod grep + reads (4 usages, file:line above).

## 3. ARMY HQ / SHIP CAPTAINS / SPECIAL-FORCES REWORK / REGIMENTAL SUPPORT — new SYSTEMS + content; no removed/renamed token the mod uses; NO EDIT (beyond #2)

- **What 1.19 added:** **Army HQs** (deploy generals as field HQs; 11 unique HQ support companies + 5 new
  commander abilities — and *"All Army HQ abilities now use `unit_modifiers`"*, i.e. the same migration as #2);
  **Ship Captains** (naval-vessel commanders, promotable to Admiral; grant medals; 8 Historical Ship Captains
  per bookmark for majors); **Special-Forces rework** (a new **fourth doctrine page** for SF specialism +
  better-befitting-strategic-capability design; Mountaineers/Marines/Paratroopers **retained**); **Regimental
  Support** (new division-designer row + **12** new support companies unlocked by tech, synergising with the
  doctrine system).
- **Schema impact on the mod's `common/units` / `common/characters` / `common/unit_leader`?** **None
  (no removal/rename).**
  - **Units / Special Forces:** the mod's SF battalions keep the standard tokens that 1.19 **retains** —
    `special_forces = yes`, `marines = yes`, `mountaineers = yes`, `paratrooper = { … }`,
    `can_be_parachuted = yes`, `category_special_forces` / `category_marines` / `category_mountaineers`
    (`common/units/{infantry,amphibious_mech,amphibious_armor,…}.txt`). The SF rework is a **doctrine + support
    company** change, not a sub_unit-definition change; the new Regimental-Support companies + 11 Army-HQ
    companies are **new content** the mod does not ship and is not forced to ship. → No `common/units` edit.
  - **Characters:** the mod uses standard `corps_commander` (388), `field_marshal` (67), `navy_leader` (84).
    Ship Captains "work within the existing `navy_leader` framework … rather than creating entirely new
    character types"; `ship_modifiers` is an additive field on **medals**, used by 0 mod files. → No
    `common/characters` edit.
  - **Unit leader:** the mod's `common/unit_leader/*` (skills + `00_traits.txt`/`JAP_traits.txt`, `type = land/
    navy`) is unaffected — no 1.19 removal/rename of a trait/skill token the mod uses surfaced. → No edit.
- **Load-bearing?** **No** (the only Army-HQ-related modding item that touches the mod, `unit_modifiers`, is the
  #2 migration the mod now follows). The new systems are content/new-doctrine and are simply not adopted.
- **Required action:** **none beyond #2.** Adopting Army HQs / Ship Captains / the SF fourth-doctrine page /
  Regimental Support is an optional **modernization** path → MODERNIZATION-REPORT (the SF fourth-doctrine page
  also belongs to the **deferred D6** doctrine migration — see #8).
- **Sources:** wiki Patch_1.19 + Thunder_at_our_Gates + patched.gg/xpgained mirrors (Army HQ 11 companies +
  5 abilities + "All Army HQ abilities now use `unit_modifiers`"; Ship Captains within `navy_leader`; SF fourth
  doctrine page, Mountaineers/Marines/Paratroopers retained; 12 Regimental-Support companies); GitHub
  `search_code` (Ship Captains within existing `navy_leader`; no new forced character type); mod grep
  (SF tokens; `corps_commander`/`field_marshal`/`navy_leader` counts; `ship_modifiers`→0).

## 4. 1.19 ADDITIVE MODDING TOKENS — mod uses NONE of the new ones; PRE-EXISTING hits are unrelated; NO EDIT

The full 1.19.0 + 1.19.X "Modding" surface beyond the one removal (item #2) is **additive** (new
effects/triggers/properties/modifiers). Whole-mod grep (excl. `pdx_documentation/`) for each new token's *use*:

- **`unlock_subunit`** (new effect — unlock a subunit for a country) → **0** hits. No collision.
- **`captured_army_leader`** (new **raid target type**) → **0** hits. No collision.
- **`ship_modifiers`** (new — add to medals) → **0** hits. No collision.
- **`allow_in_multiple_tracks`** (new subdoctrine property) → **0** hits. No collision.
- **`is_leader_visible`** (new trigger) → **0** hits. No collision.
- **`xor` for subdoctrines** (new — make subdoctrines mutually exclusive) → the 33 `xor` hits are **all** the
  long-standing **technology-exclusivity** `xor = { … }` syntax in the **deferred doctrine files**
  (`common/technologies/land_doctrine.txt`), a DIFFERENT construct, in files HARD RULE 2 forbids editing.
  No collision.
- **`officer_xp`** (new — field on **unit medals**) → the 6 hits are PRE-EXISTING `modifier_trait_*_officer_xp_
  gain_factor` **localisation strings** (`localisation/modifiers_l_english.yml`), unrelated to the new
  unit-medal field. No collision.
- **`casualty_trickleback`** (1.19 "Add modifier for `casualty_trickleback`") → 64 PRE-EXISTING hits, but as an
  **equipment/tech bonus stat** the mod already used on 1.14–1.18 (`common/script_enums.txt:30`
  [`script_enum_equipment_bonus_type`], `common/technologies/support.txt`, `common/units/field_hospital.txt`,
  `common/ai_templates/*` [deferred], `military_industrial_organization/ai_bonus_weights/*`). 1.19 *additionally*
  registers it as a general **modifier** — purely additive; the mod's existing stat/bonus usage is unaffected
  and still parses. → No edit.
- **Subdoctrines assignable to multiple track types** (new) — doctrine-system addition → **NOTE for D6**.
- **Load-bearing?** **No.** No new-token *use* exists in the mod; the pre-existing hits are unrelated forms that
  remain valid. No name collisions, no forward references.
- **Required action:** **none.** Each new capability the mod could adopt → optional MODERNIZATION-REPORT note.
- **Sources:** xpgained.co.uk 1.19 "Modding" bullet list (`unlock_subunit`, `ship_modifiers`,
  `captured_army_leader`, subdoctrine `xor`/`allow_in_multiple_tracks`/multi-track, `officer_xp` on unit medals,
  `casualty_trickleback` modifier, `is_leader_visible`, `war_with_*` scoped — item #5); mod grep (each token,
  counts + file:line above) + reads (`script_enums.txt`, `support.txt`).

## 5. DECISION `war_with_on_remove/timeout/complete` "now scoped variables" — ADDITIVE; literal-TAG form unchanged; NO EDIT

- **What 1.19 changed:** *"Decision's `war_with_on_remove/timeout/complete` are now scoped variables."* These
  decision auto-war fields now **also** accept a scoped-variable target (e.g. `war_with_on_remove = var:foo`),
  in addition to a literal `TAG`. This is an **additive capability expansion**, not a format removal: the
  literal-`TAG` form still parses and behaves as before (decision assumes its remove/timeout/complete effect
  declares war on the named country).
- **Mod uses it?** Yes — the **literal-TAG** form only: `war_with_on_remove = <TAG>` in `common/decisions/GER.txt`
  (8 active: DEN/NOR/BEL/LUX/HOL/YUG/SWI/IRE @ lines 9822–10095), plus commented-out `war_with_on_complete`
  occurrences (`GER.txt:10214`, `USSR.txt:8275`). The mod uses **none** of the new `var:…` scoped form.
- **Load-bearing?** **No.** The literal-TAG form is unchanged and is used identically by dozens of
  confirmed-1.19 mods (Kaiserreich, Millennium Dawn, EoaNB, deliciousmods/1956, diosaurreal/tgwr,
  mengxinxier/Adorable-heart, World-Ablaze, …, all `supported_version="1.19.*"`). → No edit.
- **Required action:** **none.** (Using the new `var:…` form is an optional modernization.)
- **Sources:** wiki Decision_modding + Patch_1.19 (`war_with_*` now scoped variables; literal-TAG semantics
  retained; targeted-decision alternatives `war_with_target_on_*` exist for `FROM`-target cases); GitHub
  `search_code` `war_with_on_remove path:common/decisions` (literal-TAG form ubiquitous on 1.19); mod grep
  (8 active + 2 commented, file:line above).

## 6. NAVAL BALANCE / new CONTENT focus trees (Australia / Siam / Dutch East-Indies / Democratic Elections) — content/balance; NO format break; NO EDIT

- **What 1.19 added:** Australia focus tree + a **Democratic Election** system; Siam + Dutch East-Indies focus
  trees; naval balance passes; 1.19.0.1/1.19.1 hotfixes (Civil War CTD; major-exploit fixes). These are **new
  content + balance**, not script-format breaks.
- **Mod uses it?** N/A — pure new vanilla content the mod neither ships nor references. The mod's focus trees /
  scripted_gui / on_actions / events use unchanged formats (no 1.19 focus/decision/on_action/scripted-gui/GUI/
  map format removal surfaced).
- **Load-bearing?** **No.** → No edit. (Reacting to / integrating the new nations' mechanics = optional
  modernization content.)
- **Sources:** wiki Patch_1.19 / Thunder_at_our_Gates / Patch_1.19.X + patched.gg/xpgained mirrors
  (Australia + Democratic Elections, Siam, Dutch East-Indies; naval balance; hotfix list); mod grep (no new
  content referenced).

## 7. AI division-template / division-designer schema — NO 1.19 ROLE-SCHEMA CHANGE; `ai_templates` stays DEFERRED, untouched

- **What checked (per mandate):** whether 1.19's division-designer changes (the new **Regimental Support** row;
  Army-HQ companies) moved the deferred-migration target (D1 — the mod's 9 `ai_templates/*` use the pre-1.15
  `match_to_count` + plural `roles` schema).
- **Finding:** **no AI-template role-schema change.** 1.19 **adds** a Regimental-Support row + 12 support
  companies + 11 Army-HQ companies to the division designer (new content), but does **not** alter the
  `ai_templates` role schema (`match_to_count` / plural `roles` / `target_width` / `front_role_override`). The
  deferred 1.15-schema target is **unchanged by 1.19**. (Re-verified: the 9 `common/ai_templates/*` are
  untouched by this jump.)
- **Action:** **none — do not touch `ai_templates`** (HARD RULE 1 / D1). The eventual D1 migration target
  remains the post-1.15 singular-`role` schema; 1.19 added no division-*designer*-role change to it.
- **Sources:** wiki Patch_1.19 (division-designer change = new Regimental-Support/Army-HQ **content**, not the
  AI role schema); GitHub `search_code` (no 1.19 division-designer role-schema change); mod grep.

## 8. DOCTRINE SYSTEM — 1.19 SF fourth-doctrine page + subdoctrine `xor`/`allow_in_multiple_tracks`/multi-track = doctrine-system additions; doctrines stay DEFERRED (D6), untouched

- **What checked (per mandate, with special attention to Special-Forces *doctrine*):** whether 1.19 changed the
  doctrine system (D6 — the mod ships old-format `land_doctrine.txt` + `special_forces_doctrine.txt`, old
  doctrine folders in `00_technology.txt`, and 56 doctrine `has_tech` refs).
- **Finding (NOTE for the D6 migration):** 1.19 **extends** the (1.17-introduced) Grand/Sub/Mastery doctrine
  system with: (a) a **new fourth doctrine page for Special Forces** (SF specialism via a new tech, retaining
  Mountaineers/Marines/Paratroopers; a new **Dispersed Operations** subdoctrine to counter heavy enemy air);
  (b) **subdoctrines assignable to multiple doctrine track types**; (c) an **`allow_in_multiple_tracks`**
  subdoctrine property; (d) an **`xor`** subdoctrine property (mutually-exclusive subdoctrines). These are
  **new doctrine-system surface on top of the 1.17 schema** — they do **not** remove/rename any token the mod's
  old-format doctrines currently use, and they do not change the fact that the mod's `special_forces_doctrine.txt`
  + `land_doctrine.txt` remain old-format overrides parsing on 1.19 (the same degraded-but-runnable D6 posture).
  **The D6 migration target is now: 1.17 Grand/Sub/Mastery schema PLUS 1.19's subdoctrine `xor` /
  `allow_in_multiple_tracks` / multi-track-assignment and the SF fourth-doctrine page** — i.e. when D6 is
  eventually done at the 1.19 endgame, the SF doctrine should be migrated onto the new fourth SF doctrine page
  using these 1.19 subdoctrine properties.
- **Action:** **none — do not touch the doctrine files** (HARD RULE 2 / D6). Recorded above for the eventual
  migration.
- **Sources:** wiki Patch_1.19 + Thunder_at_our_Gates + soren/PCGamesN dev-diary summaries (SF fourth doctrine
  page; Dispersed Operations subdoctrine; subdoctrine `xor` / `allow_in_multiple_tracks` / multi-track); the SF
  rework "better befits strategic capability over detailed stat modification"; mod state unchanged from Jump 4.

## 9. Equipment / MIO / medals / states / buildings / map / GUI — NO 1.19 FORMAT BREAK the mod uses

- No 1.19 equipment-stat, MIO-field, medal-format (beyond the additive `ship_modifiers`/`officer_xp`),
  state-history, building, map, or GUI **break** surfaced across the query angles that affects a token the mod
  uses. The mod's medals (`common/medals/00_medals.txt`, `common/unit_medals/00_default.txt`,
  `common/units/unit_medals/00_default.txt`) use unchanged formats; `ship_modifiers`/`officer_xp` on medals are
  additive (mod uses neither). `map/buildings.txt` 7-column format and `history/states` building-block parsing
  unchanged. The 1.19.X hotfixes are crash/exploit/balance fixes (Civil War CTD; major-exploit fixes) — none
  removes a script token.
- **`replace_path` targets (27):** all remain canonical 1.19 folders (verified each exists on disk; list in
  changes.md). 1.19 restructured no replaced folder. No edit.
- **Sources:** wiki Patch_1.19 / Patch_1.19.X (additive + content/balance + hotfix list); GitHub mirror
  Equipment / MIO / Modifiers / State pages (formats current); mod greps + 27/27 replace_path existence check.

## 10. 1.19 ADDITIVE / content surface (mod uses NONE of the new tokens) → MODERNIZATION-REPORT

New (additive) systems/tokens/content in 1.19.0–1.19.X; the mod references **none** of the new tokens
(whole-mod grep clean; see item #4):
- Systems: **Army HQs** (deployable field HQs; 11 HQ support companies; 5 new commander abilities),
  **Ship Captains** (within `navy_leader`; medals → Admiral promotion), **Special-Forces rework** (fourth
  doctrine page; Dispersed Operations subdoctrine; **12 Regimental Support** companies).
- Modding tokens (additive): `unlock_subunit`, `captured_army_leader` (raid target), `ship_modifiers`
  (medals), `officer_xp` (unit medals), subdoctrine `xor` / `allow_in_multiple_tracks` / multi-track
  assignment, `is_leader_visible` (trigger), `casualty_trickleback` (now a modifier), decision `war_with_*`
  scoped-variable targets.
- Content: Australia focus tree + **Democratic Elections** system; Siam + Dutch East-Indies focus trees; naval
  balance. Mod adopts none.

---

### Sources (consolidated)
- hoi4.paradoxwikis.com/Patch_1.19 ; /Patch_1.19.X ; /Thunder_at_our_Gates ; /Decision_modding ;
  /Unit_modding ; /Character_modding ; /List_of_modifiers ; /Modifiers (live bodies JS-walled / 403 to direct
  WebFetch — re-confirmed this run; read via the WebSearch backend, which quotes them)
- patched.gg "Thunder at our Gates" 1.19.0 patch-note mirror ; xpgained.co.uk 1.19.0 + hotfix 1.19.0.1
  mirrors (xpgained returned the verbatim 1.19 "Modding" line: *Removes support for
  `add_temporary_buff_to_units` … `unit_modifiers` … All Army HQ abilities now use `unit_modifiers`*, plus the
  additive bullet list) ; soren.com + PCGamesN + HappyGamer 1.19 summaries (Army HQ / Ship Captains / SF rework
  / 1.19.0.1 / 1.19.1) — all via WebSearch backend (bodies JS-walled / 403)
- **Vanilla-1.19 ability form recovered via raw GitHub reads** of confirmed-`1.19.*` mods: `EoaNB-Team/EoaNB`
  (`common/abilities/generic_leader_abilities.txt` — `force_attack`/`last_stand` = `unit_modifiers { offence /
  breakthrough_factor / combat_entrenchment / org_damage_multiplier / str_damage_multiplier /
  war_support_reduction_on_damage / cannot_retreat_* }`), `mengxinxier/Adorable-heart-beta1`
  (`generic_leader_abilities.txt` identical; `SOV_*` confirms migration shape)
- GitHub `mcp__github__search_code` (repo-wide): `add_temporary_buff_to_units` (still in un-ported mods) vs.
  the migrated `unit_modifiers { offence … breakthrough_factor … }` form across ~30 `1.19.*` repos
  (Kaiserreich, Millennium Dawn, East-Showdown, Red-Liberty, World-Ablaze, LotrMod, deliciousmods/1956,
  diosaurreal/tgwr, …) ; `war_with_on_remove path:common/decisions` (literal-TAG form ubiquitous on 1.19) ;
  `"1.19" filename:descriptor.mod` (descriptor convention)
- Bundled 3273913964/pdx_documentation/ (~1.14 effects/triggers/modifiers reference — confirms
  `combat_offense`/`add_temporary_buff_to_units` were special-effect parameters, not general modifiers)
- Mod grep + file reads (descriptor.mod; common/abilities/{generic_leader_abilities,GER_abilities}.txt;
  common/units/* SF tokens; common/characters/* leader-type counts; common/decisions/* `war_with_on_remove`;
  common/script_enums.txt; common/technologies/support.txt; medals files; 27/27 replace_path existence) — all
  file:line evidence cited inline.
