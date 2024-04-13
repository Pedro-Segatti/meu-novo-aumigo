import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const TopBar({Key? key, this.showBackButton = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModalRoute route = ModalRoute.of(context)!;
    
    return AppBar(
      leading: showBackButton ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ) : null,
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