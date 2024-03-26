import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/services/auth_service.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({Key? key}) : super(key: key);

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

    return AppBar(
      title: Text('Logo do Aplicativo'),
      centerTitle: true,
      actions: <Widget>[
        _auth.isLogged()
            ? IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    firstLetterName + firstLetterLastName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              )
            : SizedBox(),
      ],
      bottom: PreferredSize(
        preferredSize:
            Size.fromHeight(1.0), // Define a altura da linha inferior
        child: Container(
          color: Colors.grey, // Cor da linha inferior
          height: 0.3, // Altura da linha inferior
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
