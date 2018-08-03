#!/usr/bin/env bash

# Hack to get repos we care about

set -eu

CLONE_URL=git@github.com:mozilla-services/foxsec.git
CLONE_DIR=/tmp/repo-list

METADATA_PATH=services/metadata

if [[ ! -d $CLONE_DIR ]]; then
    git clone --depth 1 $CLONE_URL $CLONE_DIR &>/dev/null
else
    cd $CLONE_DIR
    git fetch --depth 1 &>/dev/null    # fetch latest
    git reset --hard HEAD &>/dev/null  # ensure no mods
    git checkout origin/master &>/dev/null # get latest
fi

for f in $CLONE_DIR/$METADATA_PATH/*json; do
    echo $(basename ${f%.json})
    for r in $(jq -r '.sourceControl[]' $f | sed -e 's,^https://github.com/,,'); do
	r=${r%.git}
	echo $r
    done
done
