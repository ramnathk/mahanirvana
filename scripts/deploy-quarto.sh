#!/bin/bash
# Deploy Quarto site to gh-pages using a worktree

set -e

echo "Cleaning up..."
rm -rf  _deploy_tmp 

echo "Pruning stale worktrees..."
git worktree prune

echo "Fetching latest gh-pages branch..."
git fetch origin gh-pages

echo "Resetting local gh-pages to match remote..."
git branch -f gh-pages origin/gh-pages

echo "Adding gh-pages worktree to _deploy_tmp..."
git worktree add _deploy_tmp gh-pages

echo "Rendering site with Quarto..."
quarto render pages/ 

echo "Copying rendered site to gh-pages worktree..."
rsync -av --delete --exclude='.git' pages/_site/ _deploy_tmp/

echo "Committing and pushing rendered site to gh-pages..."
cd _deploy_tmp
git add -A
git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M:%S') ($(git rev-parse --short HEAD))" || echo "Nothing to commit"
git push origin gh-pages
cd -

echo "Cleaning up temporary worktree..."
git worktree remove _deploy_tmp --force
