/**
 * This class contains unit tests for validating the behavior of Apex classes
 * LiveAgentUtilSvc.
 *
 *  
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * author: A.I.
 */
@isTest
private class LiveAgentUtilSvcTest {
    static testMethod void getLiveAgentEnvTest(){
	Organization org = LiveAgentUtilSvc.getOrgInfo();
        // === Start Test ===
        Test.startTest();        
        List<LiveAgentUtilSvc.LiveAgentEnv> lst = LiveAgentUtilSvc.getLiveAgentEnv();
        Test.StopTest();
	    
	List<LiveAgent_Env__mdt> envList = [SELECT Id, DeveloperName, Version__c, brandURL__c,
                                                 baseLiveAgentURL__c, baseLiveAgentContentURL__c, 
                                                 deploymentId__c, buttonId__c, eswLiveAgentDevName__c 
                                                 FROM LiveAgent_Env__mdt ];        
        System.assertEquals(lst.size(),envList.size());
        LiveAgentUtilSvc.LiveAgentEnv env = lst[0];
        System.assertEquals(env.orgId, org.Id);
    }

    static testMethod void queryDeploymentTest(){
	Organization org = LiveAgentUtilSvc.getOrgInfo();
        // === Start Test ===
        Test.startTest();        
        List<LiveAgentUtilSvc.LiveAgentEnv> lst = LiveAgentUtilSvc.queryDeployment('Test_Certificate');
        Test.StopTest();
	    
        System.assertEquals(lst.size(),1);
        LiveAgentUtilSvc.LiveAgentEnv env = lst[0];
        System.assertEquals(env.orgId, org.Id);
    }
}
