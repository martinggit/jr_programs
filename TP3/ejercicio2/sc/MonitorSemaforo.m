// Definir el monitor
_monitor MonitorSemaforo {
  // Inicializar variable local 
  // (simulando el contador del semáforo)
  private static int valor = 1;

  // Definir variable de condición
  _condvar recurso;

  // Simular el wait del semáforo
  _proc void semWait(){
    while(valor == 0) {
      _wait(recurso);
    }
    valor -= 1;
  }

  // Simular el signal del semáforo
  _proc void semSignal(){
    valor += 1;
    _signal(recurso);
  }
}