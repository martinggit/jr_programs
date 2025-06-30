_monitor MonitorLibro {
  // Inicializar variables locales
  _var int lectores = 0;
  _var int escritores= 0;

  // Recurso compartido
  private String [] textos = {"Texto 0", "Texto 1", "Texto 2", "Texto 3"};
  private String texto = textos[0];

  // Variables de condición
  _condvar okParaLeer;
  _condvar okParaEscribir;

  // Procedimientos
  _proc String solicitarLectura(){
    while(escritores > 0) { //si hay escritores espero que me den el ok para leer
      _wait(okParaLeer);
    }
    lectores += 1; //1 lector mas leyendo
    _return texto;
  }

  _proc void liberarLectura(){
    lectores -= 1; //termino de leer y me voy
    if (lectores == 0){ //si no hay lectores aviso que se puede escribir
      _signal(okParaEscribir);
    }
  }

  _proc void solicitarEscritura(int escritor){
    texto = textos[escritor];
    while(escritores > 0 && lectores > 0){//si no hay nadie escribiendo ni leyendo
      _wait(okParaEscribir);//espero mientras me dan el ok para escribir
    }
    escritores += 1;//aviso que estoy escribiendo
    System.out.println("El Escritor " + escritor + " escribe: '" + texto + "'.");
  }

  _proc void liberarEscritura(){
    escritores -= 1;//termino de escribir y me voy
    _signal(okParaEscribir); _signal_all(okParaLeer);//aviso que pueden escribir y aviso que pueden leer
  }

}