import 'package:flutter/material.dart';
import 'lista.dart';

// ignore: camel_case_types/, must_be_immutable
class perfil extends StatelessWidget {
  String nome = "";
  String idade = "0";
  String descricao = "";
  String avatar = "";

  perfil(String n, String i, String d, String a) {
    this.nome = n;
    this.idade = i;
    this.descricao = d;
    this.avatar = a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cãodastro"),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => lista(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
              color: Colors.orange,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundImage: AssetImage(avatar),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        nome.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      descricao.toUpperCase() + "   |   " + idade.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    
                  ],
                ),
              ],
              
            ),
          ),
        ],
      ),
    );
  }
}
