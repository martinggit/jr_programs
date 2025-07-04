/*
En la ciudad de Ushuaia, existe un puente de un solo carril que une la ciudad de norte a sur. Durante las
 horas pico, cruzar el puente se vuelve complicado debido a la gran cantidad de autos esperando en ambos
 lados. El cruce se realiza mediante turnos: en cada turno, una cantidad N de vehiculos puede cruzar el
 puente en un solo sentido. Si en un lado no hay autos, se deja via libre para el lado que si tiene vehiculos.
 Usted debera simular un sistema con monitores que asegure que los vehiculos en direcciones contrarias
 no crucen el puente simultaneamente y que gestione el cruce de a lo sumo N vehiculos. Especifique los
 supuestos que asuma.
 */

/*
Objetivo del sistema:
Simular un puente de un solo carril con las siguientes restricciones:
Capacidad maxima de cruce simultaneo: como maximo N vehículos por turno.
Sentido exclusivo: los vehículos solo pueden cruzar en una dirección a la vez.
Acceso alternado: cuando terminan de cruzar los vehículos de un lado (o si no hay más vehículos de ese lado), se cede el paso al otro lado si tiene vehículos esperando.
Evitar inanición (opcional): si un lado siempre tiene autos, no debe bloquear indefinidamente al otro.
*/
_monitor MonitorPuente {
  //CUENTAN LOS AUTOS ESPERANDO DE CADA LADO
    _var int esperandoNorte = 0;
    _var int esperandoSur = 0;
  //CUANTOS AUTOS ESTÁN CRUZANDO ACTUALMENTE (NUNCA MÁS DE N)
    _var int cruzando = 0;
    //AUTOS QUE CRUZARON DURANTE ESTE TURNO(CUANDO LLEGA A N, SE CAMBIA DE LADO)
    _var int cantidadEnTurno =0;
    //SENTIDO DEL CRUCE ACTUAL
    _var String direccionActual = "norte";
    //CAPACIDAD MAXIMA POR TURNO
    _var int N;
    //CONDICIONES DE ESPERAR HASTA PODER CRUZAR
    _condvar puedeCruzarNorte;
    _condvar puedeCruzarSur;

    _proc void llegarNorte(){
        esperandoNorte++;
        //ESPERO SI NO ES MI TURNO O SI YA SE LLEGÓ AL MAXIMO N CRUZANDO
        while (direccionActual != "norte" || cruzando >= N){
            _wait(puedeCruzarNorte);
        }
        esperandoNorte--;
        //AL CRUZAR, DECREMENTO ESPERA E INCREMENTO CRUZANDO Y CANTIDADENTURNO
        cruzando++;
        cantidadEnTurno++;
    }
    
    _proc void salirNorte(){
        cruzando--;//DECREMENTO CRUZANDO
        //CUANDO CRUZANDO == 0 Y SE COMPLETO EL TURNO >= N O NO QUEDAN MAS AUTOS DE MI LADO,
        //CAMBIO DE DIRECCION Y RESETEO CANTIDADENTURNO.
        if (cruzando == 0 && (cantidadEnTurno == N || esperandoNorte == 0) && esperandoSur > 0){
            direccionActual="sur";
            cantidadEnTurno=0;
            _signal_all(puedeCruzarSur);
        } else if (esperandoNorte > 0){
            _signal(puedeCruzarNorte);
        }
    }
    
    _proc void llegarSur() {
      esperandoSur++;
      while (direccionActual != "sur" || cruzando >= N) {
        _wait(puedeCruzarSur);
      }
      esperandoSur--;
      cruzando++;
      cantidadEnTurno++;
      }

  _proc void salirSur() {
      cruzando--;
      if (cruzando == 0 && (cantidadEnTurno >= N || esperandoSur == 0) && esperandoNorte > 0) {
        direccionActual = "norte";
        cantidadEnTurno = 0;
        _signal_all(puedeCruzarNorte);
      } else if (esperandoSur > 0) {
        _signal(puedeCruzarSur);
      }
    }

}