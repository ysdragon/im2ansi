# Resize image using byte manipulation
func resizeImage(src_cData, src_w, src_h, src_ch, target_w, target_h)
    len_src_cData = len(src_cData)
    
    # Early validation with combined checks
    if src_w <= 0 or src_h <= 0 or target_w <= 0 or target_h <= 0 or len_src_cData = 0 or src_ch <= 0
        ? "Error: Invalid dimensions, channels, or data in resize."
        return NULL
    ok
    
    expected_src_len = src_w * src_h * src_ch
    if len_src_cData != expected_src_len
        ? "Error: Source data length mismatch."
        return NULL
    ok

    expected_target_len = target_w * target_h * src_ch
    target_cData = space(expected_target_len)
    len_target_cData = len(target_cData)

    if len_target_cData != expected_target_len and expected_target_len > 0
        ? "Error: Failed to allocate space for target image."
        return NULL
    ok

    # Pre-compute ratios
    x_ratio = src_w / target_w
    y_ratio = src_h / target_h
    src_w_minus_1 = src_w - 1
    src_h_minus_1 = src_h - 1
    
    # Pre-compute ALL x source indices
    x_src_map = list(target_w)
    for x_t = 1 to target_w
        src_x = floor((x_t - 0.5) * x_ratio)
        if src_x < 0
            src_x = 0
        but src_x > src_w_minus_1
            src_x = src_w_minus_1
        ok
        x_src_map[x_t] = src_x * src_ch
    next

    # Pre-compute y source row offsets
    y_src_map = list(target_h)
    for y_t = 1 to target_h
        src_y = floor((y_t - 0.5) * y_ratio)
        if src_y < 0
            src_y = 0
        but src_y > src_h_minus_1
            src_y = src_h_minus_1
        ok
        y_src_map[y_t] = src_y * src_w * src_ch
    next

    # Pre-compute target row stride
    target_row_stride = target_w * src_ch
    
    # Main resize loop - unrolled for common channel counts
    switch src_ch
        on 3
            for y_t = 1 to target_h
                src_row_offset = y_src_map[y_t]
                target_row_offset = (y_t - 1) * target_row_stride
                
                for x_t = 1 to target_w
                    src_idx = src_row_offset + x_src_map[x_t] + 1
                    target_idx = target_row_offset + (x_t - 1) * 3 + 1
                    
                    target_cData[target_idx] = src_cData[src_idx]
                    target_cData[target_idx + 1] = src_cData[src_idx + 1]
                    target_cData[target_idx + 2] = src_cData[src_idx + 2]
                next
            next
        on 4
            for y_t = 1 to target_h
                src_row_offset = y_src_map[y_t]
                target_row_offset = (y_t - 1) * target_row_stride
                
                for x_t = 1 to target_w
                    src_idx = src_row_offset + x_src_map[x_t] + 1
                    target_idx = target_row_offset + (x_t - 1) * 4 + 1
                    
                    target_cData[target_idx] = src_cData[src_idx]
                    target_cData[target_idx + 1] = src_cData[src_idx + 1]
                    target_cData[target_idx + 2] = src_cData[src_idx + 2]
                    target_cData[target_idx + 3] = src_cData[src_idx + 3]
                next
            next
        on 1
            for y_t = 1 to target_h
                src_row_offset = y_src_map[y_t]
                target_row_offset = (y_t - 1) * target_row_stride
                
                for x_t = 1 to target_w
                    src_idx = src_row_offset + x_src_map[x_t] + 1
                    target_idx = target_row_offset + (x_t - 1) + 1
                    
                    target_cData[target_idx] = src_cData[src_idx]
                next
            next
        other
            for y_t = 1 to target_h
                src_row_offset = y_src_map[y_t]
                target_row_offset = (y_t - 1) * target_row_stride
                
                for x_t = 1 to target_w
                    src_idx = src_row_offset + x_src_map[x_t] + 1
                    target_idx = target_row_offset + (x_t - 1) * src_ch + 1
                    
                    for ch_offset = 0 to src_ch - 1
                        target_cData[target_idx + ch_offset] = src_cData[src_idx + ch_offset]
                    next
                next
            next
    off
    
    return target_cData