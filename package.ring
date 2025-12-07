aPackageInfo = [
	:name = "im2ansi",
	:description = "Image to ANSI/ASCII Art Converter",
	:folder = "im2ansi",
	:developer = "ysdragon",
	:email = "",
	:license = "MIT License",
	:version = "1.0.1",
	:ringversion = "1.24",
	:versions = 	[
		[
			:version = "1.0.1",
			:branch = "master"
		]
	],
	:libs = 	[
		[
			:name = "ringfastpro",
			:version = "1.0.5",
			:providerusername = "ringpackages"
		],
		[
			:name = "ringstbimage",
			:version = "1.0.12",
			:providerusername = "ringpackages"
		],
		[
			:name = "ringzip",
			:version = "1.0.8",
			:providerusername = "ringpackages"
		]
	],
	:files = 	[
		"lib.ring",
		"LICENSE",
		"main.ring",
		"im2ansi.ring",
		"README.md",
		"src/app.ring",
		"src/config/argparser.ring",
		"src/config/config.ring",
		"src/config/constants.ring",
		"src/image/loader.ring",
		"src/image/pixel.ring",
		"src/image/processor.ring",
		"src/image/resizer.ring",
		"src/output/ansi_writer.ring",
		"src/output/html_writer.ring",
		"src/output/svg_writer.ring",
		"src/utils/colors.ring",
		"src/utils/install.ring",
		"src/utils/utf8.ring"
	],
	:ringfolderfiles = 	[

	],
	:windowsfiles = 	[

	],
	:linuxfiles = 	[

	],
	:ubuntufiles = 	[

	],
	:fedorafiles = 	[

	],
	:freebsdfiles = 	[

	],
	:macosfiles = 	[

	],
	:windowsringfolderfiles = 	[

	],
	:linuxringfolderfiles = 	[

	],
	:ubunturingfolderfiles = 	[

	],
	:fedoraringfolderfiles = 	[

	],
	:freebsdringfolderfiles = 	[

	],
	:macosringfolderfiles = 	[

	],
	:run = "ring main.ring",
	:windowsrun = "",
	:linuxrun = "",
	:macosrun = "",
	:ubunturun = "",
	:fedorarun = "",
	:setup = "ring src/utils/install.ring",
	:windowssetup = "",
	:linuxsetup = "",
	:macossetup = "",
	:ubuntusetup = "",
	:fedorasetup = "",
	:remove = "",
	:windowsremove = "",
	:linuxremove = "",
	:macosremove = "",
	:ubunturemove = "",
	:fedoraremove = ""
]