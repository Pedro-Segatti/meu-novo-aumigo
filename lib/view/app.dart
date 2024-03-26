import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/widget/auth_check.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Novo Aumigo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: AuthCheck(),
    );
  }
}
