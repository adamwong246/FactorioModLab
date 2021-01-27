#!/bin/bash

# Build a Factorio mod by name.

set -e

# Run luajit to check the files for easy syntax errors
find ./mods/$1 -name "*.lua"|while read fname; do
  luajit -bl $fname > /dev/null
done

# get the version from info.json
VERSION=$(cat ./mods/$1/info.json | jq -r '.version')


# make the zip file
cd mods
zip -r "$1_$VERSION.zip" ./$1/*
mv "$1_$VERSION.zip" ..

echo "$1_$VERSION.zip ✅ "