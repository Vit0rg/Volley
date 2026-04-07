# Code Review Notes

## Review Process

This file documents code reviews for the Volley project.

---

## Review: Implement echeckers Development Style

**Date:** 2026-04-04  
**Branch:** volley-v2.3.1  
**Scope:** 10 modified files, 3 new files

### Summary

Introduced the echeckers development style: manifest-based build system, coding standards documentation, architecture docs, and file headers. Build succeeds with 415K output.

**10 findings reported, 5 confirmed after independent verification.**

### Findings

#### Suggestion

1. **`build.js:4` — Unused `path` import** — Remove unused require statement.
2. **`build.js` — Empty manifest produces silent build** — Add validation that manifest has entries.
3. **`build.js` — Inline fallback may produce different file order** — Add warning when using inline config.
4. **`.prettierrc.json` — `useTabs: false` conflicts with existing tab-indented JS files** — Either reformat JS files or keep `useTabs: true`.

#### Nice to have

5. **`build.js:22` — Error message says "Manifest not found" for any read error** — Change to "Failed to read manifest".
6. **`lua_best_practices.md` — Naming conventions allow both camelCase and snake_case** — Add clear rule for when to use each.

### Verdict

**Comment** — No critical issues. Changes are sound and build works. Suggestions recommended but don't block merging.

---

## Review: Merge Soristl/Volley Updates into vit0rg-development

**Date:** 2026-04-06
**Branch:** vit0rg-development
**Scope:** Merged `soristl/main` into `vit0rg-development` — 8 files changed, 19 insertions, 11 deletions. Includes UI position adjustments, version bump to V2.3.1, three-teams mode fixes, admin list changes, and debug code.

### Summary

The merge brings the V2.3.1 update from the upstream Soristl repo with important fixes (corrected map array reference for three-teams mode, three-balls guard, `getRoomAdmin` nil safety). However, several issues were found: leftover debug `print()` statements, a missing `threeTeamsMode` branch in the ban command's leave logic, a mismatched array length bug for three-balls spawns, and dead code in admin guard conditions.

**10 findings reported, 7 confirmed after independent verification.**

### Findings

#### Critical

1. **`src/events/eventChatCommand.lua:908-920` — Ban command missing `threeTeamsMode` leave handling** — After banning a player in three-teams mode, the code falls through to the `else` branch and calls `leaveTeam(name1)` instead of `leaveTeamTeamsMode(name1)`. The `!leave` command correctly handles `threeTeamsMode` separately. This causes incorrect team state cleanup when banning during an active three-teams game.
   - **Suggested fix:** Add a `gameStats.threeTeamsMode and gameStats.canTransform` branch before the `teamsMode` check that calls `leaveTeamTeamsMode(name1)`, matching the `!leave` command pattern.

2. **`src/functions/game/spawnBall/spawnInitialBall.lua:13-20` — Mismatched spawnBalls and x arrays for threeBalls + large3v3** — `spawnBalls` has 2 elements but `x` has 3 when `threeBalls` is true. Inside `spawnBallsOnSpecificPlaces`, the third iteration falls into the `else` branch using a stale `randomIndex` to pick from the fallback array, causing the third ball to spawn at an unintended position.
   - **Suggested fix:** Add a third spawn area to `spawnBalls` when `threeBalls` is true:
     ```lua
     local spawnBalls = { spawnBallArea400, spawnBallArea800 }
     if gameStats.threeBalls then
       x = {300, 600, 900}
       table.insert(spawnBalls, spawnBallArea1200) -- or appropriate third spawn
     end
     ```

#### Suggestion

3. **`src/events/eventChatCommand.lua:882, 889, 897` — Debug `print()` statements left in production** — Three `print()` calls (`'first condition'`, `'second condition'`, `'third condition'`) in the ban command handler print to the TFM console on every ban attempt. These are clearly debug artifacts.
   - **Suggested fix:** Remove all three `print()` statements.

4. **`src/events/eventChatCommand.lua:881-896, 927-933` — Dead code: `and not permanentAdmin` in ban/unban room admin guard** — Both ban and unban handlers have an early `return` if `not permanentAdmin`. The later condition `if args[2] == string.lower(getRoomAdmin) and not permanentAdmin then return` will never evaluate `not permanentAdmin` as true, making it dead code. The room admin protection check never executes as intended.
   - **Suggested fix:** Remove `and not permanentAdmin`, making the guard simply:
     ```lua
     if args[2] == string.lower(getRoomAdmin) then
       return
     end
     ```

5. **`src/main.lua:61-62` — `getRoomAdmin` declared `local` in concatenated build** — The build system concatenates all files into one Lua file. While `local getRoomAdmin` in main.lua is accessible downstream because of the concatenation, this creates implicit cross-file coupling that's fragile if the build order changes or files are ever loaded independently.
   - **Suggested fix:** Consider documenting this dependency or using an explicit global/shared state pattern if the project moves toward module isolation.

#### Nice to have

6. **`src/translate.lua:4` — Version comment out of sync with `gameVersion` variable** — File header comment says `Version: V2.3.0` but `gameVersion = "V2.3.1"`.
   - **Suggested fix:** Update the header comment to `Version: V2.3.1`.

7. **`src/functions/game/fourTeamsMode/toggleMap.lua:70, 76` — Potentially redundant `showTheScore()` call** — `showTheScore()` is called immediately before a 2500ms timer, then called again inside the timer callback when `i==1`. The `small` branch pattern only calls it once (immediately). The first call may have no visible effect if `newGame()` clears the UI.
   - **Suggested fix:** Evaluate whether the immediate call before the timer is needed. If `newGame()` clears UI, remove it and keep only the timer callback call.

### Verdict

**Request changes** — Two critical issues: the missing `threeTeamsMode` branch in the ban leave logic and the mismatched spawn arrays for three-balls mode should be fixed before considering the merge complete. The debug `print()` statements and dead code in admin guards should also be cleaned up.

---

## Review: Fix Applied Findings from Merge Review

**Date:** 2026-04-06
**Branch:** vit0rg-development
**Scope:** Uncommitted fixes addressing the 7 findings from the previous merge review. 4 source files modified: ban/unban debug cleanup, threeTeamsMode ban leave handling, spawn array mismatch fix, redundant showTheScore() removal, version bump to V2.3.2.

### Summary

All 7 findings from the prior review were addressed: 4 fixed directly, 2 determined to have no actual issue (user confirmed no dead code in admin guards; `getRoomAdmin` coupling is by design), and 1 updated beyond original scope (version bumped to V2.3.2). The new review uncovered 3 additional findings introduced by the fixes.

**6 findings reported, 3 confirmed after independent verification.**

### Findings

#### Critical

1. **`src/functions/game/spawnBall/spawnInitialBall.lua:17` — `spawnBallArea1200` may be empty on some maps** — The fix adds `spawnBalls[#spawnBalls + 1] = spawnBallArea1200` unconditionally when `threeBalls` is true. However, `spawnBallArea1200` is populated from map XML tags (T="131") in the x range [1200, 1800]. On maps without a third ball spawn area, this table is empty. If `math.random(1, 3)` selects index 3, the ball falls into the else branch in `spawnBallsOnSpecificPlaces`, spawning at default y=50 which may be off-map.
   - **Suggested fix:** Guard the addition: `if gameStats.threeBalls and #spawnBallArea1200 > 0 then spawnBalls[#spawnBalls + 1] = spawnBallArea1200 end`

2. **`src/events/eventChatCommand.lua:905-908` — `leaveTeamTeamsMode` may not handle 3-team state mutation correctly** — When `threeTeamsMode` is active, `gameStats.typeMap` is set to `"large4v4"`. The ban force-leave calls `leaveTeamTeamsMode`, which enters the `large4v4` branch and works correctly for initial player removal. However, if enough force-leaves fully eliminate a team, `toggleMapType()` mutates `typeMap` from `"large4v4"` to `"large3v3"`. After this mutation, subsequent leave calls enter the `large3v3` branch which searches `teamsPlayersOnGame` instead of the named arrays (`playersRed`, etc.), leaving dangling state. Additionally, the game never ends when a team is fully eliminated via force-leaves in 3-team mode.
   - **Suggested fix:** Audit `leaveTeamTeamsModeConfig` and `toggleMapType` to verify they handle 3-team mode elimination correctly. Consider creating a dedicated `leaveTeamThreeTeamsMode` or adding a guard in the config function.

#### Suggestion

3. **`src/events/eventChatCommand.lua:894` — Dead code `and not permanentAdmin` in ban/unban room admin guard (pre-existing)** — The early `return` at line 882 guarantees `permanentAdmin` is true, making `and not permanentAdmin` in the inner guard always false. Same pattern in the unban command at line 934.
   - **Suggested fix:** Remove `and not permanentAdmin` from both guards if the intent is to protect the room admin.

#### Nice to have

4. **`src/functions/game/fourTeamsMode/toggleMap.lua` — Inconsistency: small branch still calls `showTheScore()` immediately** — After removing the immediate `showTheScore()` from the `large3v3` branch, the `small` branch still calls it immediately before its timer. This creates a timing divergence: large3v3 defers score display by 2.5s while small shows it immediately (potentially before the map has loaded).
   - **Suggested fix:** Consider removing the immediate `showTheScore()` from the small branch as well for consistency, or restore it in large3v3 if the 2.5s delay is undesirable.

### Verdict

**Request changes** — Two critical issues found in the fixes: the `spawnBallArea1200` empty-table vulnerability and the `leaveTeamTeamsMode` state mutation bug in 3-team mode should be addressed before considering the merge complete.

---

## Review Template

Use this template for future reviews:

```markdown
## Review: [Title]

**Date:** YYYY-MM-DD
**Branch:** branch-name
**Scope:** brief description

### Summary
1-2 sentence overview.

### Findings
#### Critical / Suggestion / Nice to have
1. **file:line — Issue** — Description.

### Verdict
Approve / Request changes / Comment
```
