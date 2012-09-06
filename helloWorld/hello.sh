#!/bin/bash
## This script is a simple example showing all VISHNU variables.
# It takes as input the following variables:
# - name: a string representing the name of the user

HOSTNAME=`hostname`

echo "Hello ${name}!"
echo "You are on machine ${HOSTNAME}"

echo "The name of the submitted server is: " $HOSTNAME

echo "TEST OF VISHNU JOB OUTPUT ENVIRONMENT VARIABLES!...."
echo "VISHNU_BATCHJOB_ID: "$VISHNU_BATCHJOB_ID
echo "VISHNU_BATCHJOB_NAME: " $VISHNU_BATCHJOB_NAME
echo "VISHNU_BATCHJOB_NODEFILE:" $VISHNU_BATCHJOB_NODEFILE
cat $VISHNU_BATCHJOB_NODEFILE
echo "VISHNU_BATCHJOB_NUM_NODES: "$VISHNU_BATCHJOB_NUM_NODES
echo "VISHNU_SUBMIT_MACHINE_NAME: "$VISHNU_SUBMIT_MACHINE_NAME
echo "VISHNU_OUTPUT_DIR: " $VISHNU_OUTPUT_DIR

echo
echo "Env:"
/usr/bin/env
echo

echo "Goodbye ${name}"


