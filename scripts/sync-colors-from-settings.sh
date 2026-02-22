#!/usr/bin/env bash
set -euo pipefail

SETTINGS_FILE="${1:-.vscode/settings.json}"
THEME_FILE="${2:-themes/Mgldvd-color-theme.json}"
DRY_RUN="${DRY_RUN:-0}"

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Error: settings file not found: $SETTINGS_FILE" >&2
  exit 2
fi

if [[ ! -f "$THEME_FILE" ]]; then
  echo "Error: theme file not found: $THEME_FILE" >&2
  exit 2
fi

python3 - "$SETTINGS_FILE" "$THEME_FILE" "$DRY_RUN" <<'PY'
import re
import sys
from pathlib import Path

settings_path = Path(sys.argv[1])
theme_path = Path(sys.argv[2])
dry_run = sys.argv[3] == "1"

GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
RESET = "\033[0m"

pair_re = re.compile(r'"([^"\n]+)"\s*:\s*"(#[0-9A-Fa-f]{3,8})"')

settings_text = settings_path.read_text(encoding="utf-8")
theme_text = theme_path.read_text(encoding="utf-8")

# Includes commented + uncommented color pairs from settings
settings_pairs = pair_re.findall(settings_text)
source = {}
for key, value in settings_pairs:
    source[key] = value.lower()  # last one wins if duplicated

updated = []
unchanged = []
missing = []
out_text = theme_text

for key, value in sorted(source.items()):
    key_pat = re.escape(key)
    pattern = re.compile(rf'("{key_pat}"\s*:\s*")#[0-9A-Fa-f]{{3,8}}(")')

    if not pattern.search(out_text):
        missing.append((key, value))
        continue

    prev_values = {m.group(0).split(':', 1)[1].strip().strip('"').lower() for m in pattern.finditer(out_text)}

    out_text, count = pattern.subn(rf'\1{value}\2', out_text)

    if count > 0 and prev_values == {value}:
        unchanged.append((key, value))
    else:
        updated.append((key, value, count))

if not dry_run and out_text != theme_text:
    theme_path.write_text(out_text, encoding="utf-8")

print("Color Sync Report: settings -> theme")
print(f"Settings: {settings_path}")
print(f"Theme   : {theme_path}")
print(f"Mode    : {'DRY RUN' if dry_run else 'APPLY'}")
print()
total = len(source)
match = total - len(missing)
no_match = len(missing)

print(f"{GREEN}MATCH{RESET}       : {match}/{total}")
print(f"{RED}NO MATCH{RESET}    : {no_match}/{total}")
print(f"{YELLOW}UPDATED{RESET}     : {len(updated)}")
print(f"{YELLOW}UNCHANGED{RESET}   : {len(unchanged)}")

if updated:
    print("\nUpdated keys:")
    for key, value, count in updated:
        print(f"- {key} -> {value} ({count} occurrence{'s' if count != 1 else ''})")

if missing:
    print("\nMissing in theme:")
    for key, value in missing:
        print(f"- {key} ({value})")

    print("\nKeys with no match:")
    for key in sorted({k for k, _ in missing}):
        print(f"- {key}")

if dry_run:
    print("\n[DRY RUN] No files were modified.")
else:
    print("\n[APPLY] Theme file updated where needed.")
PY
