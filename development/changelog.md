# Changelog

All notable changes to Volley will be documented in this file.

---

## [Unreleased]

### Added

- **Development Workflow** (`development/workflow/`)
  - Agent-based development workflow with 7 specialized roles
  - Current operational workflow documentation
  - Improved workflow proposals with implementation roadmap
  - Development cycle summary with historical patterns

- **Agent Roles** (`development/roles/`)
  - Architect Agent — Global state and architecture oversight
  - Code Agent — Source code implementation
  - Build Agent — Build system maintenance
  - Test Agent — Automated testing and validation
  - Quality Agent — Code quality checks and review tracking
  - Docs Agent — Documentation synchronization
  - Release Agent — Release coordination

- **Development Standards** (`development/project_standards/`)
  - Lua best practices and coding guidelines
  - Naming conventions (camelCase for functions, PascalCase for events)
  - C-style loops standard for arrays
  - Performance guidelines

- **Architecture Documentation** (`development/project_architecture.md`)
  - Complete project architecture overview
  - Core systems documentation
  - Development workflow reference

- **Build System** (`development/build_systems/`)
  - Manifest-based build configuration (`build.txt`)
  - Build scripts moved from root to `development/build_systems/`

- **Code Review Process** (`development/review.md`)
  - Code review notes and findings
  - Review template for future use

### Changed

- **Build System** — Moved from hardcoded file list in `build.js` to manifest-based configuration with fallback
- **Build Scripts** — Moved `build.js` and `combine.js` from project root to `development/build_systems/`
- **Prettier Config** — Updated formatting preferences (single quotes, spaces, print width)
- **README** — Added development style documentation section

### Fixed

- **Build Manifest** — Corrected file paths to match actual project structure
- **Unused Import** — Removed unused `path` require from `build.js`

### File Headers

- Added standard file headers to core source files:
  - `src/balls.lua`
  - `src/maps.lua`
  - `src/printf.lua` (existing)
  - `src/translate.lua`
  - `src/timer.lua`
  - `src/main.lua`
  - `src/init.lua`
  - `src/events/eventChatCommand.lua`

---

## V2.3.2

### Added

- **Three-Teams Mode**
  - Helper function `endThreeTeamsModeGame` for proper game-end logic
  - `threeTeamsMode` support in ban command force-leave (calls `leaveTeamTeamsMode`)

### Changed

- **Version** — Bumped from V2.3.1 to V2.3.2 (`src/translate.lua`)

### Fixed

- **Ban Command** (`src/events/eventChatCommand.lua`)
  - Removed debug `print()` statements from ban/unban handlers
  - Removed duplicate `print()` calls that duplicated ban/unban chat messages
  - Added `threeTeamsMode` branch in ban force-leave logic to call correct leave function

- **Ball Spawning** (`src/functions/game/spawnBall/spawnInitialBall.lua`)
  - Fixed mismatched spawnBalls/x arrays for threeBalls + large3v3 mode
  - Added guard to prevent empty `spawnBallArea1200` table on maps without third spawn point

- **Three-Teams Game End** (`src/functions/game/leave/leaveTeamTeamsModeConfig.lua`)
  - Fixed state mutation bug where team elimination via ban could leave dangling state
  - Extracted `endThreeTeamsModeGame()` helper to avoid code duplication across team elimination blocks

- **Score UI Timing** (`src/functions/game/fourTeamsMode/toggleMap.lua`)
  - Removed redundant `showTheScore()` call before timer in large3v3 branch
  - Moved `showTheScore()` into timer callback in small branch for consistency

---

## V2.3.1

### Fixed

- **Maps** (`src/maps.lua`)
  - Fixed 4 teams map index 38

---

## V2.2.0

### Added

- **Game Modes**
  - 4 teams mode
  - 3 teams mode
  - 2 teams mode
  - Real mode

- **Internationalization**
  - Brazilian Portuguese
  - English
  - Arabic
  - French
  - Polish

### Changed

- **UI System**
  - Window-based UI components
  - Settings pages
  - Map selection interface
  - Ranking display

---

## V2.1.0

### Added

- **Ball System**
  - 15 ball variants
  - Custom ball selection
  - Random ball mode

- **Map System**
  - 53+ custom maps
  - Team-specific map variants
  - Map voting

- **Ranking System**
  - Normal mode rankings
  - Team mode rankings
  - Player history

---

## V2.0.0

### Added

- **Core Game**
  - Volleyball minigame for Transformice
  - Team-based gameplay
  - Custom physics
  - Admin system

---

## Format Notes

- **Versions** follow `V{MAJOR}.{MINOR}.{PATCH}` format
- **Sections** use `Added`, `Changed`, `Fixed`, `Removed` categories
- **File paths** are relative to project root
