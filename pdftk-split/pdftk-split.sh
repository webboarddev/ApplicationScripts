#! /bin/bash

#------------------------------------------------------------------------------
# Script used to split a file in several file
#
# The operation is performed using pdftk. For more information on pdftk, please
# go to : http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/ or www.pdftk.com
#
# Prerequisite : pdftk binary must exist.
#
# Input variables are:
#
# $INPUT_PDF_FILE : (mandatory) input pdf file to split
#
# $OUTPUT_FILENAME_TEMPLATE : (optional) output filename template
#
# Default output filename template is : output_%02d.pdf
#
# Output files are stored in $VISHNU_OUTPUT_DIR
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

# Testing if pdftk exist and needed variables are provided

pdftkBinary=$(which pdftk)

if [ -f "$pdftkBinary" ]; then

if [ "x${INPUT_PDF_FILE}" != "x" ] && [ -f "${INPUT_PDF_FILE}" ] ; then 

if [ "x${VISHNU_OUTPUT_DIR}" != "x" ] && [ -d "${VISHNU_OUTPUT_DIR}" ] ; then

#------------------------------------------------------------------------------

# code to execute if everything is ok

log "- creating temporary directory ..."

tmpdir=$(mktemp -d /tmp/vishnu-XXXXX)

log "- temporary directory created"

log "# pdftk binary path        : ${pdftkBinary}"
log "# tmp directory            : ${tmpdir}"
log "# input pdf file           : ${INPUT_PDF_FILE}"
log "# output filename template : ${OUTPUT_FILENAME_TEMPLATE}"

if [ "$OUTPUT_FILENAME_TEMPLATE" ]; then
command="pdftk ${INPUT_PDF_FILE} burst output $OUTPUT_FILENAME_TEMPLATE"
else
command="pdftk ${INPUT_PDF_FILE} burst"
fi

log "# command                  : $command"

#both variables exists and are files

log "- running command ..."

cd $tmpdir

$($command)

log "- command performed"

log "- moving output file to ${VISHNU_OUTPUT_DIR} ..."

mv ${tmpdir}/*.pdf ${VISHNU_OUTPUT_DIR}

log "- move performed"

# remove temporary directory

log "- removing temporary directory ${tmpdir}..."
rm -rf ${tmpdir}

log "- temporary directory removed"

#------------------------------------------------------------------------------
# error cases messages

else
echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist or is not a directory"
fi

else

echo "## error INPUT_PDF_FILE(${INPUT_PDF_FILE}) does not exist or is not a file"; 

fi

else "## error pdftk binary does not exist. Unable to perform needed operation";

fi