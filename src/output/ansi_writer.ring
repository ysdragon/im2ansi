# ANSI color formatting
func formatRgbAnsi(r, g, b, char_str)
	return "" + char(27) + "[38;2;" + r + ";" + g + ";" + b + "m" + char_str + char(27) + "[0m"

# Write pixel grid as ANSI output
func writeAnsi(pixels, output_file, no_color)
	ansi_output = ""
	for row in pixels
		line_str = ""
		for pixel_obj in row
			if no_color
				line_str += string(pixel_obj.character)
			else
				line_str += formatRgbAnsi(pixel_obj.color_r, pixel_obj.color_g, pixel_obj.color_b, string(pixel_obj.character))
			ok
		next
		ansi_output += line_str + nl
	next

	if len(output_file) > 0
		write(output_file, ansi_output)
	else
		see ansi_output
	ok
	return 0
