{ lib, appimageTools, fetchurl }:

let
	pname = "cursor";
	# Pin to a known working stable build for reliability; bump when needed
	version = "1.4.5";

	src = fetchurl {
		# Direct production URL; update when Cursor releases a new version
		url = "https://downloads.cursor.com/production/af58d92614edb1f72bdd756615d131bf8dfa5299/linux/x64/Cursor-1.4.5-x86_64.AppImage";
		sha256 = "sha256-2Hz1tXC+YkIIHWG1nO3/84oygH+wvaUtTXqvv19ZAz4=";
	};

	contents = appimageTools.extractType2 {
		inherit pname version src;
	};

in appimageTools.wrapType2 {
	inherit pname version src;

	extraInstallCommands = ''
		# Try to install desktop file
		if desktop_file=$(ls -1 ${contents}/*.desktop 2>/dev/null | head -n1); then
			install -Dm444 "$desktop_file" "$out/share/applications/${pname}.desktop"
			substituteInPlace "$out/share/applications/${pname}.desktop" \
				--replace "Exec=AppRun" "Exec=${pname}"
		fi

		# Try to install an icon
		if icon_file=$(ls -1 ${contents}/*.{png,svg,ico} 2>/dev/null | head -n1); then
			# Best-effort size path; DEs will scale as needed
			install -Dm444 "$icon_file" "$out/share/icons/hicolor/256x256/apps/${pname}.png"
		fi
	'';

	meta = with lib; {
		description = "Cursor – AI-first coding environment (AppImage wrapped)";
		homepage = "https://www.cursor.com";
		license = licenses.unfree;
		platforms = [ "x86_64-linux" ];
		mainProgram = pname;
	};
} 