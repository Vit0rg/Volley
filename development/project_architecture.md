# Volley Project Architecture

## Overview

Volley is a Transformice (TFM) volleyball minigame module written in Lua 5.1. It is designed to run inside the Transformice game by pasting the compiled `volley.lua` file into the game's `/lua` command interface.

**Version**: V2.3.0

---

## Architecture

### Build System

The project uses a **concatenation-based build system** (similar to echeckers):

- **Input**: Multiple modular Lua files in `src/`
- **Build Manifest**: `development/build_systems/build.txt` (explicit file order)
- **Output**: Single `volley.lua` file (ready to paste into TFM)
- **Build Tool**: Node.js-based concatenation script (`build.js`)

**Build Process:**
1. Read file order from manifest (`development/build_systems/build.txt`)
2. Concatenate files in specified order with delimiter comments
3. Output to `volley.lua`
4. (Optional) Minify with `luamin`

**Build Commands:**
```bash
npm run build    # Combine files using manifest
npm run watch    # Watch for changes and auto-rebuild
npm run minify   # Build + minify
```

---

## Project Structure

```
Volley/
├── src/                          # Source files (concatenated in build order)
│   ├── balls.lua                 # Ball type definitions (15 variants)
│   ├── maps.lua                  # Custom maps (53+ maps, team variants)
│   ├── printf.lua                # Debug utilities
│   ├── translate.lua             # Internationalization (BR, EN, AR, FR, PL)
│   ├── timer.lua                 # Custom timer system with List data structure
│   ├── main.lua                  # Global state, admins, initialization
│   ├── events/                   # TFM event callbacks
│   │   ├── eventChatCommand.lua        # Chat command handler (1436+ lines)
│   │   ├── eventKeyboard.lua           # Keyboard input handling
│   │   ├── eventLoop.lua               # Game loop
│   │   ├── eventNewGame.lua            # New game event
│   │   ├── eventNewPlayer.lua          # Player join event
│   │   ├── eventPlayerLeft.lua         # Player leave event
│   │   └── eventTextAreaCallback.lua   # UI callback handler
│   ├── functions/                # Game logic utilities
│   │   ├── afkSystem/            # AFK detection system
│   │   ├── game/                 # Core game mechanics
│   │   │   ├── consumables/      # Consumable items
│   │   │   ├── fourTeamsMode/    # 4-team mode logic
│   │   │   ├── join/             # Team joining logic
│   │   │   ├── leave/            # Team leaving logic
│   │   │   ├── miceSpawn/        # Player spawning
│   │   │   ├── miceTransform/    # Transform mechanics
│   │   │   ├── realMode/         # Real mode logic
│   │   │   ├── spawnBall/        # Ball spawning logic
│   │   │   ├── verifyIsPoint/    # Point validation
│   │   │   ├── checkRoomAdmins.lua
│   │   │   ├── selectMap.lua
│   │   │   └── startGame.lua
│   │   ├── ranking/              # Ranking and stats system
│   │   ├── settings/             # Settings management
│   │   ├── sync/                 # Text sync conditions
│   │   ├── utils/                # Utility functions (24 files)
│   │   └── vote/                 # Voting system
│   ├── ui/                       # UI components
│   │   ├── addWindow/            # Window creation utilities
│   │   │   ├── lobby/            # Lobby UI
│   │   │   ├── selectMap/        # Map selection UI
│   │   │   └── settings/         # Settings UI
│   │   └── removeWindow/         # Window removal utilities
│   └── init.lua                  # Game initialization (runs last)
├── development/                  # Development tools and documentation
│   ├── build_systems/            # Build configuration
│   │   └── build.txt             # Build manifest (file order)
│   └── project_standards/        # Coding standards
│       └── lua_best_practices.md # Lua coding guidelines
├── build.js                      # Build script
├── combine.js                    # File concatenation logic
├── package.json                  # NPM dependencies
├── .prettierrc.json              # Code formatter config
└── README.md                     # Project documentation
```

---

## Core Systems

### 1. Game State Management

**Global State Tables:**
- `gameStats` - Main game configuration and flags
- `playersRed/Blue/Yellow/Green` - Team rosters (indexed tables)
- `playerInGame`, `playerCanTransform`, `playerForce`, etc. - Player state
- `mode` - Game phase (`"startGame"`, `"showRules"`, `"gameStart"`, `"endGame"`)

**Design Pattern:**
- Files are concatenated (not modules), so functions/variables share global scope
- No `return` statements at file end
- Local variables by default, globals only for game state

---

### 2. Team System

**Supported Modes:**
- Normal Mode (1v1 free-for-all)
- 2 Teams Mode (Red vs Blue)
- 3 Teams Mode (Red vs Blue vs Green/Yellow)
- 4 Teams Mode (Red vs Blue vs Yellow vs Green)
- Real Mode (special variant)

**Team Data Structure:**
```lua
playersRed = {
  [1] = {name = ''},
  [2] = {name = ''},
  -- ... up to 6 slots
}
```

---

### 3. Timer System

Custom timer library in `timer.lua`:
- `addTimer(callback, ms, loops, label, ...)` - Create timer
- `removeTimer(id)` - Remove timer
- `pauseTimer(id)` / `resumeTimer(id)` - Control timers
- `timersLoop()` - Called from `eventLoop` every 500ms

**Implementation:**
- Uses custom `List` deque for ID pooling
- Timers can be identified by numeric ID or string label

---

### 4. UI System

**Window-based UI:**
- `ui.addWindow(id, text, player, x, y, width, height, alpha, corners, closeButton, buttonText)`
- Windows use numeric IDs with sub-elements using ID concatenation (`id.."0"`, `id.."00"`)
- `closeWindow(id, name)` removes all sub-text-areas

**Event-driven UI:**
- UI callbacks use `event:actionName` href patterns
- Handled by `eventTextAreaCallback.lua`

---

### 5. Admin System

**Admin Types:**
- **Room Admins**: Extracted from room name pattern `#volley%d+([%+_]*[%w_#]+)`
- **Permanent Admins**: Hardcoded list (`permanentAdmins`)
- **Inactive Permanent Admins**: Hardcoded list (`inactivePermanentAdmins`)
- **Tribe House Owners**: Auto-become admins in tribe houses

---

### 6. Internationalization

**Supported Languages:**
- Brazilian Portuguese (`lang.br`)
- English (`lang.en`)
- Arabic (`lang.ar`)
- French (`lang.fr`)
- Polish (`lang.pl`)

**Implementation:**
- Per-player language tracked via `playerLanguage[name].tr`
- Auto-detected from `tfm.get.room.language`

---

### 7. Ball System

**Ball Types:**
- 15 different ball variants defined in `balls.lua`
- Custom ball spawning logic
- Ball physics and collision detection

---

### 8. Map System

**Maps:**
- 53+ custom maps in `maps.lua`
- Team-specific map variants
- Map voting system
- Random map selection

---

## Development Workflow

### Coding Standards

See `development/project_standards/lua_best_practices.md` for complete guidelines.

**Key Rules:**
1. **No `return` statements** - Files are concatenated, not modules
2. **C-style loops only for arrays** - Use `for i = 1, #tbl do` instead of `ipairs`/`pairs`
3. **`pairs()` for dictionaries** - Acceptable for key-value tables like `tfm.get.room.playerList`
4. **Local by default** - Globals only for game state
5. **camelCase naming** - Functions and variables (`processBall`, `playerCanTransform`, `selectMapUI`)
6. **PascalCase for events** - Event handlers (`eventChatCommand`, `eventLoop`, `eventNewGame`)
7. **Minimize function arguments** - Exponential performance cost
8. **String concatenation** - Use `..` for small strings, `table.concat` for large/dynamic

### Build Process

1. Update `development/build_systems/build.txt` if adding/removing files
2. Run `npm run build` to generate `volley.lua`
3. Test in TFM by pasting `/lua volley.lua`
4. (Optional) Run `npm run minify` for production

---

## Performance Considerations

Based on Transformice Lua VM characteristics:

- **Variable access**: Locals are ~20% faster than globals
- **Function arguments**: Exponential cost (1 arg: ~7%, 4 args: ~64%, 8 args: ~110% slower)
- **String operations**: `..` is 2-3x faster than `table.concat` for ≤10 parts
- **Table caching**: Cache table references if accessed multiple times (~30% faster)

---

## Testing

**Current Approach:**
- Manual testing in Transformice
- Dry-run bundle validation (manual)

**Future Improvements:**
- Automated syntax checking post-build
- Unit tests for utility functions
- Integration tests for game logic

---

## Key Patterns

### Event-Driven Architecture
- TFM provides event callbacks (`eventChatCommand`, `eventKeyboard`, etc.)
- All game logic triggered by events

### String-based Event Routing
- UI callbacks parsed via string matching: `string.sub(c, 1, 11) == "joinTeamRed"`

### Global State Management
- Heavy use of global tables for game state
- Works due to concatenation (single scope)

### Large Monolithic Handlers
- `eventChatCommand.lua` handles all commands (1436+ lines)
- Consider splitting if complexity grows

---

## Migration Notes (from legacy style)

**Changes Made:**
- ✅ Added build manifest for explicit file ordering
- ✅ Updated build.js to support manifest-based builds
- ✅ Created coding standards documentation
- ✅ Added file headers to core source files
- ✅ Documented camelCase/PascalCase naming conventions
- ✅ Updated architecture documentation

**Future Work:**
- Replace `ipairs`/`pairs` with C-style loops where appropriate (arrays)
- Add proper file headers to all source files
- Document all public functions with standard format
- Keep files under 500 lines when possible
