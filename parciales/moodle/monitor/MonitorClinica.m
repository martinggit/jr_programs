_monitor MonitorClinica{

    _var int pacientesEsperando;
    _var int consultoriosLibres; // 3

    _condvar esperaPaciente;
    _condvar esperaConsultorio;

    _proc esperarPaciente(){
        pacientesEsperando++;
        _signal(esperaPaciente); //aviso a recepcion que hay paciente
        _wait(esperaConsultorio); //espero a que me llamen
    }

    _proc recepcionista(){
        while (true){
            while (pacientesEsperando == 0 || consultoriosLibres == 0){
                _wait(esperaPaciente);//espero paciente o consultorio
            }

            //hay almenos un paciente y un consultorio libre
            pacientesEsperando--;
            consultoriosLibres--;
            _signal(esperaConsultorio); //llamo al paciente
        }
    }
    
    _proc finConsulta(){
        consultoriosLibres++;
        if (pacientesEsperando > 0){
            _signal(esperaPaciente);//por si hay 
        }
    }
}
