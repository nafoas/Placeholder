# -debug Validation Runbook (1.19)

The staged 1.14 → 1.19 port is committed (`524d837`). This is the definitive validation:
run the mod on 1.19 with `-debug` and send back `error.log` so the orchestrator can do a
final cleanup against **real** engine errors and finalize the D1/D6 migration decision.

## 1. Enable -debug
Steam → right-click **Hearts of Iron IV** → **Properties** → **General** →
**Launch Options** → enter:  `-debug`
(Enables complete validation logging + debug tooltips. `error.log` is written either way,
but `-debug` makes it complete.)

## 2. Run the test
1. Launch HOI4. In the launcher **playset, enable ONLY this mod** (CBtS Fan Fork), then
   **Play**. Reaching the **main menu** already catches most load/parse errors.
2. Start a **new game as Germany** — the single best test: it exercises the migrated GER
   abilities, the GER AI templates (D1), and the doctrine references (D6) all at once.
3. Open the **Army, Navy, and Air doctrine tabs** — settles the one open question (do the
   old-format doctrines crash against 1.19's new doctrine GUI? evidence says no — confirm).
4. (Optional) open an army general and check the **Force Attack / Last Stand** abilities
   (the ones migrated in Jump 5).
5. Run at speed 4–5 for a few in-game **months** — surfaces runtime AI errors, notably the
   deferred `ai_templates` (D1) `hourly_tick` risk if it exists.
6. Exit.

## 3. Send back
- **`Documents/Paradox Interactive/Hearts of Iron IV/logs/error.log`** — the main one.
- If it crashed: also the newest folder under
  `Documents/Paradox Interactive/Hearts of Iron IV/crashes/` (`exception.txt` + dump), and
  tell me what you were doing when it crashed.
- The whole `logs/` folder is welcome, but `error.log` is what matters. Paste or attach.

## 4. What the orchestrator does with it
- Separate **mod** errors from vanilla noise, and **load-bearing** from cosmetic.
- Fix the real mod errors → a final cleanup commit.
- Use the doctrine-tab result + any AI-tick errors to finalize **D1/D6** (migrate vs delete
  vs leave) with evidence.

## Expected going in (so the log isn't alarming)
- The deferred **D1 (ai_templates)** and **D6 (doctrines)** will likely emit warnings
  (legacy keys / non-functional doctrine subsystem). That's expected — what matters is
  whether they're **warnings** (fine, deferrable) or **crashes** (act now).
- A few logged pre-existing artifacts may appear (`DECISIONS-NEEDED.md` D4 duplicate
  provinces, D5 `script_enums`) — non-load-breaking.
