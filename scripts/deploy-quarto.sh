#!/bin/bash
# Deploy Quarto site to gh-pages using a worktree

set -e

echo "Cleaning up..."
rm -rf _site _deploy_tmp

echo "Pruning stale worktrees..."
git worktree prune

echo "Adding gh-pages worktree to _deploy_tmp..."
git worktree add _deploy_tmp gh-pages

echo "Rendering site with Quarto..."
quarto render  # this writes to default _site/

echo "Copying rendered site to gh-pages worktree..."
rsync -av --delete _site/ _deploy_tmp/

echo "Committing and pushing rendered site to gh-pages..."
cd _deploy_tmp
git add -A
git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nothing to commit"
git push origin gh-pages
cd -

echo "Cleaning up temporary worktree..."
git worktree remove _deploy_tmp
