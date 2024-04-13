public class ObtenerPokemones implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    private Integer contadorRegistros = 0;
    private String url = 'https://pokeapi.co/api/v2/pokemon/';
    private List<Integer> listaPokemones;
    public ObtenerPokemones(List<Integer> listaPokemones){
        this.listaPokemones = listaPokemones;
    }
    
    public List<Integer> start(Database.BatchableContext bc) {
        return listaPokemones;
    }
    public void execute(Database.BatchableContext bc, List<Integer> scope){

        // process each batch of records
        try {
            Pokemon__c pokemonObj = new Pokemon__c();
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url + scope[0]);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            HttpResponse response = http.send(request);
            
            Map<String, Object> apiResults = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            pokemonObj.ExtId__c = (Integer) apiResults.get('id');
            String nombreMov = (String) apiResults.get('name');
            pokemonObj.Name = nombreMov.Capitalize();
            pokemonObj.Altura__c = (Double) apiResults.get('height')/10;
            pokemonObj.Peso__c = (Double) apiResults.get('weight')/10;
            // Campo Habilidad
            List<Object> listaHabilidades = (List<Object>) apiResults.get('abilities');
            Map<String, Object> habilidadAleatoria = (Map<String, Object>) listaHabilidades.get((Integer) Math.floor(Math.random()*listaHabilidades.size()));
            Map<String, Object> ability = (Map<String, Object>) habilidadAleatoria.get('ability');
            String nombreHabilidad = (String) ability.get('name');
            Habilidad__c habilidadC = [SELECT Id FROM Habilidad__c 
                                        WHERE Name = :nombreHabilidad LIMIT 1];
            if (habilidadC != null) {
                pokemonObj.Habilidad__c = habilidadC.id;
            }                            
            // Campo Imagen
            Map<String, Object> sprites = (Map<String, Object>) apiResults.get('sprites');
            Map<String, Object> other = (Map<String, Object>) sprites.get('other');
            Map<String, Object> home = (Map<String, Object>) other.get('home');
            pokemonObj.Imagen__c = (String) home.get('front_default');
            // Campo Tipos
            List<Object> listaTipos = (List<Object>) apiResults.get('types');
            Map<String, Object> tipo0 = (Map<String, Object>) listaTipos.get(0);
            Map<String, Object> type0 = (Map<String, Object>) tipo0.get('type');
            String nombreTipo0 = (String) type0.get('name');
            pokemonObj.Tipos__c = nombreTipo0.capitalize();
            if (listaTipos.size() > 1) {
                Map<String, Object> tipo1 = (Map<String, Object>) listaTipos.get(1);
                Map<String, Object> type1 = (Map<String, Object>) tipo1.get('type');
                String nombreTipo1 = (String) type1.get('name');
                pokemonObj.Tipos__c +=';' + nombreTipo1.capitalize();
            }
            // Campo Stats
            List<Object> listaStats = (List<Object>) apiResults.get('stats');
            Map<String, Object> stat0 = (Map<String, Object>) listaStats.get(0);
            Integer vida = (Integer) stat0.get('base_stat');
            pokemonObj.Vida__c = vida;
            Map<String, Object> stat1 = (Map<String, Object>) listaStats.get(1);
            Integer ataque = (Integer) stat1.get('base_stat');
            pokemonObj.Ataque__c = ataque;
            Map<String, Object> stat3 = (Map<String, Object>) listaStats.get(2);
            Integer defensa = (Integer) stat3.get('base_stat');
            pokemonObj.Defensa__c = defensa;
            Map<String, Object> stat5 = (Map<String, Object>) listaStats.get(5);
            Integer velocidad = (Integer) stat5.get('base_stat');
            pokemonObj.Velocidad__c =  velocidad;
            // Campo Movimiento
            List<Object> listaMovimientos = (List<Object>) apiResults.get('moves');
            List<Integer> listAleatorios = new List<Integer>();
            Integer contador = 0;
            while ( contador < listaMovimientos.size() && contador < 4 ){
                Integer numAleatorio = (Integer) Math.floor(Math.random()*listaMovimientos.size());
                if (!(listAleatorios.contains(numAleatorio))) {
                    listAleatorios.add(numAleatorio);
                    contador++;
                }
            }
            if (listaMovimientos.size() > 0){
                Map<String,Object> movimiento0 = (Map<String,Object>) listaMovimientos.get(listAleatorios.get(0));
                Map<String,Object> move = (Map<String, Object>) movimiento0.get('move');
                String nombreMovimiento0 = (String) move.get('name');
                Movimiento__c movimiento0Obj = [SELECT Id FROM Movimiento__c 
                                            WHERE Name = :nombreMovimiento0 LIMIT 1];
                if (movimiento0Obj != null) {
                    pokemonObj.Slot1__c = movimiento0Obj.id;
                }
            }
            if (listaMovimientos.size() > 1){
                Map<String,Object> movimiento1 = (Map<String,Object>) listaMovimientos.get(listAleatorios.get(1));
                Map<String,Object> move = (Map<String, Object>) movimiento1.get('move');
                String nombreMovimiento1 = (String) move.get('name');
                Movimiento__c movimiento1Obj = [SELECT Id FROM Movimiento__c 
                                            WHERE Name = :nombreMovimiento1 LIMIT 1];
                if (movimiento1Obj != null) {
                    pokemonObj.Slot2__c = movimiento1Obj.id;
                }
            }
            if (listaMovimientos.size() > 2){
                Map<String,Object> movimiento2 = (Map<String,Object>) listaMovimientos.get(listAleatorios.get(2));
                Map<String,Object> move = (Map<String, Object>) movimiento2.get('move');
                String nombreMovimiento2 = (String) move.get('name');
                Movimiento__c movimiento2Obj = [SELECT Id FROM Movimiento__c 
                                            WHERE Name = :nombreMovimiento2 LIMIT 1];
                if (movimiento2Obj != null) {
                    pokemonObj.Slot3__c = movimiento2Obj.id;
                }
            }
            if (listaMovimientos.size() > 3){
                Map<String,Object> movimiento3 = (Map<String,Object>) listaMovimientos.get(listAleatorios.get(3));
                Map<String,Object> move = (Map<String, Object>) movimiento3.get('move');
                String nombreMovimiento3 = (String) move.get('name');
                Movimiento__c movimiento3Obj = [SELECT Id FROM Movimiento__c 
                                            WHERE Name = :nombreMovimiento3 LIMIT 1];
                if (movimiento3Obj != null) {
                    pokemonObj.Slot4__c = movimiento3Obj.id;
                }                            
            }

            insert pokemonObj;
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        contadorRegistros++;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('registros procesados: ' + contadorRegistros);
        // Para ejecutar el batch:
        // List<Integer> listNum = new List<Integer>{};
        // for(Integer i = 1 ; i <= 898; i++){
        //     listNum.add(i);
        // }
        // ObtenerPokemones pok = new ObtenerPokemones(listNum);
        // Id batchId = Database.executeBatch(pok, 1);
    }
}