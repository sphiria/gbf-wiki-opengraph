#!/usr/bin/env bash
set -Eueo pipefail

USER_AGENT="curl github.com/FabulousCupcake/gbf-wiki-opengraph"

SCRIPT_PATH=$(dirname $(realpath -s $0))
TEMP_FILE="$(/tmp/data.json)"
WEAPONS_FILE="$SCRIPT_PATH/weapons.json"
SUMMONS_FILE="$SCRIPT_PATH/summons.json"

JQ_QUERY='
map(select(type=="object")) |
map(select(._pageName != null)) |
map({
  (._pageName | tostring):
  ._modificationDate | strptime("%Y-%m-%d %H:%M:%S") | mktime
}) |
add'

_escape() {
  node -p "encodeURI(process.argv[1])" "$1"
}

# Weapons
printf "Weapons... "
WEAPONS_URL="https://gbf.wiki/index.php?title=Special:CargoExport"\
"&tables=weapons, _pageData"\
"&join on=weapons._pageName=_pageData._pageName"\
"&fields=weapons._pageName, _pageData._pageName, _pageData._modificationDate"\
"&order by=_pageData._pageName, _pageData._modificationDate"\
"&limit=5000"\
"&format=json"
WEAPONS_URL="$(_escape "$WEAPONS_URL")"
curl -A "$USER_AGENT" -fsSL "$WEAPONS_URL&$RANDOM" > "$TEMP_FILE"
jq "$JQ_QUERY" "$TEMP_FILE" > "$WEAPONS_FILE"
echo "OK $(cat "$WEAPONS_FILE" | wc -l)"


# Summons
printf "Summons... "
WEAPONS_URL="https://gbf.wiki/index.php?title=Special:CargoExport"\
"&tables=summons, _pageData"\
"&join on=summons._pageName=_pageData._pageName"\
"&fields=summons._pageName, _pageData._pageName, _pageData._modificationDate"\
"&order by=_pageData._pageName, _pageData._modificationDate"\
"&limit=5000"\
"&format=json"
SUMMONS_URL="$(_escape "$WEAPONS_URL")"
curl -A "$USER_AGENT" -fsSL "$SUMMONS_URL&$RANDOM" > "$TEMP_FILE"
jq "$JQ_QUERY" "$TEMP_FILE" > "$SUMMONS_FILE"
echo "OK $(cat "$SUMMONS_FILE" | wc -l)"
