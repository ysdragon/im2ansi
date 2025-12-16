# Resize image using direct byte manipulation
func resizeImage(src_cData, src_w, src_h, src_ch, target_w, target_h)
	len_src_cData = len(src_cData)
	if src_w <= 0 or src_h <= 0 or target_w <= 0 or target_h <= 0 or len_src_cData = 0 or src_ch <= 0
		? "Error: Invalid dimensions, channels, or data in resize."
		return NULL
	ok
	
	expected_src_len = src_w * src_h * src_ch
	if len_src_cData != expected_src_len
		? "Error: Source data length (" + len_src_cData + ") does not match dimensions (" + src_w + "x" + src_h + "x" + src_ch + " = " + expected_src_len + ")."
		return NULL
	ok

	expected_target_len = target_w * target_h * src_ch
	target_cData = space(expected_target_len)
	len_target_cData = len(target_cData)

	if len_target_cData = 0 and expected_target_len > 0
		? "Error: Failed to allocate space for target image."
		return NULL
	ok

	if len_target_cData != expected_target_len and expected_target_len > 0
		? "Warning: Allocated space for target image (" + len_target_cData + ") is different from expected (" + expected_target_len + ")."
	ok

	for y_t = 1 to target_h
		for x_t = 1 to target_w
			src_x_float = (x_t - 0.5) * (src_w / target_w)
			src_y_float = (y_t - 0.5) * (src_h / target_h)
			
			src_x_map_zero_based = floor(src_x_float)
			src_y_map_zero_based = floor(src_y_float)

			src_x_map_zero_based = max(0, min(src_w - 1, src_x_map_zero_based))
			src_y_map_zero_based = max(0, min(src_h - 1, src_y_map_zero_based))

			src_pixel_start_idx  = (src_y_map_zero_based * src_w + src_x_map_zero_based) * src_ch + 1
			target_pixel_start_idx = ((y_t-1) * target_w + (x_t-1)) * src_ch + 1

			for ch_offset = 0 to src_ch - 1
				if (src_pixel_start_idx + ch_offset) <= len_src_cData and (target_pixel_start_idx + ch_offset) <= len_target_cData
					target_cData[target_pixel_start_idx + ch_offset] = src_cData[src_pixel_start_idx + ch_offset]
				else
					? "Error: Index out of bounds during pixel copy in resize."
					if (target_pixel_start_idx + ch_offset) <= len_target_cData
						target_cData[target_pixel_start_idx + ch_offset] = char(0)
					ok
				ok
			next
		next
	next
	return target_cData
