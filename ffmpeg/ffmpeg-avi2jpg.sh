#! /bin/bash

#------------------------------------------------------------------------------
# Script used to convert a video to images
#
# The operation is performed using ffmpeg
#
# Prerequisite : ffmpeg binary must exist.
#
# Input variables are:
#
# $INPUT_AVI_FILE : (mandatory) input video
#
# Output files are : images%d and are stored in $VISHNU_OUTPUT_DIR
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

# Testing if ffmpeg exist and needed variables are provided

ffmpegBinary=$(which ffmpeg)

if [ ! -f "$ffmpegBinary" ]; then
    echo "## error ffmpeg binary does not exist. Unable to perform needed operation"
    exit
fi

if [ "x${INPUT_AVI_FILE}" == "x" ] || [ ! -f "${INPUT_AVI_FILE}" ] ; then 
    echo "## error INPUT_AVI_FILE(${INPUT_AVI_FILE}) does not exist or is not a file"
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
log "# input avi file     : ${INPUT_AVI_FILE}"
log "# command           : ffmpeg -i ${INPUT_AVI_FILE} images%d.jpg &> ${tmpdir}/output.txt"

#both variables exists and are files

cd ${tmpdir}
log "- running command ..."
ffmpeg -i ${INPUT_AVI_FILE} images%d.jpg 2> ${tmpdir}/output.txt
if [ "${VERBOSE}" ]; then
    cat ${tmpdir}/output.txt    
fi
rm ${tmpdir}/output.txt
log "- command performed"


imagesCreated=$(ls ${tmpdir})
log "- images created:"
for image in $imagesCreated; do
    log "- $image"
done

log "- moving output file to ${VISHNU_OUTPUT_DIR} ..."
mv ${tmpdir}/* ${VISHNU_OUTPUT_DIR}
log "- move performed"

# remove temporary directory
log "- removing temporary directory ${tmpdir}..."
rm -rf ${tmpdir}

log "- temporary directory removed"
