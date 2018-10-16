/**
 * REST Service get Live Agent ENV data fmor ORG and Custom metadata
 * LiveAgent_Env__mdt stores all deplyments and button info
 * 
 * author: A.I.
 */ 
@RestResource(urlMapping='/LiveAgentEnv/*')
public without sharing class LiveAgentUtilSvc {
    public LiveAgentUtilSvc() {

    }

    @HttpGet
    global static List<LiveAgentEnv> getLiveAgentEnv(){
        List<LiveAgentEnv> listEnv = new List<LiveAgentEnv>();
        String deploymentName = null;
        if(RestContext.request != null && RestContext.request.params != null){
        	deploymentName = RestContext.request.params.get('configName');
        }
        if (deploymentName != null){ // Query specific deployment name
            listEnv = queryDeployment(deploymentName);
        }else{ // get all deployments configs
            listEnv = queryAll();
        }
        
        return listEnv;
    }
    global static List<LiveAgentEnv> queryDeployment(String nm){
        List<LiveAgentEnv> listEnv = new List<LiveAgentEnv>();
        
        Organization orgInfo = getOrgInfo();
        List<LiveAgent_Env__mdt> envList = [SELECT Id, DeveloperName, Version__c, brandURL__c, 
                                                 baseLiveAgentURL__c, baseLiveAgentContentURL__c, 
                                                 deploymentId__c, buttonId__c, eswLiveAgentDevName__c 
                                                 FROM LiveAgent_Env__mdt WHERE DeveloperName =: nm];
        BISK_LiveAgentEnv env = new BISK_LiveAgentEnv();
        env.version = '5.0';
        env.developerName = nm; 
        env.orgId = orgInfo.Id;
        env.instanceName = orgInfo.InstanceName;
        env.isSandbox = orgInfo.IsSandbox;
        env.baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        // Map LiveAgent Values from custom metadata type
        if(envList != null && envList.size() > 0){
           LiveAgent_Env__mdt cmdt = envList[0];
           env.version = cmdt.Version__c; 
           env.brandURL = cmdt.brandURL__c;
           env.baseLiveAgentContentURL = cmdt.baseLiveAgentContentURL__c; 
           env.deploymentId = cmdt.deploymentId__c;
           env.buttonId = cmdt.buttonId__c; 
           env.baseLiveAgentURL = cmdt.baseLiveAgentURL__c; 
           env.eswLiveAgentDevName = cmdt.eswLiveAgentDevName__c; 
        }
        
        listEnv.add(env);
        return listEnv;
    }
    global static List<LiveAgentEnv> queryAll(){
        List<LiveAgentEnv> listEnv = new List<LiveAgentEnv>();
        Organization orgInfo = getOrgInfo();
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        List<LiveAgent_Env__mdt> envList = [SELECT Id, DeveloperName, Version__c, brandURL__c,
                                                 baseLiveAgentURL__c, baseLiveAgentContentURL__c, 
                                                 deploymentId__c, buttonId__c, eswLiveAgentDevName__c 
                                                 FROM LiveAgent_Env__mdt ];
        
        for (LiveAgent_Env__mdt cmdt : envList){
        	LiveAgentEnv env = new iveAgentEnv();
        	env.orgId = orgInfo.Id;
        	env.instanceName = orgInfo.InstanceName;
        	env.isSandbox = orgInfo.IsSandbox;
        	env.baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        	// Map LiveAgent Values form custom metadata type
        	env.developerName = cmdt.DeveloperName; //'Villanova_University_Graduate';
            env.version = cmdt.Version__c; 
            env.brandURL = cmdt.brandURL__c;
            env.baseLiveAgentContentURL = cmdt.baseLiveAgentContentURL__c; 
            env.deploymentId = cmdt.deploymentId__c;
            env.buttonId = cmdt.buttonId__c; 
            env.baseLiveAgentURL = cmdt.baseLiveAgentURL__c; 
            env.eswLiveAgentDevName = cmdt.eswLiveAgentDevName__c; 
        
        	listEnv.add(env);    
        }        
        
        return listEnv;
    }
    global static Organization getOrgInfo(){
        Organization org = null;
        List<Organization> orgList = [SELECT Id,InstanceName,IsSandbox,Name FROM Organization];
        if(orgList != null && orgList.size()>0){
           org = orgList[0]; 
        }
        return org;
    }
    global class LiveAgentEnv {
        global String version {get; set;}
        global String instanceName {get; set;}
        global Boolean isSandbox {get; set;}
        global String developerName {get; set;}
        global String orgId {get; set;}
        global String baseURL {get; set;}
        global String brandURL {get; set;}
        global String baseLiveAgentContentURL {get; set;}
        global String deploymentId {get; set;}
        global String buttonId {get; set;}
        global String baseLiveAgentURL {get; set;}
        global String eswLiveAgentDevName {get; set;}
    }    
}
