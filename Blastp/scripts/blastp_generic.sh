#!/bin/bash
# This script launches blastp on an input fasta file.
# It requires the following environment variables to be set:
# - query_file: local path to the input fasta file
# - blastp_used_db: name of the local database to use
#   not the entire path, see below for local configurations.
#   This needs to be only the name of the database: the name of a
#   .pal file without the .pal extension
# - blastp_evalue: blastp expectation value (evalue)
# - blastp_outfmt: blastp alignment view option [0-11]

#####
## YOU NEED TO CONFIGURE THIS PART ACCORDING TO YOUR LOCAL INSTALLATION
## YOU NEED TO SET THE FOLLOWING VARIABLES:
## - DatabankDir: path to the directory containing all .pal files
## - BlastpPath: path to the blastp binary
## Make sure this configuration can work on all available machines

# retrieve local configuration
source $HOME/Blastp/blastp_source
#####

# echo parameters
echo "query_file=${query_file}"
echo "blastp_used_db=${blastp_used_db}"
echo "blastp_evalue=${blastp_evalue}"
echo "blastp_outfmt=${blastp_outfmt}"


# create temporary directory to work in
tmpdir=`mktemp -d`
echo "tmp directory=${tmpdir}"
cd ${tmpdir}
qf_basename=`basename ${query_file}`
output_file=${tmpdir}/${qf_basename}.out

# execute blastp
${BlastpPath} -query ${query_file} -out ${output_file} -db ${DatabankDir}/${blastp_used_db} -evalue ${blastp_evalue} -outfmt ${blastp_outfmt}

# echo the output file
echo "#####################################################"
cat ${output_file}
echo "#####################################################"

# Copy output file to outputdir
if [ "x${VISHNU_OUTPUT_DIR}" != "x" ]; then
    if [ -d "${VISHNU_OUTPUT_DIR}" ]; then
	mv ${output_file} ${VISHNU_OUTPUT_DIR}
    else
	echo "## error VISHNU_OUTPUT_DIR(${VISHNU_OUTPUT_DIR}) does not exist"
    fi
else
    echo "## error VISHNU_OUTPUT_DIR not set"
fi

# remove temporary directory
rm -rf ${tmpdir} 
