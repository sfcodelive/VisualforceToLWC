import { LightningElement, wire,track,api} from 'lwc';

import findlineitems from '@salesforce/apex/PaLwc_Util.FindPaProds';

export default class paProdRow extends LightningElement {
    @api partneragreementid;
    @track lineitems;
    @track error;

    @wire(findlineitems, { partnerAgreementId: '$partneragreementid' })
    wiredlineitems({error, data}){
        if(data){
            this.lineitems=data;
            this.error=undefined;
        }else if(error){
            this.error=error;
            this.lineitems=undefined;
        }
    } 
    handleSelect(event) {
        this.lineitems = null;
    }
/*  
    lineitems = [
        {
            id: 'a013i000007H2yQAAS',
            name: 'PAP-00000',
            //Product_Image__c: ,
            Image_Location__c: 'https://thewizardnews.com/uploads/2018/10/wn-fb-blue1.png' ,
            Code__c: 'Blog' ,
            Description__c: 'A blog on Salesforce' ,
            Quantity__c: 5 
        },
        {
            id: 'a013i000007H2yRAAS',
            name: 'PAP-00001',
            //Product_Image__c: ,
            Image_Location__c: 'https://thewizardnews.com/uploads/2014/01/salesforce-wizard-oct-2008.jpg' ,
            Code__c: 'WizardCombo' ,
            Description__c: 'A full combo' ,
            Quantity__c: 2 
        }        
    ];
    */
}