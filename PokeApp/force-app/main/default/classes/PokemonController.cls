public with sharing class PokemonController {
    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> traerPokemonesConFiltro( 
        String nombre, 
        String generacion, 
        String tipo1, 
        String tipo2){

        String query;
        String condicion ='';
        if (String.isNotBlank(nombre)){
            condicion = 'Name LIKE \''+'%' + nombre + '%\'';
        }
        if (String.isNotBlank(generacion)) {
            if (String.isNotBlank(condicion)){
                condicion +=' AND Generacion__c = ' + generacion +'';
            } else {
                condicion +=' Generacion__c = ' + generacion +'';
            }
        }
        if (String.isNotBlank(tipo1)) {
            if(String.isNotBlank(condicion)) {
                condicion += ' AND Tipos__c INCLUDES ' + '(\'' +tipo1 +'\')';
            } else {
                condicion += ' Tipos__c INCLUDES ' + '(\'' +tipo1 +'\')';
            }
        }
        if (String.isNotBlank(tipo2)) {
            if(String.isNotBlank(condicion)) {
                condicion += ' AND Tipos__c INCLUDES ' + '(\'' +tipo2 +'\')';
            } else {
                condicion += ' Tipos__c INCLUDES ' + '(\'' +tipo2 +'\')';
            }
        }
        if (String.isNotBlank(condicion)) {
            query =
                'SELECT ExtId__c, Generacion__c, Habilidad__c, Altura__c, Peso__c, Name, Imagen__c, Imagen_pokemon__c, Tipos__c, Vida__c, Velocidad__c, Defensa__c, Ataque__c FROM Pokemon__c WHERE ' +
                condicion +
                ' ORDER BY ExtId__c';
        } else {
            query = 'SELECT ExtId__c, Generacion__c, Habilidad__c, Altura__c, Peso__c, Name, Imagen__c, Imagen_pokemon__c, Tipos__c, Vida__c, Velocidad__c, Defensa__c, Ataque__c FROM Pokemon__c ORDER BY ExtId__c';
        }
        List<Pokemon__c> pokemones = Database.query(query);

        // if(pokemones.isEmpty()) {
        //     throw new AuraHandledException('No se enocontraron pokemones');
        // }
        return pokemones;
    }
}