import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:path_provider/path_provider.dart';

class AdoptionForm extends StatefulWidget {
  final Map<String, dynamic>? adoption;
  final String? firebaseId;

  const AdoptionForm({Key? key, this.adoption, this.firebaseId}) : super(key: key);

  @override
  _AdoptionFormState createState() => _AdoptionFormState(adoption: adoption, firebaseId: firebaseId);
}

class _AdoptionFormState extends State<AdoptionForm> {
  Map<String, dynamic>? adoption;
  final String? firebaseId;

  _AdoptionFormState({this.adoption, this.firebaseId});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedAnimalType = "Cachorro";
  String? _selectedBehavior = "Calmo";
  String? _selectedAnimalSex = "Macho";
  String? _selectedAnimalSize = "Pequeno";
  List<String> _imageUrls = [];
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _vaccinesAndMedicinesController = TextEditingController();
  TextEditingController _diseasesController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _familyInfoController = TextEditingController();
  bool _hasName = true;
  bool _isAdopted = false;

  @override
  void initState() {
    super.initState();
    adoption = widget.adoption;
    _formKey = GlobalKey<FormState>();
    if (adoption != null) {
      _selectedAnimalType = adoption?['animalType'] ?? "Cachorro";
      _selectedBehavior = adoption?['behavior'] ?? "Calmo";
      _selectedAnimalSex = adoption?['sex'] ?? "Macho";
      _selectedAnimalSize = adoption?['size'] ?? "Pequeno";
      _descriptionController = TextEditingController(text: adoption?['description']);
      List<dynamic> dynamicImageUrls =  adoption?['images'] ?? [];
      List<String> imageUrls = dynamicImageUrls.map((url) => url.toString()).toList();
      _imageUrls = imageUrls;
      _nameController = TextEditingController(text: adoption?['name']);
      _ageController = TextEditingController(text: adoption?['age']);
      _vaccinesAndMedicinesController =
          TextEditingController(text: adoption?['vaccinesAndMedicines']);
      _diseasesController = TextEditingController(text: adoption?['diseases']);
      _weightController = TextEditingController(text: adoption?['weight']);
      _familyInfoController = TextEditingController(text: adoption?['familyInfo']);
    }
  }

  void resetVariables() {
    setState(() {
      _selectedAnimalType = "Cachorro";
      _selectedBehavior = "calmo";
      _selectedAnimalSex = "Macho";
      _selectedAnimalSize = "Pequeno";
      _imageUrls = [];
      _descriptionController = TextEditingController();
      _nameController = TextEditingController();
      _ageController = TextEditingController();
      _vaccinesAndMedicinesController =
          TextEditingController();
      _diseasesController = TextEditingController();
      _weightController = TextEditingController();
      _familyInfoController = TextEditingController();
    });
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
                Visibility(
                  visible: firebaseId != null,
                  child: const Text(
                    'O animal foi adotado?',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                ),),
                Visibility(
                  visible: firebaseId != null,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: _isAdopted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAdopted = value!;
                              });
                            },
                            activeColor: Color(0xFFb85b20)
                          ),
                          Text('Sim'),
                          Radio(
                            value: false,
                            groupValue: _isAdopted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAdopted = value!;
                              });
                            },
                            activeColor: Color(0xFFb85b20)
                          ),
                          Text('Não'),
                        ],
                      ),
                    ],
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                const Text(
                  'Adicionar Imagens',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _imageUrls.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _imageUrls.length) {
                      return IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            File image = File(pickedFile.path);
                            try {
                              String imageName = DateTime.now().millisecondsSinceEpoch.toString();
                              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images').child('$imageName.jpg');
                              
                              // Mostrar indicador de carregamento enquanto a imagem está sendo enviada
                              showDialog(
                                context: context,
                                barrierDismissible: false, // Impede que o usuário feche o diálogo
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              
                              await ref.putFile(image);
                              String imageUrl = await ref.getDownloadURL();
                              setState(() {
                                _imageUrls.add(imageUrl);
                              });
                            } catch (error) {
                              print('Erro ao enviar imagem: $error');
                            } finally {
                              // Fechar o diálogo de indicador de carregamento quando o processo de envio for concluído
                              Navigator.pop(context);
                            }
                          }
                        },
                        icon: Icon(Icons.add),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          // Exibir uma caixa de diálogo de confirmação antes de remover a imagem
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Remover Imagem"),
                                content: Text("Tem certeza que deseja remover esta imagem?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fechar a caixa de diálogo
                                    },
                                    child: Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Remover a imagem do Firebase Storage
                                      try {
                                        await firebase_storage.FirebaseStorage.instance.refFromURL(_imageUrls[index]).delete();
                                      } catch (error) {
                                        print('Erro ao remover imagem do Firebase Storage: $error');
                                      }
                                      
                                      // Remover a imagem da lista
                                      setState(() {
                                        _imageUrls.removeAt(index);
                                      });
                                      
                                      Navigator.of(context).pop(); // Fechar a caixa de diálogo
                                    },
                                    child: Text("Remover"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Image.network(
                          _imageUrls[index],
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
                                adopted: _isAdopted,
                                images: _imageUrls,
                                userId: _userBd?.id ?? "");
                            
                            if (firebaseId == null) {
                              await FirebaseFirestore.instance
                                  .collection('adoptions')
                                  .add(adoption.toJson());
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('adoptions')
                                  .doc(firebaseId)
                                  .update(adoption.toJson());
                            }
                            resetVariables();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registro salvo com sucesso!'),
                              ),
                            );
                            Navigator.pop(context);
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
