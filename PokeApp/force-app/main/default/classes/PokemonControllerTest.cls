@isTest
public with sharing class PokemonControllerTest {
    @testSetup
    static void setup() {
        Pokemon__c pokemon1 = new Pokemon__c(Name='bulbasaur', ExtId__c = 1, Tipos__c = 'grass;poison');
        insert pokemon1;
        Pokemon__c pokemon2 = new Pokemon__c(Name='venusaur', ExtId__c = 3, Tipos__c = 'grass;poison');
        insert pokemon2;
        Pokemon__c pokemon3 = new Pokemon__c(Name='charizard', ExtId__c = 6, Tipos__c = 'fire;flying');
        insert pokemon3;
        Pokemon__c pokemon4 = new Pokemon__c(Name='pikachu', ExtId__c = 25, Tipos__c = 'electric');
        insert pokemon4;
        Pokemon__c pokemon5 = new Pokemon__c(Name='durant', ExtId__c = 632, Tipos__c = 'bug;steel');
        insert pokemon5;
       
       
        }
    @istest
    static void consultaSinParametros(){
        List<Pokemon__c> pokemones = new List<Pokemon__c>();
        
        Test.startTest();
        pokemones = PokemonController.traerPokemonesConFiltro('', '', '', '');
        Test.stopTest();
        
        List<Pokemon__c> listPoke= [SELECT Id, Generacion__c, Name, ExtId__c, Tipos__c 
        FROM Pokemon__c];
        system.assertEquals(listPoke.size(), 5);
        system.assertEquals(pokemones[0].Name, listPoke[0].Name, 'Los nombres son iguales.' + pokemones[0].Name);
        system.assertEquals(pokemones[1].Name, listPoke[1].Name, 'Los nombres son iguales.' + pokemones[1].Name);
        system.assertEquals(pokemones[2].Name, listPoke[2].Name, 'Los nombres son iguales.' + pokemones[2].Name);
        
    }
    @istest
    static void consultaConUnParametro(){
        List<Pokemon__c> pokemones = new List<Pokemon__c>();
        
        Test.startTest();
        pokemones = PokemonController.traerPokemonesConFiltro('', '', '', 'Electric');
        Test.stopTest();
        
        List<Pokemon__c> listPoke= [SELECT Id, Generacion__c, Name, ExtId__c, Tipos__c 
        FROM Pokemon__c
        WHERE ExtId__c = 25];
        system.assertEquals(listPoke.size(), 1);
		system.assertEquals(pokemones[0].Name, listPoke[0].Name, 'Los nombres son iguales.' + pokemones[0].Name);
    }
    @istest
    static void consultaConDosParametros(){
        List<Pokemon__c> pokemones = new List<Pokemon__c>();
        
        Test.startTest();
        pokemones = PokemonController.traerPokemonesConFiltro('', '', 'grass', 'poison');
        Test.stopTest();
        
        List<Pokemon__c> listPoke= [SELECT Id, Generacion__c, Name, ExtId__c, Tipos__c 
        FROM Pokemon__c
        WHERE Tipos__c INCLUDES('grass;poison')];
        system.assertEquals(listPoke.size(), 2);
		system.assertEquals(pokemones[0].Name, listPoke[0].Name, 'Los nombres son iguales.' + pokemones[0].Name);
    }
    @istest
    static void consultaConTresParametros(){
        List<Pokemon__c> pokemones = new List<Pokemon__c>();
        
        Test.startTest();
        pokemones = PokemonController.traerPokemonesConFiltro('', '1', 'fire', 'flying');
        Test.stopTest();
        
        List<Pokemon__c> listPoke= [SELECT Id, Generacion__c, Name, ExtId__c, Tipos__c 
        FROM Pokemon__c
        WHERE ExtId__c = 6];
        system.assertEquals(listPoke.size(), 1);
		system.assertEquals(pokemones[0].Name, listPoke[0].Name, 'Los nombres son iguales.' + pokemones[0].Name);
    }
    @istest
    static void consultaCoTodosLosParametros(){
        List<Pokemon__c> pokemones = new List<Pokemon__c>();
        
        Test.startTest();
        pokemones = PokemonController.traerPokemonesConFiltro('durant', '5', 'bug', 'steel');
        Test.stopTest();
        
        List<Pokemon__c> listPoke= [SELECT Id, Generacion__c, Name, ExtId__c, Tipos__c 
        FROM Pokemon__c
        WHERE ExtId__c = 632];
        system.assertEquals(listPoke.size(), 1);
		system.assertEquals(pokemones[0].Name, listPoke[0].Name, 'Los nombres son iguales.' + pokemones[0].Name);

    }
}