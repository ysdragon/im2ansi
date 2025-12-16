# Write pixel grid as HTML output
func writeHtml(pixels, output_file, title)
	html_output = []
	
	add(html_output, '<!DOCTYPE html>')
	add(html_output, '<html lang="en">')
	add(html_output, '<head>')
	add(html_output, '  <meta charset="UTF-8">')
	add(html_output, '  <meta name="viewport" content="width=device-width, initial-scale=1.0">')
	add(html_output, '  <title>' + title + ' - im2ansi</title>')
	add(html_output, '  <style>')
	add(html_output, '    body { background: #1a1a1a; margin: 0; padding: 20px; }')
	add(html_output, '    pre { font-family: "Courier New", monospace; font-size: 10px; line-height: 1.0; letter-spacing: 0; }')
	add(html_output, '    .container { display: inline-block; background: #000; padding: 10px; border-radius: 8px; }')
	add(html_output, '  </style>')
	add(html_output, '</head>')
	add(html_output, '<body>')
	add(html_output, '  <div class="container">')
	add(html_output, '    <pre>')
	
	for row in pixels
		line_str = ""
		for pixel in row
			hex_color = rgbToHex(pixel[PIXEL_R], pixel[PIXEL_G], pixel[PIXEL_B])
			char_to_write = string(pixel[PIXEL_CHAR])
			if char_to_write = " "
				char_to_write = "&nbsp;"
			but char_to_write = "<"
				char_to_write = "&lt;"
			but char_to_write = ">"
				char_to_write = "&gt;"
			but char_to_write = "&"
				char_to_write = "&amp;"
			ok
			line_str += '<span style="color:#' + hex_color + '">' + char_to_write + '</span>'
		next
		add(html_output, line_str)
	next
	
	add(html_output, '    </pre>')
	add(html_output, '  </div>')
	add(html_output, '</body>')
	add(html_output, '</html>')

	if len(output_file) > 0
		write(output_file, list2str(html_output))
	else
		for line in html_output
			? line
		next
	ok
	return 0
