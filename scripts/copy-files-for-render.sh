#!/bin/zsh

SRC_DIR="content"
DEST_DIR="pages"

# Recreate destination directory from scratch
rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"

# Find all .qmd files under SRC_DIR
find "$SRC_DIR" -name '*.qmd' | while read -r file; do
  # Extract YAML front matter if it exists
  yaml=$(sed -n '/^---$/,/^---$/p' "$file")

  # Check if YAML exists and includes 'partial: true'
  if [[ -n "$yaml" ]] && echo "$yaml" | yq e '.partial // false' - | grep -q 'true'; then
    echo "Skipping partial: $file"
  else
    filename=$(basename "$file")
    cp "$file" "$DEST_DIR/$filename"
    echo "Copied: $file -> $DEST_DIR/$filename"
  fi
done

echo "Copying other files to $DEST_DIR"
cp index.qmd "$DEST_DIR/"
cp _quarto.yml "$DEST_DIR/"