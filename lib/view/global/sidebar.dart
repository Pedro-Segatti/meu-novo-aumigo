import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:meu_novo_aumigo/view/login/login_page.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    var _auth = context.read<AuthService>();
    var _user = _auth.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Container(
              padding: EdgeInsets.all(
                  8.0), // Adiciona algum espaço interno para o texto
              alignment: Alignment
                  .bottomLeft, // Alinha o texto à esquerda na parte inferior
              height: 80, // Altura personalizada
              child: _auth.isLogged()
                  ? Text(
                      _user!.displayName ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            18, // Reduz o tamanho da fonte para se adequar melhor
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          Visibility(
            visible: _auth.isLogged(), // Verifica se o usuário está logado
            child: ListTile(
              leading: Icon(Icons.pets),
              title: Text("Nova Adoção"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: _auth.isLogged(), // Verifica se o usuário está logado
            child: ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text("Nova Doação"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: !_auth.isLogged() ? Text('Entrar') : Text('Logout'),
            onTap: () {
              if (!_auth.isLogged()) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (route) =>
                      false, // Remove todas as rotas até a nova rota (LoginPage)
                );
              } else {
                context.read<AuthService>().logout();
              }
            },
          ),
        ],
      ),
    );
  }
}
