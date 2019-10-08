import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class PartnerAgreement extends LightningElement {
  @track partnerAgreementId

  handleSuccess(event){
    this.partnerAgreementId = event.detail.id;
    
  }

}