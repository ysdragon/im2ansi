# Write pixel grid as SVG output
func writeSvg(pixels, output_file)
	x = 10
	y = 10
	font_size = 10
	dy = floor(font_size * 1.2)

	widest_line = 0
	nPixelsLen = len(pixels)
	for row in pixels
		if len(row) > widest_line widest_line = len(row) ok
	next

	required_width = x + widest_line * floor(font_size * 0.7)
	required_height = y + nPixelsLen * dy

	svg_output = []
	add(svg_output, '<svg width="' + required_width + '" height="' + required_height + '" xmlns="http://www.w3.org/2000/svg">')
	add(svg_output, '<text x="' + x + '" y="' + y + '" font-family="monospace" font-size="' + font_size + '">')
	line_num = 0
	for row in pixels
		first_of_row = true
		for pixel_obj in row
			attrs = ""
			if first_of_row and line_num != 0 attrs = 'dy="' + dy + '" x="' + x + '"' ok
			char_to_write = string(pixel_obj.character)
			if char_to_write = " " char_to_write = "&#160;" ok

			hex_color = substr("000000",1,2-len(hex(pixel_obj.color_r))) + hex(pixel_obj.color_r) +
			            substr("000000",1,2-len(hex(pixel_obj.color_g))) + hex(pixel_obj.color_g) +
			            substr("000000",1,2-len(hex(pixel_obj.color_b))) + hex(pixel_obj.color_b)

			add(svg_output, '<tspan fill="#' + hex_color + '" ' + attrs + '>' + char_to_write + '</tspan>')
			first_of_row = false
		next
		line_num += 1
	next
	add(svg_output, '</text>')
	add(svg_output, '</svg>')

	if len(output_file) > 0
		write(output_file, list2str(svg_output))
	else
		for line in svg_output
			? line
		next
	ok
	return 0
