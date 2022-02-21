import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(BytebankApp());

class BytebankApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        ),
      ),
      home: ListaTransferencias(),
    );
  }
}


class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return FormularioTransferenciaState();
  }

}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferências'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
                controlador:_controladorCampoNumeroConta,
                dica: '0000',
                rotulo: 'Numero da Conta'),
            Editor(
                controlador: _controladorCampoValor,
                dica: '0,00',
                rotulo: 'Valor',
                icone: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _criaTransferencia(context),
              child: Text('Confirmar'),),
          ],
        ),
      ),

    );
  }

  void _criaTransferencia(BuildContext context) {
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    _controladorCampoValor.text = _controladorCampoValor.text.replaceAll(',', '.');
    final double? valor = double.tryParse(_controladorCampoValor.text);
    if(numeroConta != null && valor != null){
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context,transferenciaCriada);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Transferência'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Conta: $numeroConta, Valor:$valor',
          onPressed: (){},
        ),
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Atenção'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Entre com os dados corretamente!',
          onPressed: (){},
        ),
      ));
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData? icone;

  Editor({required this.controlador, required this.rotulo, required this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
            fontSize: 24.0
        ),
        decoration: InputDecoration(
            icon: icone != null ? Icon(icone) : null,
            labelText: rotulo,
            hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


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
          title: Text("Transferências"),
        ),
        body: ListView.builder(
            itemCount: widget._transferencias.length,
            itemBuilder: (BuildContext context, int indice){
              final transferencia = widget._transferencias[indice];
              return ItemTransferencia(transferencia);
            }
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            final Future future = Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return FormularioTransferencia();
                }));
            future.then((transferenciaRecebida) {
              Future.delayed(Duration(seconds: 1),(){
                debugPrint('Chegou no then do future');
                debugPrint('$transferenciaRecebida');
                if(transferenciaRecebida != null) {
                  setState(() {//meio de atualização da tela do bild
                    widget._transferencias.add(transferenciaRecebida);
                  });

                }
              });
            });
          },
        )
    );
  }
}

class ItemTransferencia extends StatelessWidget {

  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia{
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{numeroConta: $numeroConta, valor: $valor}';
  }
}