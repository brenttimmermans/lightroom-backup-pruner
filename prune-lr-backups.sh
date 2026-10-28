#!/bin/zsh
backup_dir="__BACKUP_DIR__"
keep=__KEEP__

exec >>"$HOME/Library/Logs/lr-backup-pruner.log" 2>&1

if ! ls "$backup_dir" >/dev/null; then
  echo "$(date '+%F %T') cannot read $backup_dir (grant LR Backup Pruner Full Disk Access?)"
  exit 1
fi

# Lightroom folders look like "2026-10-27 2242": newest first (On = sort by name, descending)
backups=("$backup_dir"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\ *(N/On))

for old in "${backups[@]:$keep}"; do
  echo "$(date '+%F %T') removing $old"
  rm -rf -- "$old"
done
