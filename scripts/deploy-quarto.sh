#!/bin/bash
# Deploy Quarto site to gh-pages using a worktree

set -e


# Clean up stale worktree if exists
if [ -d "_site" ]; then
  echo "Removing existing _site folder..."
  rm -rf _site
fi

if git worktree list | grep -q "_site"; then
  echo "Pruning stale worktree for _site..."
  git worktree prune
fi


echo "Adding gh-pages worktree..."
git worktree add _site gh-pages

echo "Rendering site with Quarto..."
quarto render

echo "Committing rendered site..."
cd _site
git add -f .
git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nothing to commit"
git push origin gh-pages

cd