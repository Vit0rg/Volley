# Improved Development Workflow with Agent-Based CI/CD

## Overview

This document proposes an improved development workflow that leverages specialized agents for different aspects of the CI/CD pipeline while maintaining separation of concerns and accounting for global state side effects.

---

## Current Challenges

### 1. Manual Verification Burden
- Build testing requires manual execution
- Code review findings tracked in static documents
- No automated regression detection

### 2. Global State Coupling
- Changes to `gameStats` affect multiple modules
- Team changes impact ranking and UI systems
- Build configuration changes require path updates

### 3. Documentation Drift
- Architecture docs not always synchronized with code
- Review findings can be forgotten
- File headers may lag behind implementation

### 4. Large Monolithic Files
- `eventChatCommand.lua` is 1436+ lines
- No automated splitting or module extraction
- Single-file changes can have wide impact

---

## Proposed Agent Roles

### Agent Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Development Workflow                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Code       │  │   Build      │  │   Test       │       │
│  │   Agent      │  │   Agent      │  │   Agent      │       │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘       │
│         │                 │                 │                │
│         └────────────────┼─────────────────┘                │
│                          │                                  │
│                  ┌───────▼────────┐                         │
│                  │   Global State │                         │
│                  │   Registry     │                         │
│                  └───────┬────────┘                         │
│                          │                                  │
│  ┌──────────────┐  ┌─────┴────────┐  ┌──────────────┐       │
│  │   Docs       │  │   Release    │  │   Quality    │       │
│  │   Agent      │  │   Agent      │  │   Agent      │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Agent Definitions

### 1. Code Agent (`code-agent`)

**Responsibility:** Source code modifications in `src/` directory

**Capabilities:**
- Implement features in game modules and event handlers
- Refactor existing code
- Fix bugs identified by Quality Agent
- Update module exports and imports

**Constraints:**
- Cannot modify `development/build_systems/` directly
- Must declare global state changes in `@state-change` comments
- Must run local syntax validation before handoff

**Global State Declaration:**
```lua
-- @global-changes
-- MODIFIED: gameStats (added twoBalls field)
-- ADDED: gameStats.twoBalls
-- AFFECTS: eventLoop, updateTwoBallsOnGame, init
```

**Handoff Triggers:**
- New files created → Build Agent
- Import paths changed → Build Agent
- Public API changed → Test Agent, Docs Agent

---

### 2. Build Agent (`build-agent`)

**Responsibility:** Build system maintenance and validation

**Capabilities:**
- Update `development/build_systems/build.txt`
- Maintain `build.js` and `combine.js`
- Verify file discovery and path resolution
- Generate build statistics (file count, line count)

**Constraints:**
- Cannot modify `src/` source files
- Must validate paths exist before committing
- Must ensure build.txt order matches dependency order

**Build Configuration Validation:**
```
□ All files in build config exist
□ No circular dependencies
□ Path resolution works from project root
□ npm run build succeeds
□ Build output is volley.lua
□ File counts verified
```

**Handoff Triggers:**
- Build fails → Code Agent (missing dependencies)
- Path errors → Code Agent (moved files)
- New warnings → Quality Agent

---

### 3. Test Agent (`test-agent`)

**Responsibility:** Automated testing and validation

**Capabilities:**
- Run build and capture output
- Execute Lua syntax checks
- Validate global state consistency
- Run unit tests for core functions
- Check for review findings resolution

**Test Categories:**

| Category | Checks | Frequency |
|----------|--------|-----------|
| Syntax | Lua parser validation | Every commit |
| Build | File counts, warnings | Every commit |
| Unit | Core function tests | Every feature |
| Integration | Game flow transitions | Every release |
| Regression | Known bug patterns | Every commit |

**Global State Validation:**
```lua
-- Test: Team structure consistency
function test_team_integrity()
    init()  -- Fresh state

    -- Verify team rosters
    assert(#playersRed == 6, "Red team should have 6 slots")
    assert(#playersBlue == 6, "Blue team should have 6 slots")

    -- Verify scores are numbers
    assert(type(score_red) == "number", "score_red should be number")
    assert(type(score_blue) == "number", "score_blue should be number")

    -- Verify gameStats structure
    assert(gameStats.gameMode ~= nil, "gameStats.gameMode should exist")
end
```

**Handoff Triggers:**
- Test failures → Code Agent
- Missing tests → Code Agent
- Documentation gaps → Docs Agent

---

### 4. Docs Agent (`docs-agent`)

**Responsibility:** Documentation maintenance and synchronization

**Capabilities:**
- Update `development/review.md` from commit messages
- Synchronize architecture docs with code state
- Generate architecture diagrams
- Extract function signatures for API docs
- Update review findings

**Documentation Rules:**
1. Every code change must have review entry
2. Architecture changes must update `project_architecture.md`
3. New public functions need documentation
4. File headers must be present

**Auto-Generation:**
```markdown
<!-- Auto-generated from commit abc123 -->
## Review: Implement echeckers Development Style

### Changed
- **Build System** (`development/build_systems/build.js`)
  - Added manifest-based build configuration
  - Fallback to inline config for backward compatibility

### Added
- **Documentation** (`development/project_architecture.md`)
  - Complete architecture overview
- **Standards** (`development/project_standards/lua_best_practices.md`)
  - Lua coding guidelines
```

**Handoff Triggers:**
- Missing documentation → Code Agent
- Outdated architecture → Architect Agent
- Incomplete review → Release Agent

---

### 5. Quality Agent (`quality-agent`)

**Responsibility:** Code quality and review automation

**Capabilities:**
- Run Lua syntax checks
- Check for anti-patterns
- Validate naming conventions (camelCase for functions)
- Detect circular reference risks
- Identify missing nil checks

**Quality Checks:**

| Priority | Check | Action |
|----------|-------|--------|
| 1-3 | Critical: Build broken, syntax errors | Block commit |
| 4-6 | High: Duplicate table keys, globals | Block commit |
| 7-10 | Medium: Missing nil checks | Track in review.md |
| 11-14 | Low: Hardcoded values | Suggest |
| 15-17 | Minor: Style issues | Note |

**Review Automation:**
```lua
-- Automated review checks for Volley
quality_checks = {
    {
        name = "duplicate_table_key",
        description = "Check for duplicate keys in table literals",
        priority = 4,  -- High: silent overwrites
    },
    {
        name = "naming_convention",
        pattern = "function%s+%w+_%w+%(%)",  -- snake_case functions
        replacement = "camelCase",
        priority = 15,  -- Low: style issue
    },
    {
        name = "nil_check",
        description = "Functions should validate parameters",
        priority = 7,  -- Medium
    }
}
```

**Handoff Triggers:**
- Critical issues found → Code Agent
- Review findings → Docs Agent (update review.md)
- Quality gate passed → Release Agent

---

### 6. Release Agent (`release-agent`)

**Responsibility:** Release preparation and deployment

**Capabilities:**
- Verify all quality gates passed
- Generate release notes from changelog
- Create git tags
- Prepare build artifacts
- Update version numbers

**Release Checklist:**
```
□ All syntax checks passing (Quality Agent)
□ Build successful (Build Agent)
□ Documentation complete (Docs Agent)
□ Build output generated (volley.lua)
□ Changelog updated for release
□ Version numbers incremented
□ Git tag created
```

**Release Notes Generation:**
```markdown
## Release V2.3.1

### Summary
Added echeckers development style with manifest-based build system.

### Changes
- Manifest-based build system (development/build_systems/build.txt)
- Coding standards documentation
- Architecture documentation
- File headers for core modules

### Build Outputs
| File | Size | Description |
|------|------|-------------|
| volley.lua | 415K | Complete game bundle |

### Contributors
- Soristl
- Qwen-Coder
```

**Handoff Triggers:**
- Release blocked → respective agent
- Release complete → notify all agents

---

### 7. Architect Agent (`architect-agent`)

**Responsibility:** Architecture oversight and global state registry

**Capabilities:**
- Maintain global state registry
- Track module dependencies
- Validate architectural constraints
- Approve structural changes
- Update architecture documentation

**Global State Registry:**
```yaml
globals:
  gameStats:
    type: table
    description: "Main game configuration and state flags"
    accessed_by:
      - src/init.lua
      - src/events/*.lua
      - src/functions/game/*.lua
    modified_by:
      - src/init.lua
      - src/events/eventChatCommand.lua

  mode:
    type: string
    values: ["startGame", "showRules", "gameStart", "endGame"]
    accessed_by:
      - src/events/eventChatCommand.lua
      - src/events/eventLoop.lua
    modified_by:
      - src/init.lua
      - src/functions/game/startGame.lua

  playersRed:
    type: table
    size: 6
    description: "Red team roster"

  playersBlue:
    type: table
    size: 6
    description: "Blue team roster"
```

**Dependency Tracking:**
```yaml
modules:
  src/events/eventChatCommand.lua:
    depends_on:
      - src/main.lua
      - src/translate.lua
      - src/functions/game/join/*.lua
      - src/functions/ranking/*.lua
    change_frequency: high

  src/init.lua:
    depends_on:
      - src/main.lua
      - src/functions/game/checkRoomAdmins.lua
    stability: stable
```

**Handoff Triggers:**
- Architecture violation → Code Agent
- Missing dependency declaration → Code Agent
- Structural change detected → Docs Agent

---

## Workflow Orchestration

### Standard Development Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Feature Implementation                                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Architect Agent                                          │
│     └─> Approve feature scope and global state impact       │
│                                                              │
│  2. Code Agent                                               │
│     └─> Implement feature in src/                           │
│     └─> Declare global state changes                        │
│                                                              │
│  3. Build Agent                                              │
│     └─> Update build.txt if needed                          │
│     └─> Verify build succeeds                               │
│                                                              │
│  4. Test Agent                                               │
│     └─> Run syntax, build, and unit tests                   │
│     └─> Validate global state consistency                   │
│                                                              │
│  5. Quality Agent                                            │
│     └─> Run quality checks                                  │
│     └─> Update review.md                                    │
│                                                              │
│  6. Docs Agent                                               │
│     └─> Update review.md, architecture docs                 │
│                                                              │
│  7. Architect Agent                                          │
│     └─> Verify architectural compliance                     │
│                                                              │
│  8. Release Agent                                            │
│     └─> Prepare commit with all artifacts                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Hotfix Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Hotfix: Critical Bug Fix                                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Quality Agent                                            │
│     └─> Identify bug from review.md or test failure         │
│                                                              │
│  2. Code Agent                                               │
│     └─> Implement fix                                       │
│     └─> Minimal scope change                                │
│                                                              │
│  3. Test Agent                                               │
│     └─> Verify fix resolves issue                           │
│     └─> Check for regressions                               │
│                                                              │
│  4. Quality Agent                                            │
│     └─> Fast-track quality check                            │
│                                                              │
│  5. Release Agent                                            │
│     └─> Create hotfix commit                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Refactoring Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Refactor: Structural Improvement                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Architect Agent                                          │
│     └─> Approve refactoring scope                           │
│     └─> Document expected benefits                          │
│                                                              │
│  2. Code Agent                                               │
│     └─> Implement refactoring                               │
│     └─> Maintain backward compatibility                     │
│                                                              │
│  3. Build Agent                                              │
│     └─> Update all affected paths                           │
│     └─> Verify build succeeds                               │
│                                                              │
│  4. Test Agent                                               │
│     └─> Full syntax check suite                             │
│     └─> Validate global state                               │
│                                                              │
│  5. Quality Agent                                            │
│     └─> Comprehensive review                                │
│     └─> Check for new anti-patterns                         │
│                                                              │
│  6. Docs Agent                                               │
│     └─> Update architecture documentation                   │
│     └─> Document benefits in review.md                      │
│                                                              │
│  7. Architect Agent                                          │
│     └─> Verify structural integrity                         │
│                                                              │
│  8. Release Agent                                            │
│     └─> Create refactoring commit                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Global State Change Protocol

### Declaration Format

When any agent modifies global state, it must declare changes:

```lua
-- @state-change
-- GLOBAL: gameStats
-- CHANGE: Structure modified (added twoBalls field)
-- BEFORE: gameStats had no twoBalls field
-- AFTER:  gameStats.twoBalls = false (default)
-- AFFECTED_MODULES:
--   - src/events/eventLoop.lua (read)
--   - src/functions/game/spawnBall/updateTwoBallsOnGame.lua (read/write)
--   - src/init.lua (initialization)
-- MIGRATION:
--   - Add twoBalls = false to gameStats initialization in init()
```

### Validation Rules

1. **No Silent Changes**: All global modifications must be declared
2. **Impact Analysis**: Affected modules must be listed
3. **Migration Path**: Changes must include migration steps
4. **Registry Update**: Global state registry must be updated

### Approval Workflow

```
Code Agent declares change
         ↓
Architect Agent reviews impact
         ↓
Test Agent validates state consistency
         ↓
Quality Agent checks for issues
         ↓
Release Agent commits with metadata
```

---

## Implementation Roadmap

### Phase 1: Foundation (Week 1-2)
- [x] Create agent role definitions in `development/roles/` folder
- [x] Set up global state registry format
- [x] Implement basic Test Agent scripts
- [x] Create Quality Agent check definitions
- [x] Create workflow documentation

### Phase 2: Automation (Week 3-4)
- [ ] Implement Build Agent validation scripts
- [ ] Create Docs Agent auto-generation tools
- [ ] Define handoff protocols
- [ ] Set up CI pipeline skeleton

### Phase 3: Integration (Week 5-6)
- [ ] Connect agents in workflow orchestration
- [ ] Implement Architect Agent registry
- [ ] Create Release Agent automation
- [ ] Test full development cycle

### Phase 4: Optimization (Week 7-8)
- [ ] Add performance monitoring
- [ ] Create agent communication protocol
- [ ] Document agent usage patterns
- [ ] Refine quality checks

---

## Metrics and KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| Build Success Rate | >99% | Build Agent logs |
| Test Coverage | >80% | Test Agent reports |
| Quality Gate Pass | 100% | Quality Agent checks |
| Documentation Sync | <1 commit lag | Docs Agent audit |
| Global State Violations | 0 | Architect Agent |
| Mean Time to Fix | <1 hour | Release Agent tracking |

---

## Conclusion

This agent-based workflow provides:

1. **Separation of Concerns**: Each agent has clear responsibilities
2. **Global State Awareness**: All changes tracked and validated
3. **Automated Quality**: Continuous validation at each step
4. **Documentation Sync**: Automatic updates prevent drift
5. **Build Safety**: Manifest-based builds ensure correct file order
6. **Scalable Process**: Agents can run in parallel when independent

The key innovation is the **Global State Registry** maintained by the Architect Agent, which ensures that all agents are aware of the side effects of changes to shared state like `gameStats`, `playersRed`, and `mode`.
