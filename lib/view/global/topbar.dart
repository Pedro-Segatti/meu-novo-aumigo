import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Logo do Aplicativo'),
      automaticallyImplyLeading: false,
      centerTitle: true,
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
