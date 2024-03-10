#!/bin/bash
#######################
# Deployed by Ansible #
#######################

MOBSF_URL=$1 # without end slash
MOBSF_APIKEY=$(curl -s "${MOBSF_URL}/api_docs" | grep 'REST API Key' | grep -o -E '[a-z0-9]{64}')

REPO_PATH=$2 # without end slash
DIRECTORYNAME_TO_SCAN=$3

TMP_PATH=/tmp/
TMP_NAME=${DIRECTORYNAME_TO_SCAN}.$$.zip
REPORT_PATH=$4

# PREPARE SCAN
cd "${REPO_PATH}" || exit
if [ "${DIRECTORYNAME_TO_SCAN}" != app ]; then
    mv "${DIRECTORYNAME_TO_SCAN}" app
fi
zip -r "${TMP_PATH}/${TMP_NAME}" app -x "*debug*" -x '*/.git*' >/dev/null 2>&1
if [ "${DIRECTORYNAME_TO_SCAN}" != app ]; then
    mv app "${DIRECTORYNAME_TO_SCAN}"
fi

# Upload FILE
echo "Upload ${TMP_NAME}"
RESP=$(curl -s -F "file=@${TMP_PATH}/${TMP_NAME}" "${MOBSF_URL}/api/v1/upload" -H "Authorization:${MOBSF_APIKEY}")
echo "${RESP}"
HASH=$(echo "${RESP}" | grep '"hash"' | awk -F '"hash": "' '{print $2}' | awk -F '"' '{print $1}' | tail -1)
# Clean
rm "${TMP_PATH}/${TMP_NAME}"

# Scan
echo "Start scan"
RESP=$(curl -s -X POST --url "${MOBSF_URL}/api/v1/scan" --data "scan_type=zip&file_name=${TMP_NAME}&hash=${HASH}" -H "Authorization:${MOBSF_APIKEY}")
echo "${RESP}" | cut -c1-50

# Report
echo "Download report"
curl -s -X POST --url "${MOBSF_URL}/api/v1/report_json" --data "hash=${HASH}" -H "Authorization:${MOBSF_APIKEY}" -o "${REPORT_PATH}"
# Clean
RESP=$(curl -s -X POST --url "${MOBSF_URL}/api/v1/delete_scan" --data "hash=${HASH}" -H "Authorization:${MOBSF_APIKEY}")
echo "${RESP}"

echo "cat ${REPORT_PATH} | jq .code_analysis"
echo "cat ${REPORT_PATH} | jq .manifest_analysis # Android specific"
echo "cat ${REPORT_PATH} | jq .ats_analysis      # iOS specific
