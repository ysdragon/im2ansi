# UTF-8 string utilities

# Convert a UTF-8 string to a list of characters (handles multi-byte)
func utf8ToList(str)
	result = []
	i = 1
	strLen = len(str)
	
	while i <= strLen
		byte1 = ascii(str[i])
		
		if byte1 < 128
			# Single byte ASCII (0xxxxxxx)
			result + str[i]
			i++
		but (byte1 & 0xE0) = 0xC0
			# Two byte sequence (110xxxxx)
			if i + 1 <= strLen
				result + substr(str, i, 2)
				i += 2
			else
				i++
			ok
		but (byte1 & 0xF0) = 0xE0
			# Three byte sequence (1110xxxx)
			if i + 2 <= strLen
				result + substr(str, i, 3)
				i += 3
			else
				i++
			ok
		but (byte1 & 0xF8) = 0xF0
			# Four byte sequence (11110xxx)
			if i + 3 <= strLen
				result + substr(str, i, 4)
				i += 4
			else
				i++
			ok
		else
			# Invalid UTF-8, skip byte
			i++
		ok
	end
	
	return result

# Get the number of UTF-8 characters in a string
func utf8Len(str)
	return len(utf8ToList(str))

# Get a UTF-8 character at index
func utf8Char(str, index)
	chars = utf8ToList(str)
	if index >= 1 and index <= len(chars)
		return chars[index]
	ok
	return NULL
