import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Adoptions {
  final String animalType;
  final String? behavior;
  final String? description;
  final String? name;
  final String sex;
  final String? age;
  final String? vaccinesAndMedicines;
  final String? diseases;
  final String size;
  final String? weight;
  final String? familyInfo;
  final bool? adopted;
  final String? adopterName;
  final String? adopterCpf;
  final List<dynamic>? images;
  final String userId;

  Adoptions({
    required this.animalType,
    this.behavior,
    this.description,
    this.name,
    required this.sex,
    this.age,
    this.vaccinesAndMedicines,
    this.diseases,
    required this.size,
    this.weight,
    this.familyInfo,
    this.adopted,
    this.adopterName,
    this.adopterCpf,
    this.images,
    required this.userId,
  });

  factory Adoptions.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Adoptions(
      animalType: data['animalType'],
      behavior: data['behavior'] ?? '',
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      sex: data['sex'] ?? '',
      age: data['age'] ?? '',
      vaccinesAndMedicines: data['vaccinesAndMedicines'] ?? '',
      diseases: data['diseases'] ?? '',
      size: data['size'] ?? '',
      weight: data['weight'] ?? '',
      familyInfo: data['familyInfo'] ?? '',
      adopted: data['adopted'] ?? '',
      adopterName: data['adopterName'] ?? '',
      adopterCpf: data['adopterCpf'] ?? '',
      images: data['images'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animalType': animalType,
      'behavior': behavior,
      'description': description,
      'name': name,
      'sex': sex,
      'age': age,
      'vaccinesAndMedicines': vaccinesAndMedicines,
      'diseases': diseases,
      'size': size,
      'weight': weight,
      'familyInfo': familyInfo,
      'adopted': adopted,
      'adopterName': adopterName,
      'adopterCpf': adopterCpf,
      'images': images,
      'userId': userId
    };
  }

  bool isAnimalTypeDog() {
    return animalType == "Cachorro";
  }

  bool isAnimalTypeCat() {
    return animalType == "Gato";
  }

  getAnimalTypeIcon() {
    if (isAnimalTypeDog()) {
      return Icon(FontAwesomeIcons.dog, size: 16);
    }
    if (isAnimalTypeCat()) {
      return Icon(FontAwesomeIcons.cat, size: 16);
    }
    return Icon(FontAwesomeIcons.frog, size: 16);
  }

  String getAnimalAdoptionMessage() {
    return "Olá, Gostaria de adotar o cachorro $name. Estou pronto para recebê-lo em um lar cheio de amor e cuidado. Por favor, me informe os próximos passos para a adoção. Obrigado(a).";
  }
}
