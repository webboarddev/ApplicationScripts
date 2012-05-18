#! /bin/bash

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

# basic environment variables

# uncomment this variable declaration to get more information
#export VERBOSE=1

export TEST_BASE_DIR=$(pwd)

export TMP_DIR_TEMPLATE=${TEST_BASE_DIR}/vishnu-XXXXX
export VISHNU_OUTPUT_DIR=${TEST_BASE_DIR}/output

mkdir -p ${VISHNU_OUTPUT_DIR}

export SCRIPT_LOCATION_DIR=${TEST_BASE_DIR}/..


echo "Executing test suite for pdftk"

tests=$(ls tests)

testsCount=0
for script in $tests; do
testsCount=$(expr $testsCount + 1)
done


echo "${testsCount} tests to perform"

for script in $tests; do
./tests/${script}
done

if [ "x${VISHNU_OUTPUT_DIR}" != "x" ] && [ -d "${VISHNU_OUTPUT_DIR}" ] ; then
rm -rf ${VISHNU_OUTPUT_DIR}
fi
