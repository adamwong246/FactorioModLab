#!/bin/bash

# Build a Factorio mod by name.

set -e

echo "luajit-ing..."
while read p; do
  # Run luajit to check the files for easy syntax errors
  find ./mods/$1/$p -name "*.lua"|while read fname; do
    /usr/local/bin/luajit-2.1.0-beta3 -bl $fname > /dev/null && echo "$fname ✅"

  done

done <./mods/$1/.fmodlab

# get the version from info.json
VERSION=$(cat ./mods/$1/info.json | jq -r '.version')

# rm "$1_$VERSION.zip"
cd mods/$1

echo "building..."
rm -rf "$1_$VERSION"
mkdir "$1_$VERSION"

while read p; do
  # Run luajit to check the files for easy syntax errors
  find $p |while read fname; do

    # luajit -bl $fname > /dev/null

    # cp --parents  $fname "$1_$VERSION"
    # ditto $fname "$1_$VERSION"
    rsync -R $fname "$1_$VERSION"

    echo "$fname -> $1_$VERSION..."
  done

done <.fmodlab

zip "$1_$VERSION.zip" -r "$1_$VERSION"
rm -rf "$1_$VERSION"
echo "$1_$VERSION.zip ✅"

#
# mv "$1_$VERSION.zip" ../..
#
