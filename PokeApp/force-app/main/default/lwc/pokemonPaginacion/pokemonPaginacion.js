import { LightningElement, api } from 'lwc';

export default class PokemonPaginacion extends LightningElement {
    
    totalPokemones = [];
    tamañoPagina = 9;
    paginaActual = 1;
    paginasTotal = 0;
    
    @api
    set pokemonespag(data){
        if (data) {
            this.totalPokemones = data;
            this.paginasTotal = Math.ceil(data.length / this.tamañoPagina)
            this.actualizarRegistrosPok();
        }
    }
    
    get pokemonespag(){
        return this.pokemonesVisibles;
    }

    get deshabilitarBotonPrevius(){
        return this.paginaActual <= 1;
    }

    get deshabilitarBotonNext(){
        return this.paginaActual >= this.paginasTotal;
    }

    actualizarRegistrosPok(){
        const inicio = (this.paginaActual-1) * this.tamañoPagina;
        const final = this.paginaActual * this.tamañoPagina;
        this.pokemonesVisibles = this.totalPokemones.slice(inicio, final);
        this.dispatchEvent(new CustomEvent('update',{
            detail:{
                pokemonespag: this.pokemonesVisibles
            }
        }))
    }

    handlerPrevius(){
        if (this.paginaActual > 1) {
            this.paginaActual -= 1;
            this.actualizarRegistrosPok();
        }
    }

    handlerNext(){
        if (this.paginaActual < this.paginasTotal) {
            this.paginaActual += 1;
            this.actualizarRegistrosPok();
        }
    }


}