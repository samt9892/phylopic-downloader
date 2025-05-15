#!/usr/bin/env bash
IFS=$'\n\t' # Strings are only split on newlines or tabs, not spaces.

# ── Setup ─────────────────────────────────────────────────────────────
echo "📡 Fetching PhyloPic metadata..."
METADATA=$(curl -s --location "https://api.phylopic.org/images")

BUILD=$(echo "$METADATA" | jq -r '.build')
ITEMS_PER_PAGE=$(echo "$METADATA" | jq -r '.itemsPerPage')
TOTAL_ITEMS=$(echo "$METADATA" | jq -r '.totalItems')
TOTAL_PAGES=$(echo "$METADATA" | jq -r '._links.lastPage.href' | grep -o 'page=[0-9]*' | cut -d= -f2)

echo "📦 Build:          $BUILD"
echo "📄 Items per page: $ITEMS_PER_PAGE"
echo "🔢 Total items:    $TOTAL_ITEMS"
echo "📑 Total pages:    $((TOTAL_PAGES + 1))"

# Output folder
DOWNLOAD_DIR="$PWD/downloads"
mkdir -p "$DOWNLOAD_DIR"

# ── Loop through pages ────────────────────────────────────────────────
for PAGE in $(seq 0 "$TOTAL_PAGES"); do
  echo "➡️  Page $PAGE of $TOTAL_PAGES..."

  UUIDS=$(curl --location -s "https://api.phylopic.org/images?build=$BUILD&page=$PAGE&pagesize=$ITEMS_PER_PAGE" |
    jq -r '._links.items[].href' | cut -d '/' -f3 | cut -d '?' -f1)

  for UUID in $UUIDS; do
    META_JSON=$(curl --location -s "https://api.phylopic.org/images/$UUID")

    # Extract species name
    SPECIES=$(echo "$META_JSON" | jq -r '._links.specificNode.title // .title // "unknown_species"')
    CLEAN_NAME=$(echo "$SPECIES" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')

    # Save metadata
    JSON_OUT="$DOWNLOAD_DIR/$CLEAN_NAME.json"
    if [[ ! -f "$JSON_OUT" ]]; then
      echo "$META_JSON" > "$JSON_OUT"
      echo "📝 Saved metadata: $CLEAN_NAME.json"
    else
      echo "✅ Metadata already exists: $CLEAN_NAME.json"
    fi

    # Download SVG
    SVG_URL=$(echo "$META_JSON" | jq -r '._links.vectorFile.href // empty')
    if [[ -n "$SVG_URL" ]]; then
      SVG_OUT="$DOWNLOAD_DIR/$CLEAN_NAME.svg"
      if [[ ! -f "$SVG_OUT" ]]; then
        echo "⬇️  Downloading $CLEAN_NAME.svg"
        curl -s --location -o "$SVG_OUT" "$SVG_URL"
      else
        echo "✅ SVG already exists: $CLEAN_NAME.svg"
      fi
    else
      echo "❌ No SVG (vectorFile) for $CLEAN_NAME [$UUID]"
    fi
  done
done

echo "🎉 Complete! All metadata and SVGs saved in: $DOWNLOAD_DIR"