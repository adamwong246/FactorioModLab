VERSION=$(cat $1/info.json | jq -r '.version')
echo "making project: $1 v$VERSION"
zip "$1_$VERSION.zip" $1/*
