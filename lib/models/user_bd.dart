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
  final String? instagram_link;
  final String? facebook_link;
  final String? x_link;
  final String? tiktok_link;

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
    this.instagram_link,
    this.facebook_link,
    this.x_link,
    this.tiktok_link,
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
      instagram_link: data['instagram_link'] ?? '',
      facebook_link: data['facebook_link'] ?? '',
      x_link: data['x_link'] ?? '',
      tiktok_link: data['tiktok_link'] ?? '',
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
      'instagram_link': instagram_link,
      'facebook_link': facebook_link,
      'x_link': x_link,
      'tiktok_link': tiktok_link,
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
