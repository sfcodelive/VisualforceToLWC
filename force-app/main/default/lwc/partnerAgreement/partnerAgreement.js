import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createDefaultRows from '@salesforce/apex/PaLwc_Util.createDefaultRows';

export default class PartnerAgreement extends LightningElement {
  @track partnerAgreementId

  handleSuccess(event){
    createDefaultRows({ partnerAgreementId: event.detail.id })
      .then(result => {
        this.partnerAgreementId = event.detail.id;
      })
      .catch(error => {
        const evt = new ShowToastEvent({
            title: "An error has occured",
            message: "Failed to create default rows for partnership agreement id: " + event.detail.id,
            variant: "error"
        });
        this.dispatchEvent(evt);
      })
  }

}