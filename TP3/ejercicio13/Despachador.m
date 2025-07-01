_monitor Despachador {
  
  _var boolean cpu0Libre = true;
  _var boolean cpu1Libre = true;
  _var int asignacionesCPU0 = 0;
  _var int asignacionesCPU1 = 0;

  _condvar esperaCPU;

  _proc int adquirirCPU(int pid) {
    while (!cpu0Libre && !cpu1Libre) {//mientras no haya ningun CPU libre espero
      _wait(esperaCPU);
    }

    if (cpu0Libre) {
      cpu0Libre = false;
      asignacionesCPU0++;
      System.out.println("Proceso " + pid + " asignado a CPU0");
      _return 0;
    } else {
      cpu1Libre = false;
      asignacionesCPU1++;
      System.out.println("Proceso " + pid + " asignado a CPU1");
      _return 1;
    }
  }

  _proc void liberarCPU(int cpu) {
    if (cpu == 0) {
      cpu0Libre = true;
      System.out.println("CPU0 liberada");
    } else {
      cpu1Libre = true;
      System.out.println("CPU1 liberada");
    }
    _signal(esperaCPU);
  }

  _proc void mostrarEstadisticas() {
    System.out.println("Asignaciones CPU0: " + asignacionesCPU0);
    System.out.println("Asignaciones CPU1: " + asignacionesCPU1);
  }
}
