import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:meu_novo_aumigo/view/adoption/adoption_page.dart';
import 'package:meu_novo_aumigo/view/adoption/adoption_list.dart';
import 'package:meu_novo_aumigo/view/approval/approval.dart';
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
    var _userBD = _auth.userBD;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFb85b20),
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
              title: Text("Adoções"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdoptionList(),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: _auth.isLogged(), // Verifica se o usuário está logado
            child: ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text("Doações"),
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
            visible: _auth.isLogged() && _userBD!.isRoleAdmin(),
            child: ListTile(
              leading: Icon(Icons.approval),
              title: Text("Aprovação de Perfis"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Approval(),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: !_auth.isLogged() ? Text('Entrar') : Text('Sair'),
            onTap: () {
              if (!_auth.isLogged()) {
                _auth.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
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
