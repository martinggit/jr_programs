_monitor MonitorLibro {
  // Inicializar variables locales
  private int lectores = 0;
  private int escritores = 0;

  // Recurso compartido
  private String [] textos = {"Texto escrito 0", "Texto escrito 1", "Texto escrito 2", "Texto escrito 3"};
  private String texto = textos[0];

  // Variables de condición
  _condvar okParaLeer;
  _condvar okParaEscribir;

  // Procedimientos
  _proc String solicitarLectura(){
    if(escritores > 0) { //lector espera si hay un escritor escribiendo
      _wait(okParaLeer);
    }
    lectores += 1;
    _return texto;
  }

  _proc void liberarLectura(){
    lectores -= 1;
    if (lectores == 0){//si no hay lectores aviso que se puede escribir
      _signal(okParaEscribir);
    }
  }

  _proc void solicitarEscritura(int escritor){
    if(escritores > 0 && lectores > 0 && !(_empty(okParaLeer))){ //escritores esperan si hay lectores o escritores
      System.out.println("El Escritor " + escritor + " espera '");
      _wait(okParaEscribir);
    }
    texto = textos[escritor];
    escritores += 1;
    System.out.println("El Escritor " + escritor + " escribe: '" + texto + "'.");
  }

  _proc void liberarEscritura(){
    escritores -= 1; //termino de escribir y ya no hay escritores activos
    _signal_all(okParaLeer); 
    _signal(okParaEscribir);//una vez escrito despierto a todos los lectores y escritores sin prioridad
    //signal all porque puede haber muchos lectores esperando.
    //cuando no hay escritores activos, seguro hay varios lectores leyendo al mismo tiempo
    //lectura concurrente permitida
    //solo un escritor puede escribir a la vez, entonces despierto a un solo escritor
  }
}