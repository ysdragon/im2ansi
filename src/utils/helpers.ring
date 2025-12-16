# Escape special characters for SVG
func escapeSvgChar(char_val)
	char_str = string(char_val)
	
	switch char_str
		on " "
			return "&#160;"
		on "<"
			return "&lt;"
		on ">"
			return "&gt;"
		on "&"
			return "&amp;"
		on '"'
			return "&quot;"
		on "'"
			return "&apos;"
		other
			return char_str
	off

# Convert RGB to hex color (shared with HTML writer)
func rgbToHex(r, g, b)
	return padHex(r) + padHex(g) + padHex(b)

func padHex(n)
	h = hex(n)
	if len(h) = 1
		return "0" + h
	ok
	return h