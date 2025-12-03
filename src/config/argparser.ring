load "constants.ring"
load "stdlibcore.ring"
load "../utils/colors.ring"

# Get app name based on compiled status
func getAppName()
	if isAppCompiled()
		return "im2ansi"
	else
		return "ring im2ansi.ring"
	ok

# Parse command line arguments and populate config
func parseArgs(config)
	args = sysargv
	nArgsLen = len(args)
	
	for i = 2 to nArgsLen
		arg = lower(args[i])
		switch arg
			on "--path"
				if i+1 <= nArgsLen config.path = args[i+1] i++ ok
			on "-p"
				if i+1 <= nArgsLen config.path = args[i+1] i++ ok
			on "--output"
				if i+1 <= nArgsLen config.output_file = args[i+1] i++ ok
			on "-o"
				if i+1 <= nArgsLen config.output_file = args[i+1] i++ ok
			on "--format"
				if i+1 <= nArgsLen config.format = args[i+1] i++ ok
			on "-f"
				if i+1 <= nArgsLen config.format = args[i+1] i++ ok
			on "--size"
				if i+1 <= nArgsLen config.size = number(args[i+1]) i++ ok
			on "-s"
				if i+1 <= nArgsLen config.size = number(args[i+1]) i++ ok
			on "--width"
				if i+1 <= nArgsLen config.width = number(args[i+1]) i++ ok
			on "-w"
				if i+1 <= nArgsLen config.width = number(args[i+1]) i++ ok
			on "--character_set"
				if i+1 <= nArgsLen config.character_set = args[i+1] i++ ok
			on "-c"
				if i+1 <= nArgsLen config.character_set = args[i+1] i++ ok
			on "--seed"
				if i+1 <= nArgsLen config.seed = number(args[i+1]) i++ ok
			on "--ramp"
				if i+1 <= nArgsLen config.ramp_index = number(args[i+1]) i++ ok
			on "-r"
				if i+1 <= nArgsLen config.ramp_index = number(args[i+1]) i++ ok
			on "--invert"
				config.invert = true
			on "-i"
				config.invert = true
			on "--no-color"
				config.no_color = true
			on "--quiet"
				config.quiet = true
			on "-q"
				config.quiet = true
			on "--html"
				config.html = true
				config.format = "html"
			on "--version"
				config.show_version = true
			on "-v"
				config.show_version = true
			on "--help"
				config.show_help = true
			on "-h"
				config.show_help = true
		off
	next
	return config

# Validate configuration
func validateConfig(config)
	# Check if file exists
	if len(config.path) > 0
		if not fexists(config.path)
			see errorMsg("File not found: " + config.path) + nl
			return false
		ok
	ok
	
	# Validate format
	validFormats = ["ansi", "ascii", "svg", "html"]
	if not find(validFormats, lower(config.format))
		see errorMsg("Invalid format '" + config.format + "'. Valid formats: ansi, ascii, svg, html") + nl
		return false
	ok
	
	# Validate size
	if config.size < 1
		see errorMsg("Size must be at least 1") + nl
		return false
	ok
	
	# Validate ramp index
	if config.ramp_index < 1 or config.ramp_index > len(ASCII_RAMPS)
		see errorMsg("Ramp index must be between 1 and " + len(ASCII_RAMPS)) + nl
		return false
	ok
	
	return true

# Display version
func showVersion()
	cAppName = getAppName()
	see bold(brightCyan(cAppName)) + " version " + bold(APP_VERSION) + nl

# Display help message
func showHelp()
	cOutput = ""
	cAppName = getAppName()
	
	# Title
	cOutput += nl
	cOutput += bold(brightCyan("  ██╗███╗   ███╗██████╗  █████╗ ███╗   ██╗███████╗██╗")) + nl
	cOutput += bold(brightCyan("  ██║████╗ ████║╚════██╗██╔══██╗████╗  ██║██╔════╝██║")) + nl
	cOutput += bold(brightCyan("  ██║██╔████╔██║ █████╔╝███████║██╔██╗ ██║███████╗██║")) + nl
	cOutput += bold(brightCyan("  ██║██║╚██╔╝██║██╔═══╝ ██╔══██║██║╚██╗██║╚════██║██║")) + nl
	cOutput += bold(brightCyan("  ██║██║ ╚═╝ ██║███████╗██║  ██║██║ ╚████║███████║██║")) + nl
	cOutput += bold(brightCyan("  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝")) + nl
	cOutput += nl
	cOutput += "  " + dim("Version " + APP_VERSION + " - Convert images into beautiful ANSI/ASCII art") + nl
	cOutput += nl
	
	# Usage
	cOutput += bold(yellow("USAGE:")) + nl
	cOutput += "  " + cyan(cAppName) + " " + green("-p") + " <image> [options]" + nl
	cOutput += nl
	
	# Options
	cOutput += bold(yellow("OPTIONS:")) + nl
	cOutput += "  " + green("--path, -p") + " <path>          " + dim("Path to the image to convert") + nl
	cOutput += "  " + green("--output, -o") + " <path>        " + dim("Output file path (optional)") + nl
	cOutput += "  " + green("--format, -f") + " <format>      " + dim("Output format: ") + brightYellow("ansi") + dim("|") + brightYellow("svg") + dim("|") + brightYellow("ascii") + dim("|") + brightYellow("html") + dim(" (default: ansi)") + nl
	cOutput += "  " + green("--size, -s") + " <height>        " + dim("Output height in characters (default: 30)") + nl
	cOutput += "  " + green("--width, -w") + " <width>        " + dim("Output width (auto-calculated if not set)") + nl
	cOutput += "  " + green("--character_set, -c") + " <set>  " + dim("Characters for ansi/svg mode (default: '01')") + nl
	nRampsLen = len(ASCII_RAMPS)
	cOutput += "  " + green("--ramp, -r") + " <index>         " + dim("ASCII ramp 1-" + nRampsLen + " for ascii mode (default: 1)") + nl
	cOutput += "  " + green("--seed") + " <seed>              " + dim("Random seed for reproducible output") + nl
	cOutput += "  " + green("--invert, -i") + "               " + dim("Invert brightness") + nl
	cOutput += "  " + green("--no-color") + "                 " + dim("Output without colors (plain ASCII)") + nl
	cOutput += "  " + green("--html") + "                     " + dim("Output as HTML") + nl
	cOutput += "  " + green("--quiet, -q") + "                " + dim("Suppress info messages") + nl
	cOutput += "  " + green("--version, -v") + "              " + dim("Show version information") + nl
	cOutput += "  " + green("--help, -h") + "                 " + dim("Show this help message") + nl
	cOutput += nl
	
	# Formats
	cOutput += bold(yellow("FORMATS:")) + nl
	cOutput += "  " + brightYellow("ansi") + "   " + dim("Colored terminal output with random chars") + nl
	cOutput += "  " + brightYellow("ascii") + "  " + dim("Colored terminal output using grayscale ramp") + nl
	cOutput += "  " + brightYellow("svg") + "    " + dim("Scalable Vector Graphics image") + nl
	cOutput += "  " + brightYellow("html") + "   " + dim("HTML document with inline styles") + nl
	cOutput += nl
	
	# Examples
	cOutput += bold(yellow("EXAMPLES:")) + nl
	cOutput += "  " + dim("# Basic conversion") + nl
	cOutput += "  " + cyan(cAppName) + green(" -p ") + "image.jpg" + nl
	cOutput += nl
	cOutput += "  " + dim("# ASCII art with detailed ramp, custom size") + nl
	cOutput += "  " + cyan(cAppName) + green(" -p ") + "image.jpg" + green(" -f ") + "ascii" + green(" -r ") + "2" + green(" -s ") + "50" + nl
	cOutput += nl
	cOutput += "  " + dim("# Save as HTML with inverted colors") + nl
	cOutput += "  " + cyan(cAppName) + green(" -p ") + "image.jpg" + green(" --html") + green(" -i") + green(" -o ") + "output.html" + nl
	cOutput += nl
	cOutput += "  " + dim("# SVG output without info messages") + nl
	cOutput += "  " + cyan(cAppName) + green(" -p ") + "image.jpg" + green(" -f ") + "svg" + green(" -q") + green(" -o ") + "output.svg" + nl
	cOutput += nl
	
	see cOutput
