#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
PAGES_DIR="${1:-$ROOT/../kommandoraden-i-linux-pages-worktree}"
PORT="${PORT:-$((18000 + RANDOM % 1000))}"
RUN_ID="$(date +%s)"
SERVER_LOG="$(mktemp)"
SERVER_PID=""

cleanup() {
	if [[ -n "$SERVER_PID" ]]; then
		kill "$SERVER_PID" >/dev/null 2>&1 || true
		wait "$SERVER_PID" 2>/dev/null || true
	fi
	rm -f "$SERVER_LOG"
}

require_command() {
	command -v "$1" >/dev/null 2>&1 || {
		printf 'missing command: %s\n' "$1" >&2
		exit 1
	}
}

require_file() {
	[[ -f "$1" ]] || {
		printf 'missing file: %s\n' "$1" >&2
		exit 1
	}
}

trap cleanup EXIT

require_command python3
require_command npx
require_file "$ROOT/pa11y.json"
require_file "$PAGES_DIR/index.html"

# Locate a chromium/chrome binary and hand it to puppeteer (pa11y uses it under
# the hood). Keeping executablePath out of pa11y.json lets the same JSON work
# on whatever distro the runner happens to have.
CHROME_BIN="$(command -v chromium 2>/dev/null \
	|| command -v chromium-browser 2>/dev/null \
	|| command -v google-chrome 2>/dev/null \
	|| command -v google-chrome-stable 2>/dev/null \
	|| true)"
if [[ -z "$CHROME_BIN" ]]; then
	printf 'no chromium/chrome binary found in PATH\n' >&2
	exit 1
fi
export PUPPETEER_EXECUTABLE_PATH="$CHROME_BIN"

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$(dirname "$PAGES_DIR")" >"$SERVER_LOG" 2>&1 &
SERVER_PID="$!"
sleep 2

npx --yes pa11y --config "$ROOT/pa11y.json" "http://127.0.0.1:${PORT}/$(basename "$PAGES_DIR")/index.html?run=${RUN_ID}"
