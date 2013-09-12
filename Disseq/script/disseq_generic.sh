#!/bin/bash
# This script launches disseq on an input fasta file and an input base file. Base file is mendatory in this script. (It would be meaningless to "disseq" only a fragment of a user provided reference)
# It requires the following environment variables to be set:
# - query_file: local path to the input fasta file
# - base_file: local path to the base file
# - disseq_algo: choosen algorithm ( nw/sw/nwt/swt available).
# - disseq_dispSeqLen: whether to display sequence length. (yes/no)
# - disseq_printSeqID: whether to print sequence identifier. (yes/no)

#####
## YOU NEED TO CONFIGURE THIS PART ACCORDING TO YOUR LOCAL INSTALLATION
## YOU NEED TO SET THE FOLLOWING VARIABLES:
## - DisseqPath: path to the disseq binary
## Make sure this configuration can work on all available machines

# retrieve local configuration
source /home/ubuntu/Source/ApplicationScripts/Disseq/scripts/disseq_source
#####

# This function transforms a relative path into a complete path
# This is useful for input files, if you need to change the working dir
function normalizePath() {
    dir=`dirname $1`
    name=`basename $1`
    cd ${dir}
    normdir=`pwd`
    cd - > /dev/null 2>&1
    echo "${normdir}/${name}"
}

query_file=`normalizePath ${query_file}`
base_file=`normalizePath ${base_file}`



# echo parameters
echo "query_file=${query_file}"
echo "base_file=${base_file}"
echo "disseq_algo=${disseq_algo}"
echo "disseq_dispSeqLen=${disseq_dispSeqLen}"
echo "disseq_printSeqID=${disseq_printSeqID}"


# create temporary directory to work in
tmpdir=`mktemp -d`
echo "tmp directory=${tmpdir}"
cd ${tmpdir}
qf_basename=`basename ${query_file}`
output_file=${tmpdir}/${qf_basename}.out
echo "Output text file: ${output_file}"

# execute disseq
${DisseqPath} -in ${query_file} -in2 ${base_file} -out ${output_file} -bin no -algo ${disseq_algo} -sl ${disseq_dispSeqLen} -id ${disseq_printSeqID} > disseq.out 2> disseq.err

# Copy output file to outputdir
if [ "x${VISHNU_OUTPUT_DIR}" != "x" ]; then
    if [ -d "${VISHNU_OUTPUT_DIR}" ]; then
	echo "VISHNU_OUTPUT_DIR='${VISHNU_OUTPUT_DIR}'"
	mv ${output_file} ${VISHNU_OUTPUT_DIR}
	mv ${tmpdir}/disseq.out ${VISHNU_OUTPUT_DIR}
	mv ${tmpdir}/disseq.err ${VISHNU_OUTPUT_DIR}
    else
	echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist"
        # echo the output file
	echo "#####################################################"
	cat ${output_file}
	echo "#####################################################"
    fi
else
    echo "## error VISHNU_OUTPUT_DIR not set"
    # echo the output file
    echo "#####################################################"
    cat ${output_file}
    echo "#####################################################"
fi

# remove temporary directory
rm -rf ${tmpdir} 
