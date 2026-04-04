## 🧪 Technologies

This project was developed with the following technologies:

- [Lua]
- [Javascript]
- [NodeJS]

## 📋 Development Style

This project follows the **echeckers development style** (from [vit0rg/echeckers](https://github.com/vit0rg/echeckers)), which emphasizes:

- **Concatenation-based build**: Files are concatenated into a single bundle (no `return` statements)
- **Explicit build manifests**: File order defined in `development/build_systems/build.txt`
- **Build scripts**: Located in `development/build_systems/` (following echeckers convention)
- **C-style loops**: Use `for i = 1, #tbl do` instead of `ipairs`/`pairs` for arrays
- **Local by default**: Variables are local unless explicitly needed as globals
- **camelCase naming**: Functions and variables use camelCase (e.g., `processBall`, `playerCanTransform`)
- **PascalCase for events**: Event handlers use PascalCase (e.g., `eventChatCommand`, `eventLoop`)
- **Documentation standards**: All public functions documented with `@param` and `@return`
- **Performance focus**: Minimize function arguments, cache table references

See `development/project_standards/lua_best_practices.md` for complete guidelines.

## 🚀 How to install and run the project

You must have Node JS installed on your machine. Visit the page to download [Node JS Website](https://nodejs.org/en/download/).

Clone the project

```bash
$ git clone https://github.com/Soristl/Volley.git

$ npm i              # Install dependencies
$ npm run build      # Build volley.lua from source files
$ npm run minify     # Build + minify for production
$ npm run watch      # Watch for changes and auto-rebuild
```

With the volley.lua file generated, open Transformice, go to your tribe's house, type the command /lua and paste it into the game's code interface

## 💻 Project

Volley is currently a semi-official Transformice module created to bring fun to people.

## 📝 License

This project is licensed under the MIT License. See the file [LICENSE](https://github.com/Soristl/Volley/blob/main/LICENSE) for more details.
