# Development Cycle Summary

## Overview

This document summarizes the typical development cycle for the Volley project based on historical commit patterns and development practices.

---

## Current Development Cycle

### Phase 1: Planning (Pre-Development)

1. **Task Definition**
   - Check `development/review.md` for known issues
   - Review `development/project_architecture.md` for structural constraints
   - Identify scope of the current feature/refactoring cycle
   - Identify potential side effects on global state

2. **Architecture Review**
   - Consult `development/project_architecture.md` for constraints
   - Review `development/review.md` for known issues from previous cycles
   - Check `development/roles/architect-agent.md` for global state rules

### Phase 2: Implementation

1. **Code Development**
   - Create/modify source files in `src/` directory
   - Follow module patterns: camelCase for functions, PascalCase for events
   - Use internal function prefix `_` for private functions
   - Maintain separation: `src/` for source, `development/` for tools

2. **Build Configuration**
   - Update `development/build_systems/build.txt` for new files
   - Ensure path consistency across build configuration
   - Maintain correct file order (dependencies before dependents)

3. **Documentation Updates**
   - Update `development/review.md` with changes
   - Update architecture documentation if structure changed
   - Add file headers to new source files

### Phase 3: Verification

1. **Build Testing**
   ```bash
   npm run build
   ```
   - Verify no errors in build output
   - Check file counts
   - Review WARNING messages for missing files
   - Confirm `volley.lua` was created

2. **Code Quality**
   - Manual review of changes
   - Check for circular references in table operations
   - Validate nil checks on public APIs
   - Ensure consistent naming conventions (camelCase)

3. **Git Hygiene**
   ```bash
   git status          # Review all changes
   git add -A          # Stage all changes
   git diff --staged   # Verify staged changes
   ```

### Phase 4: Commit

1. **Commit Message Format**
   ```
   type: Short title describing the change

   - Change 1
   - Change 2
   - Change 3

   Co-authored-by: Qwen-Coder <qwen-coder@alibabacloud.com>
   ```

2. **Post-Commit Verification**
   ```bash
   git status          # Should show clean working tree
   git log -n 1        # Verify commit message and author
   ```

---

## Historical Patterns

### Version Numbering Convention

| Pattern | Usage |
|---------|-------|
| `V{MAJOR}.{MINOR}.{PATCH}` | Standard versioning |
| `V2.3.0` | New feature (minor) |
| `V2.3.1` | Bug fix (patch) |
| `V3.0.0` | Major overhaul |

**Examples from history:**
- V2.3.0 - Previous release with 4 teams map fixes
- V2.3.1 - Current development (echeckers style integration)

### Common Change Patterns

1. **Feature Implementation**
   - Add new function modules (`src/functions/game/*.lua`)
   - Update event handlers if needed
   - Add UI components
   - Update build configuration

2. **Refactoring**
   - Restructure existing modules
   - Update import paths in build config
   - Maintain backward compatibility during transition
   - Document benefits in review.md

3. **Build System Changes**
   - Update path resolution in build scripts
   - Modify build configuration files
   - Add/remove files from manifest

4. **Bug Fixes**
   - Fix identified in `development/review.md`
   - Applied across affected modules
   - Documented in review.md

---

## Global State Considerations

### Current Global Variables

```lua
-- Game State
gameStats = {}           -- Main game configuration
playersRed = {}          -- Red team roster (6 slots)
playersBlue = {}         -- Blue team roster (6 slots)
playersYellow = {}       -- Yellow team roster (3-4 slots)
playersGreen = {}        -- Green team roster (3-4 slots)
mode = "startGame"       -- Current game phase
score_red = 0            -- Red team score
score_blue = 0           -- Blue team score
ball_id = 6              -- Current ball type
ballOnGame = false       -- Ball active flag

-- Player State
playerInGame = {}        -- Player in-game status
playerCanTransform = {}  -- Player transform permission
playerForce = {}         -- Player force settings
playerLanguage = {}      -- Player language settings

-- Configuration
globalSettings = {}      -- Room settings
admins = {}              -- Admin access map
```

### Side Effect Patterns

1. **gameStats Operations**
   - Changing `gameStats` structure affects:
     - UI rendering (`src/ui/addWindow/*.lua`)
     - Event handlers (`src/events/*.lua`)
     - Game functions (`src/functions/game/*.lua`)

2. **Team Changes**
   - Modifying team rosters affects:
     - Join/leave logic
     - Ranking system
     - Score tracking

3. **Build Configuration**
   - Path changes affect:
     - Build order (`development/build_systems/build.txt`)
     - File concatenation order
     - Function availability

---

## Pain Points Identified

### From Code Reviews

1. **Priority 1-3 (Critical)**
   - Build system reliability
   - Duplicate table keys in command shortcuts

2. **Priority 4-6 (High)**
   - Silent overwrite when duplicate keys exist
   - Missing file validation in build manifest

3. **Priority 7-14 (Medium)**
   - Missing nil checks in public functions
   - Duplicated logic across modules
   - Table allocation on every call

4. **Priority 15-17 (Low)**
   - Outdated comments
   - Build artifacts in repo

### From Development Process

1. **Manual Verification**
   - No automated testing
   - Manual build verification required
   - Code review findings tracked manually

2. **Documentation Lag**
   - Architecture docs not always updated
   - File headers sometimes missing

---

## Metrics

### Typical Step Duration

| Step Type | Files Changed | Lines Changed |
|-----------|---------------|---------------|
| Feature | 5-15 | 200-1000 |
| Refactor | 10-30 | 100-500 |
| Build | 2-5 | 50-200 |
| Hotfix | 1-3 | 10-50 |

### Build Output

| Metric | Value |
|--------|-------|
| Files | 136 |
| Output Size | ~415K |
| Output File | volley.lua |

---

## Recommendations for Improvement

See `improved_development.md` for detailed suggestions on:
- Agent-based development workflow
- Automated testing and validation
- Documentation automation
- Separation of concerns with global state awareness
- Agent roles and responsibilities

---

## Agent-Based Workflow Integration

The Volley project now uses an agent-based workflow with the following roles:

| Agent | Role File |
|-------|-----------|
| Architect Agent | `development/roles/architect-agent.md` |
| Code Agent | `development/roles/code-agent.md` |
| Build Agent | `development/roles/build-agent.md` |
| Test Agent | `development/roles/test-agent.md` |
| Quality Agent | `development/roles/quality-agent.md` |
| Docs Agent | `development/roles/docs-agent.md` |
| Release Agent | `development/roles/release-agent.md` |

### Standard Workflow

```
Architect → Code → Build → Test → Quality → Docs → Release
```

### Quick Reference

- **Feature Development**: See `development/workflow/current_workflow.md`
- **Bug Fix**: Quality → Code → Build → Test → Quality → Release
- **Refactoring**: Architect → Code → Build → Test → Quality → Docs → Architect → Release
