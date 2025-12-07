load "stdlibcore.ring"
load "libcurl.ring"
load "ziplib.ring"
load "simplejson.ring"
load "src/utils/colors.ring"

func main
	cRepoUser = "ysdragon"
	cRepoName = "im2ansi"
	cReleaseApiUrl = "https://api.github.com/repos/" + cRepoUser + "/" + cRepoName + "/releases/latest"

	# Cleanup tracking
	cSavePath = ""
	cTempDir = ""

	? infoMsg("Starting installation for " + cRepoName + "...")

	# Detect OS
	cOS = ""
	cArch = getArch()
	
	switch true
		on isWindows() cOS = "windows"
		on isLinux()   cOS = "linux"
		on isMacOSX()  cOS = "macos"
		other
			failure("Unsupported operating system detected!", cSavePath, cTempDir)
	off
	
	? infoMsg("Detected System: " + cOS + " (" + cArch + ")")

	# Fetch Latest Release Information
	? infoMsg("Fetching latest release info from GitHub...")
	
	curl = curl_easy_init()
	curl_easy_setopt(curl, CURLOPT_URL, cReleaseApiUrl)
	curl_easy_setopt(curl, CURLOPT_USERAGENT, "IM2ANSI Install Script")
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)

	if cOS = "windows"
		curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)
	ok
	
	cJsonResponse = curl_easy_perform_silent(curl)
	curl_easy_cleanup(curl)

	if len(cJsonResponse) < 10
		failure("Failed to retrieve release information.", cSavePath, cTempDir)
	ok

	# Parse JSON
	try
		aResponse = json_decode(cJsonResponse)
	catch
		failure("Failed to parse GitHub response.", cSavePath, cTempDir)
	done

	if not isList(aResponse)
		failure("Invalid JSON response format.", cSavePath, cTempDir)
	ok

	aAssets = aResponse[:assets]
	
	if len(aAssets) = 0
		failure("No assets found in the latest release.", cSavePath, cTempDir)
	ok

	cDownloadUrl = ""
	cFileName = ""
	cTargetSearch = ""

	# Determine target naming
	if cOS = "windows"
		if cArch = "x64" cTargetSearch = "windows-x64"
		but cArch = "x86" cTargetSearch = "windows-x86" ok
	but cOS = "linux"
		if cArch = "x64" cTargetSearch = "linux-amd64"
		but cArch = "arm64" cTargetSearch = "linux-arm64" ok
	but cOS = "macos"
		if cArch = "x64" cTargetSearch = "macos-x86_64"
		but cArch = "arm64" cTargetSearch = "macos-arm64" ok
	else
		failure("Unsupported architecture detected!", cSavePath, cTempDir)
	ok

	for asset in aAssets
		cName = asset[:name]
		cUrl = asset[:browser_download_url]
		if substr(cName, ".zip") > 0 and substr(cName, cTargetSearch) > 0
			cFileName = cName
			cDownloadUrl = cUrl
			exit
		ok
	next

	if isNull(cDownloadUrl)
		failure("No match found for " + cTargetSearch, cSavePath, cTempDir)
	ok

	cSavePath = exefolder() + "../" + cFileName

	? infoMsg("Downloading from: " + cDownloadUrl)
	
	curl = curl_easy_init()
	curl_easy_setopt(curl, CURLOPT_URL, cDownloadUrl)
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
	curl_easy_setopt(curl, CURLOPT_USERAGENT, "IM2ANSI Install Script")
	curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1)

	if cOS = "windows"
		curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)
	ok
	
	cContent = curl_easy_perform_silent(curl)
	curl_easy_cleanup(curl)

	if len(cContent) = 0
		failure("Download failed (empty response).", cSavePath, cTempDir)
	ok

	write(cSavePath, cContent)

	if not fexists(cSavePath)
		failure("Download failed (write error).", cSavePath, cTempDir)
	ok

	? successMsg("Download complete.")

	# Extract Files
	cExtractDir = exefolder()
	if cOS != "windows"
		if right(cExtractDir, 4) = "bin/"
			cExtractDir = left(cExtractDir, len(cExtractDir) - 4)
		else
			cExtractDir += "../"
		ok
	ok
	
	cTempFile = tempName()
	remove(cTempFile)
	cTempDir = cTempFile
	makeDir(cTempDir)

	try
		zip_extract_allfiles(cSavePath, cTempDir)
		? successMsg("Extraction successful!")
		
		# Move files
		cCommand = ""
		if cOS = "windows"
			cCommand = "xcopy /E /Y " + cTempDir + " " + cExtractDir
		but cOS = "linux"
			cCommand = "cp -r --remove-destination " + cTempDir + "/* " + cExtractDir
		but cOS = "macos"
			cCommand = "cp -fR " + cTempDir + "/* " + cExtractDir
		ok
		
		systemSilent(cCommand)
		
		# Clean temp folder immediate
		if cOS = "windows"
			systemSilent("rmdir /s /q " + cTempDir)
		else
			systemSilent("rm -rf " + cTempDir)
		ok
		cTempDir = "" 

	catch
		failure("Failed to extract/install files. Details: " + cCatchError, cSavePath, cTempDir)
	done

	# Create Symlink for Linux/macOS
	if cOS = "linux" or cOS = "macos"
		cExeName = "im2ansi"
		cExePath = exefolder() + cExeName
		
		if cOS = "macos"
			cDestDir = "/usr/local/bin"
		but cOS = "linux"
			cDestDir = "/usr/bin"
		ok

		? infoMsg("Creating symlink for " + cExeName + "...")
		system("chmod +x " + cExePath)
		runPrivileged('ln -sf "' + cExePath + '" "' + cDestDir + '"')
	ok

	# Create Symlinks for Libraries
	if cOS = "linux" or cOS = "macos"
		cLibDir = exefolder() + "../lib/"
		
		if cOS = "macos"
			cDestLibDir = "/usr/local/lib/"
			cExt = ".dylib"
		but cOS = "linux"
			cDestLibDir = "/usr/lib/"
			cExt = ".so"
		ok

		oZip = zip_openfile(cSavePath, "r")
		nFiles = zip_filescount(oZip)

		for i = 1 to nFiles
			cFileInsideZip = zip_getfilenamebyindex(oZip, i)
			if substr(cFileInsideZip, cExt) > 0 and (substr(cFileInsideZip, "lib/") > 0)
				cFileName = JustFileName(cFileInsideZip)
				cDestPath = cDestLibDir + cFileName
				cSourcePath = cLibDir + cFileName
				
				if not fexists(cDestPath)
					? infoMsg("Linking library " + cFileName + "...")
					runPrivileged('ln -sf "' + cSourcePath + '" "' + cDestLibDir + '"')
				ok
			ok
		next
		zip_close(oZip)
	ok

	cleanup(cSavePath, cTempDir)
	? successMsg("Installation finished successfully.")

func failure cMsg, cSavePath, cTempDir
	? errorMsg(cMsg)
	cleanup(cSavePath, cTempDir)
	bye

func cleanup cSavePath, cTempDir
	if cTempDir != "" and fexists(cTempDir)
		if isWindows()
			systemSilent("rmdir /s /q " + cTempDir)
		else
			systemSilent("rm -rf " + cTempDir)
		ok
	ok
	if cSavePath != "" and fexists(cSavePath)
		remove(cSavePath)
	ok

func runPrivileged cCmd
	cFinalCmd = 'which sudo >/dev/null 2>&1 && sudo ' + cCmd + 
			' || (which doas >/dev/null 2>&1 && doas ' + cCmd + 
			' || ' + cCmd + ')'
	system(cFinalCmd)