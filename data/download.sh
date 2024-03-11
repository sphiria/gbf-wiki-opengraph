#!/usr/bin/env bash
set -Eueo pipefail

USER_AGENT="curl github.com/FabulousCupcake/gbf-wiki-opengraph"

SCRIPT_PATH=$(dirname $(realpath -s $0))
TEMP_FILE="$(mktemp)"
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

# Weapons
printf "Weapons... "
WEAPONS_URL='https://gbf.wiki/index.php?title=Special:CargoExport&tables=weapons%2C+_pageData%2C&join+on=weapons._pageName%3D_pageData._pageName&fields=weapons._pageName%2C+_pageData._pageName%2C+_pageData._modificationDate&&order+by=`cargo___pageData`.`_pageName`%2C`cargo___pageData`.`_modificationDate`&limit=5000&format=json';
curl -A "$USER_AGENT" -fsSL "$WEAPONS_URL&$RANDOM" > "$TEMP_FILE"
jq "$JQ_QUERY" "$TEMP_FILE" > "$WEAPONS_FILE"
echo "OK $(cat "$WEAPONS_FILE" | wc -l)"

# Summons
printf "Summons... "
SUMMONS_URL='https://gbf.wiki/index.php?title=Special:CargoExport&tables=summons%2C+_pageData%2C&join+on=summons._pageName%3D_pageData._pageName&fields=summons._pageName%2C+_pageData._pageName%2C+_pageData._modificationDate&&order+by=`cargo___pageData`.`_pageName`%2C`cargo___pageData`.`_modificationDate`&limit=5000&format=json';
curl -A "$USER_AGENT" -fsSL "$SUMMONS_URL&$RANDOM" > "$TEMP_FILE"
jq "$JQ_QUERY" "$TEMP_FILE" > "$SUMMONS_FILE"
echo "OK $(cat "$SUMMONS_FILE" | wc -l)"
