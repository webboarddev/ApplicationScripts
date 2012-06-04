#!/bin/bash

echo "###### TEST 1 #######"
max=1 cut_tc=1 query_file=../examples/Pkinase.hmm target_seqfile=../examples/globins45.fa ./hmmsearch.sh


echo "###### TEST 2 #######"
max=0 cut_tc=1 query_file=../examples/Pkinase.sto target_seqfile=../examples/globins45.fa ./hmmsearch.sh


