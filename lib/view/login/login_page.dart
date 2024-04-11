import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:meu_novo_aumigo/view/home/home_page.dart';
import 'package:meu_novo_aumigo/view/ong_form/form.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  bool loading = false;

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return Container(); //
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/img/logo.png', // Coloque o caminho da sua imagem aqui
                      fit: BoxFit
                          .contain, // Ajuste da imagem dentro do espaço disponível
                      height: 150, // Ajuste a altura conforme necessário
                    ),
                    const SizedBox(
                        width: 8), // Espaçamento entre a imagem e o texto
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.black54), // Cor do texto do rótulo
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .deepOrange), // Defina a cor desejada aqui
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(
                                0xFFb85b20)), // Cor das bordas quando não está em foco
                      ),
                      labelText: 'E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.black54), // Cor do texto do rótulo
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .deepOrange), // Defina a cor desejada aqui
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(
                                0xFFb85b20)), // Cor das bordas quando não está em foco
                      ),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFb85b20)), // Cor de fundo do botão
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // Cor do texto e ícone do botão
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              Icon(Icons.check),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OngForm()),
                    );
                  }),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFb85b20)),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(
                          fontSize: 16), // Definindo o tamanho da fonte como 20
                    ),
                  ),
                  child: Text("Cadastre-se"),
                ),
                TextButton(
                  onPressed: () =>
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFb85b20)),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(
                          fontSize: 16), // Definindo o tamanho da fonte como 20
                    ),
                  ),
                  child: Text("Ir para o menu principal"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
