public without sharing class PartnerAgreement_ext {
  
   
  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description PartnerAgreement Ext controls the ParnterAgreement.page
  * Once submitted it should create the PartnerAgreement and child records
  * Which should then trigger a workflow rule to send the generated template
  * 
  */
  @testvisible private final Partner_Agreement__c MyAgreement;

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description Extension Method
  * @return 
  */
  public PartnerAgreement_ext(ApexPages.StandardController stdController) {
    this.MyAgreement = (Partner_Agreement__c)stdController.getRecord();
    MyAgreement.Agreement_Type__c = 'The Wizard News';
    //mSettings = new map<string,Partner_Agreement_Line_Items__c>();
    //mSettings = Partner_Agreement_Line_Items__c.getAll();
    PA_Prods  = new list<Partner_Agreement_Product__c>();
    renderSuccess = false;
    
    //default field visibility
    DisplayDisposableLidCode = false;
    DisplayOtherCasePack = false; 
    DisplayCapacity = false; 
    DisplayHeight = false; 
    DisplayCamRack = false; 
    DisplayDiameter  = false;
    DisplayRequestedColorCode = false; 
    DisplayShoreline = false; 
    DisplayLidCapacity  = false;  
    DisplayRenewal = false;
    MyAgreement.Special_Request__c = 'No';
    if(apexpages.currentPage().getParameters().containsKey('PAID')){
      DisplayRenewal = true;
      FillDefaults(apexpages.currentPage().getParameters().get('PAID'));
      
    }
    RefreshProds();
  }
 
  /**
  * @author Brian Kwong - Better Partners 
  * @date 06/17/2019
  * @param None
  * @Description removes a row from PA Prod list
  * @return 
  */
  public void FillDefaults(string vPAID){
  //string vPAID =apexpages.currentPage().getParameters().get('vNewProd');
    try{
      Partner_Agreement__c PriorPA = [SELECT Agreement_Type__c,Sales_Rep_Comments__c,
        Sales_Rep_Company__c,Sales_Rep_Email__c,Sales_Rep_Name__c,City__c,Customer_Email__c,
        Customer_Fax__c,Customer_Name__c,Customer_Phone__c,Customer_Title__c,Distributor_City__c,
        Distributor_Name__c,Distributor_Sales_Rep_E_mail__c,Distributor_State__c,
        Distributor_Street_Address__c,Distributor_Zip_Code__c,Facility_Name__c,
        Healthcare_Specialist__c,Licensed_Beds__c,Name,Renewal__c,Room_Trays_Served__c,
        State__c,Street_Address__c,Zip_Postal_Code__c,Contact__c 
        FROM Partner_Agreement__c where id = :vPAID ];

      MyAgreement.Renewal_Compliance_Approval_Status__c = 'Approval Required' ;
      MyAgreement.Agreement_Type__c=PriorPA.Agreement_Type__c;
      MyAgreement.Sales_Rep_Comments__c=PriorPA.Sales_Rep_Comments__c;
      MyAgreement.Sales_Rep_Company__c=PriorPA.Sales_Rep_Company__c;
      MyAgreement.Sales_Rep_Email__c=PriorPA.Sales_Rep_Email__c;
      MyAgreement.Sales_Rep_Name__c=PriorPA.Sales_Rep_Name__c;
      MyAgreement.City__c=PriorPA.City__c;
      MyAgreement.Customer_Email__c=PriorPA.Customer_Email__c;
      MyAgreement.Customer_Fax__c=PriorPA.Customer_Fax__c;
      MyAgreement.Customer_Name__c=PriorPA.Customer_Name__c;
      MyAgreement.Customer_Phone__c=PriorPA.Customer_Phone__c;
      MyAgreement.Customer_Title__c=PriorPA.Customer_Title__c;
      MyAgreement.Distributor_City__c=PriorPA.Distributor_City__c;
      MyAgreement.Distributor_Name__c=PriorPA.Distributor_Name__c;
      MyAgreement.Distributor_Sales_Rep_E_mail__c=PriorPA.Distributor_Sales_Rep_E_mail__c;
      MyAgreement.Distributor_State__c=PriorPA.Distributor_State__c;
      MyAgreement.Distributor_Street_Address__c=PriorPA.Distributor_Street_Address__c;
      MyAgreement.Distributor_Zip_Code__c=PriorPA.Distributor_Zip_Code__c;
      MyAgreement.Facility_Name__c=PriorPA.Facility_Name__c;
      MyAgreement.Healthcare_Specialist__c=PriorPA.Healthcare_Specialist__c;
      MyAgreement.Licensed_Beds__c=PriorPA.Licensed_Beds__c;    
      MyAgreement.Renewal__c= 'Yes';
      MyAgreement.Room_Trays_Served__c=PriorPA.Room_Trays_Served__c;
      MyAgreement.State__c=PriorPA.State__c;
      MyAgreement.Street_Address__c=PriorPA.Street_Address__c;
      MyAgreement.Zip_Postal_Code__c=PriorPA.Zip_Postal_Code__c; 
      //MyAgreement.Contact__c = PriorPA.Contact__c;   //removed since contact can change
      MyAgreement.Facility__c = PriorPA.Facility__c;
      MyAgreement.Distributor__c = PriorPA.Distributor__c;

      RefreshProds();
    }catch(exception e){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Renewal Link is invalid'));  
    } 
  }
  
  /**
  * @author Brian Kwong - Better Partners 
  * @date 06/17/2019
  * @param None
  * @Description removes a row from PA Prod list
  * @return 
  */
  public void NewProductSet(){
    //vNewProd=apexpages.currentPage().getParameters().get('vNewProd');
    system.debug('vNewProd: ' + vNewProd);
  }
  
  /**
  * @author Brian Kwong - Better Partners 
  * @date 06/17/2019
  * @param None
  * @Description removes a row from PA Prod list
  * @return 
  */
  public string vNewProd{get;set;}
  public list<SelectOption> getProdNumbers(){
    list<SelectOption> options = new list<SelectOption>();
    //options.add(new selectoption('','--none--'));
     options.add(new selectoption('','--none--'));
    for(Partner_Agreement_Products__mdt prod :mProdMDT.values()){     
      options.add(new selectoption(prod.Code__c,prod.Code__c));
    }    
    return options;   
  }
  
  /**
  * @author Brian Kwong - Better Partners 
  * @date 06/17/2019
  * @param None
  * @Description adds a row from PA Prod list
  * @return 
  */
  public void addRow(){
    list<ProdNColors> newItems = new list<ProdNColors>();
    list<Partner_Agreement_Products__mdt> lProdsCMDT = new list<Partner_Agreement_Products__mdt>();
    system.debug('adding line for code: ' + vNewProd);
    lProdsCMDT.add(mProdCodeMDT.get(vNewProd));
    newItems =addLineItems(lProdsCMDT);
    PrdColors.addall(newItems);
  }
    /**
  * @author Brian Kwong - Better Partners 
  * @date 06/17/2019
  * @param None
  * @Description removes a row from PA Prod list
  * @return 
  */
  public list<ProdNColors> addLineItems(list<Partner_Agreement_Products__mdt> lProdsCMDT){
    list<ProdNColors> lProdNColors = new list<ProdNColors>();
    list<selectOption> lcolors = new List<selectOption>();
    system.debug('Adding Line for: ' + lProdsCMDT);
    for(Partner_Agreement_Products__mdt prod : lProdsCMDT){
          //create a selectoption for each color
          lcolors = new List<selectOption>();
          lcolors.add(new selectOption('','--none--'));
          if(prod== null ){break;}
          system.debug('prod id: ' + prod.id);
          system.debug('Total Colors for Prod: ' + mProdlColors.get(prod.id).size());
          
          for(string color : mProdlColors.get(prod.id)){       
              lcolors.add(new SelectOption(color,color));                    
          }      
         // lcolors.add(new SelectOption('Product Loop: '+vProdInteger,'Product Loop: '+vProdInteger));
          //create PA product based on the CMDT product.
          Partner_Agreement_Product__c thisprod = new Partner_Agreement_Product__c(
            Code__c =prod.Code__c,
            Description__c =prod.Description__c,
            Approx_Capacity__c =prod.Approx_Capacity__c,
            Outside_Diameter__c =prod.Outside_Diameter__c,
            Height__c =prod.Height__c,
            Full_Size_Camrack__c =prod.Full_Size_Camrack__c,
            Case_Pack__c =string.valueof(prod.Case_Pack__c),
            Disposable_Lid_Code__c =prod.Disposable_Lid_Code__c,
            Image_Location__c =URL.getSalesforceBaseUrl().toExternalForm() + prod.Image_Location__c,
            //Image_Location__c =prodps://na10.salesforce.com'+ palt.Image_Location__c,
            Free_Goods_Requested_in_Units__c =0,
            Free_Goods_Requested_in_Cases__c=0,
            Free_Goods_Requested_Color_Code__c='N/A',
            Initial_Lid_Order_In_Cases__c=0,
            Other_Case_Pack__c =prod.Other_Case_Pack__c,
            Fits_Shoreline_Products__c =prod.Fits_Shoreline_Products__c
          );
          //Add to Wrapper List
          prdColors.add(new ProdNColors(
            lcolors,
            thisprod        
          ));

        }      
      return lProdNColors;  
  }
  public Integer rowToRemove {get;set;}
  /**
  * @author Brian Kwong - Better Partners 
  * @date 06/17/2019
  * @param None
  * @Description removes a row from PA Prod list
  * @return 
  */
  public void RemoveRow(){
      PrdColors.remove(rowToRemove);
  }

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description Queries the User based on the HealthCare Specialist selected
  * @return 
  */
  public string queryHealthcareSpecialist(){
    string userID = null;
    User u;
    if(vspecialist == ''){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'A Healthcare Specialist must be selected'));  
    }else{        
      system.debug('vspecialist: ' + vspecialist);
      try{
        u = [select id from User where username = :vSpecialist and IsActive = true];
        UserId = u.id;
      }catch(exception e){
        system.debug('Error querying Healthcare Specialists: ' + e);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Healthcare Specialist not found ERROR: ' + string.valueof(e)));        
      }
    }
    return userID;
  }

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description Stores variable selected on the Health Specialist field
  * @return 
  */
  public string vSpecialist{get;set;}

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description Creates the drop down option based on Custom Setting Partner_Agreement_Healthcare_Specialist__c
  * @return 
  */    
  public list<SelectOption> getvSpecialists(){
    list<SelectOption> options = new list<SelectOption>();
    options.add(new selectoption('','--none--'));
    set<string> sEmails = new set<string>();
    map<string,Partner_Agreement_Healthcare_Specialist__c> mSpecialists = Partner_Agreement_Healthcare_Specialist__c.getAll();
    for(Partner_Agreement_Healthcare_Specialist__c PAHS : mSpecialists.values()){
      options.add(new SelectOption(PAHS.Specialist_s_Email__c,PAHS.name));
    }

    return options;
  }

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description stores boolean variable
  * @return 
  */ 
  public boolean renderSuccess {get;set;}

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description List of line items which can be created
  * @return 
  */
  public list<Partner_Agreement_Product__c> PA_Prods {get;set;} 

  /**
  * @author Brian Kwong - Better Partners 
  * @date 04/17/2019
  * @param None
  * @Description Wrapper Class for Products & Color Codes select options
  * @return 
  */
  public class ProdnColors{
    public List<selectOption> Colors{get;set;}
    public Partner_Agreement_Product__c ProdItem {get;set;}
    public prodnColors(list<SelectOption> vcolors, Partner_Agreement_Product__c prod){
      Colors = vcolors;
      ProdItem = prod;
    }
  }
  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description Populates PA_Prods to display all possible line items for the select agreement type
  * @return 
  */  
  public list<ProdnColors> PrdColors {get;set;}
  public  map<id, Partner_Agreement_Products__mdt> mProdMDT = new map<id, Partner_Agreement_Products__mdt>();
  public  map<string, Partner_Agreement_Products__mdt> mProdCodeMDT = new map<string, Partner_Agreement_Products__mdt>();
  public map<string, list<string>> mProdlColors = new map<string, list<string>>();
  public void ManageCMDT(){
    //Query Products from CMDT    
    mProdMDT = new map<id, Partner_Agreement_Products__mdt>([SELECT Agreement_Type__c,Approx_Capacity__c,Case_Pack__c,Code__c,Description__c,
    DeveloperName,Disposable_Lid_Code__c,Full_Size_Camrack__c,Height__c,Id,
    Image_Location__c,MasterLabel,Other_Case_Pack__c,Outside_Diameter__c,
    Reusable_Lid_Capacity__c,QualifiedApiName,Fits_Shoreline_Products__c 
    FROM Partner_Agreement_Products__mdt where Agreement_Type__c = :MyAgreement.Agreement_Type__c]);
    
    for(Partner_Agreement_Products__mdt prod : mProdMDT.values()){
      mProdCodeMDT.put(prod.code__c,prod);
    }

    //Query colors for products CMDT
    mProdlColors = new map<string, list<string>>();
    list<Partner_Agreement_Colors__mdt> colorsMDT =[SELECT Color_Code__c,DeveloperName,Id,MasterLabel,
    Partner_Agreement_Product__c,QualifiedApiName 
    FROM Partner_Agreement_Colors__mdt 
    where Partner_Agreement_Product__c in : mProdMDT.keyset() order by Partner_Agreement_Product__c asc];
    string lastProd = null;

    list<string> ltempcolors = new list<string>();

    for(Partner_Agreement_Colors__mdt cmdt : colorsMDT){
      if(lastprod == null || lastprod == cmdt.Partner_agreement_product__c){
        ltempColors.add(cmdt.Color_code__c);
      }else{
        mProdlColors.put(lastprod,ltempColors);
        ltempColors = new list<string>();
      }
      lastprod = cmdt.Partner_agreement_product__c;
    }
    mProdlColors.put(lastprod,ltempColors);  
  }
  public void RefreshProds(){
    FieldVisibilityControl(); //Decides which fields should be displayed based on AgreementType
    ManageCMDT();
   
    //Create LineItems for visualforce page
    PrdColors = new list<ProdnColors>();
    List<selectOption> lcolors = new List<selectOption>();
    //Loop through products
    integer vProdInteger = 0;
    system.debug('Total Products: ' + mProdMDT.values().size());
    for(Partner_Agreement_Products__mdt prod : mProdMDT.values()){
      //create a selectoption for each color
      lcolors = new List<selectOption>();
      lcolors.add(new selectOption('','--none--'));
      if(mProdlColors.containsKey(prod.id)){
        system.debug('Total Colors for Prod: ' + mProdlColors.get(prod.id).size());
        for(string color : mProdlColors.get(prod.id)){       
            lcolors.add(new SelectOption(color,color));                    
        } 
      }     

      //create PA product based on the CMDT product.
      Partner_Agreement_Product__c thisprod = new Partner_Agreement_Product__c(
        Code__c =prod.Code__c,
        Description__c =prod.Description__c,
        Approx_Capacity__c =prod.Approx_Capacity__c,
        Outside_Diameter__c =prod.Outside_Diameter__c,
        Height__c =prod.Height__c,
        Full_Size_Camrack__c =prod.Full_Size_Camrack__c,
        Case_Pack__c =string.valueof(prod.Case_Pack__c),
        Disposable_Lid_Code__c =prod.Disposable_Lid_Code__c,
        //Image_Location__c =URL.getSalesforceBaseUrl().toExternalForm() + prod.Image_Location__c, //Original comment out for code stream
        Image_Location__c =prod.Image_Location__c,
        Free_Goods_Requested_in_Units__c =0,
        Free_Goods_Requested_in_Cases__c=0,
        Free_Goods_Requested_Color_Code__c='N/A',
        Initial_Lid_Order_In_Cases__c=0,
        Other_Case_Pack__c =prod.Other_Case_Pack__c,
        Fits_Shoreline_Products__c =prod.Fits_Shoreline_Products__c
      );
      //Add to Wrapper List
      prdColors.add(new ProdNColors(
        lcolors,
        thisprod        
      ));

    }
    system.debug('Total Prods post loop: ' + vProdInteger);
  }


  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description 
  * @return 
  */
  public string RecordName {get;set;}
    
  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description 
  * @return 
  */
  public void Submit(){
    system.debug('Creating records');
    MyAgreement.Healthcare_Specialist__c= queryHealthcareSpecialist();
    if(MyAgreement.Healthcare_Specialist__c == null){
        system.debug('Error with Healthcare Specialists: ');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Healthcare Specialist is not set'));        
    }else{
      try{
        insert MyAgreement;         
        
        RecordName =[select name from Partner_Agreement__c where id= :MyAgreement.id].name;
        list<Partner_Agreement_Product__c> PA_Prods_insert = new list<Partner_Agreement_Product__c>();
        
        for(integer i=0; i<prdColors.size(); i++){       
          prdColors[i].ProdItem.Partner_Agreement__c = MyAgreement.id; 
          if(prdColors[i].ProdItem.Free_Goods_Requested_in_Units__c >0
          ||
          prdColors[i].ProdItem.Free_Goods_Requested_in_Cases__c>0
          ||
          prdColors[i].ProdItem.Initial_Lid_Order_In_Cases__c>0){
            PA_Prods_insert.add(prdColors[i].ProdItem);
          }
        }

        insert PA_Prods_insert;

        renderSuccess = true;
        }catch(exception e){
          system.debug('Error Creating Agreement: ' + e);
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning, 'ERROR: ' + string.valueof(e)));
            
      }
    }

  }

  /**
  * @author Brian Kwong - Better Partners 
  * @date 09/15/2015
  * @param None
  * @Description marks the "Send to Rep" box to try then calls the submit method to save the records
  * @return 
  */
  public void SumbitEmailRep(){
    system.debug('Submitting and emailing rep');
    MyAgreement.Send_to_Rep__c = true;
    Submit();
  }
  
  /**
  * @author Brian Kwong - Better Partners 
  * @date 10/27/2015
  * @param None
  * @Description variables and method that controls which fields will be displayed
  * @return 
  */ 
  public boolean DisplayDisposableLidCode {get;set;}
  public boolean DisplayOtherCasePack {get;set;}
  public boolean DisplayCapacity {get;set;}
  public boolean DisplayHeight {get;set;}
  public boolean DisplayCamRack {get;set;}
  public boolean DisplayDiameter {get;set;}
  public boolean DisplayRequestedColorCode {get;set;}
  public boolean DisplayShoreline {get;set;}
  public boolean DisplayLidCapacity {get;set;}
  public string CasePacklabel {get;set;}
  public boolean DisplayRenewal {get;set;} //Added to control renewal visibility. Should only be available PA via the link


  public void FieldVisibilityControl(){
    //default field visibility
    DisplayDisposableLidCode = false;
    DisplayOtherCasePack = false; 
    DisplayCapacity = false; 
    DisplayHeight = false; 
    DisplayCamRack = false; 
    DisplayDiameter  = false;
    DisplayRequestedColorCode = false; 
    DisplayShoreline = false; 
    DisplayLidCapacity  = false;     

    //if(vAgreementType.contains('Mugs')){
    if(MyAgreement.Agreement_Type__c.contains('Mugs')){
      DisplayCapacity=true;
      DisplayDiameter=true;
      DisplayHeight=true;
      DisplayCamRack=true;
      DisplayDisposableLidCode=true;
      DisplayRequestedColorCode=true;
      CasePackLabel = 'Case Pack';
    }else
    //if(vAgreementType=='Tumblers'){
    if(MyAgreement.Agreement_Type__c.contains('Tumblers')){  
      DisplayDisposableLidCode=true;
      DisplayOtherCasePack=true;
      DisplayCapacity=true;
      DisplayHeight=true;
      DisplayCamRack=true;
      DisplayRequestedColorCode=true;
      CasePackLabel = 'Tumbler Case Pack';
    }else
    //if(vAgreementType=='Camlids'){
    if(MyAgreement.Agreement_Type__c.contains('Camlids')){  
      DisplayShoreline=true;
      DisplayCapacity=true;
    }
  }
  
  /**
  * @author Brian Kwong - Better Partners 
  * @date 06/19/2018
  * @param None
  * @Description Get the values from territory picklist on Account for use as a dropdown on the PA page
  * @return 
  */ 
  
  public List<selectOption> getRepGroups(){
    list<selectOption> repGroups = new list<SelectOption>();
   //repGroups.add(null,'--none--');
    Schema.DescribeFieldResult TerritoryDescribe = Account.Territory__c.getDescribe();
    List<Schema.PicklistEntry> ple = TerritoryDescribe.getPicklistValues();
    for(Schema.PicklistEntry f : ple){
      repGroups.add(new SelectOption(f.getLabel(),f.getValue()));
    }
    return repGroups;
  }

//eof    
}