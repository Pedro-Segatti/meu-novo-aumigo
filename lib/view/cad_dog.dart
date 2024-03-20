import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/modelos/model.dart';
import 'package:projeto_integrador_6/provider/add_lista.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class cad_dog extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _dadosForm = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cãodastro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Campo inválido';
                  return null;
                },
                onSaved: (value) => _dadosForm['nome'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Idade'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Campo inválido';
                  return null;
                },
                onSaved: (value) => _dadosForm['idade'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Campo inválido';
                  return null;
                },
                onSaved: (value) => _dadosForm['descricao'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Caminho da imagem (assets/img/arquivo.png)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Campo inválido';
                  return null;
                },
                onSaved: (value) => _dadosForm['avatar'] = value!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final valido = _form.currentState?.validate();
                    if (valido!) {
                      _form.currentState?.save();
                      Provider.of<add_lista>(context, listen: false).put(
                        model(
                          id: _dadosForm['id']!,
                          nome: _dadosForm['nome']!,
                          idade: _dadosForm['idade']!,
                          descricao: _dadosForm['descricao']!,
                          avatar: _dadosForm['avatar']!,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
