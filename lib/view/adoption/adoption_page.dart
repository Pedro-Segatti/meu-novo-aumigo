import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: AdoptionForm(),
  ));
}

class AdoptionForm extends StatefulWidget {
  @override
  _AdoptionFormState createState() => _AdoptionFormState();
}

class _AdoptionFormState extends State<AdoptionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedAnimalType;
  String? _selectedBehavior;
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Adoção de Animal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecione o tipo de animal:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedAnimalType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedAnimalType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione o tipo de animal';
                    }
                    return null;
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Cachorro',
                      child: Text('Cachorro'),
                    ),
                    DropdownMenuItem(
                      value: 'Gato',
                      child: Text('Gato'),
                    ),
                    DropdownMenuItem(
                      value: 'Outros',
                      child: Text('Outros'),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  'Comportamento do animal:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Calmo',
                      groupValue: _selectedBehavior,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedBehavior = value;
                        });
                      },
                    ),
                    Text('Calmo'),
                    Radio(
                      value: 'Agitado',
                      groupValue: _selectedBehavior,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedBehavior = value;
                        });
                      },
                    ),
                    Text('Agitado'),
                  ],
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite uma descrição';
                    }
                    return null;
                  },
                  maxLines: 4,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseFirestore.instance
                                .collection('adoptions')
                                .add({
                              'animalType': _selectedAnimalType,
                              'behavior': _selectedBehavior,
                              'description': _descriptionController.text,
                            });
                            setState(() {
                              _selectedAnimalType = null;
                              _selectedBehavior = null;
                              _descriptionController = TextEditingController();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registro salvo com sucesso!'),
                              ),
                            );
                          } catch (e) {
                            print('Erro ao enviar os dados: $e');
                          }
                        }
                      },
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchDocumentData() async {
    if (_selectedAnimalType != null && _selectedAnimalType!.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('adoptions')
            .where('animalType', isEqualTo: _selectedAnimalType)
            .get();
        // Lógica para exibir os dados recuperados do Firebase Firestore
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          print('ID: ${documentSnapshot.id}');
          print('Tipo de Animal: ${documentSnapshot['animalType']}');
          print('Comportamento: ${documentSnapshot['behavior']}');
          print('Descrição: ${documentSnapshot['description']}');
        }
      } catch (e) {
        print('Erro ao buscar os dados: $e');
      }
    } else {
      print('Por favor, insira o tipo de animal.');
    }
  }
}
