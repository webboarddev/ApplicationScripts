#! /bin/bash

#------------------------------------------------------------------------------
# Script used to get the state of the partitions
#
# Output is stored in : output.txt and it is stored in $VISHNU_OUTPUT_DIR
#
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------

if [ "x${VISHNU_OUTPUT_DIR}" == "x" ] || [ ! -d "${VISHNU_OUTPUT_DIR}" ] ; then
    echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist or is not a directory"
    exit
fi

#------------------------------------------------------------------------------

# code to execute if everything is ok

df > ${VISHNU_OUTPUT_DIR}/output.txt