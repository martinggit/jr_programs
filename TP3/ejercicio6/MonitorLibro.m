_monitor MonitorLibro {
  // Inicializar variables locales
  private int lectores = 0;
  private int escritores = 0;
  private int escritoresEsperando=0; //uso esta variable para llevar la cuenta
  //de los escritores que quieren escribir pero no estan activos

  // Recurso compartido
  private String [] textos = {"Texto 0", "Texto 1", "Texto 2", "Texto 3"};
  private String texto = textos[0];

  // Variables de condición
  _condvar okParaLeer;
  _condvar okParaEscribir;

  // Procedimientos
  _proc String solicitarLectura(){//bloqueo si hay escritor activo o esperando
    while (escritores > 0 || escritoresEsperando > 0) {
      _wait(okParaLeer);
    }
    lectores += 1;
    _return texto;
  }
  //evito que entren nuevos lectores si hay algún escritor activo o esperando
  //permito que un escritor que está esperando entre en cuanto termine la lectura actual.

  _proc void liberarLectura(){
    lectores -= 1;
    if (lectores == 0){
      _signal(okParaEscribir);//Doy paso a escritores si no hay más lectores
    }
  }

  _proc void solicitarEscritura(int escritor){
    escritoresEsperando++;//marcamos que hay escritores en espera, lo que frena la entrada de lectores
    while (escritores> 0 || lectores > 0){
      System.out.println("El Escritor " + escritor + " espera '");
      _wait(okParaEscribir); 
    }
    escritoresEsperando--;
    texto = textos[escritor];
    escritores += 1;
    System.out.println("El Escritor " + escritor + " escribe: '" + texto + "'.");
  }

  _proc void liberarEscritura(){
    escritores -= 1;
    if (escritoresEsperando > 0){
      _signal(okParaEscribir);//prioridad a otro escritor
    } else {
      _signal_all(okParaLeer);//si no hay escritores esperando, lectores leen
    }
  }

}