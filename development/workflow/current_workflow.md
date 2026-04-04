# Current Workflow (Agent-Based)

## Overview

This document describes the **current operational workflow** for the Volley project, based on the implemented agent roles. This workflow is active and should be followed for all development activities.

---

## Agent Roster

| Agent | Role | Primary Responsibility |
|-------|------|----------------------|
| **Architect Agent** | Architecture Guardian | Global state, dependencies, approval |
| **Code Agent** | Implementation Specialist | Source code in `src/` directory |
| **Build Agent** | Build System Guardian | Build scripts and configurations |
| **Test Agent** | Validation Specialist | Automated testing and validation |
| **Quality Agent** | Code Quality Guardian | Quality checks and review tracking |
| **Docs Agent** | Documentation Synchronizer | Changelog, review notes, API docs |
| **Release Agent** | Release Coordinator | Commit preparation (only when prompted) |

---

## Workflow States

```
┌─────────────────────────────────────────────────────────────┐
│  Current Workflow State Machine                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  [IDLE] ──> [DEVELOPMENT] ──> [VALIDATION] ──> [REVIEW]     │
│     ^           |                  |              |          │
│     |           v                  v              v          │
│     |      [CODE_AGENT]      [TEST_AGENT]   [QUALITY_AGENT] │
│     |      [ARCHITECT_AGENT] [BUILD_AGENT]  [DOCS_AGENT]    │
│     |                                  |                     │
│     |                                  v                     │
│     └────────────────────────── [RELEASE_AGENT] ──> [IDLE]  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Active Workflows

### 1. Feature Development Workflow

**Trigger:** New task from TODO tracking

```
┌─────────────────────────────────────────────────────────────┐
│  Feature Implementation                                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  PHASE 1: PLANNING                                           │
│  ═════════════════                                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Architect Agent                                       │   │
│  │ - Review feature scope                                │   │
│  │ - Identify global state impact                        │   │
│  │ - Approve architectural changes                       │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│  PHASE 2: IMPLEMENTATION                                     │
│  ═══════════════════════                                     │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Code Agent                                            │   │
│  │ - Implement feature in src/                           │   │
│  │ - Add @state-change declarations                      │   │
│  │ - Document public API                                 │   │
│  │ - Run local syntax validation                         │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Build Agent                                           │   │
│  │ - Update build.txt if new files added                 │   │
│  │ - Verify paths exist                                  │   │
│  │ - Test build: npm run build                           │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│  PHASE 3: VALIDATION                                         │
│  ════════════════════                                        │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Test Agent                                            │   │
│  │ - Run syntax checks (lua -p)                          │   │
│  │ - Validate build (volley.lua created)                 │   │
│  │ - Validate global state consistency                   │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Quality Agent                                         │   │
│  │ - Check anti-patterns                                 │   │
│  │ - Validate naming conventions (camelCase)             │   │
│  │ - Generate quality report                             │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│  PHASE 4: DOCUMENTATION                                      │
│  ════════════════════════                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Docs Agent                                            │   │
│  │ - Update review.md                                    │   │
│  │ - Update architecture docs if structure changed       │   │
│  │ - Update README if needed                             │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│  PHASE 5: COMMIT                                             │
│  ════════════                                                │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Release Agent (only when explicitly prompted)         │   │
│  │ - Verify all gates passed                             │   │
│  │ - Prepare commit message                              │   │
│  │ - Create commit with proper format                    │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Handoff Sequence:**
```
Architect → Code → Build → Test → Quality → Docs → Release → [Git]
```

---

### 2. Bug Fix Workflow (Hotfix)

**Trigger:** Quality Agent detects issue or user report

```
┌─────────────────────────────────────────────────────────────┐
│  Hotfix: Critical Bug Fix                                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Quality Agent                                            │
│     └─> Identify bug priority (P1-P17)                      │
│     └─> Create issue report                                 │
│                                                              │
│  2. Code Agent                                               │
│     └─> Implement minimal fix                               │
│     └─> Add regression test                                 │
│                                                              │
│  3. Build Agent                                              │
│     └─> Verify build still works                            │
│                                                              │
│  4. Test Agent                                               │
│     └─> Verify fix resolves issue                           │
│     └─> Run syntax checks                                   │
│                                                              │
│  5. Quality Agent                                            │
│     └─> Fast-track quality check                            │
│     └─> Update review.md (mark resolved)                    │
│                                                              │
│  6. Release Agent                                            │
│     └─> Create hotfix commit                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Handoff Sequence:**
```
Quality → Code → Build → Test → Quality → Release → [Git]
```

---

### 3. Refactoring Workflow

**Trigger:** Technical debt or architectural improvement

```
┌─────────────────────────────────────────────────────────────┐
│  Refactor: Structural Improvement                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Architect Agent                                          │
│     └─> Approve refactoring scope                           │
│     └─> Document expected benefits                          │
│     └─> Update dependency registry                          │
│                                                              │
│  2. Code Agent                                               │
│     └─> Implement refactoring                               │
│     └─> Maintain backward compatibility                     │
│                                                              │
│  3. Build Agent                                              │
│     └─> Update build.txt paths                              │
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
│     └─> Approve final state                                 │
│                                                              │
│  8. Release Agent                                            │
│     └─> Create refactoring commit                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Handoff Sequence:**
```
Architect → Code → Build → Test → Quality → Docs → Architect → Release → [Git]
```

---

## Global State Change Protocol

### Declaration Format

When any change affects global state, the Code Agent **must** include this declaration:

```lua
-- @state-change
-- GLOBAL: gameStats
-- CHANGE: Added twoBalls flag for dual-ball mode
-- BEFORE: gameStats had no twoBalls field
-- AFTER: gameStats.twoBalls = false (default)
-- AFFECTED_MODULES:
--   - src/events/eventLoop.lua (read)
--   - src/functions/game/spawnBall/updateTwoBallsOnGame.lua (read/write)
-- MIGRATION:
--   - Initialize in src/init.lua
```

### Validation Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Global State Change Validation                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Code Agent declares change                                  │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Architect Agent                                       │   │
│  │ - Verify declaration format                           │   │
│  │ - Check affected modules list                         │   │
│  │ - Validate migration path                             │   │
│  └──────────────────────────────────────────────────────┘   │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Test Agent                                            │   │
│  │ - Validate global state consistency                   │   │
│  │ - Verify no unauthorized access                       │   │
│  └──────────────────────────────────────────────────────┘   │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Quality Agent                                         │   │
│  │ - Check for side effects                              │   │
│  │ - Validate layer boundaries                           │   │
│  └──────────────────────────────────────────────────────┘   │
│         │                                                    │
│         ▼                                                    │
│  APPROVED → Proceed to commit                                │
│  REJECTED → Return to Code Agent with feedback               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Agent Communication Protocol

### Handoff Message Format

All agent handoffs must use this format:

```
HANDOFF: [Agent Name]
ACTION: [Required action]
[Context-specific fields]
PRIORITY: [critical | high | normal | low]
```

### Priority Levels

| Priority | Response Time | Examples |
|----------|---------------|----------|
| **critical** | Immediate | Build broken, syntax errors |
| **high** | Same session | Missing files, path errors, quality gate failure |
| **normal** | Next development cycle | Documentation updates, new features |
| **low** | When convenient | Style suggestions, minor improvements |

### Notification Channels

```
┌─────────────────────────────────────────────────────────────┐
│  Agent Communication Matrix                                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Code Agent ──┬──> Build Agent    (new files, path changes)  │
│               ├──> Test Agent     (new API, feature tests)   │
│               ├──> Quality Agent  (code review)              │
│               └──> Docs Agent     (API docs, changelog)      │
│                                                              │
│  Build Agent ─┬──> Test Agent     (build artifact ready)     │
│               ├──> Quality Agent  (build warnings)           │
│               └──> Release Agent  (artifacts for release)    │
│                                                              │
│  Test Agent ──┬──> Code Agent     (test failures)            │
│               ├──> Quality Agent  (quality metrics)          │
│               └──> Release Agent  (release approval)         │
│                                                              │
│  Quality Agent┬──> Code Agent     (issues to fix)            │
│               ├──> Docs Agent     (review.md updates)        │
│               └──> Release Agent  (quality approval)         │
│                                                              │
│  Docs Agent ──┬──> Code Agent     (missing documentation)    │
│               └──> Release Agent  (release notes ready)      │
│                                                              │
│  Architect ───┬──> Code Agent     (architecture violations)  │
│  Agent        ├──> Build Agent    (structural changes)       │
│               ├──> Docs Agent     (architecture docs)        │
│               └──> Release Agent  (architecture approval)    │
│                                                              │
│  Release ─────┴──> All Agents    (release notification)      │
│  Agent                                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Current State

### Active Agents

All agents are **ACTIVE** and operational:

- ✅ **Architect Agent** - Global state and architecture oversight
- ✅ **Code Agent** - Source code implementation
- ✅ **Build Agent** - Build system maintained
- ✅ **Test Agent** - Test framework ready
- ✅ **Quality Agent** - Quality checks configured
- ✅ **Docs Agent** - Review notes and docs synchronized
- ⏸️ **Release Agent** - Invoked only when explicitly prompted

### Global State Registry

**Tracked Globals:**
- `gameStats` - Main game configuration
- `playersRed/Blue/Yellow/Green` - Team rosters
- `mode` - Game phase (startGame, gameStart, etc.)
- `score_red`, `score_blue` - Team scores
- `ball_id`, `ballOnGame` - Ball state
- `playerInGame`, `playerCanTransform` - Player state
- `globalSettings` - Room settings

### Quality Gates

**Required for all commits:**
1. ✅ Syntax validation (`lua -p`)
2. ✅ Build success (`npm run build`)
3. ✅ Unit tests passing
4. ✅ Global state validation
5. ✅ Quality checks (anti-patterns, naming)
6. ✅ Documentation updated (review.md, architecture)

---

## Getting Started

### For New Development Sessions

1. **Review current state**
   ```bash
   cat development/review.md
   cat development/project_architecture.md
   ```

2. **Start with Architect Agent approval**
   - Review scope of planned changes
   - Identify global state impact

3. **Follow the workflow**
   - Code → Build → Test → Quality → Docs → Release

### For Bug Fixes

1. **Quality Agent identifies issue** (or review findings)
2. **Architect Agent approves scope**
3. **Code Agent implements fix**
4. **Build Agent verifies build**
5. **Test Agent confirms fix**
6. **Docs Agent updates review.md**
7. **Release Agent commits** (when prompted)

### For Releases

1. **Release Agent coordinates all agents**
2. **Verify all quality gates**
3. **Generate release notes**
4. **Create git tag**
5. **Publish release**

---

## Metrics Dashboard

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Build Success Rate | - | 100% | ⏳ Tracking |
| Test Pass Rate | - | 100% | ⏳ Tracking |
| Quality Score | - | >90/100 | ⏳ Tracking |
| Documentation Sync | - | 100% | ⏳ Tracking |
| Global State Violations | 0 | 0 | ✅ OK |

*Metrics will be populated after first development cycle*

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-04-04 | Initial workflow definition based on implemented roles |
