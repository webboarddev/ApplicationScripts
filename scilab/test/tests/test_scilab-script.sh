#! /bin/bash

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

export INPUT_SCILAB_FILE=${TEST_BASE_DIR}/data/test.sce

log "- [START] test for scilab-script"

${SCRIPT_LOCATION_DIR}/scilab-script.sh

log "- [STOP] test for scilab-script"

if $(diff ${TEST_BASE_DIR}/data/output.txt ${VISHNU_OUTPUT_DIR}/output.txt >/dev/null) ; then
  echo "scilab-script [OK]"
else
  echo "scilab-script [NOK]"
fi
