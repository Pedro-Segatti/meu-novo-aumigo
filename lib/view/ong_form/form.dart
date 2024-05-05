import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:meu_novo_aumigo/models/user_bd.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';
import 'package:meu_novo_aumigo/view/home/home_page.dart';
import 'package:meu_novo_aumigo/view/login/login_page.dart';
import 'package:provider/provider.dart';

class OngForm extends StatefulWidget {
  OngForm({Key? key}) : super(key: key);

  @override
  _OngFormState createState() => _OngFormState();
}

class _OngFormState extends State<OngForm> {
  late Future<List<String>> _futureCities;
  late Future<List<String>> _futureStates;

  @override
  void initState() {
    super.initState();
    _futureCities = fetchCities();
    _futureStates = fetchStates();

    var _auth = context.read<AuthService>();
    var _user = _auth.user;
    var _userDB = _auth.userBD;

    if (_user != null) {
      _name = TextEditingController(text: _userDB?.name);
      _cnpj = TextEditingController(text: _userDB?.cnpj);
      _cellphone = TextEditingController(text: _userDB?.cellphone);
      _selectedState = _userDB?.state;
      _selectedCity = _userDB?.city;
      _neighborhood = TextEditingController(text: _userDB?.neighborhood);
      _street = TextEditingController(text: _userDB?.street);
      _houseNumber = TextEditingController(text: _userDB?.houseNumber);
      _observation = TextEditingController(text: _userDB?.observation);
      _email = TextEditingController(text: _userDB?.email);
    }
  }

  bool loading = false;
  bool loadingPage = true;

  final formKey = GlobalKey<FormState>();
  var _name = TextEditingController();
  var _cnpj = TextEditingController();
  var _cellphone = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  var _neighborhood = TextEditingController();
  var _street = TextEditingController();
  var _houseNumber = TextEditingController();

  var _observation = TextEditingController();

  var _email = TextEditingController();
  var _password = TextEditingController();

  Future<List<String>> fetchCities() async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/municipios'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String>? cities =
          data.map((city) => city['nome']).cast<String>().toList();
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<List<String>> fetchStates() async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String>? states =
          data.map((state) => state['nome']).cast<String>().toList();
      return states;
    } else {
      throw Exception('Failed to load states');
    }
  }

  final _cnpjMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cellphoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##)# ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String getOnlyNumbers(String text) {
    // Remove todos os caracteres não numéricos do texto
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  registrar() async {
    setState(() => loading = true);
    try {
      // Acessando a instância do Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Coleção onde você quer armazenar os dados
      CollectionReference users = firestore.collection('users');

      var _auth = context.read<AuthService>();
      var _userDB = _auth.userBD;

      UserBD newUser = UserBD(
        name: _name.text,
        cnpj: getOnlyNumbers(_cnpj.text),
        cellphone: getOnlyNumbers(_cellphone.text),
        state: _selectedState,
        city: _selectedCity,
        neighborhood: _neighborhood.text,
        street: _street.text,
        houseNumber: _houseNumber.text,
        observation: _observation.text,
        email: _email.text,
        status: _auth.isLogged() ? _userDB!.status : "WA",
        role: "institution",
      );

      if (!_auth.isLogged()) {
        await users.add(newUser.toJson());

        await context
            .read<AuthService>()
            .registrar(_email.text, _password.text, _name.text);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cadastro Realizado!'),
              content: Container(
                width: double.maxFinite,
                child: const Text(
                  'O seu cadastro foi realizado com sucesso! Ele passará por uma fase de análise e assim que concluída, um e-mail será enviado para o endereço informado, permitindo o login no aplicativo. Agradecemos pelo cadastro e estamos ansiosos para ajudar nossos aumigos.',
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.thumb_up),
                      SizedBox(width: 8),
                      Text(
                        'Entendido',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      } else {
        await users.doc(_userDB?.id).update(newUser.toJson());

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cadastro Atualizado!'),
              content: Container(
                width: double.maxFinite,
                child: const Text(
                  'O seu cadastro foi atualizado com sucesso!',
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _auth.logout();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.thumb_up),
                      SizedBox(width: 8),
                      Text(
                        'Entendido',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _auth = context.read<AuthService>();

    return Scaffold(
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _auth.isLogged() ? "Edite sua Conta" : "Crie sua Conta",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                // Seção Informações Pessoais
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informações Gerais",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Divider(
                        color: const Color.fromARGB(255, 156, 156, 156),
                        thickness: 0.3,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _name,
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
                          labelText: 'Nome',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe o nome corretamente';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _cellphone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_cellphoneMaskFormatter],
                        decoration: InputDecoration(
                          labelText: 'Celular',
                          hintText: '(00)0 0000-0000',
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
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 11) {
                            return 'Informe um celular válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _cnpj,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_cnpjMaskFormatter],
                        decoration: InputDecoration(
                          labelText: 'CNPJ',
                          hintText: '00.000.000/0000-00',
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
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 14) {
                            return 'Informe um CNPJ válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informações Residenciais",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Divider(
                        color: const Color.fromARGB(255, 156, 156, 156),
                        thickness: 0.3,
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<List<String>>(
                        future: _futureStates,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<String> states = snapshot.data!;
                            return DropdownButtonFormField<String>(
                              value: _selectedState,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                });
                              },
                              items: states.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Selecione um estado',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors
                                        .black54), // Cor do texto do rótulo
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
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione um Estado';
                                }
                                return null;
                              },
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<List<String>>(
                        future: _futureCities,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<String> cities = snapshot.data!;
                            return DropdownButtonFormField<String>(
                              value: _selectedCity,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCity = newValue;
                                });
                              },
                              items: cities.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Selecione uma cidade',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Colors
                                        .black54), // Cor do texto do rótulo
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
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione uma Cidade';
                                }
                                return null;
                              },
                            );
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _neighborhood,
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
                          labelText: 'Bairro',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe um bairro válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _street,
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
                          labelText: 'Rua',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe uma rua válida';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _houseNumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ], // Permite apenas números
                        keyboardType: TextInputType.number,
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
                          labelText: 'Número',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe uma número válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Obeservações",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Divider(
                        color: const Color.fromARGB(255, 156, 156, 156),
                        thickness: 0.3,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _observation,
                        maxLines: 3, // Para permitir múltiplas linhas de texto
                        decoration: InputDecoration(
                          labelText:
                              'Conte-nos um pouco sobre a sua Instituição',
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
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 30) {
                            return 'Informe uma observação válida';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                Visibility(
                  visible:
                      !_auth.isLogged(), // Verifica se o usuário está logado
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Credenciais de Acesso",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 156, 156, 156),
                          thickness: 0.3,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                                color:
                                    Colors.black54), // Cor do texto do rótulo
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
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe o email corretamente';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                                color:
                                    Colors.black54), // Cor do texto do rótulo
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
                              return 'Informe sua senha';
                            } else if (value.length < 6) {
                              return 'Sua senha deve ter no mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Botão de Cadastro
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        registrar();
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
                                  !_auth.isLogged() ? "Cadastrar" : "Salvar",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                // Botão de Voltar ao Login
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFb85b20)),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(
                          fontSize: 16), // Definindo o tamanho da fonte como 20
                    ),
                  ),
                  onPressed: () =>
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }),
                  child: Text("Voltar ao Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
