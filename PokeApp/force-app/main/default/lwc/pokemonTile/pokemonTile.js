import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class PokemonTile extends NavigationMixin(LightningElement) {
	@api pokemon;

    navigateToRecordViewPage() {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.pokemon.Id,
                objectApiName: 'Pokemon__c', // objectApiName is optional
                actionName: 'view'
            }
        });
    }
}