import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/img/logo.png', // Coloque o caminho da sua imagem aqui
            fit: BoxFit.contain, // Ajuste da imagem dentro do espaço disponível
            height: 45, // Ajuste a altura conforme necessário
          ),
          const SizedBox(width: 8), // Espaçamento entre a imagem e o texto
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey,
          height: 0.3,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
