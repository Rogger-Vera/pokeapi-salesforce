import { LightningElement, wire, track } from 'lwc';
import traerPokemonesF from "@salesforce/apex/PokemonController.traerPokemonesConFiltro"

export default class PokemonList extends LightningElement {
	nombre = '';
    tipo1 = ''; 
	tipo2 = '';
	generacion = null;
	@track pokemones = [];
	pokemonesVisibles;
	numeroDePokemones;
	error;
	@track todosLosTipos = [];

	generacionOpciones = [
		{ label: 'Todas', value: ''},
		{ label: 'Generación 1', value: '1' },
		{ label: 'Generación 2', value: '2' },
		{ label: 'Generación 3', value: '3' },
		{ label: 'Generación 4', value: '4' },
		{ label: 'Generación 5', value: '5' },
		{ label: 'Generación 6', value: '6' },
		{ label: 'Generación 7', value: '7' },
		{ label: 'Generación 8', value: '8' }
	]
	
	tiposOpciones = [
		{ label : 'Todos', value: 'Todos'},
		{ label : 'Bug (Bicho)', value: 'Bug'},
		{ label : 'Dark (Oscuro)', value: 'Dark'},
		{ label : 'Dragon (Dragón)', value: 'Dragon'},
		{ label : 'Electric (Eléctrico)', value: 'Electric'},
		{ label : 'Fairy (Hada)', value: 'Fairy'},
		{ label : 'Fighting (Luchador)', value: 'Fighting'},
		{ label : 'Fire (Fuego)', value: 'Fire'},
		{ label : 'Flying (Volador)', value: 'Flying'},
		{ label : 'Ghost (Fantasma)', value: 'Ghost'},
		{ label : 'Grass (Planta)', value: 'Grass'},
		{ label : 'Ground (Tierra)', value: 'Ground'},
		{ label : 'Ice (Hielo)', value: 'Ice'},
		{ label : 'Normal (Normal)', value: 'Normal'},
		{ label : 'Poison (Veneno)', value: 'Poison'},
		{ label : 'Psychic (Psíquico)', value: 'Psychic'},
		{ label : 'Rock (Roca)', value: 'Rock'},
		{ label : 'Steel (Acero)', value: 'Steel'},
		{ label : 'Water (Agua)', value: 'Water'}
	]
	
	get tieneResultados() {
		return this.numeroDePokemones > 0;
	}
	
    @wire(traerPokemonesF, {
        nombre: "$nombre",
        generacion: "$generacion",
        tipo1: "$tipo1",
		tipo2: "$tipo2"
    })

	wiredPokemones({error, data}) {
		if (data) {
			console.log('Datos ', data);
			console.log('json Data', JSON.stringify(data));
			this.pokemones = data;
            this.error = undefined;
        } else if (error) {
			this.error = error;
            this.pokemones = undefined;
        }
		this.numeroDePokemones = this.pokemones.length;
	}

	handleInputChange(event) {
		const textoABuscar = event.target.value;
		this.nombre = textoABuscar;
	}
	
	handleTiposChange(event) {
		const tipoSeleccionado = event.target.value;
		
		if(tipoSeleccionado == 'Todos'){
			this.tipo1 = '';
			this.tipo2 = '';
			this.todosLosTipos = [];
		}
		if(!this.todosLosTipos.includes(tipoSeleccionado)
		&& tipoSeleccionado != 'Todos'
		&& this.tipo2 != tipoSeleccionado
		&& this.tipo1 == ''){
			this.tipo1 = tipoSeleccionado;
			this.todosLosTipos.push(tipoSeleccionado);
		} 
		if(!this.todosLosTipos.includes(tipoSeleccionado)
		&& tipoSeleccionado != 'Todos' 
		&& this.tipo1 != tipoSeleccionado
		&& this.tipo2 == ''){
			this.tipo2 = tipoSeleccionado;
			this.todosLosTipos.push(tipoSeleccionado);
		}
	}

	handleTiposRemove(event){
		const tipoRemovido = event.target.name;
		if (this.tipo1 == tipoRemovido){
			this.tipo1 = '';
		}
		if (this.tipo2 == tipoRemovido){
			this.tipo2 = '';
		}
		this.todosLosTipos.splice(this.todosLosTipos.indexOf(tipoRemovido),1);
	}

    handleGeneracionChange(event){
		this.generacion = event.target.value
    }

	handlerUpdatePokemon(event){
		this.pokemonesVisibles = [...event.detail.pokemonespag]
	}


}