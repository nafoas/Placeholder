# Notes for the 1.19 agent — observations from the 1.18 deep-fix pass

These are things the **1.18 deep-fix agent** noticed that fall in the **1.19 agent's lane**
(subunit-category SYSTEM reconciliation; naval-support modifiers; modern-navy / regimental-support
equipment DB). The 1.18 agent did **NOT** edit any of these — documented here so the 1.19 agent can
reconcile the whole category system in one place without conflicts.

---

## 1. Helicopter SUBUNIT categories + helicopter support-company unit types (1.19 category reconciliation)

The 1.18 agent fixed the **technology category** `helicopter_tech` (a *tech-tag* in
`common/technology_tags/00_technology.txt`). That is a **different namespace** from the **subunit
category** `category_helicopter_support_companies` (a *unit category* in
`common/unit_tags/00_categories.txt`). The subunit side is the 1.19 agent's lane and is **untouched**.

Observed (live tree + error.log):

- **`common/unit_tags/00_categories.txt`** declares `sub_unit_categories = { ... }` but does **NOT**
  include `category_helicopter_support_companies`. (grep confirmed absent.)
- Vanilla files that reference the helicopter subunit category / helicopter support-company **unit
  types**, which the mod **loads** (it does NOT `replace_path` `common/doctrines` or `common/units`,
  and ships no `common/doctrines` of its own — see §3):
  - `common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt` — `Unexpected token:
    category_helicopter_support_companies` (near line 316/318); also the helicopter support-company
    unit types `helicopter_recon` (line ~307), `helicopter_field_hospital` (~321),
    `helicopter_transport` (~333).
  - `common/doctrines/subdoctrines/land/infantry_subdoctrines.txt` — `helicopter_field_hospital`
    (near line 527/529).
  - `common/units/helicopter_brigade.txt` — `Invalid subunit category:
    category_helicopter_support_companies` (near line 22/23).
- The helicopter support-company **unit types** (`helicopter_field_hospital`, `helicopter_recon`,
  `helicopter_transport`) are vanilla support companies defined in vanilla `common/units/*` that load
  beneath the mod. They belong to the subunit/regimental-support category reconciliation, NOT to the
  1.18 tech-category fix.

**Recommended for 1.19:** when reconciling the full subunit-category list in
`common/unit_tags/00_categories.txt`, add `category_helicopter_support_companies` alongside the other
missing categories from error-inventory section C (`category_regimental_support_*`,
`category_tank_destroyers`, `category_self_propelled_*`, `category_maritime_patrol_bomber`,
`category_carrier_*`, etc.). This is the authoritative single place to fix the whole category system.

**Do NOT** confuse this with the already-applied `helicopter_tech` tech-tag fix — leave that one as is.

---

## 2. `helicopter_equipment` missing from the mod's `script_enums.txt` override (cosmetic; non-1.18)

The mod's same-filename override `common/script_enums.txt` lists the **train** equipment archetypes in
`script_enum_equipment_bonus_type` but omits `helicopter_equipment` / `helicopter_equipment_1`
(error.log lines 287-289, 2815-2816: "helicopter_equipment not in script_enum_equipment_bonus_type" /
"…should be updated at the same time as …common/units/equipment"). This is:
- **Pre-existing / non-1.18** (vanilla helicopters were added in Götterdämmerung/1.15; the mod does not
  `replace_path` `common/units/equipment`, so vanilla helicopter equipment has loaded beneath the mod
  since 1.15).
- **Non-load-blocking by design** — the engine emits this as a documentation-sync **log reminder**, not
  a load abort.

Not the 1.18 agent's lane and not load-bearing, so left untouched. If the 1.19 endgame `-debug` pass
wants a clean log, append `helicopter_equipment` (+`_1`) to the mod's
`script_enum_equipment_bonus_type` enum. (Already flagged by the 1.18 auditor as O1; restated here for
completeness.)

---

## 3. Doctrine structure context (affects how vanilla helicopter doctrine refs reach the mod)

The mod ships **no** `common/doctrines/` directory at all and does **not** `replace_path` it. Its
doctrines live in the **old pre-1.17 location** `common/technologies/land_doctrine.txt` +
`special_forces_doctrine.txt`. Consequence: **vanilla's** `common/doctrines/subdoctrines/**` files
(combat_support / infantry / armor / operations / special_forces) **all load beneath the mod** and throw
the section-F parse errors (and the helicopter-category / `helicopter_tech` references) because they hit
the mod's stale subunit-category and (previously) tech-category sets. The `helicopter_tech` tech-category
miss is now fixed; the **subunit-category** misses in those same vanilla files remain for the 1.19
category reconciliation (§1). The broader doctrine-schema migration (D6 / section F) is its own item.
