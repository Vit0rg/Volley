const fs = require("fs")
const combine = require("./combine")
const luamin = require("luamin")

// Build configuration
const BUILD_MANIFEST = "development/build_systems/build.txt"

/**
 * Read build manifest and return file list
 * Falls back to inline configuration if manifest not found
 */
function getBuildFiles() {
	try {
		if (fs.existsSync(BUILD_MANIFEST)) {
			const content = fs.readFileSync(BUILD_MANIFEST, "utf8")
			return content
				.split("\n")
				.map(line => line.trim())
				.filter(line => line && !line.startsWith("#"))
		}
	} catch (err) {
		console.log("\x1b[33m%s\x1b[0m", `Manifest not found, using inline configuration: ${err.message}`)
	}

	// Fallback: inline configuration (legacy support)
	return [
		"src/balls.lua",
		"src/maps.lua",
		"src/printf.lua",
		"src/translate.lua",
		"src/timer.lua",
		"src/main.lua",
		"src/events",
		"src/functions",
		"src/ui",
		"src/init.lua"
	]
}

const buildFiles = getBuildFiles()
console.log("\x1b[36m%s\x1b[0m", `Using ${buildFiles.length} files/directories from ${fs.existsSync(BUILD_MANIFEST) ? 'manifest' : 'inline config'}`)

combine(
	// List of files and directories in order to be concatenated
	buildFiles,

	// Output file
	"volley.lua",

	// Optional parameters to alter behaviour
	{
		delimeterBefore: "--[[ ",
		delimeterAfter: " ]]--"
	}
)

// Optionally minify the final output script using luamin
if (process.argv[2] == "minify") {
	console.log("\x1b[32m%s\x1b[0m", "Minifying script...\n")

	var fileContents = fs.readFileSync(
		"volley.lua",
		"utf8",
		function (err, data) {
			if (err) {
				console.log("\x1b[31m%s\x1b[0m", err)
				process.exit(1)
			}
			var originalFile = fs.createWriteStream("volley.lua", { flags: "w" })
			var minified = luamin.minify(data)
			console.log("\x1b[32m%s\x1b[0m", "[" + minified + "]")
			originalFile.write(minified)
			originalFile.close()
		}
	)

	console.log("\x1b[32m%s\x1b[0m", "Finished minifying!\n")
}
