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
    machineId = webboardDataRequest.machine
    scriptPath = webboardDataRequest.application
    workId = webboardDataRequest.workId

    parameters = dictToVishnu(webboardDataRequest.parameters)
    inputFiles = dictToVishnu(webboardDataRequest.files)


    criterion = VISHNU.LoadCriterion()    
    vishnuOptions = VISHNU.SubmitOptions()

  #  vishnuOptions.setWid(workId)
#    vishnuOptions.setTextParams(str(parameters))
 #   vishnuOptions.setFileParams(str(inputFiles))
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
