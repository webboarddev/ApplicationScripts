#! /bin/bash

function abspath { 
case "$1" in 
/*)printf "%s\n" "$1";; 
*)printf "%s\n" "$PWD/$1";; 
esac; 
}

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

# basic environment variables

# uncomment this variable declaration to get more information
#export VERBOSE=1

export TEST_BASE_DIR=$(dirname $(abspath $0))
log "- $0"
log "- TEST_BASE_DIR=${TEST_BASE_DIR}"

export TMP_DIR_TEMPLATE=${TEST_BASE_DIR}/vishnu-XXXXX
export VISHNU_OUTPUT_DIR=${TEST_BASE_DIR}/output

mkdir -p ${VISHNU_OUTPUT_DIR}

export SCRIPT_LOCATION_DIR=${TEST_BASE_DIR}/..


echo "Executing test suite for pdftk"

tests=$(ls ${TEST_BASE_DIR}/tests)

testsCount=0
for script in $tests; do
testsCount=$(expr $testsCount + 1)
done


echo "${testsCount} tests to perform"

for script in $tests; do
${TEST_BASE_DIR}/tests/${script}
done

if [ "x${VISHNU_OUTPUT_DIR}" != "x" ] && [ -d "${VISHNU_OUTPUT_DIR}" ] ; then
rm -rf ${VISHNU_OUTPUT_DIR}
fi
