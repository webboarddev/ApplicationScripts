#!/bin/bash
## This script launches hmmer on two input files:
# - an alignment sequences file, in Stockholm format
# - a fasta file
## It requires the following environment variables to be set:
# - query_file: local COMPLETE path to the input file. If this is is a .sto file, use hmmbuild to build a .hmm file, if this is a .hmm file, do not use hmmbuild
# - target_seqfile: local COMPLETE path to the input .fasta file
## Optional input parameters:
# - Boolean options
#   + acc: prefer accessions over names in output
#   + noali: don't output alignments, so output is smaller
#   + cut_ga: use profile's GA gathering cutoffs to set all thresholding
#   + cut_nc: use profile's NC noise cutoffs to set all thresholding
#   + cut_tc: use profile's TC trusted cutoffs to set all thresholding
#   + max: Turn all heuristic filters off (less speed, more power)
#   + nobias: turn off composition bias filter
#   + nonull2: turn off biased composition score corrections


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


########################
# deal with parameters #
########################
# mandatory parameters
if [ "${query_file}x" == "x" ]; then
    echo "## input query file not provided"
    error=1
elif [ ! -r ${query_file} ]; then
    echo "## input query file '${query_file}' does not exist or is not readable"
    error=1
fi

if [ "${target_seqfile}x" == "x" ]; then
    echo "## input target file parameter not provided"
    error=1    
elif [ ! -r ${target_seqfile} ]; then
    echo "## input target file '${target_seqfile}' does not exist or is not readable"
    error=1
fi

if [ "${error}x" != "x" ]; then
    exit 1
fi

## optional parameters
# default option
options="--notextw"
# boolean options
boolean_params="acc noali cut_ga cut_nc cut_tc max nobias nonull2"
for i in ${boolean_params}; do
    eval "var_${!i}=${!i}"
    if [ "$var_${!i}" == "1" ]; then
        options="${options} --${i}"
    fi
done
### other options NOT IMPLEMENTED YET
# options directing output:
#   -o <f>          : direct output to file <f>, not stdout
#   -A <f>          : save multiple alignment of all hits to file <s>
#   --tblout <f>    : save parseable table of per-sequence hits to file <s>
#   --domtblout <f> : save parseable table of per-domain hits to file <s>
#   --textw <n>     : set max width of ASCII text output lines  [120]  (n>=120)
# 
# options controlling reporting thresholds:
#   -E <x>     : report sequences <= this E-value threshold in output  [10.0]  (x>0)
#   -T <x>     : report sequences >= this score threshold in output
#   --domE <x> : report domains <= this E-value threshold in output  [10.0]  (x>0)
#   --domT <x> : report domains >= this score cutoff in output
# 
# options controlling inclusion (significance) thresholds:
#   --incE <x>    : consider sequences <= this E-value threshold as significant
#   --incT <x>    : consider sequences >= this score threshold as significant
#   --incdomE <x> : consider domains <= this E-value threshold as significant
#   --incdomT <x> : consider domains >= this score threshold as significant
# 
# options controlling acceleration heuristics:
#   --F1 <x> : Stage 1 (MSV) threshold: promote hits w/ P <= F1  [0.02]
#   --F2 <x> : Stage 2 (Vit) threshold: promote hits w/ P <= F2  [1e-3]
#   --F3 <x> : Stage 3 (Fwd) threshold: promote hits w/ P <= F3  [1e-5]
# 
# other expert options:
#   -Z <x>        : set # of comparisons done, for E-value calculation
#   --domZ <x>    : set # of significant seqs, for domain E-value calculation
#   --seed <n>    : set RNG seed to <n> (if 0: one-time arbitrary seed)  [42]
#   --tformat <s> : assert target <seqfile> is in format <s>>: no autodetection
#   --cpu <n>     : number of parallel CPU workers to use for multithreads




# echo parameters
query_file=`normalizePath ${query_file}`
target_seqfile=`normalizePath ${target_seqfile}`
echo "query_file=${query_file}"
echo "target_seqfile=${target_seqfile}"
echo "options=${options}"


###########
# Execute #
###########
# Check query file extension
qf_basename=`basename ${query_file}`
ext=`echo ${qf_basename} | awk -F . '{print $NF}'`
if [ "${ext}" != "hmm" -a  "${ext}" != "sto" ]; then
    echo "## Input file is neither a .sto nor a .hmm file"
    return 1
fi

# create temporary directory to work in
tmpdir=`mktemp -d`
## on mac os x use the following command instead: tmpdir=`mktemp -d /tmp/tempXXXXXXXX`
echo "tmp directory=${tmpdir}"

# if we have a .sto file, we need to use hmmbuild
if [ "${ext}" == "sto" ]; then
    query_hmmfile=${tmpdir}/${qf_basename}.hmm
    hmmbuild ${query_hmmfile} ${query_file}
else
    query_hmmfile=${query_file}
fi
echo "Query .hmm file=${query_hmmfile}"


# execute hmmsearch
cd ${tmpdir}
hmmsearch ${options} ${query_hmmfile} ${target_seqfile}


## No output to do yet, unless we use the -o option
# # Copy output file to outputdir
# if [ "x${VISHNU_OUTPUT_DIR}" != "x" ]; then
#     if [ -d "${VISHNU_OUTPUT_DIR}" ]; then
# 	mv ${output_file} ${VISHNU_OUTPUT_DIR}
#     else
# 	echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist"
#     fi
# else
#     echo "## error VISHNU_OUTPUT_DIR not set"
# fi


# remove temporary directory
rm -rf ${tmpdir} 
