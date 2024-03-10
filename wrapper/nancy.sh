#!/bin/bash

REPO_PATH=$1
REPORT_PATH=$2

OLD_PWD="${PWD}"

for gomod_dir in $(find $REPO_PATH -type f -name 'go.mod' -exec dirname {} \;);
do
    cd "${gomod_dir}"
    go list -e -json -deps ./... 2>/dev/null| /tmp/nancy sleuth -o json > ${REPORT_PATH}
done

cd "${OLD_PWD}"
