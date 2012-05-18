#! /bin/bash

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

export INPUT_PDF_FILE_1=${TEST_BASE_DIR}/data/toto_01.pdf
export INPUT_PDF_FILE_2=${TEST_BASE_DIR}/data/toto_02.pdf

log "- [START] test for pdftk-cat"

${SCRIPT_LOCATION_DIR}/pdftk-cat.sh

log "- [STOP] test for pdftk-cat"

if [ -f "${VISHNU_OUTPUT_DIR}/output1.pdf" ] ; then
echo "pdftk-cat [OK]"
else
echo "pdftk-cat [NOK]"
fi
