import { LightningElement, api } from 'lwc';

export default class NewPaLineItem extends LightningElement {
  @api partneragreementid

  customsubmit(event){
    event.preventDefault();       // stop the form from submitting
    const fields = event.detail.fields;
    fields.partner_agreement__c  = this.recordId;
    this.template.querySelector('lightning-record-edit-form').submit(fields);
  }

  onSuccess(event) {
    event.preventDefault();  
    const selectEvent = new CustomEvent('select', {
        detail: event.detail.id
    });
    
    this.dispatchEvent(selectEvent);
  }
}
