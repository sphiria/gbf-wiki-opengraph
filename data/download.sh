#!/usr/bin/env bash
set -Eueo pipefail

SCRIPT_PATH=$(dirname $(realpath -s $0))
TEMP_FILE="$(mktemp)"
DEST_FILE="$SCRIPT_PATH/weapons.json"

# Special:CargoExport pages
WEAPONS_URL='https://gbf.wiki/index.php?title=Special:CargoExport&tables=weapons%2C+_pageData%2C&join+on=weapons._pageName%3D_pageData._pageName&fields=weapons._pageName%2C+_pageData._pageName%2C+_pageData._modificationDate&&order+by=`cargo___pageData`.`_pageName`%2C`cargo___pageData`.`_modificationDate`&limit=5000&format=json';
curl -sL "$WEAPONS_URL" > "$TEMP_FILE"

# Transform into simpler key:val object
JQ_QUERY='map({
  (._pageName | tostring):
  ._modificationDate | strptime("%Y-%m-%d %H:%M:%S") | mktime
}) | add'
jq "$JQ_QUERY" "$TEMP_FILE" > "$SCRIPT_PATH/weapons.json"