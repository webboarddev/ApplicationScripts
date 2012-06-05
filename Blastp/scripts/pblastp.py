#!/usr/bin/env python                                                                                                 
import VISHNU

import os

def dictToVishnu(dictionnary):
    concat = ''
    if dictionnary != None and dictionnary:
        for key, value in dictionnary.iteritems():
            if not concat == '':
                concat += ' '
            concat += "%s=%s" % (key,value)
    return concat


#Submit a job to vishnu
def submitToVishnu(webboardDataRequest):
    vsession = webboardDataRequest.vsession
    machineId = webboardDataRequest.machineId
    scriptPath = webboardDataRequest.application
    options = dictToVishnu(webboardDataRequest.options)
    inputFiles = dictToVishnu(webboardDataRequest.files)
    workId = webboardDataRequest.workId
    criterion = VISHNU.LoadCriterion()
    
    vishnuOptions = VISHNU.SubmitOptions()


    vishnuOptions.setTextParams(str(options))
    vishnuOptions.setFileParams(str(inputFiles))
    job = VISHNU.Job()
   
    print "vsession %s, machine %s, application %s" % (str(vsession),str(machineId),str(scriptPath))
    VISHNU.submitJob(str(vsession),str(machineId),scriptPath,job,vishnuOptions)
    print job.getJobId()

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

def splitAndSubmit(vsession,machineId, scriptPath,   options,  workId,inputFilePath, nbSequences,scratchDir):
	split(inputFilePath, nbSequences,scratchDir)
	#Read all files in scratchdir directory
	print scratchDir
	dirList=os.listdir(scratchDir)
	for subSequenceFile in dirList:
		print scratchDir +  "/"+subSequenceFile
		submitToVishnu(vsession,machineId,scriptPath,options,scratchDir +"/"+subSequenceFile, workId)
	
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
    
