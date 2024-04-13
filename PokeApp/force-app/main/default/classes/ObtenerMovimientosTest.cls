@isTest
public with sharing class ObtenerMovimientosTest {
    @isTest
    static void deberiaInsertarMovimientoConEffectEntries() {
       SingleRequestMock respuestaFalsa = new SingleRequestMock(200,
                                                              'OK',
                                                              '{"accuracy":100,"effect_chance":null,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"pound","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}',
                                                               null);
        Test.setMock(HttpCalloutMock.class, respuestaFalsa); 
        Test.startTest();
        List<Integer> listNum = new List<Integer>{};
            for(Integer i = 1 ; i <= 1; i++){
                listNum.add(i);
            }
            ObtenerMovimientos mov = new ObtenerMovimientos(listNum);
            Id batchId = Database.executeBatch(mov, 1);
        Test.stopTest();
        List<Movimiento__c> listaMovimientos = [SELECT Id, Name, ExtId__c, Chance_efecto__c, Objetivo__c, Punteria__c, Prioridad__c, Poder__c, Pp__c, Efecto__c
                                FROM Movimiento__c
                                LIMIT 1];
        System.assertEquals('Pound', listaMovimientos[0].Name, 'El nombre del movimiento es ' + listaMovimientos[0].Name);
        System.assertEquals(1, listaMovimientos[0].ExtId__c, 'El Id externo del movimiento es ' + listaMovimientos[0].ExtId__c);
        System.assertEquals('Inflicts regular damage with no additional effect.', listaMovimientos[0].Efecto__c, 'El efecto del moviemiento es ' + listaMovimientos[0].Efecto__c);
   }

   @isTest
    static void deberiaInsertarMovimientoSinEffectEntries() {
       SingleRequestMock respuestaFalsa = new SingleRequestMock(200,
                                                              'OK',
                                                              '{"accuracy":100,"effect_chance":null,"effect_entries":[],"id":1,"name":"pound","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}',
                                                               null);
       Test.setMock(HttpCalloutMock.class, respuestaFalsa); 
       Test.startTest();
       List<Integer> listNum = new List<Integer>{};
        for(Integer i = 1 ; i <= 1; i++){
            listNum.add(i);
        }
        ObtenerMovimientos mov = new ObtenerMovimientos(listNum);
        Id batchId = Database.executeBatch(mov, 1);
       Test.stopTest();
       List<Movimiento__c> listaMovimientos = [SELECT Id, Name, ExtId__c, Chance_efecto__c, Objetivo__c, Punteria__c, Prioridad__c, Poder__c, Pp__c, Efecto__c
                            FROM Movimiento__c
                            LIMIT 1];
       System.assertEquals('Pound', listaMovimientos[0].Name, 'El nombre del movimiento es ' + listaMovimientos[0].Name);
       System.assertEquals(1, listaMovimientos[0].ExtId__c, 'El Id externo del movimiento es ' + listaMovimientos[0].ExtId__c);
       System.assertEquals(null, listaMovimientos[0].Efecto__c, 'Este movimimento no tiene efecto');
   }

   @isTest
    static void noDeberiaInsertarMovimiento() {
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
        ObtenerMovimientos mov = new ObtenerMovimientos(listNum);
        Id batchId = Database.executeBatch(mov, 1);
       Test.stopTest();
       List<Movimiento__c> listaMovimientos = [SELECT Id, Name, ExtId__c, Chance_efecto__c, Objetivo__c, Punteria__c, Prioridad__c, Poder__c, Pp__c, Efecto__c
                            FROM Movimiento__c
                            LIMIT 1];
       System.assertEquals(0, listaMovimientos.size(), 'No hay movimientos insertados.');
   }
}