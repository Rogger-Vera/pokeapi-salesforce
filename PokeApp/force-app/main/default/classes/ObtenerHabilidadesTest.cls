@isTest
public with sharing class ObtenerHabilidadesTest {
    @isTest
    static void habilidadInsertadaConEfectoEnIngles() {
        SingleRequestMock respuestaFalsa = new SingleRequestMock(200,
                                                               'OK',
                                                               '{"effect_entries":[{"effect":"Attacken die Schaden","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":"Mit jedem Treffer"},{"effect":"This Pokemons damaging move.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Has a 10% chance of making target Pokémon flinch with each hit."}],"id":1,"name":"stench"}',
                                                                null);
        // SingleRequestMock respuestaFalsa2 = new SingleRequestMock(200,
        //                                                         'OK',
        //                                                         '{"effect_entries":[{"effect":"Das weather ändert sich","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":"Ändert beim Betreten"},{"effect":"The weather changes.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Summons rain that lasts indefinitely upon entering battle."}],"id":2,"name":"drizzle"}',
        //                                                          null);                                                        
        
        // Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        // endpoint2TestResp.put('https://pokeapi.co/api/v2/ability/1',respuestaFalsa1);
        // endpoint2TestResp.put('https://pokeapi.co/api/v2/ability/2',respuestaFalsa2);

        // HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, respuestaFalsa); 
        Test.startTest();
        List<Integer> listNum = new List<Integer>{};
        for(Integer i = 1 ; i <= 1; i++){
            listNum.add(i);
        }
        ObtenerHabilidades ha = new ObtenerHabilidades(listNum);
        Id batchId = Database.executeBatch(ha, 1);
        Test.stopTest();
        List<Habilidad__c> listaHabilidades = [SELECT Id, Name, ExtId__c, Efecto_corto__c 
                              FROM Habilidad__c 
                              LIMIT 2];
        System.assertEquals('Stench', listaHabilidades[0].name, 'El nombre de la habilidad es ' + listaHabilidades[0].name);
        System.assertEquals(1, listaHabilidades[0].ExtId__c, 'El Id externo de la habilidad es ' + listaHabilidades[0].ExtId__c);
        System.assertEquals('Has a 10% chance of making target Pokémon flinch with each hit.', listaHabilidades[0].Efecto_corto__c, 'El efecto de la habilidad es ' + listaHabilidades[0].Efecto_corto__c);
        
        // System.assertEquals('drizzle', listaHabilidades[1].name, 'El nombre de la habilidad es ' + listaHabilidades[1].name);
        // System.assertEquals(2, listaHabilidades[1].ExtId__c, 'El Id externo de la habilidad es ' + listaHabilidades[1].ExtId__c);
        // System.assertEquals('Summons rain that lasts indefinitely upon entering battle.', listaHabilidades[1].Efecto_corto__c, 'El efecto de la habilidad es ' + listaHabilidades[1].Efecto_corto__c);
    }

    static void  habilidadInsertadaSinEfectoEnIngles() {
        SingleRequestMock respuestaFalsa = new SingleRequestMock(200,
                                                               'OK',
                                                               '{"effect_entries":[{"effect":"Attacken die Schaden","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":"Mit jedem Treffer"}],"id":1,"name":"stench"}',
                                                                null);
        Test.setMock(HttpCalloutMock.class, respuestaFalsa); 
        Test.startTest();
        List<Integer> listNum = new List<Integer>{};
        for(Integer i = 1 ; i <= 1; i++){
            listNum.add(i);
        }
        ObtenerHabilidades ha = new ObtenerHabilidades(listNum);
        Id batchId = Database.executeBatch(ha, 1);
        Test.stopTest();
        List<Habilidad__c> listaHabilidades = [SELECT Id, Name, ExtId__c, Efecto_corto__c 
                              FROM Habilidad__c 
                              LIMIT 1];
        System.assertEquals('Stench', listaHabilidades[0].name, 'El nombre de la habilidad es ' + listaHabilidades[0].name);
        System.assertEquals(1, listaHabilidades[0].ExtId__c, 'El Id externo de la habilidad es ' + listaHabilidades[0].ExtId__c);
        System.assertEquals('', listaHabilidades[0].Efecto_corto__c, 'Esta habilidad no tiene un efecto en ingles.');
    }

    static void  habilidadNoInsertada() {
        SingleRequestMock respuestaFalsa = new SingleRequestMock(404,
                                                               'OK',
                                                               'Not Fount',
                                                                null);
        Test.setMock(HttpCalloutMock.class, respuestaFalsa); 
        Test.startTest();
        List<Integer> listNum = new List<Integer>{};
        for(Integer i = 1 ; i <= 1; i++){
            listNum.add(i);
        }
        ObtenerHabilidades ha = new ObtenerHabilidades(listNum);
        Id batchId = Database.executeBatch(ha, 1);
        Test.stopTest();
        List<Habilidad__c> listaHabilidades = [SELECT Id, Name, ExtId__c, Efecto_corto__c 
                              FROM Habilidad__c 
                              LIMIT 1];
        System.assertEquals(0, listaHabilidades.size(), 'No hay habilidades insertadas');
    }

}