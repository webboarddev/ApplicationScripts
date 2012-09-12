#!/bin/bash
#
# <TODO: DESCRIBE YOUR APPLICATION HERE>
#
# It requires the following environment variables to be set:
#  - <TODO: DESCRIBE YOUR INPUT VARIABLES HERE, USING THE FOLLOWING SYNTAX: "variableName: description">
#  

##################
# COMMON METHODS #
##################
## This function transforms a relative path into a complete path
# This is useful for input files, if you need to change the working dir
function normalizePath() {
    dir=`dirname $1`
    name=`basename $1`
    cd ${dir}
    normdir=`pwd`
    cd - > /dev/null 2>&1
    echo "${normdir}/${name}"
}

## This function outputs a given string to stdout if the VERBOSE variable is set
function log {
    if [ "${VERBOSE}" ]; then
        echo $1
    fi
}
###################
# /COMMON METHODS #
###################


#########################
# CHECK INPUT VARIABLES #
#########################

## <TODO: RETRIEVE AND TEST YOUR INPUT VARIABLES HERE>
# Examples:
# if [ "${query_file}x" == "x" ]; then
#     echo "## input query file not provided"
#     error=1
# elif [ ! -r ${query_file} ]; then
#     echo "## input query file '${query_file}' does not exist or is not readable"
#     error=1
# fi
# if [ "${target_seqfile}x" == "x" ]; then
#     echo "## input target file parameter not provided"
#     error=1    
# elif [ ! -r ${target_seqfile} ]; then
#     echo "## input target file '${target_seqfile}' does not exist or is not readable"
#     error=1
# fi

##########################
# /CHECK INPUT VARIABLES #
##########################


################
# EXECUTE CODE #
################

## <TODO: EXECUTE YOUR CODE HERE>

#################
# /EXECUTE CODE #
#################


##################
# HANDLE OUTPUTS #
##################
# Copy output file to outputdir
if [ "x${VISHNU_OUTPUT_DIR}" != "x" ]; then
    if [ -d "${VISHNU_OUTPUT_DIR}" ]; then
	echo "VISHNU_OUTPUT_DIR='${VISHNU_OUTPUT_DIR}'"

        ## <TODO: COPY ANY OUTPUT FILE TO VISHNU_OUTPUT_DIR>

    else
	echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist"

        ## <TODO: DO WHATEVER NEEDS TO BE DONE TO HANDLE THIS ERROR>
    fi
else
    echo "## error VISHNU_OUTPUT_DIR not set"

    ## <TODO: DO WHATEVER NEEDS TO BE DONE TO HANDLE THIS ERROR>
fi
###################
# /HANDLE OUTPUTS #
###################
