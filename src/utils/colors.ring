# ANSI color and style utilities for terminal output

# Colors
COLOR_RESET     = char(27) + "[0m"
COLOR_BOLD      = char(27) + "[1m"
COLOR_DIM       = char(27) + "[2m"
COLOR_ITALIC    = char(27) + "[3m"
COLOR_UNDERLINE = char(27) + "[4m"

# Foreground colors
FG_BLACK   = char(27) + "[30m"
FG_RED     = char(27) + "[31m"
FG_GREEN   = char(27) + "[32m"
FG_YELLOW  = char(27) + "[33m"
FG_BLUE    = char(27) + "[34m"
FG_MAGENTA = char(27) + "[35m"
FG_CYAN    = char(27) + "[36m"
FG_WHITE   = char(27) + "[37m"

# Bright foreground colors
FG_BRIGHT_BLACK   = char(27) + "[90m"
FG_BRIGHT_RED     = char(27) + "[91m"
FG_BRIGHT_GREEN   = char(27) + "[92m"
FG_BRIGHT_YELLOW  = char(27) + "[93m"
FG_BRIGHT_BLUE    = char(27) + "[94m"
FG_BRIGHT_MAGENTA = char(27) + "[95m"
FG_BRIGHT_CYAN    = char(27) + "[96m"
FG_BRIGHT_WHITE   = char(27) + "[97m"

# Helper functions
func bold(text)
	return COLOR_BOLD + text + COLOR_RESET

func dim(text)
	return COLOR_DIM + text + COLOR_RESET

func italic(text)
	return COLOR_ITALIC + text + COLOR_RESET

func underline(text)
	return COLOR_UNDERLINE + text + COLOR_RESET

func red(text)
	return FG_RED + text + COLOR_RESET

func green(text)
	return FG_GREEN + text + COLOR_RESET

func yellow(text)
	return FG_YELLOW + text + COLOR_RESET

func blue(text)
	return FG_BLUE + text + COLOR_RESET

func magenta(text)
	return FG_MAGENTA + text + COLOR_RESET

func cyan(text)
	return FG_CYAN + text + COLOR_RESET

func brightCyan(text)
	return FG_BRIGHT_CYAN + text + COLOR_RESET

func brightYellow(text)
	return FG_BRIGHT_YELLOW + text + COLOR_RESET

func brightGreen(text)
	return FG_BRIGHT_GREEN + text + COLOR_RESET

func brightMagenta(text)
	return FG_BRIGHT_MAGENTA + text + COLOR_RESET

func brightRed(text)
	return FG_BRIGHT_RED + text + COLOR_RESET

# Styled messages
func errorMsg(text)
	return bold(red("✗ Error: ")) + text

func warnMsg(text)
	return bold(yellow("⚠ Warning: ")) + text

func infoMsg(text)
	return bold(cyan("ℹ Info: ")) + text

func successMsg(text)
	return bold(green("✓ ")) + text
