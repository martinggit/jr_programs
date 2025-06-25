_monitor LecCalEsc {
    _var int dato1;
    _var int dato2;
    _var int resultado;

    _var boolean hayDato1=false;
    _var boolean hayDato2 = false;
    _var boolean hayResultado = false;

    _condvar puedeCalcular;
    _condvar puedeEscribir;
    _condvar puedeL1;
    _condvar puedeL2;

    _proc void ponerDato1(int d1){
        while (hayDato1){
            _wait(puedeL1);
        }
        dato1=d1;
        hayDato1 = true;
        if (hayDato2){
            _signal(puedeCalcular);
        }
    }

    _proc void ponerDato2(int d2) {
        while (hayDato2) {
            _wait(puedeL2);
        }
        dato2 = d2;
        hayDato2 = true;
        if (hayDato1) {
            _signal(puedeCalcular);
        }
    }

    _proc void calcular() {
        while (!(hayDato1 && hayDato2)) {
            _wait(puedeCalcular);
        }
        resultado = dato1 + dato2;
        hayResultado = true;
        hayDato1 = false;
        hayDato2 = false;

        _signal(puedeEscribir);
        _signal(puedeL1);
        _signal(puedeL2);
    }

    _proc int obtenerResultado() {
        while (!hayResultado) {
            _wait(puedeEscribir);
        }
        hayResultado = false;
        return resultado;
    }
}