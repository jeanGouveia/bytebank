import 'package:flutter/material.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';

class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = <Transferencia>[];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencias>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transferências"),
        ),
        body: ListView.builder(
            itemCount: widget._transferencias.length,
            itemBuilder: (BuildContext context, int indice){
              final transferencia = widget._transferencias[indice];
              return ItemTransferencia(transferencia);
            }
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            final Future future = Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return FormularioTransferencia();
                }));
            future.then((transferenciaRecebida) {
              //Future.delayed(Duration(seconds: 1),(){
                _atualiza(transferenciaRecebida);
             // });
            });
          },
        )
    );
  }

  void _atualiza(transferenciaRecebida) {
    if(transferenciaRecebida != null) {
      setState(() {//meio de atualização da tela do bild
        widget._transferencias.add(transferenciaRecebida);
      });
    
    }
  }
}

class ItemTransferencia extends StatelessWidget {

  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}