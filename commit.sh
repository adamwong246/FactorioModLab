echo "commiting $1"

cd $1

git add --all
git status

VERSION=$(cat info.json | jq -r '.version')
echo "current version $VERSION"
read -p "Enter next version: " NEXT_VERSION

NEW_INFO=$(jq --arg NEXT_VERSION "$NEXT_VERSION" '.version = $NEXT_VERSION' info.json)
rm info.json
echo "$NEW_INFO" > info.json

echo "info.json version updated"

read -p "Enter the changelog entry (to be used as the title of the git message as well): " GIT_MESSAGE

rm -f /tmp/changelog_entry.tmp
echo "---------------------------------------------------------------------------------------------------" >> /tmp/changelog_entry.tmp
echo "Version: $NEXT_VERSION" >> /tmp/changelog_entry.tmp
echo "Date: $(date +'%m.%d.%Y')" >> /tmp/changelog_entry.tmp
echo "" >> /tmp/changelog_entry.tmp
echo "$GIT_MESSAGE" >> /tmp/changelog_entry.tmp
echo "" >> /tmp/changelog_entry.tmp
echo "---------------------------------------------------------------------------------------------------" >> /tmp/changelog_entry.tmp

cat changelog.txt >> /tmp/changelog_entry.tmp
rm changelog.txt
cp /tmp/changelog_entry.tmp changelog.txt
echo "the changelog.txt has been updated"

echo "v$NEXT_VERSION - $GIT_MESSAGE" > /tmp/commit_template
echo "" >> /tmp/commit_template
echo "# Put code-related information here..." >> /tmp/commit_template

git add --all
git commit --allow-empty-message -t /tmp/commit_template
git push origin master
