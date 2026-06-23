# Modernization Report — CBtS Fan Fork

New engine features/systems added in each ported version that *supersede or could improve* what the
mod currently does. These are **NOT applied during the faithful port** (the port only fixes what
broke). One line per relevant addition, with source, for the owner to consider later.

---

## 1.15 (Götterdämmerung)

Additions surfaced while researching the 1.14→1.15 jump (all are NEW capabilities; not required
for the mod to load on 1.15). Sources: hoi4.paradoxwikis.com/Patch_1.15 ;
hoi4.paradoxwikis.com/Map_modding ; hoi4.paradoxwikis.com/Modifiers ; hoi4.paradoxwikis.com/Defines.

- `MIN_SHIPS_FOR_HIGHER_SHIP_RATIO_PENALTY` (new define) — exempt small fleets from the higher
  ship-ratio combat penalty; tune naval balance.
- `ai_wanted_divisions_factor` — new AI knob influencing how many divisions the AI wants; relevant
  to the mod's heavy AI tuning in `common/ai_*`.
- `heavy_fighter` — new **medium**-plane category; could replace bespoke heavy-fighter handling.
- `give_resource_rights` now accepts a variable/keyword receiver — more flexible resource-rights scripting.
- `divisional_commander_xp` — set divisional officer XP on unit creation (OOB / event spawns).
- `add_dynamic_modifier` tooltip variables — richer dynamic-modifier tooltips.
- `is_subject` multi-target tooltip fix — cleaner tooltips when checking subject status of multiple targets.
- `state_resources_<resource>_factor` (new state modifier) — scale a specific resource per state.
- `equipment_production_min_factories_archetype` (new AI strategy) — min factories for a specific
  equipment archetype; finer AI production control.
- `has_naval_invasion_against_state` (new trigger) — detect naval invasions targeting a state.
- New trigger to enumerate all states in a given continent.
- Bindable / boundable localisation variables — define custom variables for use in loc keys,
  collapsing many near-duplicate loc strings (the mod has 151 loc files; potential big cleanup).
- AI division templates can now specify a division **name list**; AI roles are now assigned on
  template creation (replacing the removed `match_to_count` dynamic matching).
- Germany rework + nuclear / secret-weapons (Special Projects) program — large new content systems;
  pure additions, only relevant if the mod ever wants to integrate them.
- "Terrain Traits XP Gain" (`terrain_traits_xp_gain`) — new modifier (replaces the National-Spirit
  role of the old `terrain_penalty_reduction`); only relevant if the owner decides to adopt it.
  NOTE: do NOT treat as a drop-in rename of `terrain_penalty_reduction` — different effect (see
  jump-1.14-to-1.15/UNCERTAINTIES.md U1).
