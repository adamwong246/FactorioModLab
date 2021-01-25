VERSION=$(cat ./mods/$1/info.json | jq -r '.version')
echo "making project: $1 v$VERSION"

cd mods
zip "$1_$VERSION.zip" ./$1/*
mv "$1_$VERSION.zip" ..
