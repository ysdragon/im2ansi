# Channel indices
R_COL = 1
G_COL = 2
B_COL = 3

# Pixel list indices
PIXEL_R = 1
PIXEL_G = 2
PIXEL_B = 3
PIXEL_CHAR = 4

# Grayscale coefficients
GRAY_R = 0.299
GRAY_G = 0.587
GRAY_B = 0.114

# Process image data and resize if needed
func processImageSize(cData, img_width, img_height, img_channels, target_size, target_width)
    current_proc_cData = cData
    current_proc_width = img_width
    current_proc_height = img_height

    needsResize = false
    
    if target_width > 0 and target_size > 0
        target_h = target_size
        target_w = target_width
        needsResize = (target_w != img_width or target_h != img_height)
    but target_size > 0 and img_height != target_size and img_height > 0
        target_h = target_size
        target_w = floor(img_width * target_h / img_height)
        if target_w <= 0 target_w = 1 ok
        needsResize = true
    but target_width > 0 and img_width != target_width and img_width > 0
        target_w = target_width
        target_h = floor(img_height * target_w / img_width)
        if target_h <= 0 target_h = 1 ok
        needsResize = true
    else
        target_w = img_width
        target_h = img_height
    ok

    if needsResize
        expected_len = target_w * target_h * img_channels
        temp_resized_cData = resizeImage(cData, img_width, img_height, img_channels, target_w, target_h)

        if temp_resized_cData != NULL and len(temp_resized_cData) = expected_len
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
        :mul, R_COL, GRAY_R,
        :mul, G_COL, GRAY_G,
        :mul, B_COL, GRAY_B,
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
    # Pre-compute format checks
    format_lower = lower(config.format)
    isAscii = (format_lower = "ascii")
    isAnsi = (format_lower = "ansi")
    isSvg = (format_lower = "svg")
    isHtml = (format_lower = "html")
    
    # Cache config values
    doInvert = config.invert
    doNoColor = config.no_color
    
    selected_ascii_ramp = []
    len_ramp = 0
    cGrayData = NULL
    ramp_scale = 0

    if isAscii
        if config.character_set != "01" and len(config.character_set) > 0
            selected_ascii_ramp = utf8ToList(config.character_set)
        else
            ramp_idx = config.ramp_index
            if ramp_idx < 1 or ramp_idx > len(ASCII_RAMPS)
                ramp_idx = 1
                config.ramp_index = 1
            ok
            selected_ascii_ramp = utf8ToList(ASCII_RAMPS[ramp_idx])
        ok
        len_ramp = len(selected_ascii_ramp)
        if len_ramp = 0
            config.ramp_index = 1
            selected_ascii_ramp = utf8ToList(ASCII_RAMPS[1])
            len_ramp = len(selected_ascii_ramp)
        ok
        
        cGrayData = computeGrayscale(cData, channels, width, height)
        ramp_scale = (len_ramp - 1) / 255.0
    ok

    char_set_list = utf8ToList(config.character_set)
    len_char_set = len(char_set_list)
    if (isAnsi or isSvg or isHtml) and len_char_set = 0
        config.character_set = "01"
        char_set_list = ["0", "1"]
        len_char_set = 2
    ok
    len_char_set_minus_1 = len_char_set - 1

    usePrecomputedGray = (cGrayData != NULL and not doInvert)
    has_alpha = (channels = 4)
    row_pixel_count = width * 2
    row_stride = width * channels
    
    # Pre-allocate grid
    pixels_grid = list(height)
    
    if isAscii
        for y = 1 to height
            row_pixels = list(row_pixel_count)
            row_base_offset = (y - 1) * row_stride
            
            for x = 1 to width
                pixel_index = row_base_offset + (x - 1) * channels + 1
                
                r_val = ascii(cData[pixel_index])
                g_val = ascii(cData[pixel_index + 1])
                b_val = ascii(cData[pixel_index + 2])
                
                if has_alpha
                    a_val = ascii(cData[pixel_index + 3])
                else
                    a_val = 255
                ok

                if doInvert
                    r_val = 255 - r_val
                    g_val = 255 - g_val
                    b_val = 255 - b_val
                ok

                if doNoColor
                    gray = floor(GRAY_R * r_val + GRAY_G * g_val + GRAY_B * b_val)
                    r_val = gray
                    g_val = gray
                    b_val = gray
                ok

                if a_val < 100
                    char_to_use = " "
                else
                    if usePrecomputedGray
                        gray = ascii(cGrayData[pixel_index])
                    else
                        gray = floor(GRAY_R * r_val + GRAY_G * g_val + GRAY_B * b_val)
                    ok
                    ramp_idx = floor(gray * ramp_scale) + 1
                    if ramp_idx < 1
                        ramp_idx = 1
                    but ramp_idx > len_ramp
                        ramp_idx = len_ramp
                    ok
                    char_to_use = selected_ascii_ramp[ramp_idx]
                ok
                
                current_pixel = [r_val, g_val, b_val, char_to_use]
                
                out_idx = (x - 1) * 2 + 1
                row_pixels[out_idx] = current_pixel
                row_pixels[out_idx + 1] = current_pixel
            next
            
            pixels_grid[y] = row_pixels
        next
    else
        for y = 1 to height
            row_pixels = list(row_pixel_count)
            row_base_offset = (y - 1) * row_stride
            
            for x = 1 to width
                pixel_index = row_base_offset + (x - 1) * channels + 1
                
                r_val = ascii(cData[pixel_index])
                g_val = ascii(cData[pixel_index + 1])
                b_val = ascii(cData[pixel_index + 2])
                
                if has_alpha
                    a_val = ascii(cData[pixel_index + 3])
                else
                    a_val = 255
                ok

                if doInvert
                    r_val = 255 - r_val
                    g_val = 255 - g_val
                    b_val = 255 - b_val
                ok

                if doNoColor
                    gray = floor(GRAY_R * r_val + GRAY_G * g_val + GRAY_B * b_val)
                    r_val = gray
                    g_val = gray
                    b_val = gray
                ok

                if a_val < 100
                    char_to_use = " "
                else
                    char_idx = random(len_char_set_minus_1) + 1
                    char_to_use = char_set_list[char_idx]
                ok
                
                current_pixel = [r_val, g_val, b_val, char_to_use]
                
                out_idx = (x - 1) * 2 + 1
                row_pixels[out_idx] = current_pixel
                row_pixels[out_idx + 1] = current_pixel
            next
            
            pixels_grid[y] = row_pixels
        next
    ok
    
    return pixels_grid