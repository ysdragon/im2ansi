# Main application entry point

# Load Libraries
load "fastpro.ring"
load "stbimage.ring"
load "stdlibcore.ring"

# Load scripts
load "config/config.ring"
load "config/constants.ring"
load "config/argparser.ring"

load "image/loader.ring"
load "image/processor.ring"
load "image/resizer.ring"

load "utils/colors.ring"
load "utils/helpers.ring"
load "utils/utf8.ring"

load "output/ansi_writer.ring"
load "output/svg_writer.ring"
load "output/html_writer.ring"

func main()
	config = new Config
	config = parseArgs(config)

	# Show version if requested
	if config.show_version
		showVersion()
		return
	ok

	# Show help if requested or no path provided
	if config.show_help or len(config.path) = 0
		showHelp()
		return
	ok

	# Validate configuration
	if not validateConfig(config)
		return
	ok

	if config.seed = 0 
		config.seed = random(1000000)
	ok
	srandom(config.seed)

	# Load image
	img_result = loadImage(config.path)
	cData = img_result[1]
	img_width = img_result[2]
	img_height = img_result[3]
	img_channels = img_result[4]

	if cData = NULL
		return
	ok

	# Show image info unless quiet mode
	if not config.quiet
		? infoMsg("Loaded image: " + config.path)
		? infoMsg("Dimensions: " + img_width + "x" + img_height + " (" + img_channels + " channels)")
	ok

	# Process and resize image
	proc_result = processImageSize(cData, img_width, img_height, img_channels, config.size, config.width)
	current_proc_cData = proc_result[1]
	current_proc_width = proc_result[2]
	current_proc_height = proc_result[3]

	if not config.quiet
		? infoMsg("Output size: " + current_proc_width*2 + "x" + current_proc_height + " characters")
	ok

	if img_channels != 3 and img_channels != 4
		? errorMsg("Image must be RGB (3 channels) or RGBA (4 channels). Detected: " + img_channels)
		return
	ok

	# Convert to pixel grid
	pixels_grid = convertToPixelGrid(config, current_proc_cData, current_proc_width, current_proc_height, img_channels)
	
	# Output based on format
	switch lower(config.format)
		on "ansi"
			writeAnsi(pixels_grid, config.output_file, config.no_color)
		on "ascii"
			writeAnsi(pixels_grid, config.output_file, config.no_color)
		on "svg"
			writeSvg(pixels_grid, config.output_file)
		on "html"
			writeHtml(pixels_grid, config.output_file, config.path)
		other
			? errorMsg("Invalid format '" + config.format + "'; valid: ansi, ascii, svg, html")
	off

	# Success message
	if not config.quiet and len(config.output_file) > 0
		? successMsg("Output saved to: " + config.output_file)
	ok
