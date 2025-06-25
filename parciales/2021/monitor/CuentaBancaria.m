_monitor CuentaBancaria{
    _var int saldoCuenta;
    _var int sumatoriaDepositos;
    _var int sumatoriaExtracciones;
    _var boolean hayEsperandoParaExtraer;

    _condvar puedeExtraer;


    _proc void deposit(int montoD){
        sumatoriaDepositos+=montoD;
        saldoCuenta+=montoD;
        if (hayEsperandoParaExtraer){
            _signal(puedeExtraer); //Despierta a quien estaba esperando para una extraccion
        }
    }

    _proc void extraction(int montoE){
    while (saldoCuenta < montoE){
        hayEsperandoParaExtraer=true;
        _wait(puedeExtraer);
    }
    sumatoriaExtracciones+=montoE;
    saldoCuenta-=montoE;
    }
}