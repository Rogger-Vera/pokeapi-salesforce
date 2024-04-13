@isTest
private with sharing class ObtenerPokemonesTest {
    @testSetup
    static void setup() {
              
        Habilidad__c habilidad1 = new Habilidad__c(Name = 'Overgrow');
        insert habilidad1;
        Movimiento__c movimiento1 = new Movimiento__c(Name = 'Razor-wind');
        insert movimiento1;
        Movimiento__c movimiento2 = new Movimiento__c(Name = 'Swords-dance');
        insert movimiento2;
        Movimiento__c movimiento3 = new Movimiento__c(Name = 'Cut');
        insert movimiento3;
        Movimiento__c movimiento4 = new Movimiento__c(Name = 'Bind');
        insert movimiento4;
        
    }
    @isTest 
    static void deberiaInsertarPokemon() {
        SingleRequestMock respuestaFalsa = new SingleRequestMock(200,
                                                               'OK',
                                                               '{"abilities":[{"ability":{"name":"overgrow","url":"https://pokeapi.co/api/v2/ability/65/"},"is_hidden":false,"slot":1}],"height":7,"id":1,"moves":[{"move":{"name":"razor-wind","url":"https://pokeapi.co/api/v2/move/13/"}},{"move":{"name":"swords-dance","url":"https://pokeapi.co/api/v2/move/14/"}},{"move":{"name":"cut","url":"https://pokeapi.co/api/v2/move/15/"}},{"move":{"name":"bind","url":"https://pokeapi.co/api/v2/move/20/"}}],"name":"bulbasaur","sprites":{"back_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png","back_female":null,"back_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png","back_shiny_female":null,"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png","front_female":null,"front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png","front_shiny_female":null,"other":{"dream_world":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg","front_female":null},"home":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png","front_female":null,"front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png","front_shiny_female":null},"official-artwork":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"}}},"stats":[{"base_stat":45,"effort":0,"stat":{"name":"hp","url":"https://pokeapi.co/api/v2/stat/1/"}},{"base_stat":49,"effort":0,"stat":{"name":"attack","url":"https://pokeapi.co/api/v2/stat/2/"}},{"base_stat":49,"effort":0,"stat":{"name":"defense","url":"https://pokeapi.co/api/v2/stat/3/"}},{"base_stat":65,"effort":1,"stat":{"name":"special-attack","url":"https://pokeapi.co/api/v2/stat/4/"}},{"base_stat":65,"effort":0,"stat":{"name":"special-defense","url":"https://pokeapi.co/api/v2/stat/5/"}},{"base_stat":45,"effort":0,"stat":{"name":"speed","url":"https://pokeapi.co/api/v2/stat/6/"}}],"types":[{"slot":1,"type":{"name":"grass","url":"https://pokeapi.co/api/v2/type/12/"}},{"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}],"weight":69}',
                                                                null);
        Test.setMock(HttpCalloutMock.class, respuestaFalsa);
        Test.startTest();
        List<Integer> listNum = new List<Integer>{};
        for(Integer i = 1 ; i <= 1; i++){
            listNum.add(i);
        }
        ObtenerPokemones pok = new ObtenerPokemones(listNum);
        Id batchId = Database.executeBatch(pok, 1);
        Test.stopTest();
        List<Pokemon__c> listaPokemones = [SELECT Id, Name, ExtId__c, Generacion__c, 
                            Altura__C, Peso__c, Habilidad__c, Tipos__c, Vida__c, Defensa__c, Ataque__c,
                            Velocidad__c, Imagen__c, Slot1__c, Slot2__c, Slot3__c, Slot4__c
                            FROM Pokemon__c
                            LIMIT 1];
        System.assertEquals('Bulbasaur', listaPokemones[0].Name, 'El nombre del pokemon es ' + listaPokemones[0].Name);
        System.assertEquals(1, listaPokemones[0].ExtId__c, 'El Id externo del pokemon es ' + listaPokemones[0].ExtId__c);
        System.assertEquals(1, listaPokemones[0].Generacion__c, 'El Id externo del pokemon es ' + listaPokemones[0].Generacion__c);
        System.assertEquals('Poison;Grass', listaPokemones[0].Tipos__c, 'Los tipos del pokemon son ' + listaPokemones[0].Tipos__c);
        System.assertEquals('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png', listaPokemones[0].Imagen__c, 'La imagnen del pokemon es ' + listaPokemones[0].Imagen__c);
        System.assertEquals(6.9, listaPokemones[0].Peso__c, 'El peso del pokemon es ' + listaPokemones[0].Peso__c);
        System.assertEquals(0.7, listaPokemones[0].Altura__c, 'La altura del pokemon es ' + listaPokemones[0].Altura__c);
        System.assertEquals(45, listaPokemones[0].Vida__c, 'La vida del pokemon es ' + listaPokemones[0].Vida__c);
        System.assertEquals(45, listaPokemones[0].Velocidad__c, 'La velocidad del pokemon es ' + listaPokemones[0].Velocidad__c);
        System.assertEquals(49, listaPokemones[0].Defensa__c, 'La defensa del pokemon es ' + listaPokemones[0].Defensa__c);
        System.assertEquals(49, listaPokemones[0].Ataque__c, 'El ataque del pokemon es ' + listaPokemones[0].Ataque__c);
        // System.assertNotEquals('a00Dn000005xpcgIAA', listaPokemones[0].Habilidad__c, 'La habilidad del pokemon es ' + listaPokemones[0].Habilidad__c);
        // System.assertNotEquals(null, listaPokemones[0].Slot1__c, 'El movimiento 1 del pokemon es ' + listaPokemones[0].Slot1__c);
        // System.assertNotEquals(null, listaPokemones[0].Slot2__c, 'El movimienton 2 del pokemon es ' + listaPokemones[0].Slot2__c);
        // System.assertNotEquals(null, listaPokemones[0].Slot3__c, 'El movimiento 3 del pokemon es ' + listaPokemones[0].Slot3__c);
        // System.assertNotEquals(null, listaPokemones[0].Slot4__c, 'El movimiento 4 del pokemon es ' + listaPokemones[0].Slot4__c);
    }
    @isTest 
    static void noDeberiaInsertarPokemon() {
        SingleRequestMock respuestaFalsa = new SingleRequestMock(404,
                                                               'Not Found',
                                                               '',
                                                                null);
        Test.setMock(HttpCalloutMock.class, respuestaFalsa);   
        Test.startTest();
        List<Integer> listNum = new List<Integer>{};
        for(Integer i = 1 ; i <= 1; i++){
            listNum.add(i);
        }
        ObtenerPokemones pok = new ObtenerPokemones(listNum);
        Id batchId = Database.executeBatch(pok, 1);
        Test.stopTest();
        List<Pokemon__c> listaPokemones = [SELECT Id, Name, ExtId__c, Generacion__c, 
                            Altura__C, Peso__c, Habilidad__c, Tipos__c, Vida__c, Defensa__c, Ataque__c,
                            Velocidad__c, Imagen__c, Slot1__c, Slot2__c, Slot3__c, Slot4__c
                            FROM Pokemon__c
                            LIMIT 1];
        System.assertEquals(0, listaPokemones.size(), 'No hay pokemones insertados');
    }
}