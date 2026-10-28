<p align="center"><img src="icon.png" width="128" alt="Lightroom Backup Pruner icon"></p>

# Lightroom Backup Pruner

Keeps only the newest Lightroom Classic catalog backups in a folder, so a synced drive doesn't fill up with old ones.

A LaunchAgent watches the backup folder. When Lightroom adds a backup, a tiny background app deletes the oldest dated backup folders (`2026-10-27 2242`) beyond the newest 3. Anything else in the folder is left alone.

## Install

```sh
./build.sh
```

Builds `/Applications/Lightroom Backup Pruner.app` and loads the LaunchAgent. Run it again after any change.

## Settings

At the top of `build.sh`:

| Setting | Default |
|---|---|
| `backup_dir` | `~/Library/CloudStorage/ProtonDrive-*-folder/lightroom-backups` |
| `keep` | `3` |

## Log

Deletions and errors go to `~/Library/Logs/lightroom-backup-pruner.log`. If it says `cannot read`, give Lightroom Backup Pruner Full Disk Access in System Settings → Privacy & Security.

## Uninstall

```sh
launchctl bootout gui/$(id -u)/com.brent.lightroom-backup-pruner
rm ~/Library/LaunchAgents/com.brent.lightroom-backup-pruner.plist
rm -rf "/Applications/Lightroom Backup Pruner.app"
```
