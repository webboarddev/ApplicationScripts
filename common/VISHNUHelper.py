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
def submitToVishnu(webboardDataRequest,errorHandler=None):

    myErrorHandler = errorHandler

    if (myErrorHandler == None ):
	    myErrorHandler = {}

    myErrorHandler.submitStatus = ""

    vsession = webboardDataRequest.vsession
    scriptPath = webboardDataRequest.application
    workId = webboardDataRequest.workId
    estimatedHours = webboardDataRequest.estimatedHours
    nbcpus = webboardDataRequest.nbcpus
    machineId = webboardDataRequest.machine

    specparams = webboardDataRequest.specparams

    parameters = dictToVishnu(webboardDataRequest.parameters)
    inputFiles = dictToVishnu(webboardDataRequest.files)


    criterion = VISHNU.LoadCriterion()    
    vishnuOptions = VISHNU.SubmitOptions()

    vishnuOptions.setWorkId(workId)
    if(estimatedHours and estimatedHours != "0" ):
	    vishnuOptions.setWallTime(int(estimatedHours))
    if(nbcpus and nbcpus  !="0"):
	    vishnuOptions.setNbCpu(int(nbcpus))
    vishnuOptions.setTextParams(str(parameters))
    vishnuOptions.setFileParams(str(inputFiles))
    
    if (specparams != ""):
        vishnuOptions.setSpecificParams(str(specparams))
        print "Specific parameters : ", str(specparams)
	

    #vishnuOptions.setSelectQueueAutom(True)
    #vishnuOptions.setNbCpu(int())

    job = VISHNU.Job()
    try:   
        
        print "vsession %s, machine %s, application %s" % (str(vsession),str(machineId),str(scriptPath))
        VISHNU.submitJob(str(vsession),str(machineId),str(scriptPath),job,vishnuOptions)
        print "Submit Ok"
        myErrorHandler.submitStatus = "Success"
        myErrorHandler.jobid = job.getJobId()
        print job.getJobId()

    except VISHNU.SystemException as e:
        myErrorHandler.errors = myErrorHandler.errors + 1
        myErrorHandler.submitStatus = "VISHNU System exception : " + e.what()
        myErrorHandler.jobid = job.getJobId()
        print "VISHNU : ", e.what()
        print job.getJobId()

    except VISHNU.VishnuException as e :
        myErrorHandler.errors = myErrorHandler.errors + 1
        myErrorHandler.submitStatus = "VISHNU exception : " + e.what()
        myErrorHandler.jobid = job.getJobId()
        print "Vishnu Exception : ",e.what()
        print job.getJobId()

    except Exception as e :
        myErrorHandler.errors = myErrorHandler.errors + 1
        myErrorHandler.submitStatus = "Exception : " + e
        myErrorHandler.jobid = job.getJobId()
        print "Exception Bizarre ",e
        print job.getJobId()

    return job



def dictToVishnuTest():
    WebData =   {'blastp_evalue': '0.00001', 'blastp_outfmt': '7', 'blastp_used_db': 'Default'}
    VishnuData = dictToVishnu(WebData)
    if VishnuData  != "blastp_evalue=0.00001 blastp_outfmt=7 blastp_used_db=Default" :
        print "dictToVishnu Error VishnuData is %s", VishnuData
    else :
        print "dictToVishnu OK"

dictToVishnuTest()
