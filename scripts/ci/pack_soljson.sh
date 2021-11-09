#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SOLJSON_JS="$1"
SOLJSON_WASM="$2"
SOLJSON_WASM_SIZE=$(wc -c "${SOLJSON_WASM}" | cut -d ' ' -f 1)

(( $# <= 2 )) || { >&2 echo "Usage: $0 soljson.js soljson.wasm"; exit 1; }

# If this changes in an emscripten update, it's probably nothing to worry about,
# but we should double-check when it happens.
[ "$(head -c 5 "${SOLJSON_JS}")" == "null;" ] || { >&2 echo 'Expected soljson.js to start with "null;"'; exit 1; }

echo -n 'var Module = Module || {}; Module["wasmBinary"] = '
cat "${SCRIPT_DIR}/wasm_unpack.js"
echo -n '("'
lz4c --no-frame-crc --best --favor-decSpeed "${SOLJSON_WASM}" - | base64 -w 0 | sed 's/[^A-Za-z0-9\+\/=]//g'
echo -n "\",${SOLJSON_WASM_SIZE});"
tail -c +6 "${SOLJSON_JS}"
