import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:meu_novo_aumigo/view/login/login_page.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _auth = context.read<AuthService>();
    var _user = _auth.user;

    String firstLetterName = '';
    String firstLetterLastName = '';
    if (_user != null) {
      String userDisplayName = _user.displayName ?? '';
      List<String> nameParts = userDisplayName.split(' ');
      firstLetterName = nameParts[0][0];
      firstLetterLastName = nameParts.length > 1 ? nameParts[1][0] : '';
    }

    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        if (index == 0) {
          Scaffold.of(context).openDrawer();
        } else if (index == 2 && !_auth.isLogged()) {
          // Navegar para a página de login quando o índice do menu for 3 e o usuário não estiver logado
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
      },
      unselectedItemColor: Colors.deepOrange,
      selectedItemColor: Colors.deepOrange,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Ranking',
        ),
        BottomNavigationBarItem(
          icon: _auth.isLogged()
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    firstLetterName + firstLetterLastName,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )
              : Icon(Icons.login),
          label: _auth.isLogged() ? _user?.displayName ?? '' : 'Entrar',
        ),
      ],
    );
  }
}
