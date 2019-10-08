@isTest
private class PartnerAgreement_test {
	
	@testsetup static void createTestData(){
		double vrandom = math.random();
		list<Partner_Agreement_Healthcare_Specialist__c> lPAHS = new list<Partner_Agreement_Healthcare_Specialist__c>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='teststandarduser@testorg.combetterpartners'+vrandom, 
        EmailEncodingKey='UTF-8', LastName='Testing', Firstname='Tester', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='teststandarduser@testorg.combetterpartners'+vrandom);
        insert u;	

		User testUser = [select Name, Email, UserName from User where isActive =true and lastname = 'testing' and firstname='tester' limit 1];
		
		lPAHs.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = testUser.Name,
			Specialist_s_Email__c = testUser.Email
		));
		lPAHS.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = 'George Wilson',
			Specialist_s_Email__c = 'gwilson@wizardcast.com.test'
		));
		lPAHS.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = 'Peter Wilson',
			Specialist_s_Email__c = 'pwilson@wizardcast.com.test'
		));
		lPAHS.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = 'Ryan Wilson',
			Specialist_s_Email__c = 'rwilson@wizardcast.com.test'
		));		
		insert lPAHS;
		
		Account Facility = new account(name='Facility');
		Account Distributor = new ACcount(name='Distributor');
		
		list<Account> lActs = new list<Account>();
		lActs.add(facility); lActs.add(Distributor);
		insert lacts;
		Contact Con = new Contact(firstName='PATest', 
		LastName='Contact', AccountID=Facility.id);
		insert con;

		Partner_Agreement__c testPA = new Partner_Agreement__c(
			Agreement_Type__c = 'TestData',
			Sales_Rep_Comments__c = 'Test PA',
			Sales_Rep_Company__c = 'MK FOOD SERVICE EQPT,INC',
			Sales_Rep_Email__c = 'support+Salestest@betterpartners.com',
			Sales_Rep_Name__c = 'Better Partners',
			City__c = 'York',
			Customer_Email__c = 'support+Salestest1@betterpartners.com',
			Customer_Fax__c = 'n/a',
			Customer_Name__c = 'Better Partners Name',
			Customer_Phone__c = '(717) 840-7100',
			Customer_Title__c = 'Corporate Buyer',
			Distributor_City__c = 'Alletnown',
			Distributor_Name__c = 'US Foods',
			Distributor_Sales_Rep_E_mail__c = 'support+Salestest2@betterpartners.com',
			Distributor_State__c = 'PA',
			Distributor_Zip_Code__c = '18109',
			Distributor_Street_Address__c = '1200 Hoover Ave.',
			Facility_Name__c = 'Pleasant Acres Nursing & Rehab.',
			Healthcare_Specialist__c = testUser.id,
			Licensed_Beds__c = 378,
			Order_Number__c = '19062122-0',			
			Renewal__c = 'No',
			Room_Trays_Served__c = 378,
			Status__c = 'Shipped',
			State__c = 'PA',
			Street_Address__c = '118 Pleasant Acres Rd.',
			Zip_Postal_Code__c = '17402',
			Start_Date__c = date.today()-366,
			End_Date__c = date.today()-1,
			Facility__c = Distributor.id,
			Distributor__c = Facility.id,
			Contact__c = Con.id
		);
		insert testPa;
	} 

	@isTest static void test_CMDT_Submit(){

		Partner_Agreement__c PA = new Partner_Agreement__c();
        PageReference pageRef = Page.PartnerAgreements;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(PA);
        PartnerAgreement_ext ext =  new PartnerAgreement_ext(sc);
		
		User testUser = [select id,Name, Email, UserName from User where isActive =true and lastname = 'testing' and firstname='tester' limit 1];

		ext.getvSpecialists();
        //ext.MyAgreement.Agreement_Type__c = 'Mugs & Bowls';
		ext.MyAgreement.Agreement_Type__c = 'TestData';
        ext.RefreshProds(); //calls FieldVisibilityControl()
       // ext.queryHealthcareSpecialist(); //Called by Submit()

        ext.vSpecialist = testUser.UserName;   //set the HealthSpecialist      
        
        //ext.getvAgreementTypes();
        
        ext.SumbitEmailRep(); //Calls Submit()
		//PrdColors test input
        test.starttest();
        try{
        	Partner_Agreement__c vPA = [select id from Partner_Agreement__c limit 1];
        	list<Partner_Agreement_Product__c> lPAProds = [select id from Partner_Agreement_Product__c where Partner_Agreement__c= :vPA.id Order by Code__c];
        	for(integer i=0; i<lPAProds.size(); i++){
        		system.assertequals(lPAProds[i].Code__c,'TestProduct'+i+1);
        	}        	
        }catch(exception e){
        	system.debug('Error: ' + e);
        }

        test.stoptest();        

	}
	@isTest static void test_CMDT_Other(){

		Partner_Agreement__c PA = new Partner_Agreement__c();
        PageReference pageRef = Page.PartnerAgreements;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(PA);
        PartnerAgreement_ext ext =  new PartnerAgreement_ext(sc);
		
		User testUser = [select id,Name, Email, UserName from User where isActive =true and lastname = 'testing' and firstname='tester' limit 1];

		ext.getvSpecialists();
        //ext.MyAgreement.Agreement_Type__c = 'Mugs & Bowls';
		ext.MyAgreement.Agreement_Type__c = 'TestData';
        ext.RefreshProds(); //calls FieldVisibilityControl()

		//PrdColors test input
		list<SelectOption> options = ext.getvSpecialists();
        test.starttest();
        	//ext.getRepGroups();
		    map<string,Partner_Agreement_Healthcare_Specialist__c> mSpecialists = Partner_Agreement_Healthcare_Specialist__c.getAll();		    
		    
		    system.assertnotequals(null,options,'Options should be instantiated');
		    system.assert(!options.isEmpty(),'Options should be populated');
		    string vlabel;
		    for(integer i=0; i<options.size(); i++){
		    	vlabel = options.get(i).getvalue();
		    	system.assertnotequals(null, vlabel,'Label shouldnt be empty');
		    	if(vlabel == 'gwilson@WizardCast.com.test'
		    		|| vlabel =='pwilson@WizardCast.com.test'
		    		|| vlabel =='rwilson@WizardCast.com.test'|| vlabel == testUser.email 
		    		||  vlabel =='--none--' || vlabel == ''){

		    		}else{
		    			system.assert(false,vlabel +' HealthSpecialst does not match custom setting values');
		    		}
		    }
		    ext.vSpecialist = testUser.Email;
   	        string vUserID = ext.queryHealthcareSpecialist();
 			system.assertequals(vUserID,testUser.id);
        test.stoptest();   

	}
	@isTest static void test_CMDT_Coverage(){

		Partner_Agreement__c PA = new Partner_Agreement__c();
        PageReference pageRef = Page.PartnerAgreements;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(PA);
        PartnerAgreement_ext ext =  new PartnerAgreement_ext(sc);
		
		User testUser = [select id,Name, Email, UserName from User where isActive =true and lastname = 'testing' and firstname='tester' limit 1];

		ext.getvSpecialists();
        //ext.MyAgreement.Agreement_Type__c = 'Mugs & Bowls';
		ext.MyAgreement.Agreement_Type__c = 'TestData';
        ext.RefreshProds(); 
        ext.vSpecialist = testUser.UserName;   //set the HealthSpecialist      
        
       
       ext.MyAgreement.Agreement_Type__c = 'Mugs';
        ext.FieldVisibilityControl();       
        system.assertequals(true,ext.DisplayDiameter );
       ext.MyAgreement.Agreement_Type__c = 'Tumblers';
        ext.FieldVisibilityControl();
        system.assertequals(true,ext.DisplayDisposableLidCode );
       ext.MyAgreement.Agreement_Type__c = 'Camlids';
        ext.FieldVisibilityControl();
        system.assertequals(true,ext.DisplayShoreline );

       ext.getRepGroups();
		//PrdColors test input
        test.starttest();


        test.stoptest();        

	}	

	@isTest static void test_PAID_Renewal(){
		User testUser = [select id,Name, Email, UserName from User where isActive =true and lastname = 'testing' and firstname='tester' limit 1];
		Partner_Agreement__c PriorPA = [select id,Agreement_Type__c, Sales_Rep_Comments__c, 
			Sales_Rep_Company__c, Sales_Rep_Email__c, Sales_Rep_Name__c, City__c, Customer_Email__c, 
			Customer_Fax__c, Customer_Name__c, Customer_Phone__c, Customer_Title__c, Distributor_City__c, 
			Distributor_Name__c, Distributor_Sales_Rep_E_mail__c, Distributor_State__c, Distributor_Zip_Code__c, 
			Distributor_Street_Address__c, Facility_Name__c, Healthcare_Specialist__c, Licensed_Beds__c, 
			Order_Number__c, Optional_Header_Image__c, Renewal__c, Room_Trays_Served__c, Status__c, State__c, 
			Street_Address__c, Zip_Postal_Code__c, Start_Date__c, End_Date__c, Facility__c, Distributor__c, 
			Contact__c from Partner_Agreement__c where Customer_Name__c = 'Better Partners Name' limit 1];
 
		
		Partner_Agreement__c PA = new Partner_Agreement__c();
        PageReference pageRef = Page.PartnerAgreements;
        Test.setCurrentPage(pageRef);
		apexpages.currentPage().getParameters().put('PAID',PriorPA.id);
        ApexPages.StandardController sc = new ApexPages.standardController(PA);
        PartnerAgreement_ext ext =  new PartnerAgreement_ext(sc);

        ext.getRepGroups();
		//PrdColors test input
        test.starttest();
		test.stoptest();
		//check PA set to renewal
		system.assertequals(ext.MyAgreement.Renewal_Compliance_Approval_Status__c,'Approval Required');
		system.assertequals(ext.MyAgreement.Agreement_Type__c,PriorPA.Agreement_Type__c);
		system.assertequals(ext.MyAgreement.Sales_Rep_Comments__c,PriorPA.Sales_Rep_Comments__c);
		system.assertequals(ext.MyAgreement.Sales_Rep_Company__c,PriorPA.Sales_Rep_Company__c);
		system.assertequals(ext.MyAgreement.Sales_Rep_Email__c,PriorPA.Sales_Rep_Email__c);
		system.assertequals(ext.MyAgreement.Sales_Rep_Name__c,PriorPA.Sales_Rep_Name__c);
		system.assertequals(ext.MyAgreement.City__c,PriorPA.City__c);
		system.assertequals(ext.MyAgreement.Customer_Email__c,PriorPA.Customer_Email__c);
		system.assertequals(ext.MyAgreement.Customer_Fax__c,PriorPA.Customer_Fax__c);
		system.assertequals(ext.MyAgreement.Customer_Name__c,PriorPA.Customer_Name__c);
		system.assertequals(ext.MyAgreement.Customer_Phone__c,PriorPA.Customer_Phone__c);
		system.assertequals(ext.MyAgreement.Customer_Title__c,PriorPA.Customer_Title__c);
		system.assertequals(ext.MyAgreement.Distributor_City__c,PriorPA.Distributor_City__c);
		system.assertequals(ext.MyAgreement.Distributor_Name__c,PriorPA.Distributor_Name__c);
		system.assertequals(ext.MyAgreement.Distributor_Sales_Rep_E_mail__c,PriorPA.Distributor_Sales_Rep_E_mail__c);
		system.assertequals(ext.MyAgreement.Distributor_State__c,PriorPA.Distributor_State__c);
		system.assertequals(ext.MyAgreement.Distributor_Street_Address__c,PriorPA.Distributor_Street_Address__c);
		system.assertequals(ext.MyAgreement.Distributor_Zip_Code__c,PriorPA.Distributor_Zip_Code__c);
		system.assertequals(ext.MyAgreement.Facility_Name__c,PriorPA.Facility_Name__c);
		system.assertequals(ext.MyAgreement.Healthcare_Specialist__c,PriorPA.Healthcare_Specialist__c);
		system.assertequals(ext.MyAgreement.Licensed_Beds__c,PriorPA.Licensed_Beds__c);    
		system.assertequals(ext.MyAgreement.Renewal__c, 'Yes');
		system.assertequals(ext.MyAgreement.Room_Trays_Served__c,PriorPA.Room_Trays_Served__c);
		system.assertequals(ext.MyAgreement.State__c,PriorPA.State__c);
		system.assertequals(ext.MyAgreement.Street_Address__c,PriorPA.Street_Address__c);
		system.assertequals(ext.MyAgreement.Zip_Postal_Code__c,PriorPA.Zip_Postal_Code__c); 
		//MyAgreement.Contact__c = PriorPA.Contact__c;   //removed since contact can change
		system.assertequals(ext.MyAgreement.Facility__c,PriorPA.Facility__c);
		system.assertequals(ext.MyAgreement.Distributor__c,PriorPA.Distributor__c);
	}		


	@isTest static void test_Add_RemoveLIne(){
		User testUser = [select id,Name, Email, UserName from User where isActive =true and lastname = 'testing' and firstname='tester' limit 1];
		Partner_Agreement__c PriorPA = [select id,Agreement_Type__c, Sales_Rep_Comments__c, 
			Sales_Rep_Company__c, Sales_Rep_Email__c, Sales_Rep_Name__c, City__c, Customer_Email__c, 
			Customer_Fax__c, Customer_Name__c, Customer_Phone__c, Customer_Title__c, Distributor_City__c, 
			Distributor_Name__c, Distributor_Sales_Rep_E_mail__c, Distributor_State__c, Distributor_Zip_Code__c, 
			Distributor_Street_Address__c, Facility_Name__c, Healthcare_Specialist__c, Licensed_Beds__c, 
			Order_Number__c, Optional_Header_Image__c, Renewal__c, Room_Trays_Served__c, Status__c, State__c, 
			Street_Address__c, Zip_Postal_Code__c, Start_Date__c, End_Date__c, Facility__c, Distributor__c, 
			Contact__c from Partner_Agreement__c where Customer_Name__c = 'Better Partners Name' limit 1];
 
		
		Partner_Agreement__c PA = new Partner_Agreement__c();
        PageReference pageRef = Page.PartnerAgreements;
        Test.setCurrentPage(pageRef);
		apexpages.currentPage().getParameters().put('PAID',PriorPA.id);
        ApexPages.StandardController sc = new ApexPages.standardController(PA);
        PartnerAgreement_ext ext =  new PartnerAgreement_ext(sc);
		ext.ManageCMDT();
		ext.FillDefaults(PriorPA.id);
		ext.RefreshProds();
	test.starttest();
	test.stoptest();
	system.assertequals('TestData',ext.MyAgreement.Agreement_Type__c);
	list<Partner_Agreement_Products__mdt>lmdt = new list<Partner_Agreement_Products__mdt>();
	lmdt =[SELECT Agreement_Type__c,Approx_Capacity__c,Case_Pack__c,Code__c,Description__c,
    DeveloperName,Disposable_Lid_Code__c,Full_Size_Camrack__c,Height__c,Id,
    Image_Location__c,MasterLabel,Other_Case_Pack__c,Outside_Diameter__c,
    Reusable_Lid_Capacity__c,QualifiedApiName,Fits_Shoreline_Products__c 
    FROM Partner_Agreement_Products__mdt]; // where Agreement_Type__c = :ext.MyAgreement.Agreement_Type__c];
	system.assertnotequals(0,lmdt.size(),'No CMDT Records');
	integer startProdNum =0;
	
	list<PartnerAgreement_ext.ProdnColors> lpnc = new list<PartnerAgreement_ext.ProdnColors>();
	lpnc= ext.PrdColors;

	//PrdColors
	startProdNUm = lpnc.size();
	system.assertnotequals(0,startProdNum,'Line Items Do not Exist');
	ext.getProdNumbers();	
	ext.vNewProd =ext.mProdMDT.values()[0].Code__c;	
	ext.addRow();
	lpnc = new list<PartnerAgreement_ext.ProdnColors>();
	lpnc= ext.PrdColors;
    
	system.assertequals( lpnc.size(),startProdNum+1); //Check if 1 row was added
	ext.rowToRemove =  lpnc.size()-1; //Removes last row
	ext.RemoveRow();
	lpnc = new list<PartnerAgreement_ext.ProdnColors>();
	lpnc= ext.PrdColors;	
	system.assertequals(lpnc.size(),startProdNum); //check 1 row was removed

}
/*
@isTest static void test_HealthSpecialistErrormsg(){

}*/
	/* //REplaced with CMDT update 4/18/19
	@isTest static void test_method_one() {
		//Create test records

		//Partner_Agreement_Line_Items__c
		//SELECT Agreement_Type__c,Approx_Capacity__c,Case_Pack__c,Code__c,Description__c,
		//Disposable_Lid_Code__c,Full_Size_Camrack__c,Height__c,Image_Location__c,
		//Outside_Diameter__c FROM Partner_Agreement_Line_Items__c
		list<Partner_Agreement_Line_Items__c> lPali = new list<Partner_Agreement_Line_Items__c>();
		lPali.add(new Partner_Agreement_Line_Items__c(
			Name = 'Test',
			Agreement_Type__c = 'Mugs & Bowls' ,
			Approx_Capacity__c = '3 oz.',
			Case_Pack__c = '5',
			Code__c = '235',
			Description__c = 'test' ,
			Disposable_Lid_Code__c =  '235',
			Full_Size_Camrack__c = '235' ,
			Height__c = '235',
			Image_Location__c = 'http://google.com' ,
			Outside_Diameter__c = '532'
		));
		insert lPali;
		//Partner_Agreement_Healthcare_Specialist__c
		//SELECT Name,Specialist_s_Email__c FROM Partner_Agreement_Healthcare_Specialist__c
		list<Partner_Agreement_Healthcare_Specialist__c> lPAHS = new list<Partner_Agreement_Healthcare_Specialist__c>();
		User testUser = [select Name, Email, UserName from User where isActive =true limit 1];
		lPAHs.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = testUser.Name,
			Specialist_s_Email__c = testUser.Email
		));
		lPAHS.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = 'George Wilson',
			Specialist_s_Email__c = 'gwilson@wizardcast.com.test'
		));
		lPAHS.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = 'Peter Wilson',
			Specialist_s_Email__c = 'pwilson@wizardcast.com.test'
		));
		lPAHS.add(new Partner_Agreement_Healthcare_Specialist__c(
			Name = 'Ryan Wilson',
			Specialist_s_Email__c = 'rwilson@wizardcast.com.test'
		));		
		insert lPAHS;	


		Partner_Agreement__c PA = new Partner_Agreement__c();
        PageReference pageRef = Page.PartnerAgreements;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(PA);
        PartnerAgreement_ext ext =  new PartnerAgreement_ext(sc);
        //ext.MyAgreement.Agreement_Type__c = 'Mugs and Bowls';
        //ext.vAgreementType = 'Mugs and Bowls';
        ext.MyAgreement.Agreement_Type__c = 'Mugs & Bowls';
        ext.vSpecialist = testUser.UserName;
        ext.queryHealthcareSpecialist();
        ext.getvSpecialists();
        //ext.getvAgreementTypes();
        ext.RefreshProds();
        ext.SumbitEmailRep();

        test.starttest();
        try{
        	Partner_Agreement__c vPA = [select id from Partner_Agreement__c limit 1];
        	list<Partner_Agreement_Product__c> lPAProds = [select id from Partner_Agreement_Product__c where Partner_Agreement__c= :vPA.id];
        	for(Partner_Agreement_Product__c p : lPAProds){
        		system.assertequals(p.Approx_Capacity__c,'3 oz.');
        	}
        }catch(exception e){
        	system.debug('Error: ' + e);
        }

        test.stoptest();
	}
	
	
}