# Load an image from file and return image data with dimensions
func loadImage(path)
	img_width = 0
	img_height = 0
	img_channels = 0
	cData = stbi_load(path, :img_width, :img_height, :img_channels, 0)

	if cData = NULL
		see "Error loading image: " + stbi_failure_reason() + nl
		return [NULL, 0, 0, 0]
	ok

	return [cData, img_width, img_height, img_channels]
