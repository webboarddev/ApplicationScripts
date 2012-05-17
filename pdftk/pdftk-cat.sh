#! /bin/bash

#------------------------------------------------------------------------------
# Script used to concatenate two files in an file called output1.pdf
#
# The operation is performed using pdftk. For more information on pdftk, please
# go to : http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/ or www.pdftk.com
#
# Prerequisite : pdftk binary must exist.
#
# Input variables are:
#
# $INPUT_PDF_FILE_1 : first input pdf file
#
# $INPUT_PDF_FILE_2 : second input pdf file
#
# Output file is : output1.pdf and it is stored in $VISHNU_OUTPUT_DIR
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

if [ ! -f "$pdftkBinary" ]; then
echo "## error pdftk binary does not exist. Unable to perform needed operation"
exit
fi

if [ "x${INPUT_PDF_FILE_1}" == "x" ] || [ ! -f "${INPUT_PDF_FILE_1}" ] ; then 
echo "## error INPUT_PDF_FILE_1(${INPUT_PDF_FILE_1}) does not exist or is not a file"
exit
fi

if [ "x${INPUT_PDF_FILE_2}" == "x" ] || [ ! -f "${INPUT_PDF_FILE_2}" ] ; then 
echo "## error INPUT_PDF_FILE_2(${INPUT_PDF_FILE_2}) does not exist or is not a file" 
exit
fi


if [ "x${VISHNU_OUTPUT_DIR}" == "x" ] || [ ! -d "${VISHNU_OUTPUT_DIR}" ] ; then
echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist or is not a directory"
exit
fi

#------------------------------------------------------------------------------

# code to execute if everything is ok

log "- creating temporary directory ..."

tmpdir=$(mktemp -d /tmp/vishnu-XXXXX)

log "- temporary directory created"

log "# pdftk binary path : ${pdftkBinary}"
log "# tmp directory     : ${tmpdir}"
log "# input pdf file 1  : ${INPUT_PDF_FILE_1}"
log "# inout pdf file 2  : ${INPUT_PDF_FILE_2}"
log "# command           : pdftk ${INPUT_PDF_FILE_1} ${INPUT_PDF_FILE_2} cat output ${tmpdir}/output1.pdf"

#both variables exists and are files

log "- running command ..."

pdftk ${INPUT_PDF_FILE_1} ${INPUT_PDF_FILE_2} cat output ${tmpdir}/output1.pdf

log "- command performed"

log "- moving output file to ${VISHNU_OUTPUT_DIR} ..."

mv ${tmpdir}/output1.pdf ${VISHNU_OUTPUT_DIR}

log "- move performed"

# remove temporary directory

log "- removing temporary directory ${tmpdir}..."
rm -rf ${tmpdir}

log "- temporary directory removed"