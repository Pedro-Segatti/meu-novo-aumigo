import 'package:cloud_firestore/cloud_firestore.dart';

class UserBD {
  final String? id;
  final String name;
  final String cnpj;
  final String cellphone;
  final String? state;
  final String? city;
  final String neighborhood;
  final String street;
  final String houseNumber;
  final String observation;
  final String email;
  final String status;
  final String role;

  UserBD({
    this.id,
    required this.name,
    required this.cnpj,
    required this.cellphone,
    this.state,
    this.city,
    required this.neighborhood,
    required this.street,
    required this.houseNumber,
    required this.observation,
    required this.email,
    required this.status,
    required this.role,
  });

  factory UserBD.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserBD(
      id: doc.id,
      name: data['name'] ?? '',
      cnpj: data['cnpj'] ?? '',
      cellphone: data['cellphone'] ?? '',
      state: data['state'] ?? '',
      city: data['city'] ?? '',
      neighborhood: data['neighborhood'] ?? '',
      street: data['street'] ?? '',
      houseNumber: data['houseNumber'] ?? '',
      observation: data['observation'] ?? '',
      email: data['email'] ?? '',
      status: data['status'] ?? '',
      role: data['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj,
      'cellphone': cellphone,
      'state': state,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'houseNumber': houseNumber,
      'observation': observation,
      'email': email,
      'status': status,
      'role': role,
    };
  }

  bool isRoleAdmin() {
    return role == "admin";
  }

  bool isStatusWaitingApproval() {
    return status == "WA";
  }

  bool isStatusDisapproved() {
    return status == "D";
  }

  bool isStatusApproved() {
    return status == "A";
  }
}
