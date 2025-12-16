# ANSI color formatting
func formatRgbAnsi(r, g, b, char_str)
	return "" + char(27) + "[38;2;" + r + ";" + g + ";" + b + "m" + char_str + char(27) + "[0m"

# Write pixel grid as ANSI output
func writeAnsi(pixels, output_file, no_color)
	ansi_output = ""
	for row in pixels
		line_str = ""
		for pixel in row
			if no_color
				line_str += string(pixel[PIXEL_CHAR])
			else
				line_str += formatRgbAnsi(pixel[PIXEL_R], pixel[PIXEL_G], pixel[PIXEL_B], string(pixel[PIXEL_CHAR]))
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
