#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
PAGES_DIR="${1:-$ROOT/../kommandoraden-i-linux-pages-worktree}"
BACKUP_DIR=""

copy_dir_contents() {
	local src="$1"
	local dst="$2"
	cp -R "$src/." "$dst/"
}

if ! git -C "$ROOT" rev-parse --verify HEAD >/dev/null 2>&1; then
	printf 'Create a first local commit on main before initializing the pages worktree.\n' >&2
	exit 1
fi

if git -C "$ROOT" rev-parse --verify pages >/dev/null 2>&1; then
	printf 'The pages branch already exists.\n' >&2
	exit 1
fi

if [[ -e "$PAGES_DIR/.git" ]]; then
	printf 'The target directory already looks like a git worktree: %s\n' "$PAGES_DIR" >&2
	exit 1
fi

if [[ -d "$PAGES_DIR" ]] && [[ -n "$(ls -A "$PAGES_DIR")" ]]; then
	BACKUP_DIR="$(mktemp -d)"
	copy_dir_contents "$PAGES_DIR" "$BACKUP_DIR"
	rm -rf "$PAGES_DIR"
fi

git -C "$ROOT" worktree add -b pages "$PAGES_DIR" HEAD
git -C "$PAGES_DIR" rm -rf . >/dev/null 2>&1 || true

find "$PAGES_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

if [[ -n "$BACKUP_DIR" ]]; then
	copy_dir_contents "$BACKUP_DIR" "$PAGES_DIR"
	rm -rf "$BACKUP_DIR"
fi

printf 'Pages worktree created at: %s\n' "$PAGES_DIR"
printf 'Review files there, then commit them on the pages branch when ready.\n'
