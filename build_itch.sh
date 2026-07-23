#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
GODOT="${GODOT:-/Users/arjun/Desktop/Godot.app/Contents/MacOS/Godot}"
BUILD_DIR="$PROJECT_DIR/build"
TARGET="${1:-web}"

if [[ ! -x "$GODOT" ]]; then
	echo "Godot not found at: $GODOT"
	echo "Set GODOT to your Godot executable and try again."
	exit 1
fi

mkdir -p "$BUILD_DIR"

case "$TARGET" in
	web)
		echo "Exporting Web build..."
		mkdir -p "$BUILD_DIR/web"
		"$GODOT" --headless --path "$PROJECT_DIR" --export-release "Web" "$BUILD_DIR/web/index.html"

		echo "Creating itch.io zip..."
		(
			cd "$BUILD_DIR/web"
			zip -r -X -9 "$BUILD_DIR/gmtk-countdown-web.zip" .
		)

		echo "Done: $BUILD_DIR/gmtk-countdown-web.zip"
		echo "Upload this zip to itch.io and set Kind of project to HTML."
		;;
	macos)
		echo "Exporting macOS build..."
		mkdir -p "$BUILD_DIR/macos"
		"$GODOT" --headless --path "$PROJECT_DIR" --export-release "macOS" "$BUILD_DIR/macos/GMTK Countdown.app"

		echo "Creating itch.io zip..."
		(
			cd "$BUILD_DIR/macos"
			zip -r -X -9 "$BUILD_DIR/gmtk-countdown-macos.zip" "GMTK Countdown.app"
		)

		echo "Done: $BUILD_DIR/gmtk-countdown-macos.zip"
		echo "Upload this zip to itch.io and set Kind of project to macOS."
		;;
	all)
		"$0" web
		"$0" macos
		;;
	*)
		echo "Usage: $0 [web|macos|all]"
		exit 1
		;;
esac
