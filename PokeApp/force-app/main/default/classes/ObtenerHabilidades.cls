public class ObtenerHabilidades implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    private Integer contadorRegistros = 0;
    private String url = 'https://pokeapi.co/api/v2/ability/';
    private List<Integer> listaHabilidades;
    public ObtenerHabilidades(List<Integer> listaHabilidades){
        this.listaHabilidades = listaHabilidades;
    }
    
    public List<Integer> start(Database.BatchableContext bc) {
        return listaHabilidades;
    }
    public void execute(Database.BatchableContext bc, List<Integer> scope){

        // process each batch of records
        try {
            Habilidad__c habilidadObj = new Habilidad__c();

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url + scope[0]);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            HttpResponse response = http.send(request);
            
            Map<String, Object> apiResults = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            String nombreHab = (String) apiResults.get('name');
            habilidadObj.Name = nombreHab.Capitalize();
            habilidadObj.ExtId__c = (Integer) apiResults.get('id');
            
            List<Object> listEfectoEntries = (List<Object>) apiResults.get('effect_entries');
            if (listEfectoEntries.size() > 0) {
                for (Integer i = 0; i < listEfectoEntries.size(); i++) {
                    Map<String,Object> efecto = (Map<String,Object>) listEfectoEntries.get(i);
                    Map<String,Object> lenguaje = (Map<String,Object>) efecto.get('language');
                    String lengName = (String) lenguaje.get('name');
                    if (lengName.equals('en')){
                        String efectoCorto = (String) efecto.get('short_effect');
                        habilidadObj.Efecto_corto__c = efectoCorto;
                    }
                }
            }
            
            insert habilidadObj;
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        contadorRegistros++;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('registros procesados: ' + contadorRegistros);
        // Para ejecutar el batch:
        // List<Integer> listNum = new List<Integer>{};
        // for(Integer i = 1 ; i <= 267; i++){
        //     listNum.add(i);
        // }
        // ObtenerHabilidades ha = new ObtenerHabilidades(listNum);
        // Id batchId = Database.executeBatch(ha, 1);
        
    }
}