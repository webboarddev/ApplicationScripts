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
    machineId = webboardDataRequest.machineId
    scriptPath = webboardDataRequest.application
    workId = webboardDataRequest.workId

    options = dictToVishnu(webboardDataRequest.options)
    inputFiles = dictToVishnu(webboardDataRequest.files)


    criterion = VISHNU.LoadCriterion()    
    vishnuOptions = VISHNU.SubmitOptions()


    vishnuOptions.setTextParams(str(options))
    vishnuOptions.setFileParams(str(inputFiles))
    job = VISHNU.Job()
   
    print "vsession %s, machine %s, application %s" % (str(vsession),str(machineId),str(scriptPath))
    VISHNU.submitJob(str(vsession),str(machineId),scriptPath,job,vishnuOptions)
    print job.getJobId()
