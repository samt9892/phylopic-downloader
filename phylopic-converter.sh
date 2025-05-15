#!/usr/bin/env bash
IFS=$'\n\t' # Strings are only split on newlines or tabs, not spaces.

# ── Setup ─────────────────────────────────────────────────────────────
DOWNLOAD_DIR="$PWD/downloads"
mkdir -p "$DOWNLOAD_DIR"
echo "🖼️ Converting all SVGs in: $DOWNLOAD_DIR"

# ── Check tool availability ───────────────────────────────────────────
if ! command -v rsvg-convert &>/dev/null; then
  echo "❌ rsvg-convert not found. Please install librsvg2-bin."
  exit 1
fi

# ── Find and convert SVGs ─────────────────────────────────────────────
SVG_FILES=$(find "$DOWNLOAD_DIR" -type f -name "*.svg")

if [[ -z "$SVG_FILES" ]]; then
  echo "⚠️  No SVG files found in $DOWNLOAD_DIR"
  exit 0
fi

for SVG_PATH in $SVG_FILES; do
  FILENAME=$(basename "$SVG_PATH")
  BASENAME="${FILENAME%.svg}"
  PNG_PATH="$DOWNLOAD_DIR/$BASENAME.png"

  if [[ -f "$PNG_PATH" ]]; then
    echo "✅ PNG already exists: $BASENAME.png"
  else
    echo "🔄 Converting $FILENAME to $BASENAME.png..."

    # Use rsvg-convert to convert SVG to PNG.
    # Default DPI is 90 — uncomment below to use 300 DPI instead:
    # rsvg-convert "$SVG_PATH" --dpi-x=300 --dpi-y=300 -o "$PNG_PATH"

    rsvg-convert "$SVG_PATH" -o "$PNG_PATH"

    if [[ $? -eq 0 ]]; then
      echo "🖼️  Saved PNG: $BASENAME.png"
    else
      echo "❌ Failed to convert: $FILENAME"
    fi
  fi
done

echo "✅ Conversion complete. All PNGs saved in: $DOWNLOAD_DIR"