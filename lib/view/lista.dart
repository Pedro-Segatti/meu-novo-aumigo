import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/componente/modelTile.dart';
import 'package:meu_novo_aumigo/main.dart';
import 'package:meu_novo_aumigo/provider/add_lista.dart';
import 'package:provider/provider.dart';

import 'cad_dog.dart';

class lista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final add_lista addLista = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Adoção"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => cad_dog(),
                ),
              );
              /*
              addLista.put(
                model(
                  nome: 'teste',
                  descricao: 'testettt',
                  idade: '1',
                  avatar: 'assets/img/dg3.jpg',
                ),
              );
              */
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: addLista.count,
        itemBuilder: (context, i) => modelTile(addLista.byIndex(i)),
      ),
      /*
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => List(),
                ),
              );
              break;
            case 1:
              Navigator.pushNamed(context, "/second");
              break;
            
          }
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepOrange,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Página Inicial'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            title: Text('Quem Somos'),
          ),
        ],
      ),
      */
    );
  }
}
