_monitor MonitorPizzeria{
  final String[] ingredientes = {'Salsa', 'Queso', 'Morrón'};
  String[]pizza = new String[3];

  int faltante = -1;
  
  _var boolean pizzaLista = true;
  _var ooolean faltaIngrediente = false;

  _condvar pizzaIncompleta; // signal cuando faltaIngrediente = true
  _condvar ingredienteAgregado; // signal cuando pizzaLista = true

  _proc void prepararMasa(){
    while (!pizzaLista){
      _wait(ingredienteAgregado);
    }
    faltante = (int)(Math.random()*3); //Falta uno al azar
    
    for (int i = 0; i<3 ;i++) { // Para cada ingrediente necesario de la pizza
      if (i != faltante) { // Si no es el que falta 
        pizza[i] = ingredientes[i] // El pizzero agrega los otros dos
      } else {
        pizza[i]=null;
      }
    }
    faltaIngrediente = true;
    pizzaLista = false;
    _signal(pizzaIncompleta);    
    }
  

 _proc void agregarIngrediente(int idIngrediente){
    while (!faltaIngrediente || idIngrediente != faltante){
      _wait(pizzaIncompleta);
    }
    pizza[idIngrediente] = ingrediente[idIngrediente];

    faltaIngrediente = false;
    pizzaLista = true;
    _signal(ingredienteAgregado);//Despierto al pizzero
  }

}