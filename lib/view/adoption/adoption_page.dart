import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_novo_aumigo/models/adoptions.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';

class AdoptionForm extends StatefulWidget {
  final Map<String, dynamic>? adoption;

  const AdoptionForm({Key? key, this.adoption}) : super(key: key);
  
  @override
  _AdoptionFormState createState() => _AdoptionFormState(adoption: adoption);
}

class _AdoptionFormState extends State<AdoptionForm> {
  Map<String, dynamic>? adoption;

  _AdoptionFormState({this.adoption});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedAnimalType = "Cachorro";
  String? _selectedBehavior = "Calmo";
  String? _selectedAnimalSex = "Macho";
  String? _selectedAnimalSize = "Pequeno";
  List<File> _images = [];
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _vaccinesAndMedicinesController =
      TextEditingController();
  TextEditingController _diseasesController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _familyInfoController = TextEditingController();
  bool _hasName = true;

  @override
  void initState() {
    super.initState();
    adoption = widget.adoption;
    _formKey = GlobalKey<FormState>();
    if ( adoption != null ) {
      _selectedAnimalType = adoption?['animalType'] ?? "Cachorro";
      _selectedBehavior = adoption?['behavior'] ?? "Calmo";
      _selectedAnimalSex = adoption?['sex'] ?? "Macho";
      _selectedAnimalSize = adoption?['size'] ?? "Pequeno";
      _descriptionController = TextEditingController(text: adoption?['description']);
      _nameController = TextEditingController(text: adoption?['name']);
      _ageController = TextEditingController(text: adoption?['age']);
      _vaccinesAndMedicinesController = TextEditingController(text: adoption?['vaccinesAndMedicines']);
      _diseasesController = TextEditingController(text: adoption?['diseases']);
      _weightController = TextEditingController(text: adoption?['weight']);
      _familyInfoController = TextEditingController(text: adoption?['familyInfo']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _auth = context.read<AuthService>();
    var _userBd = _auth.userBD;

    return Scaffold(
      appBar: TopBar(),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
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
                  items: const [
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
                  decoration: InputDecoration(
                    labelText: 'Tipo de Animal',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black54), // Cor do texto do rótulo
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.deepOrange), // Defina a cor desejada aqui
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(
                              0xFFb85b20)), // Cor das bordas quando não está em foco
                    ),
                  ),
                ),
                const Text(
                  'O animal possui nome?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                        value: true,
                        groupValue: _hasName,
                        onChanged: (bool? value) {
                          setState(() {
                            _hasName = value!;
                          });
                        },
                        activeColor: Color(0xFFb85b20)),
                    const Text('Sim'),
                    Radio(
                        value: false,
                        groupValue: _hasName,
                        onChanged: (bool? value) {
                          setState(() {
                            _hasName = value!;
                            if (!_hasName) {
                              _nameController.text = '';
                            }
                          });
                        },
                        activeColor: Color(0xFFb85b20)),
                    const Text('Não'),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _nameController,
                  enabled: _hasName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black54), // Cor do texto do rótulo
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.deepOrange), // Defina a cor desejada aqui
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(
                              0xFFb85b20)), // Cor das bordas quando não está em foco
                    ),
                    labelText: 'Nome',
                  ),
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: _selectedAnimalSex,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedAnimalSex = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione o tipo de animal';
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Macho',
                      child: Text('Macho'),
                    ),
                    DropdownMenuItem(
                      value: 'Fêmea',
                      child: Text('Fêmea'),
                    ),
                    DropdownMenuItem(
                      value: 'Não identificado',
                      child: Text('Não identificado'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black54), // Cor do texto do rótulo
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.deepOrange), // Defina a cor desejada aqui
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(
                              0xFFb85b20)), // Cor das bordas quando não está em foco
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Idade',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.black54), // Cor do texto do rótulo
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .deepOrange), // Defina a cor desejada aqui
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(
                                0xFFb85b20)), // Cor das bordas quando não está em foco
                      ),
                    )),
                const SizedBox(height: 20.0),
                TextFormField(
                    controller: _vaccinesAndMedicinesController,
                    decoration: const InputDecoration(
                      labelText: 'Informações sobre vacinas/medicamentos',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.black54), // Cor do texto do rótulo
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .deepOrange), // Defina a cor desejada aqui
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(
                                0xFFb85b20)), // Cor das bordas quando não está em foco
                      ),
                    ),
                    maxLines: 4),
                const SizedBox(height: 20.0),
                TextFormField(
                    controller: _diseasesController,
                    decoration: const InputDecoration(
                      labelText: 'Informações sobre doenças',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.black54), // Cor do texto do rótulo
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .deepOrange), // Defina a cor desejada aqui
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(
                                0xFFb85b20)), // Cor das bordas quando não está em foco
                      ),
                    ),
                    maxLines: 4),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: _selectedAnimalSize,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedAnimalSize = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione o tipo de animal';
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Pequeno',
                      child: Text('Pequeno'),
                    ),
                    DropdownMenuItem(
                      value: 'Médio',
                      child: Text('Médio'),
                    ),
                    DropdownMenuItem(
                      value: 'Grande',
                      child: Text('Grande'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Porte',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _familyInfoController,
                  decoration: const InputDecoration(
                    labelText: 'Informações familiares',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
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
                      activeColor: Color(0xFFb85b20),
                    ),
                    const Text('Calmo'),
                    Radio(
                        value: 'Agitado',
                        groupValue: _selectedBehavior,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedBehavior = value;
                          });
                        },
                        activeColor: Color(0xFFb85b20)),
                    const Text('Agitado'),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Adicionar Imagens',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _images.length) {
                      return IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.getImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _images.add(File(pickedFile.path));
                            });
                          }
                        },
                        icon: Icon(Icons.add),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                        child: Image.file(
                          _images[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          List<String> imageUrls = [];

                          try {
                            for (File image in _images) {
                              String imageName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              firebase_storage.Reference ref = firebase_storage
                                  .FirebaseStorage.instance
                                  .ref()
                                  .child('images')
                                  .child('$imageName.jpg');
                              await ref.putFile(image);

                              String imageUrl = await ref.getDownloadURL();
                              imageUrls.add(imageUrl);
                            }
                          } catch (error) {
                            print('Erro ao enviar imagens: $error');
                          }

                          try {
                            Adoptions adoption = Adoptions(
                                animalType: _selectedAnimalType ?? "",
                                size: _selectedAnimalSize ?? "",
                                behavior: _selectedBehavior,
                                description: _descriptionController.text,
                                name: _nameController.text,
                                sex: _selectedAnimalSex ?? "",
                                age: _ageController.text,
                                vaccinesAndMedicines:
                                    _vaccinesAndMedicinesController.text,
                                diseases: _diseasesController.text,
                                weight: _weightController.text,
                                familyInfo: _familyInfoController.text,
                                adopted: false,
                                images: imageUrls,
                                userId: _userBd?.id);
                            await FirebaseFirestore.instance
                                .collection('adoptions')
                                .add(adoption.toJson());
                            setState(() {
                              _selectedAnimalType = "Cachorro";
                              _selectedBehavior = "calmo";
                              _selectedAnimalSex = "Macho";
                              _selectedAnimalSize = "Pequeno";
                              _images = [];
                              _descriptionController = TextEditingController();
                              _nameController = TextEditingController();
                              _ageController = TextEditingController();
                              _vaccinesAndMedicinesController =
                                  TextEditingController();
                              _diseasesController = TextEditingController();
                              _weightController = TextEditingController();
                              _familyInfoController = TextEditingController();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registro salvo com sucesso!'),
                              ),
                            );
                          } catch (e) {
                            print('Erro ao enviar os dados: $e');
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFb85b20)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
