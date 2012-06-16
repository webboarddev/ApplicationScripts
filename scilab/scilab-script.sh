#! /bin/bash

#------------------------------------------------------------------------------
# Script used tu run a scilab script in batch mode
#
# The operation is performed using scilab
#
# Prerequisite : scilab binary must exist.
#
# Input variables are:
#
# $INPUT_SCILAB_FILE : (mandatory) input scilab
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

scilabBinary=$(which scilab)

if [ ! -f "$scilabBinary" ]; then
echo "## error scilab binary does not exist. Unable to perform needed operation"
exit
fi

if [ "x${INPUT_SCILAB_FILE}" == "x" ] || [ ! -f "${INPUT_SCILAB_FILE}" ] ; then 
echo "## error INPUT_SCILAB_FILE(${INPUT_SCILAB_FILE}) does not exist or is not a file"
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

log "# ffmpeg binary path : ${ffmpegBinary}"
log "# tmp directory      : ${tmpdir}"
log "# input scilab file  : ${INPUT_SCILAB_FILE}"
log "# command            : scilab -nwni -f ${INPUT_SCILAB_FILE} &>  ${tmpdir}/output.txt"

#both variables exists and are files

cd ${tmpdir}
log "- running command ..."
scilab -nwni -f ${INPUT_SCILAB_FILE} &>  ${tmpdir}/output.txt
log "- command performed"

log "- moving output file to ${VISHNU_OUTPUT_DIR} ..."
mv ${tmpdir}/* ${VISHNU_OUTPUT_DIR}
log "- move performed"

# remove temporary directory
log "- removing temporary directory ${tmpdir}..."
rm -rf ${tmpdir}

log "- temporary directory removed"
