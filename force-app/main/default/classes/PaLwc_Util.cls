public with sharing class PaLwc_Util {

    @AuraEnabled(cacheable=true) 
    public static list<Partner_Agreement_Product__c> FindPaProds(){
        //method runs if all I do is a soql. It fails if I do DML after removing cachable=true. 
        //base on debug log looks like the method isn't called
        system.debug('grabbing products');
        list<Partner_Agreement_Product__c> lProds = new list<Partner_Agreement_Product__c>();
        //Hard code a record URL so I can really get the damn thing working
        string paid = 'a023i0000038GJvAAM';
        /*
        //temporary PA just to get this damn thing working
        Partner_agreement__c PA = new Partner_agreement__c (
            Agreement_Type__c = 'The Wizard News'
        );
        insert PA;       
        paid = pa.id;         
        system.debug('PaID: ' + PA.id);
         */
         /*
        list<Partner_Agreement_Products__mdt> lProdsMDT =[SELECT Agreement_Type__c,Approx_Capacity__c,Case_Pack__c,Code__c,Description__c,
            DeveloperName,Disposable_Lid_Code__c,Full_Size_Camrack__c,Height__c,Id,
            Image_Location__c,MasterLabel,Other_Case_Pack__c,Outside_Diameter__c,
            Reusable_Lid_Capacity__c,QualifiedApiName,Fits_Shoreline_Products__c 
            FROM Partner_Agreement_Products__mdt where Agreement_Type__c = 'The Wizard News'];   
        system.debug('CMDT size: ' + lProdsMDT.size());
        for(Partner_Agreement_Products__mdt prod : lProdsMDT){
           lProds.add(new Partner_Agreement_Product__c(
                Code__c =prod.Code__c,
                Description__c =prod.Description__c,
                Image_Location__c =URL.getSalesforceBaseUrl().toExternalForm() + prod.Image_Location__c,                
                Quantity__c =0,
                Partner_Agreement__c = paid
           ));            
        }        
        insert lprods;
        system.debug('prods size: ' + lProds.size());
        */
        //Soql Existing record because the above wasn't working. 
        lProds = [select code__c, description__c, id, Image_Location__c, Quantity__c from Partner_Agreement_Product__c where Partner_Agreement__c = :paid];
        return lprods;
    }
    
}
