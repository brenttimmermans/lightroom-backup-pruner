#!/bin/zsh
set -euo pipefail
cd "${0:A:h}"

backup_dir=(~/Library/CloudStorage/ProtonDrive-*-folder/lightroom-backups(N/))
keep=3

app_name="Lightroom Backup Pruner"
app="/Applications/$app_name.app"
label="com.brent.lightroom-backup-pruner"
agent="$HOME/Library/LaunchAgents/$label.plist"

if (( ${#backup_dir} != 1 )); then
  echo "Expected exactly one backup folder, found ${#backup_dir}: set backup_dir in build.sh" >&2
  exit 1
fi

rm -rf build
mkdir -p build/AppIcon.iconset
for px in 16 32 128 256 512; do
  sips -z $px $px icon.png --out "build/AppIcon.iconset/icon_${px}x${px}.png" >/dev/null
  sips -z $((px * 2)) $((px * 2)) icon.png --out "build/AppIcon.iconset/icon_${px}x${px}@2x.png" >/dev/null
done
iconutil -c icns build/AppIcon.iconset -o build/AppIcon.icns

rm -rf "$app"
osacompile -o "$app" main.applescript
# osacompile names the executable "applet", which is what macOS shows in Login Items and Privacy & Security.
mv "$app/Contents/MacOS/applet" "$app/Contents/MacOS/$app_name"
plutil -replace CFBundleExecutable -string "$app_name" "$app/Contents/Info.plist"
sed -e "s|__BACKUP_DIR__|$backup_dir|" -e "s|__KEEP__|$keep|" prune-lightroom-backups.sh > "$app/Contents/Resources/prune-lightroom-backups.sh"
chmod +x "$app/Contents/Resources/prune-lightroom-backups.sh"
cp build/AppIcon.icns "$app/Contents/Resources/applet.icns"
rm -f "$app/Contents/Resources/Assets.car"
plutil -remove CFBundleIconName "$app/Contents/Info.plist" 2>/dev/null || true
plutil -replace CFBundleIdentifier -string "$label" "$app/Contents/Info.plist"
plutil -replace LSUIElement -bool true "$app/Contents/Info.plist"
codesign --force --sign - "$app"

launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
sed "s|__BACKUP_DIR__|$backup_dir|" "$label.plist" > "$agent"
launchctl bootstrap "gui/$(id -u)" "$agent"
echo "Installed $app, watching $backup_dir (keeping $keep)"
