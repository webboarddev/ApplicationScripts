#!/usr/bin/env python                                                                                                 

import ../../common/VISHNUHelper
import ../../common/WebboardData as SubmitRequest

import copy
import os

#Split inputFilePath in sequence set. Create new file for each in scratchDir
def split(inputFilePath, nbSequences,scratchDir):
    f = open(inputFilePath, 'r')
    countSequence = 0
    countFile = 1
    #Open the output file
    out = open(scratchDir+'/'+str(countFile),'w')

    try :
        for line in f:
            #new sequence start with >
            if line.startswith('>'):
                countSequence = countSequence + 1
            if countSequence <= nbSequences:
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
    
    split(inputFilePath, nbSequences,scratchDir)
    #Read all files in scratchdir directory and build new submit request

    dirList=os.listdir(scratchDir)
    for subSequenceFile in dirList:
        #Copy submitRequest origin and change the inputFilePath
        submitRequestCopy = copy.deepcopy(submitRequest)
        submitRequestCopy.inputFiles['query_file'] = scratchDir +"/"+subSequenceFile
        VishnuHelper.submitToVishnu(vsession,machineId,scriptPath,options,scratchDir +"/"+subSequenceFile, workId)
	
def tests():
    VISHNU.vishnuInitialize(os.getenv("VISHNU_CONFIG_FILE"))
    
    session = VISHNU.Session()
    err = VISHNU.connect("root", "vishnu_user", session)

    sessionKey = session.getSessionKey()
    workId = 11
    scratchDir = "/tmp/blastp/work"+ str(workId)
    try:
        os.makedirs(scratchDir)
    except os.error as e:
        print e
        splitAndSubmit(sessionKey,"MA_2","/home/ubuntu/Blastp/blastp_generic.sh","blastp_used_db=Default blastp_evalue=1e-5 blastp_outfmt=7",workId,"/home/ubuntu/Blastp/big.fasta",100,scratchDir)
#vsession,machineId, scriptPath,   options, inputFilePath, workId):
        
#submitToVishnu(sessionKey,"MA_2","/home/ubuntu/Blastp/blastp_generic.sh","blastp_used_db=Default blastp_evalue=1e-5 blastp_outfmt=7","/tmp/blastp/work5/1",4)
def dictToVishnuTest():
    WebData =   {'blastp_evalue': '0.00001', 'blastp_outfmt': '7', 'blastp_used_db': 'Default'}
    VishnuData = dictToVishnu(WebData)
    if VishnuData  != "blastp_evalue=0.00001 blastp_outfmt=7 blastp_used_db=Default" :
        print "dictToVishnu Error VishnuData is %s", VishnuData
    else :
        print "dictToVishnu OK"

dictToVishnuTest()
    
