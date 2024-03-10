#!/bin/bash

BINARY_PATH=/tmp/gosec

REPO_PATH=$1 # without end slash
REPORT_PATH=$2

EXCLUDE_RULES=G301,G302,G303,G304,G305,G306,G307,G401,G402,G403,G404,G501,G502,G503,G504,G505,G601
SEVERITY=medium
CONFIDENCE=medium
REPORT_FORMAT=json
# TODO: variabilize
EXTRA_ARGS=-exclude-dir ${REPO_PATH}/vendor

# Scan
echo "Start scan"
${BINARY_PATH} -exclude=${EXCLUDE_RULES} -severity ${SEVERITY} -confidence ${CONFIDENCE} ${EXTRA_ARGS} -fmt ${REPORT_FORMAT} -out "${REPORT_PATH}" "${REPO_PATH}/..."

# Report
# Remove path
sed -i "s#${REPO_PATH}/##g" "${REPORT_PATH}"

echo "cat ${REPORT_PATH} | jq .Issues"
