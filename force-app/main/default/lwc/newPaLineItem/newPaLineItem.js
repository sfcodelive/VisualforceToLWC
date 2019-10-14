import { LightningElement, api } from 'lwc';

export default class NewPaLineItem extends LightningElement {
  @api partneragreementid

  onSuccess(event) {
    event.preventDefault();  
    const selectEvent = new CustomEvent('select', {
        detail: event.detail.id
    });
    
    this.dispatchEvent(selectEvent);
  }
}
