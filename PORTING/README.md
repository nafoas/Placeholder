# CBtS Fan Fork — 1.14 → 1.19 Port

Staged, verified port of **"Calm Before the Storm Fan Fork"** (CBtS_FF) v0.3
(Steam Workshop `3273913964`, mod root [`/3273913964`](../3273913964)) from
Hearts of Iron IV **1.14** to the current **1.19**.

## Scope (chosen by repo owner)
- **Faithful port now** — make the mod load and run error-free on 1.19, preserving
  original behavior/balance as closely as possible.
- **+ Modernization report** — a prioritized list of where new 1.15–1.19 systems
  supersede what the mod does, delivered separately (see `MODERNIZATION-REPORT.md`),
  NOT applied during the port unless required for compatibility.
- Testing: owner will run the game **at the end**; we backtrack via per-jump commits
  if something misbehaves. No live error logs mid-port.

## The non-negotiable mandate (drilled into every agent)
> Never assume anything. Never guess syntax, never guess what goes where, never
> guess what a version changed. If you don't know, look it up — read the patch
> changelog, the modding wiki, dev diaries, bug/crash reports, and modder help
> threads until you find a definitive answer. If, after genuinely exhausting
> research, you still cannot resolve something **that is load-bearing** (would
> break loading or crash the game), STOP and ask — do not insert something random.
> Anything you cannot verify but is not load-bearing goes in `UNCERTAINTIES.md`
> with your best-supported call and a citation. Every non-trivial change must cite
> the source that justifies it.

## Version ladder
| Jump | From | To | Patch / DLC |
|---|---|---|---|
| 1 | 1.14 | 1.15 | Götterdämmerung |
| 2 | 1.15 | 1.16 | Graveyard of Empires |
| 3 | 1.16 | 1.17 | No Compromise, No Surrender |
| 4 | 1.17 | 1.18 | Peace for Our Time |
| 5 | 1.18 | 1.19 | Thunder at our Gates (current) |

## Mod inventory (attack surface)
- `common/` (2,007 files) — defines, equipment, units, ideas, **national_focus (388)**,
  decisions (160), characters (138), **military_industrial_organization** (MIOs),
  scripted_effects/triggers/guis/localisation, on_actions, bop, intelligence_agencies,
  operations, peace_conference, technologies, etc. **Highest breakage risk.**
- `history/` (1,851) — countries, states, **units (division templates + equipment variants)**, general.
- `interface/` (44 `.gui` + 55 `.gfx`) — custom GUI; format changes can break loading.
- `map/` (custom, 272 MB) — definition.csv, adjacencies, railways, supply_nodes, strategicregions, etc.
- `localisation/` (151 `.yml`), `events/` (149), `gfx/` (12,078, mostly art).
- **`descriptor.mod`** — declares `supported_version="1.14.*"` and ~25 `replace_path`
  directives that wholesale-replace vanilla folders. **The replace_path list is
  version-fragile** — if vanilla restructures any replaced folder, the replace
  silently breaks. Checked every jump.
- **Asset:** `3273913964/pdx_documentation/` holds the game's auto-generated
  effects/triggers/modifiers/script docs (no embedded version stamp; treated as a
  ~1.14 reference, cross-verified). Diff target against the 1.19 equivalents.

## Per-jump procedure
1. **Orchestrator research → `jump-1.x-to-1.y/dossier.md`**: sourced, concrete list
   of modder-facing breaking changes for the jump, scoped to subsystems this mod uses,
   with the exact transformation required for each and a citation.
2. **Updater agent**: applies the dossier to `/3273913964`, independently verifying
   each item, deep-diving anything uncertain, logging unresolved non-blocking items to
   `UNCERTAINTIES.md`. Produces `changes.md`.
3. **Orchestrator**: sanity-check (leftover deprecated tokens, brace/encoding checks),
   bump `descriptor.mod` `supported_version`, **commit the jump, push**.
4. **Deconstructor agent**: independently re-researches the jump and audits the result
   against changelogs, known bugs, and modding advice; reports weak spots to `review.md`.
5. **Orchestrator**: triage + fix, **commit fixups, push**. Proceed to next jump.

## Conventions
- One commit per jump (+ fixup commits) = clean `git bisect` for end-of-port backtracking.
- `* -text` in `.gitattributes` preserves HOI4 file bytes/encodings exactly.
- Mod files live only under `/3273913964`; all porting meta lives under `/PORTING`.

## Status
| Phase | State |
|---|---|
| Import 1.14 baseline | ✅ committed + pushed (`5074c94`) |
| Jump 1 (1.14→1.15) | ✅ ported + audited + pushed (`48b973e`) — 1 edit (descriptor bump) |
| Jump 2 (1.15→1.16) | 🔄 starting |
| Jumps 3–5 | ⬜ |
| AI-template migration | ⬜ deferred to 1.19 endgame — owner decision, see `DECISIONS-NEEDED.md` D1 |
| Final 1.19 self-review + owner `-debug` error.log pass | ⬜ |
</content>
