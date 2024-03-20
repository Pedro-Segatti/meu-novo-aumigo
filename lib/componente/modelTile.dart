import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/modelos/model.dart';
import 'package:projeto_integrador_6/view/perfil.dart';

// ignore: camel_case_types
class modelTile extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final model Model;
  const modelTile(this.Model);

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(Model.avatar),
          ),
        ),
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: avatar,
            title: Text(Model.nome),
            subtitle: Text(Model.descricao),
            trailing: Container(
              width: 40,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu_open),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => perfil(Model.nome, Model.idade,Model.descricao, Model.avatar),
                ),
              );
                    },
                  )
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
