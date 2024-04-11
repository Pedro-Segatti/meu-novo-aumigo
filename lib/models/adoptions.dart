import 'package:cloud_firestore/cloud_firestore.dart';
class Adoptions {
  final String animalType;
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
  final List<String>? images;
  final String? userId;

  Adoptions({
    required this.animalType,
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
    this.images,
    this.userId,
  });

  factory Adoptions.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Adoptions(
      animalType: data['animalType'],
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
      images: data['images'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animalType': animalType,
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
      'images': images,
      'userId': userId
    };
  }
}
