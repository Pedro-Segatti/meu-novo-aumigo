import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';
import 'package:path_provider/path_provider.dart';

class DonationForm extends StatefulWidget {
  final Map<String, dynamic>? donation;
  final String? firebaseId;

  const DonationForm({Key? key, this.donation, this.firebaseId}) : super(key: key);

  @override
  _DonationFormState createState() => _DonationFormState(donation: donation, firebaseId: firebaseId);
}

class _DonationFormState extends State<DonationForm> {
  Map<String, dynamic>? donation;
  final String? firebaseId;

  _DonationFormState({this.donation, this.firebaseId});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _imageUrls = [];
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _donorNameController = TextEditingController();
  TextEditingController _donorContactController = TextEditingController();
  TextEditingController _donationDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    donation = widget.donation;
    _formKey = GlobalKey<FormState>();
    if (donation != null) {
      _descriptionController = TextEditingController(text: donation?['description']);
      _donorNameController = TextEditingController(text: donation?['donorName']);
      _donorContactController = TextEditingController(text: donation?['donorContact']);
      _donationDetailsController = TextEditingController(text: donation?['donationDetails']);
    }
  }

  void resetVariables() {
    setState(() {
      _descriptionController = TextEditingController();
      _donorNameController = TextEditingController();
      _donorContactController = TextEditingController();
      _donationDetailsController = TextEditingController();
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
                TextFormField(
                  controller: _donorNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                    labelText: 'Nome do Doador',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do doador';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _donorContactController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                    labelText: 'Contato do Doador',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o contato do doador';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                    labelText: 'Descrição da Doação',
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição da doação';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _donationDetailsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFb85b20)),
                    ),
                    labelText: 'Detalhes da Doação',
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var donation = {
                          'description': _descriptionController.text,
                          'donorName': _donorNameController.text,
                          'donorContact': _donorContactController.text,
                          'donationDetails': _donationDetailsController.text,
                          'userId': _userBd?.id ?? ""
                        };
                        
                        if (firebaseId == null) {
                          await FirebaseFirestore.instance
                              .collection('donations')
                              .add(donation);
                        } else {
                          await FirebaseFirestore.instance
                              .collection('donations')
                              .doc(firebaseId)
                              .update(donation);
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
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFb85b20)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text('Salvar'),
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