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
    if(escritores > 0) {
      _wait(okParaLeer);
    }
    lectores += 1;
    _return texto;
  }

  _proc void liberarLectura(){
    lectores -= 1;
    if (lectores == 0){
      _signal(okParaEscribir);
    }
  }

  _proc void solicitarEscritura(int escritor){
    if(escritores > 0 && lectores > 0 && !(_empty(okParaLeer))){
      System.out.println("El Escritor " + escritor + " espera '");
      _wait(okParaEscribir);
    }
    texto = textos[escritor];
    escritores += 1;
    System.out.println("El Escritor " + escritor + " escribe: '" + texto + "'.");
  }

  _proc void liberarEscritura(){
    escritores -= 1;
    _signal_all(okParaLeer); _signal(okParaEscribir); 
  }

}