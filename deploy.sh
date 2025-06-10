#!/bin/bash

# This is already covered in by tasks.json, but kept here just in case
quarto render
cd _site || exit 1
git add .
git commit -m "Deploy site $(date)"
git push origin gh-pages
cd ..
