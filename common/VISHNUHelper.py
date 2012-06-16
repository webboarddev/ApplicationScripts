import VISHNU


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
    scriptPath = webboardDataRequest.application
    workId = webboardDataRequest.workId
    estimatedHours = webboardDataRequest.estimatedHours
    nbcpus = webboardDataRequest.nbcpus
    machineId = webboardDataRequest.machine

    parameters = dictToVishnu(webboardDataRequest.parameters)
    inputFiles = dictToVishnu(webboardDataRequest.files)


    criterion = VISHNU.LoadCriterion()    
    vishnuOptions = VISHNU.SubmitOptions()

    vishnuOptions.setWid(workId)
    if(estimatedHours and estimatedHours != "0" ):
	    vishnuOptions.setWallTime(int(estimatedHours))
    if(nbcpus and nbcpus  !="0"):
	    vishnuOptions.setNbCpu(int(nbcpus))
    vishnuOptions.setTextParams(str(parameters))
    vishnuOptions.setFileParams(str(inputFiles))
    #vishnuOptions.setSelectQueueAutom(True)
    #vishnuOptions.setNbCpu(int())

    job = VISHNU.Job()
    try:   
        
        print "vsession %s, machine %s, application %s" % (str(vsession),str(machineId),str(scriptPath))
        VISHNU.submitJob(str(vsession),str(machineId),str(scriptPath),job,vishnuOptions)
        print "Submit Ok"
        print job.getJobId()
    except VISHNU.SystemException as e:
        print "VISHNU : %s", e.what()
    except VISHNU.VishnuException as e :
        print "Vishnu Exception : %s",e.what()
    except Exception as e :
        print "Exception BIzarre %s",e
    return job
def dictToVishnuTest():
    WebData =   {'blastp_evalue': '0.00001', 'blastp_outfmt': '7', 'blastp_used_db': 'Default'}
    VishnuData = dictToVishnu(WebData)
    if VishnuData  != "blastp_evalue=0.00001 blastp_outfmt=7 blastp_used_db=Default" :
        print "dictToVishnu Error VishnuData is %s", VishnuData
    else :
        print "dictToVishnu OK"

dictToVishnuTest()
