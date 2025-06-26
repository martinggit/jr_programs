_monitor MonitorSki{
    _var int M; //cantidad M de esquiadores permitidos en pista
    _var int maxVips; //cantidad maxima de 2 vips en pista
    _var int cant_esq; //cantidad actual de esquiadores
    _var int vipsEsperando;
    _var int estandarEsperando;

    _condvar puedeEntrarE;
    _condvar puedeSalirE;


    _proc void accesoEstandar(){
        estandarEsperando++;
        while (vipsEsperando > 0 || cant_esq >= M ){
            _wait(puedeEntrarE);
        }
        estandarEsperando--;
        cant_esq++;
    }

    _proc void accesoVip(){
        vipsEsperando++;
        while (cant_esq >= M || maxVips > 2){
            _wait(puedeEntrarV);
        }
        vipsEsperando--;
        maxVips++;
        cant_esq++;
    }

    _proc void salidaEstandar(){
        cant_esq--;
        if (vipsEsperando > 0 && maxVips < 2){
            _signal(puedeEntrarV);
        } 
        else if (estandarEsperando > 0){
            _signal(puedeEntrarE);
        }
    }

    _proc void salidaVip(){
        cant_esq--;
        maxVips--;
        if (vipsEsperando > 0 && maxVips < 2){
            _signal(puedeEntrarV);
        } 
        else if (estandarEsperando > 0){
            _signal(puedeEntrarE);
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
_monitor MonitorSki{
    _var int M; //capacidad maxima de esquiadores en pista
    _var int enPista = 0;
    _var int vipsEnPista=0;
    _var int vipsEsperando = 0;
    _var int estandarEsperando =0;

    _condvar puedeEntrarE;
    _condvar puedeEntrarV;

    _proc void accesoEstandar(){
        estandarEsperando++;
        while(vipsEnPista > 0 || enPista >= M){
            _wait(puedeEntrarE); //mientras haya vips en pista o hayan M en pista espero
        }
        estandarEsperando--;
        enPista++;
    }

    _proc void salidaEstandar(){
        enPista--;
        if(vipsEsperando > 0 && enPista == 0){
            _signal(puedeEntrarV);
        } else {
            _signal(puedeEntrarE);
        }
    }

    _proc void accesoVip(){
        vipsEsperando++;
        while (enPista > 0|| vipsEnPista>=2){
            _wait(puedeEntrarV);
        }
        vipsEsperando--;
        vipsEnPista++;
        enPista++;
        if (vipsEnPista < 2 && vipsEsperando > 0){
            _signal(puedeEntrarV);
        }
        
    }

    _proc void acceso(){
        enPista--;
        vipsEnPista--;
        if(vipsEsperando > 0 && enPista==0 && vipsEnPista < 2){
            _signal(puedeEntrarV);
        } else if{
            _signal(puedeEntrarE);
        }
    }
}