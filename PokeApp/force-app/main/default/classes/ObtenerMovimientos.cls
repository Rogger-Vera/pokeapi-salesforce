public class ObtenerMovimientos implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    private Integer contadorRegistros = 0;
    private String url = 'https://pokeapi.co/api/v2/move/';
    private List<Integer> listaMoviemientos;
    public ObtenerMovimientos(List<Integer> listaMoviemientos){
        this.listaMoviemientos = listaMoviemientos;
    }
    public List<Integer> start(Database.BatchableContext bc) {
        return listaMoviemientos;
    }
    public void execute(Database.BatchableContext bc, List<Integer> scope){

        // process each batch of records
        try {
            Movimiento__c movimientoObj = new Movimiento__c();
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url + scope[0]);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            HttpResponse response = http.send(request);
            
            Map<String, Object> apiResults = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            String nombreMov = (String) apiResults.get('name');
            movimientoObj.Name = nombreMov.Capitalize();
            movimientoObj.ExtId__c = (Integer) apiResults.get('id');
            movimientoObj.Punteria__c = (Integer) apiResults.get('accuracy');
            movimientoObj.Chance_efecto__c = (Integer) apiResults.get('effect_chance');
            Map<String, Object> target = (Map<String, Object>) apiResults.get('target');
            movimientoObj.Objetivo__c = (String) target.get('name');
            movimientoObj.Prioridad__c = (Integer) apiResults.get('priority');
            List<Object> listEfectoEntries = (List<Object>) apiResults.get('effect_entries');
            if (listEfectoEntries.size() > 0) {
                Map<String, Object> efectEntries = (Map<String, Object>) listEfectoEntries.get(0);
                movimientoObj.Efecto__c = (String) efectEntries.get('short_effect');
            }
            movimientoObj.Poder__c = (Integer) apiResults.get('power');
            movimientoObj.Pp__c = (Integer) apiResults.get('pp');
            Map<String, Object> tipo = (Map<String, Object>) apiResults.get('type');
            movimientoObj.Tipo__c = (String) tipo.get('name');

            insert movimientoObj;
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        contadorRegistros++;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('registros procesados: ' + contadorRegistros);
        System.debug('Batch finalizado');
        // Para ejecutar el batch:
        // List<Integer> listNum = new List<Integer>{};
        // for(Integer i = 1 ; i <= 826; i++){
        //     listNum.add(i);
        // }
        // ObtenerMovimientos mov = new ObtenerMovimientos(listNum);
        // Id batchId = Database.executeBatch(mov, 1);
    }
}