#!/usr/bin/env python                                                                                                
import copy
import os
import sys
import tempfile
import shutil

#lib_path = os.path.abspath('../../')
#sys.path.append(lib_path)
from WebboardData import * 
from VISHNUHelper import *
import VISHNU
#Split inputFilePath in sequence set. Create new file for each in scratchDir
def split(inputFilePath, nbSequences,scratchDir):
    f = open(inputFilePath, 'r')
    countSequence = 0
    countFile = 1
    #Open the output file
    out = open(scratchDir+'/'+str(countFile),'w')
    nbSequencesInt = int( nbSequences)
    try :
        for line in f:
            #new sequence start with >

            if line.startswith('>'):
                countSequence = countSequence + 1
            if countSequence <= nbSequencesInt :
                out.write(line)
            else :
                countSequence = 1
                countFile = countFile + 1
                out.close()
                out =  open(scratchDir+'/'+str(countFile),'w')
                out.write(line)
        
            
    finally:
        out.close()
        f.close()

#Split inputFilePath into subsequence. Submit a job for each of them
def splitAndSubmit(webboardDataRequest,scratchDir):
    
    split(webboardDataRequest.files['query_file'], webboardDataRequest.parameters['nbSequence'],scratchDir)
    #Read all files in scratchdir directory and build new submit request

    dirList=os.listdir(scratchDir)
    for subSequenceFile in dirList:
        #Copy submitRequest origin and change the inputFilePath
        submitRequestCopy = copy.deepcopy(webboardDataRequest)
        submitRequestCopy.files['query_file'] = scratchDir +"/"+subSequenceFile
        submitToVishnu(submitRequestCopy)
	
def tests():
    print "In tests"
    VISHNU.vishnuInitialize(os.getenv("VISHNU_CONFIG_FILE"))
    
    session = VISHNU.Session()
    err = VISHNU.connect("root", "vishnu_user", session)

    sessionKey = session.getSessionKey()
    workId =0

    submitRequest = WebboardData(sessionKey,"cluster1",'1', '1',workId,"/home/ubuntu/Source/ApplicationScripts/Blastp/scripts/blastp_generic.sh","/home/ubuntu/Source/ApplicationScripts/Blastp/scripts/pblastp.py",{'query_file': '/home/ubuntu/Source/ApplicationScripts/Blastp/examples/input3.fasta'},{'blastp_used_db': 'Default' ,'blastp_evalue':'1e-5', 'blastp_outfmt':'7','nbSequence' :'2' })
    execute(submitRequest)
    print "out tests"
#vsession,machineId, scriptPath,   options, inputFilePath, workId):
        
#submitToVishnu(sessionKey,"MA_2","/home/ubuntu/Blastp/blastp_generic.sh","blastp_used_db=Default blastp_evalue=1e-5 blastp_outfmt=7","/tmp/blastp/work5/1",4)


def execute(submitRequest):
    # Create temporary directory to work in
    scratchDir = tempfile.mkdtemp(suffix="_blastpwork"+ str(submitRequest.workId))

    try:
        os.makedirs(scratchDir)
    except os.error as e:
        print e

    # Submit jobs
    splitAndSubmit(submitRequest,scratchDir)

    # Delete temporary directory
    shutil.rmtree(scratchDir)
    
