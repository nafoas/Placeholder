# GUI-reconciliation changes — 1.19 port (CBtS / Operation Postern)

Agent: GUI-reconciliation. Scope: reconcile the mod's stale 1.14-baseline `interface/*.gui`
overrides against vanilla 1.19, fixing the `change_background` CTD and any other crash-level GUI
issues, preserving the mod's customizations. Log analysed:
`scratchpad/error2.log` (3924 lines; ends at the `change_background` crash).

Format: `file — what — WHY — SOURCE(url)`

---

## PRIORITY 1 — CTD: `Undefined GUI_TYPE: change_background` (RESOLVED — must-win)

**`interface/frontendmainview.gui`** — Added the vanilla `change_background` containerWindowType
(top-level, inserted as the last child of `guiTypes`, after `mainmenu_achievement_button`, lines
~572-644), including ALL of its child elements the engine reported missing:
`change_background_button` (buttonType), `background_selection` (containerWindowType) with its
`select_all_checkbox` (checkboxType), `select_all_label` (instantTextBoxType), and nested
`background_selection_list` (containerWindowType) containing the `available_backgrounds`
(gridBoxType).
— **WHY**: The mod's `frontendmainview.gui` is a pristine 1.14 override that predates the main-menu
"change background" feature, so the `change_background` GUI_TYPE was undefined. At game init the
engine logs `gui.cpp:931: Undefined GUI_TYPE: change_background - This will most likely crash the
game` + `gui.cpp:409: Failed to create containerWindowType "change_background"` + four
`containerwindow.cpp` "Could not find ... in window" misses for `background_selection`,
`background_selection_list`, `available_backgrounds`, `select_all_checkbox`. This is the LAST entry
in the log = the CTD surface. `change_background` is referenced by the engine itself (the main-menu
view instantiates it); grep confirms it is not authored anywhere in the mod, so the fix is to
re-introduce the missing vanilla definition. The mod's file carries heavy customizations (CBtS logo,
version sprites, disabled subscription widget, custom button positions), so the override is KEPT and
the block is ADDED rather than removing the override.
— Sprites/fonts used by the ported block resolve cleanly: `GFX_tiled_window2_1b_border` and
`GFX_tiled_window_transparent` are present in the mod's own `interface/core.gfx`;
`GFX_button_238x38`, `GFX_generic_checkbox`, `right_vertical_slider`, and fonts
`hoi_24header`/`hoi_18mbs`/`Main_14_black` are vanilla base assets the mod does not override.
— Verified: file braces balanced 178/178, CRLF preserved (645 CR / 645 LF), all four required element
names now present.
— **SOURCE** (block is byte-identical across these two independent confirmed mirrors of the vanilla
1.19 frontendmainview.gui; the only inter-mirror diff is Kaiserreich's extra `hide = yes ## KR`):
  - https://raw.githubusercontent.com/mugicnote/pk_dea/master/interface/frontendmainview.gui (pristine vanilla form — exact text ported)
  - https://raw.githubusercontent.com/Kaiserreich/Kaiserreich-HOI4/master/interface/frontendmainview.gui (cross-reference, identical structure)
  - Structure further corroborated across 60+ mods via GitHub code search for `change_background` + `background_selection_list` + `available_backgrounds` + `select_all_checkbox`.

---

## PRIORITY 2 — 665x `technology.cpp:210 ... invalid folder "bba_air_techs_folder"` (RESOLVED)

**`common/technologies/bba_air_techs.txt`** — Commented out the stale second `folder = { name =
secret_weapons_folder position = { x = 6 y = 8 } }` block on technology `improved_small_airframe`
(was lines 155-158). The tech now declares only its valid `bba_air_techs_folder` folder.
— **WHY**: The brief hypothesised the GUI was missing the tech folder. That hypothesis is WRONG and
was verified false: tech folders are registered in `common/technology_tags/00_technology.txt` (the
authoritative `technology_folders = { ... }` registry), NOT in the GUI. There, `bba_air_techs_folder`
IS registered (lines 221-226) and valid; `secret_weapons_folder` is NOT registered (present only as
a comment `#secret_weapons_folder` at line 270). `improved_small_airframe` is the ONLY tech in the
entire BBA air file (and the only tech mod-wide) with an active `secret_weapons_folder` folder
reference, and it is the ONLY tech that errors — all 665 errors are this single tech (logged once per
country/eval context). When a technology declares multiple `folder` blocks and one names an
unregistered folder, the engine rejects the tech's folder set and logs the failure citing the tech's
folder. In vanilla 1.19 (and in this mod's own `electronic_mechanical_engineering.txt:1247`) this
exact `secret_weapons_folder` block is commented out, because vanilla retired `secret_weapons_folder`
from the folder registry. Commenting it here matches vanilla and clears all 665 errors. Minimal,
design-preserving (the tech keeps its real BBA-air placement).
— Verified: no active `secret_weapons_folder` reference remains in the file; braces balanced 301/301;
CRLF + tabs preserved.
— **SOURCE**:
  - In-repo authoritative registry: `common/technology_tags/00_technology.txt` (lines 221-226 register `bba_air_techs_folder`; line 270 shows `secret_weapons_folder` is only a comment).
  - Vanilla-matching precedent — `secret_weapons_folder` block commented on this tech / noted "commented in vanilla":
    - https://raw.githubusercontent.com/Ivysaur-Mrquestionmarks/HOI4_MAA/master/common/technologies/bba_air_techs.txt (`#folder = { #name = secret_weapons_folder ...`)
    - https://raw.githubusercontent.com/KR-Tech-Extension/kr-tech-extension_knr_compat/master/common/technologies/electronic_mechanical_engineering.txt (comment: "secret_weapons_folder is commented in vanilla, see technology_tags/technology.txt")
  - In-repo precedent: `common/technologies/electronic_mechanical_engineering.txt:1247` already comments the same block.

---

## PRIORITY 3 — other stale gui overrides (scanned; no further crash-level issues)

Full scan of `error2.log` for crash signatures: the ONLY `Undefined GUI_TYPE`, the ONLY `gui.cpp:409`
(failed containerWindowType), and the ONLY "most likely crash" line is `change_background` (fixed
above). No missing-sprite / `Invalid GUI_TYPE` / failed-gui-load errors exist anywhere in the log.

### Cosmetic-only (documented, NOT forced — per brief)
**`interface/career_profile/common_components.gui`** (window `career_profile_pages`, line 95) —
12 distinct 1.19 career-profile statistic rows are looked up by the engine but not defined by the
mod's stale override, producing non-fatal `containerwindow.cpp:991/983/927` "Could not find X in
window" misses (the engine continues; the rows simply don't render):
`special_projects_completed`, `special_forces_deployed`, `ship_captains_promoted`,
`scientist_level_ups`, `rescued_commanders`, `naval_headquarters_built`, `mio_size_ups`,
`mastery_gained`, `launched_raids`, `faction_goals_completed`, `equipment_sold`,
`captured_commanders`.
— **WHY not fixed**: cosmetic-only and explicitly scoped as document-don't-force in the brief. These
are 1.19 career-profile stats added after the mod's `common_components.gui` override was authored.
Adding all 12 stat rows is a pure-cosmetic re-skin of the career-profile screen with no gameplay/load
impact and risk of layout drift; left for a dedicated career-profile reconciliation if desired.

---

## Files changed
- `interface/frontendmainview.gui` — added vanilla 1.19 `change_background` window (+ children). [CTD fix]
- `common/technologies/bba_air_techs.txt` — commented stale `secret_weapons_folder` folder ref on `improved_small_airframe`. [665 folder errors]

## CTD status
RESOLVED. `change_background` GUI_TYPE is now defined; the `Undefined GUI_TYPE` /
`Failed to create containerWindowType` crash and its four child-lookup misses are eliminated.
