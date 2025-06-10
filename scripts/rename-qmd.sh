#!/bin/bash
# Rename .qmd files to replace spaces with dashes
find content -type f -name "*.qmd" | while read -r f; do
  newf=$(echo "$f" | tr ' ' '-')
  if [ "$f" != "$newf" ]; then
    echo "Renaming: $f → $newf"
    mv "$f" "$newf"
  fi
done
