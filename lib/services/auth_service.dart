import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/models/user_bd.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  UserBD? userBD;
  bool isLoading = true;
  bool isAnonymousAccess = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      user = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    user = _auth.currentUser;
    _authCheck();
    notifyListeners();
  }

  registrar(String email, String senha, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: senha);
      await userCredential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(String email, String senha) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('status', isEqualTo: "A")
          .get();

      if (snapshot.docs.isEmpty) {
        throw AuthException(
            'O Seu cadastro está em revisão, não é possível acessar o aplicativo.');
      }
      userBD = UserBD.fromFirestore(snapshot.docs[0]);
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      } else if (e.code == 'invalid-email') {
        throw AuthException('E-mail inválido');
      } else if (e.code == 'invalid-credential') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else {
        throw AuthException('Não foi possível realizar o login');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  isLogged() {
    return user != null;
  }
}
