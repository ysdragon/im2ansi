# Write pixel grid as SVG output
func writeSvg(pixels, output_file)
	x = 10
	y = 10
	font_size = 10
	char_width = floor(font_size * 0.6)
	line_height = floor(font_size * 1.2)

	widest_line = 0
	nPixelsLen = len(pixels)
	for row in pixels
		row_len = len(row)
		if row_len > widest_line widest_line = row_len ok
	next

	required_width = x + widest_line * char_width + x
	required_height = y + nPixelsLen * line_height + y

	svg_output = []
	
	add(svg_output, '<?xml version="1.0" encoding="UTF-8"?>')
	add(svg_output, '<svg width="' + required_width + '" height="' + required_height + '" xmlns="http://www.w3.org/2000/svg">')
	
	add(svg_output, '<rect width="100%" height="100%" fill="#000000"/>')
	
	add(svg_output, '<style>')
	add(svg_output, '  text { font-family: "Courier New", monospace; font-size: ' + font_size + 'px; }')
	add(svg_output, '</style>')
	
	current_y = y + font_size
	
	for row in pixels
		line_str = '<text x="' + x + '" y="' + current_y + '">'
		
		for pixel in row
			hex_color = rgbToHex(pixel[PIXEL_R], pixel[PIXEL_G], pixel[PIXEL_B])
			char_to_write = escapeSvgChar(pixel[PIXEL_CHAR])
			line_str += '<tspan fill="#' + hex_color + '">' + char_to_write + '</tspan>'
		next
		
		line_str += '</text>'
		add(svg_output, line_str)
		current_y += line_height
	next
	
	add(svg_output, '</svg>')

	if len(output_file) > 0
		write(output_file, list2str(svg_output))
	else
		for line in svg_output
			? line
		next
	ok
	return 0