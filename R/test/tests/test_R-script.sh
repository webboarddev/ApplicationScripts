#! /bin/bash

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

export INPUT_R_FILE=${TEST_BASE_DIR}/data/log.r
export INPUT_DATA_FILES="${TEST_BASE_DIR}/data/log-d1.data ${TEST_BASE_DIR}/data/log-d2.data"

log "- [START] test for R-script"

${SCRIPT_LOCATION_DIR}/R-script.sh

log "- [STOP] test for R-script"

testOutputFile=$(stat -f "%z" ${VISHNU_OUTPUT_DIR}/Rplots.pdf)
exampleValueFile=$(stat -f "%z" ${TEST_BASE_DIR}/data/Rplots.pdf)

if [ "$testOutputFile" -eq "$exampleValueFile" ]; then 
echo "R-script [OK]"
else
echo "R-script [NOK]"
fi
