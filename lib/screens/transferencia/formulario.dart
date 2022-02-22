import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';

const _titleAppBar = 'Criando Transferências';
const _rotuloCampoValor = 'Valor';
const _rotuloNumeroConta = 'Numero da Conta';
const _dicaCampoNumeroConta = '0000';
const _dicaCampoValor = '0,00';
const _buttonConfirmar = 'Confirmar';
const _textMessage = 'Entre com os dados corretamente!';
const _titleMessage = 'Transferência';




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
        title: const Text(_titleAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
                controlador:_controladorCampoNumeroConta,
                dica: _dicaCampoNumeroConta,
                rotulo: _rotuloNumeroConta),
            Editor(
                controlador: _controladorCampoValor,
                dica: _dicaCampoValor,
                rotulo: _rotuloCampoValor,
                icone: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _criaTransferencia(context),
              child: const Text(_buttonConfirmar),),
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
        content: const Text(_titleMessage),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '$_rotuloNumeroConta: $numeroConta, $_rotuloCampoValor:$valor',
          onPressed: (){},
        ),
      ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Atenção'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: _textMessage,
          onPressed: (){},
        ),
      ),
      );
    }
  }
}