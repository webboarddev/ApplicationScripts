#! /bin/bash

#------------------------------------------------------------------------------
# Script used tu run a R script in batch mode
#
# The operation is performed using R
#
# Prerequisite : R binary must exist.
#
# Input variables are:
#
# $INPUT_R_FILE : (mandatory) input R
# 
# $INPUT_DATA_FILES : (optional) input data files
#
# Output file is : output.txt and is stored in $VISHNU_OUTPUT_DIR
#
# VERBOSE can also be defined to log some variables to the standard output
#
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------

# Simple logging function

function log {
if [ "${VERBOSE}" ]; then
echo $1
fi
}

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------

# Testing if scilab exist and needed variables are provided

RBinary=$(which R)

if [ ! -f "$RBinary" ]; then
echo "## error R binary does not exist. Unable to perform needed operation"
exit
fi

if [ "x${INPUT_R_FILE}" == "x" ] || [ ! -f "${INPUT_R_FILE}" ] ; then 
echo "## error INPUT_R_FILE(${INPUT_R_FILE}) does not exist or is not a file"
exit
fi

if [ "x${VISHNU_OUTPUT_DIR}" == "x" ] || [ ! -d "${VISHNU_OUTPUT_DIR}" ] ; then
echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist or is not a directory"
exit
fi

#------------------------------------------------------------------------------

# code to execute if everything is ok

log "- creating temporary directory ..."

tmpdir=$(mktemp -d ${HOME}/vishnu-XXXXX)

log "- temporary directory created"

log "# ffmpeg binary path : ${RBinary}"
log "# tmp directory      : ${tmpdir}"
log "# input R file       : ${INPUT_R_FILE}"
log "# input data files   : ${INPUT_DATA_FILES}"
log "# command            : R -q --vanilla < ${INPUT_R_FILE} &>  ${tmpdir}/output.txt"

#both variables exists and are files

cd ${tmpdir}
for aFile in ${INPUT_DATA_FILES}; do
    cp $aFile ${tmpdir}
done
log "- running command ..."
R -q --vanilla < ${INPUT_R_FILE} &>  ${tmpdir}/output.txt
log "- command performed"

log "- moving output file to ${VISHNU_OUTPUT_DIR} ..."
mv ${tmpdir}/* ${VISHNU_OUTPUT_DIR}
log "- move performed"

# remove temporary directory
log "- removing temporary directory ${tmpdir}..."
rm -rf ${tmpdir}

log "- temporary directory removed"