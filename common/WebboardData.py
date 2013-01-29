#Message class send by Webboard 

#vsession : session wb (id wb + cle vishnu)
#machine : machine vishnu
#workId : identifiant vishnu du travail (ensemble de jobs)
#application : script a executer
#preScriptPath : script de pretraitement et qui prendra en charge la soumission
#files : fichier a passer 
#parameters : les options du script (preScript + scriptPath)

import simplejson as json
import pickle
class WebboardData:

    def __init__(self, vsession,machine,estimatedHours, nbcpus,workId, application, preScriptPath, files, parameters,specparams,memory):
        self.vsession = vsession
        if machine == "automatic" :
          self.machine = "autom"
        else:
          self.machine = machine
        self.workId = workId
        self.application = application
        self.preScriptPath = preScriptPath
        self.files = files
        self.parameters = parameters
        self.nbcpus = nbcpus
        self.estimatedHours = estimatedHours 
        self.specparams = specparams
        self.memory = memory
    
    def toJson(self) :
        serialized = {'vsession': self.vsession, 'machine': self.machineId, 'estimatedHours': self.estimatedHours,'nbcpus' :self.nbcpus,'workId':self.workId, 'application' :self.application, 'preScriptPath':self.preScriptPath,'files': self.files,'parameters':self.parameters,'specificParams':self.specparams,'memory':self.memory}
        return serialized

def fromJson(messageSerialized):
  try:
    vsession = messageSerialized['vsession']['key']
    if messageSerialized['machine'] == "automatic" :
      machine = "autom"
    else:
      machine = messageSerialized['machine']
    workId = messageSerialized['id']
    estimatedHours = messageSerialized['estimatedHours']
    application = messageSerialized['application']
    preScriptPath = messageSerialized['preScriptPath']
    files = messageSerialized['files']

    #maybe we should add this to the next section?
    nbcpus = messageSerialized['nbcpus']

    parameters = messageSerialized['parameters']
    ################################################
    # We are now parsing the "parameters" map : 
    # reserved entries will become vishnu options.
    ################################################
    specparams = ""
    memory = ""
    #Specific params
    if 'specificParams' in parameters:
      specparams = parameters['specificParams']
    #memory
    if 'memory' in parameters:
      memory = parameters['memory']

    #end of parsing

  except Exception as e:
    print "Error in submit request data structure : %s", e
  return WebboardData(vsession,machine,estimatedHours,nbcpus, workId, application, preScriptPath,files,parameters,specparams,memory)
           

#def fromJsonTest():
    
def toJsonTest():
    wbData = WebboardData("Sessionid","MA_3","1","2","id1","scriptApp1","preScript1","option1","truc=a test=b machin=c","1024")
    wbDataSerialize = wbData.toJson()
    wbDataLoaded = fromJson(wbDataSerialize)
    #TODO :assert

def fromJsonTest():
    wbDataSerialized = {'files': {'query_file': '/opt/sysfera/uploads/3d5805b5-0b54-4bfd-a324-b35bbf6ee7d8-script'}, 'parameters': {'blastp_evalue': '0.00001', 'blastp_outfmt': '7', 'blastp_used_db': 'Default'}, 'machine': 'MA_2', 'application': '/opt/sysfera/pblastp', 'vsession': {'vsessionid': 'webboard-session-0', 'key': '3e05aac7-e5d4-458b-9510-f93bb5ce257e'}, 'identifier': '258b5de0-b1c3-42d5-834b-edca7272326c', 'id': 1,'preScriptPath': '/opt/sysfera/pblastp','estimatedHours': '1', 'nbcpus':'1', 'specificParams':'truc=a test=b machin=c' }
    wbData = fromJson(wbDataSerialized)
    if wbData.vsession != "3e05aac7-e5d4-458b-9510-f93bb5ce257e" :
        print "fromJsonTest Error. Key is %s . Expected : 3e05aac7-e5d4-458b-9510-f93bb5ce257e ", wbData.vsession
    else: print "fromJsonTest OK"
fromJsonTest()
