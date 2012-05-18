#! /bin/bash

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

export INPUT_PDF_FILE=${TEST_BASE_DIR}/data/output_test.pdf

export OUTPUT_FILENAME_TEMPLATE=toto_%02d.pdf

log "- [START] test for pdftk-split"

${SCRIPT_LOCATION_DIR}/pdftk-split.sh

log "- [STOP] test for pdftk-split"

if [ -f "${VISHNU_OUTPUT_DIR}/toto_01.pdf" ] && [ -f "${VISHNU_OUTPUT_DIR}/toto_02.pdf" ] ; then
echo "pdftk-split [OK]"
else
echo "pdftk-split [NOK]"
fi