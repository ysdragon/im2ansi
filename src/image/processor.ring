load "fastpro.ring"
load "pixel.ring"
load "resizer.ring"
load "../config/constants.ring"
load "../utils/utf8.ring"

# Channel indices
R_COL = 1
G_COL = 2
B_COL = 3

# Process image data and resize if needed
func processImageSize(cData, img_width, img_height, img_channels, target_size, target_width)
	current_proc_cData = cData
	current_proc_width = img_width
	current_proc_height = img_height

	# Calculate target dimensions
	if target_width > 0 and target_size > 0
		target_h = target_size
		target_w = target_width
	elseif target_size > 0 and img_height != target_size and img_height > 0
		target_h = target_size
		target_w = floor(img_width * (target_h / img_height))
		if target_w <= 0 target_w = 1 ok
	elseif target_width > 0 and img_width != target_width and img_width > 0
		target_w = target_width
		target_h = floor(img_height * (target_w / img_width))
		if target_h <= 0 target_h = 1 ok
	else
		target_w = img_width
		target_h = img_height
	ok

	if target_w != img_width or target_h != img_height
		temp_resized_cData = resizeImage(cData, img_width, img_height, img_channels, target_w, target_h)

		if temp_resized_cData != NULL and len(temp_resized_cData) = (target_w * target_h * img_channels)
			current_proc_cData = temp_resized_cData
			current_proc_width = target_w
			current_proc_height = target_h
		ok
	ok
	
	if current_proc_height <= 0 current_proc_height = 1 ok
	if current_proc_width <= 0 current_proc_width = 1 ok

	return [current_proc_cData, current_proc_width, current_proc_height]

# Pre-compute grayscale
func computeGrayscale(cData, channels, width, height)
	if channels != 3 and channels != 4
		return NULL
	ok
	
	cGrayData = updateBytesColumn(cData, channels, width * height, 255,
		:mul, R_COL, 0.299,
		:mul, G_COL, 0.587,
		:mul, B_COL, 0.114,
		:merge, R_COL, G_COL,
		:merge, R_COL, B_COL,
		:copy, R_COL, G_COL,
		:copy, R_COL, B_COL
	)
	
	if cGrayData != NULL and len(cGrayData) = len(cData)
		return cGrayData
	ok
	return NULL

# Convert image data to pixel grid
func convertToPixelGrid(config, cData, width, height, channels)
	pixels_grid = []
	selected_ascii_ramp = []
	len_ramp = 0
	cGrayData = NULL
	char_set_list = []

	if lower(config.format) = "ascii"
		if config.character_set != "01" and len(config.character_set) > 0
			selected_ascii_ramp = utf8ToList(config.character_set)
		else
			if config.ramp_index < 1 or config.ramp_index > len(ASCII_RAMPS)
				config.ramp_index = 1
			ok
			selected_ascii_ramp = utf8ToList(ASCII_RAMPS[config.ramp_index])
		ok
		len_ramp = len(selected_ascii_ramp)
		if len_ramp = 0
			config.ramp_index = 1
			selected_ascii_ramp = utf8ToList(ASCII_RAMPS[config.ramp_index])
			len_ramp = len(selected_ascii_ramp)
		ok
		# Pre-compute grayscale for all pixels at once
		cGrayData = computeGrayscale(cData, channels, width, height)
	ok

	# Convert character set to list for proper UTF-8 handling
	char_set_list = utf8ToList(config.character_set)
	len_char_set = len(char_set_list)
	if (lower(config.format) = "ansi" or lower(config.format) = "svg" or lower(config.format) = "html") and len_char_set = 0
		config.character_set = "01"
		char_set_list = utf8ToList(config.character_set)
		len_char_set = len(char_set_list)
	ok

	for y = 1 to height
		row_pixels = []
		for x = 1 to width
			pixel_index = ((y-1) * width + (x-1)) * channels + 1
			
			r_val = ascii(cData[pixel_index])
			g_val = ascii(cData[pixel_index+1])
			b_val = ascii(cData[pixel_index+2])
			a_val = 255
			if channels = 4
				a_val = ascii(cData[pixel_index+3])
			ok

			# Apply invert if enabled
			if config.invert
				r_val = 255 - r_val
				g_val = 255 - g_val
				b_val = 255 - b_val
			ok

			# Apply no-color if enabled (convert to grayscale)
			if config.no_color
				gray = floor(0.299 * r_val + 0.587 * g_val + 0.114 * b_val)
				r_val = gray
				g_val = gray
				b_val = gray
			ok

			for i_char = 1 to 2
				char_to_use = " "
				if a_val < 100
					char_to_use = " "
				else
					if lower(config.format) = "ascii"
						if cGrayData != NULL and not config.invert
							gray = ascii(cGrayData[pixel_index])
						else
							gray = floor(0.299 * r_val + 0.587 * g_val + 0.114 * b_val)
						ok
						ramp_idx = floor(gray / 255.0 * (len_ramp - 1)) + 1
						if ramp_idx < 1 ramp_idx = 1 ok
						if ramp_idx > len_ramp ramp_idx = len_ramp ok
						char_to_use = selected_ascii_ramp[ramp_idx]
					else
						char_idx = (random(len_char_set-1)) + 1
						char_to_use = char_set_list[char_idx]
					ok
				ok
				
				current_pixel = new Pixel {
					color_r = r_val
					color_g = g_val
					color_b = b_val
					character = char_to_use
				}
				row_pixels + current_pixel
			next
		next
		pixels_grid + row_pixels
	next
	
	return pixels_grid
