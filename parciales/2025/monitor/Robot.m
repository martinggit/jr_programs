/*
Una farmacia con alta demanda y una búsqueda lenta de medicamentos decide implementar un sistema de robots para agilizar el proceso de búsqueda y entrega. 
La farmacia se organiza en tres zonas: estantes (zona de búsqueda), pasillo de tránsito y zona de entrega. 
Cuando un cliente solicita un medicamento, un robot toma la solicitud y accede de a uno a la zona de búsqueda; 
una vez que encuentra el medicamento, libera el acceso para que otro robot pueda ingresar. 
Luego, el robot se desplaza por el pasillo junto con otros (puede haber varios en tránsito al mismo tiempo), 
y finalmente accede de a uno y por orden de llegada a la zona de entrega, donde entrega el medicamento al cliente. 
Algunos robots son más lentos que otros, lo cual puede afectar los tiempos de tránsito. 
Si la solicitud es urgente, se activa un "robot de entrega urgente", que tiene prioridad total y acceso exclusivo a cualquier zona, 
incluso si hay otros robots en tránsito o esperando: estos deben detenerse hasta que el robot urgente complete su tarea. 
Además, se debe llevar un contador global de medicamentos entregados. 
Para resolver este problema, se debe usar un monitor que garantice la exclusión mutua y sincronización. 
Especifique los supuestos que asuma.
*/

_monitor Robot {
    _var int estandarEsperando;
    _var int urgenteEsperando;
    _var int urgenteEsperandoEntregar;
    _var int estandarEsperandoEntregar;
    _var int medicamentosEntregados;
    
    _var boolean estandarBuscando;
    _var boolean estandarEntregando;
    _var boolean urgenteEntregando;
    _var boolean urgenteBuscando;

    _condvar puedoBuscar;
    _condvar puedoEntregar;
    _condvar puedoBuscarUrgente;
    _condvar puedoEntregarUrgente;
 

    _proc void solicitudEstadar(){
        estandarEsperando++
        while (estandarBuscando || urgenteBuscando || urgenteEsperando > 0){
            _wait(puedoBuscar);
        }
        estandarEsperando--;
        estandarBuscando = true;
        //Busco y encuentro medicamento
        estandarBuscando = false;
        if (urgenteEsperando > 0){
            _signal(puedoBuscarUrgente);
        } else if (estandarEsperando > 0) {
            _signal(puedoBuscar);
        }
    }
    
    _proc void finalizarEstandar(){
        estandarEsperandoEntregar++
        while(estandarEntregando || urgenteEntregando || urgenteEsperandoEntregar > 0)
            _wait(puedoEntregar);
        estandarEsperandoEntregar--;
        estandarEntregando = true;
        //Entrego medicamento
        medicamentosEntregados++;
        estandarEntregando = false;
        if (urgenteEsperandoEntregar > 0){
            _signal(puedoEntregarUrgente);
        } else if (estandarEsperandoEntregar > 0) {
            _signal(puedoEntregar);
        }
    }

    _proc void solicitudUrgente(){
        urgenteEsperando++
        while (urgenteBuscando){
            _wait(puedoBuscarUrgente);
        }
        urgenteEsperando--;
        urgenteBuscando = true;
        //Busco y encuentro medicamento
        urgenteBuscando = false;
        if (urgenteEsperando > 0){
            _signal(puedoBuscarUrgente);
        } else if (estandarEsperando > 0) {
            _signal(puedoBuscar);
        }
    }
    
    _proc void finalizarUrgente(){
        urgenteEsperandoEntregar++
        while(urgenteEntregando)
            _wait(puedoEntregarUrgente);
        urgenteEsperandoEntregar--;
        urgenteEntregando= true;
        //Entrego medicamento
        medicamentosEntregados++;
        urgenteEntregando= false;
        if (urgenteEsperandoEntregar > 0){
            _signal(puedoEntregarUrgente);
        } else if (estandarEsperandoEntregar > 0) {
            _signal(puedoEntregar);
        }
    }
}