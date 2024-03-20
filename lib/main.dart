import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/provider/add_lista.dart';
import 'package:projeto_integrador_6/view/lista.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => add_lista(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adoção de Cachorros',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Centro de Zoonose Itambiqui"),
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    alignment: Alignment.center,
                    image: AssetImage('../assets/img/logo.png'),
                    height: 350,
                    width: 350,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => lista(),
                ),
              );
              break;
            case 1:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => lista(),
              //   ),
              // );
              break;
          }
        },
        unselectedItemColor: Colors.deepOrange,
        selectedItemColor: Colors.deepOrange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind),
            label: 'Adoção',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Quem Somos',
          ),
        ],
      ),
    );
  }
}